//========================================================================
// EpollEventServer.h : implementation of class EpollEventServer   (IO event server based on epoll)                            
// 
//
// Author: JeffLuo
// Created: 2007-01-24
//=========================================================================

#include "EpollEventServer.h"


IMPL_LOGGER(EpollEventServer, logger);
IMPL_LOGGER(timer_manager, logger);

bool operator < ( const timer_item &l, const timer_item &r )
{
	return l.next_expired_time < r.next_expired_time;
}

bool timer_manager::create_timer( unsigned data, unsigned millisecond)
{
       LOG4CPLUS_TRACE(logger, "create timer data: " << data << ", ms: " << millisecond );
      if( millisecond > 0x7fffffff )
      {
	     millisecond /= 2;
      }

      op_timer_map::iterator it = _handler_map.find((unsigned)data);
      if( it != _handler_map.end() )
      {
            LOG4CPLUS_TRACE(logger, "create repeat timer data: " << data << ", ms: " << millisecond );
               
             //return false;
            //remove_timer(data);
            _expired_set.erase(it->second.timer_set_iterator);
	    _handler_map.erase( it );		 

       }
	   
       _u64 next_expired_time = Utility::current_time_ms() + millisecond;
       timer_item item;

       item.data		= (unsigned)data;
       item.next_expired_time	= next_expired_time;
       item.period				= millisecond;

       op_timer_item op_item;
	
      	op_item.timer_set_iterator = _expired_set.insert(item);
       _handler_map.insert( std::pair<unsigned, op_timer_item>((unsigned)data, op_item) );
       return true;
}


void timer_manager::remove_timer( unsigned data )
{
      std::pair<op_timer_map::iterator, op_timer_map::iterator> pos = _handler_map.equal_range((unsigned)data);	
      if( pos.first != pos.second )
      {
	      for( op_timer_map::iterator it = pos.first; it != pos.second; it++ )		  
	      {
		     LOG4CPLUS_TRACE(logger, "remove timer handler: " << data  );
		    _expired_set.erase(it->second.timer_set_iterator);
	     }
	     _handler_map.erase( pos.first, pos.second );
      }
}

void timer_manager::get_timer_of_out(_u64 time_now, vector<unsigned> & result )
{
        result.clear();         
        if(_expired_set.size()<=0)
       {
             return;
       }

       timer_set::iterator ia = _expired_set.begin();
       for(; ia!= _expired_set.end(); ia++)
       {
              if(ia->next_expired_time < time_now )
              {
                    result.push_back(ia->data); 
              }
		else
		{
		       break;
		}
       }
}


EpollEventServer::EpollEventServer() : m_free_indexes(MAX_EPOLL_EVENTS)
{
	m_should_exit = false;
	m_max_fd_index = -1;	
	m_last_check_timer = Utility::current_time_ms();
	m_last_check_timeout = Utility::current_time_ms();

	memset(m_events_info, 0, sizeof(m_events_info));

	for(int i = MAX_EPOLL_EVENTS - 1; i > -1; i--)
	{
		m_free_indexes.push(i);
	}

	read_conf();
	init_epoll_fd();
}

void EpollEventServer::init_epoll_fd()
{
	m_epoll_fd = epoll_create(MAX_EPOLL_EVENTS);
	if(m_epoll_fd < 0)
	{
		// report to monitor
		LOG4CPLUS_ERROR(logger, "create epoll failed: errno="<< errno);
	}
}

void EpollEventServer::read_conf()
{
	m_epoll_timeout_ms = 100;
}

bool EpollEventServer::add_event(int fd, int event_type, EventInfo* event_info)
{
	if(event_info == NULL || event_info->m_ev_cb == NULL)
	{
		LOG4CPLUS_WARN(logger, "Parameter event_info is NULL!!");
		return false;
	}
	if((event_type & EVENT_ALL) == 0 && event_info->m_timeout_ms <= 0)
	{
		LOG4CPLUS_WARN(logger, "Invalid parameter: event_type is " << event_type << " and timeout <= 0. " );
		return false;
	}

	if((fd == 0 || fd == -1) && event_type == 0 && event_info->m_timeout_ms > 0)
	{
		// this is timer event
		return add_timer_event(event_info);
	}

	event_info->m_ev_cb->set_event_server(this);

	bool is_new_fd = true;
	int fd_index = -1;
	
	hash_map<int, int>::iterator it = m_fdindex_map.find(fd);
	if(it != m_fdindex_map.end())
	{
		is_new_fd = false;
		fd_index = it->second;
	}
	else
	{
		fd_index = find_free_index();
		if(fd_index == -1)
			return false;
	}

    int16_t epoll_event = 0;
	if(event_type & EVENT_READABLE)
		epoll_event |= EPOLLIN;
	if(event_type & EVENT_WRITABLE)
		epoll_event |= EPOLLOUT;	
	if(!is_new_fd)
	{
		epoll_event |= m_events_info[fd_index].m_event;
	}

	struct epoll_event epev = {epoll_event, {0}};
	epev.data.u32 = fd_index;
	int epoll_op = is_new_fd ? EPOLL_CTL_ADD : EPOLL_CTL_MOD;
	if (epoll_ctl(m_epoll_fd, epoll_op, fd, &epev) == -1)
	{
		int res = -1;
		if(errno == ENOENT && epoll_op == EPOLL_CTL_MOD)
		{	
			epoll_op = EPOLL_CTL_ADD; // retry with EPOLL_CTL_ADD operation
			res = epoll_ctl(m_epoll_fd, epoll_op, fd, &epev);
			if(res == 0)
			{
				LOG4CPLUS_WARN(logger, "epoll_ctl(EPOLL_CTL_MOD) failed, but epoll_ctl(EPOLL_CTL_ADD) succeeded on fd=" << fd);
			}
		}
		if(res == -1)
		{
			LOG4CPLUS_WARN(logger, "epoll_ctl(op=" << epoll_op << ", fd=" << fd << ") failed, errno=" << errno);
			return false;
		}
	}	
	LOG4CPLUS_DEBUG(logger, "epoll_ctl(" << (epoll_op == EPOLL_CTL_ADD ? "EPOLL_CTL_ADD" : "EPOLL_CTL_MOD")  << ") called on fd=" << fd << " in add_event().");	

	memcpy(m_events_info + fd_index, event_info, sizeof(EventInfo));
	m_events_info[fd_index].m_fd = fd;
	m_events_info[fd_index].m_event = epoll_event;
	m_events_info[fd_index].m_is_persist_event = ((event_type & EVENT_PERSIST) != 0);
	m_events_info[fd_index].m_is_used = true;
	m_events_info[fd_index].m_start_time_ms = (_u64)Utility::current_time_ms(); 
	
	if(is_new_fd)
	{
		m_fdindex_map[fd] = fd_index;
	}

     //  if(m_events_info[fd_index].m_timeout_ms >0)
       //{
	//     m_timer_manager.create_timer(fd_index, m_events_info[fd_index].m_timeout_ms);
     //  }
	   
	return true;
}

int EpollEventServer::find_free_index()
{
	int free_index;
	if(m_free_indexes.pop(free_index))
	{
		LOG4CPLUS_DEBUG(logger, "find free index: " << free_index);
		if(m_max_fd_index < free_index)
			m_max_fd_index = free_index;
	}
	else
	{
		free_index = -1;
		LOG4CPLUS_WARN(logger, "no free index available!!");
	}

	return free_index;
}

bool EpollEventServer::add_timer_event(EventInfo* event_info)
{
	if(event_info == NULL || event_info->m_timeout_ms <= 0)
		return false;

	event_info->m_ev_cb->set_event_server(this);	

	TimerInfo timer_info;
	memcpy(&timer_info, event_info, sizeof(EventInfo));
	timer_info.m_start_time_ms = Utility::current_time_ms();

	m_registered_timers.push_back(timer_info);

	return true;
}

bool EpollEventServer::del_event(int fd, int event_type)
{
	if(fd <= 0)
	{
		LOG4CPLUS_WARN(logger, "Invalid parameter(del_event): fd is " << fd);
		return false;
	}

	LOG4CPLUS_WARN(logger, "del_event() not implemented yet.");	
	return false;
}

void EpollEventServer::notify_fd_closed(int fd)
{
	if(fd <= 0)
		return;

	LOG4CPLUS_INFO(logger, "notify_fd_closed() called on fd=" << fd);	

	remove_fd_from_epoll(fd);
}

void EpollEventServer::remove_fd_from_epoll(int fd)
{
	hash_map<int, int>::iterator it = m_fdindex_map.find(fd);
	if(it == m_fdindex_map.end())
	{
		LOG4CPLUS_DEBUG(logger, "fd " << fd << " not found in fd-index map when remove_fd_from_epoll() called.");
		return;
	}
	

	// event should removed from epoll	
	int res = epoll_ctl(m_epoll_fd, EPOLL_CTL_DEL, fd, NULL);
	if(res == 0)
	{
		LOG4CPLUS_DEBUG(logger, "epoll_ctl(EPOLL_CTL_DEL) called on fd=" << fd << " when remove_fd_from_epoll() called.");
	}
	else
	{
		LOG4CPLUS_WARN(logger, "epoll_ctl(EPOLL_CTL_DEL) failed on fd=" << fd << " when remove_fd_from_epoll() called, errno=" << errno);
	}	

	int fd_index = it->second;
	memset(&m_events_info[fd_index], 0, sizeof(EventInfoEx));
	m_free_indexes.push(fd_index);
	if(fd_index == m_max_fd_index && m_max_fd_index >= 0)
		m_max_fd_index--;
	m_fdindex_map.erase(it);
       // m_timer_manager.remove_timer(fd_index);
}

void EpollEventServer::run_event_loop()
{
	while(!should_exit())
	{
		int ret = epoll_wait(m_epoll_fd, m_events, MAX_EPOLL_EVENTS, m_epoll_timeout_ms);
		if(ret == -1)
		{
			if(errno == EINTR){
				continue;
			}
			else{
				// report to monitor
				LOG4CPLUS_ERROR(logger, "epoll_wait() returns -1, errno=" << errno);
				break;					
			}
		}
		else
		{
			if(ret > 0)
			{
				LOG4CPLUS_DEBUG(logger, "total " << ret << " events occured after epoll_wait() called.");
			}
			
			_u64 start = Utility::current_time_ms();

			if(start > m_last_check_timer + 100)
			{	
				m_last_check_timer = start;
				check_timer_events(start);
			}

			list<TriggeredEvent> triggered_events;

			// check triggered events
			for(int i = 0; i < ret; i++)
			{
				int fd_index = m_events[i].data.u32;
				bool error_occured = false;
				if(m_events[i].events & (EPOLLHUP |EPOLLERR))
				{
					TriggeredEvent event;
					set_triggered_event(event, fd_index, ACTIVE_EVENT_ERROR, start);
					triggered_events.push_back(event);
					error_occured = true;
				}
				if(!error_occured && (m_events[i].events & EPOLLOUT))
				{
					TriggeredEvent event;
					set_triggered_event(event, fd_index, ACTIVE_EVENT_WRITE, start);
					triggered_events.push_back(event);
				}				
				if(!error_occured && (m_events[i].events & EPOLLIN))
				{		
					TriggeredEvent event;
					set_triggered_event(event, fd_index, ACTIVE_EVENT_READ, start);
					triggered_events.push_back(event);
				}

				modify_event_status(fd_index, error_occured, m_events[i].events);
			}
			
			_u64 now = Utility::current_time_ms();
			if(now >= m_last_check_timeout + 1 * 1000) // 为了提高效率，1秒钟检查一次
			{
				m_last_check_timeout = now;
				// check timeout events
				int total_events = m_max_fd_index + 1;
				for(int i = 0; i < total_events; i++)
				{
					if(m_events_info[i].m_is_used && m_events_info[i].m_timeout_ms > 0)
					{
						if(now - m_events_info[i].m_start_time_ms >= (_u32)m_events_info[i].m_timeout_ms)
						{
						    TriggeredEvent event;
							set_triggered_event(event, i, ACTIVE_EVENT_TIMEOUT, now);
							triggered_events.push_back(event);	

							bool has_error = true;
							// delete from events array
							modify_event_status(i, has_error, m_events_info[i].m_event);
						}
					}
				}		
			}

		/*	vector<unsigned>	time_out_index;
			m_timer_manager.get_timer_of_out(now, time_out_index);

                     int time_out_item_count =   time_out_index.size();

                     LOG4CPLUS_DEBUG(logger, "total  " << time_out_item_count<<" time out!");

			for(int i=0; i<time_out_item_count; i++)
			{
			       uint32_t out_index = time_out_index[i];
				if(out_index>=0 && out_index<total_events)   
				{
				      if(m_events_info[out_index].m_is_used && m_events_info[out_index].m_timeout_ms > 0)
				      {
					
						LOG4CPLUS_WARN(logger, "socket fd " << m_events_info[out_index].m_fd << " timeout, elapsed=" << (now - m_events_info[out_index].m_start_time_ms) << ", starttime=" << m_events_info[out_index].m_start_time_ms)
					
						TriggeredEvent event;
						set_triggered_event(event, out_index, ACTIVE_EVENT_TIMEOUT, now);
						triggered_events.push_back(event);	

						bool has_error = true;
						// delete from events array
						modify_event_status(out_index, has_error, m_events_info[out_index].m_event);
					
				      }
					else
					{
					      LOG4CPLUS_WARN(logger, " get  wrong ount index 1:"<<out_index<<", m_max_fd_index:"<<m_max_fd_index);
					      m_timer_manager.remove_timer(out_index);
					}
				}
				else
				{
				        LOG4CPLUS_WARN(logger, " get  wrong ount index 2:"<<out_index<<", m_max_fd_index"<<m_max_fd_index);
				        m_timer_manager.remove_timer(out_index);
				}
			}
					 
			*/
		
			trigger_active_events(triggered_events);

			int elapsed = (int)(Utility::current_time_ms() - start);

			if(elapsed > 40)
			{
				LOG4CPLUS_WARN(logger, "Total " << triggered_events.size() << " events  checked, takes " << elapsed << " ms., events "<<ret);			
			}
			else{  
				LOG4CPLUS_DEBUG(logger, "Total " << triggered_events.size() << " events checked in " << elapsed << " ms. events "<<ret);			
			}

		}
	}

	if(should_exit())
	{
		LOG4CPLUS_WARN(logger, "exit event loop requested by user!!");
		m_should_exit = false; // reset to initial value
	}

}

void EpollEventServer::trigger_active_events(const list<TriggeredEvent>& events)
{
	for(list<TriggeredEvent>::const_iterator it = events.begin(); it != events.end(); it++)
	{
		TriggeredEvent& event = const_cast<TriggeredEvent&>(*it);
		if(event.m_event == ACTIVE_EVENT_ERROR)
		{
			event.m_ev_cb->on_fd_error(event.m_fd, &event);
		}
		else if(event.m_event == ACTIVE_EVENT_TIMEOUT)
		{
			event.m_ev_cb->on_fd_timeout(event.m_fd, &event);
		}
		else if(event.m_event == ACTIVE_EVENT_WRITE)
		{
			event.m_ev_cb->on_fd_writable(event.m_fd, &event);
		}
		else if(event.m_event == ACTIVE_EVENT_READ)
		{
			event.m_ev_cb->on_fd_readable(event.m_fd, &event);
		}
		else
		{
			LOG4CPLUS_WARN(logger, "unknown event type: " << event.m_event << " on fd " << event.m_fd);
		}		
	}
}

void EpollEventServer::set_triggered_event(TriggeredEvent& event, int fd_index, int16_t event_type, _u64 current_ms)
{
	if(fd_index < 0)
		return;

	memcpy(&event, &m_events_info[fd_index], sizeof(EventInfo));
	event.m_fd = m_events_info[fd_index].m_fd;
	event.m_event = event_type;
	if(event_type == ACTIVE_EVENT_READ || event_type == ACTIVE_EVENT_WRITE)
		m_events_info[fd_index].m_start_time_ms = current_ms;		
}

void EpollEventServer::modify_event_status(int fd_index, bool error_occured, int epoll_event)
{
	if(error_occured || (!m_events_info[fd_index].m_is_persist_event && m_events_info[fd_index].m_event == epoll_event))
	{
		int fd = m_events_info[fd_index].m_fd;
		remove_fd_from_epoll(fd);

		// m_timer_manager.remove_timer(fd_index);

		return;
	}

	if(!m_events_info[fd_index].m_is_persist_event && m_events_info[fd_index].m_event != epoll_event)
	{
		// should modify fd event in epoll
		int fd = m_events_info[fd_index].m_fd;
		LOG4CPLUS_WARN(logger, "modify_event_status() on fd " << fd << " called, old_event=" << m_events_info[fd_index].m_event << ", new_event=" << epoll_event);
		
		m_events_info[fd_index].m_event &= ~epoll_event;
		m_events_info[fd_index].m_start_time_ms =(_u64)Utility::current_time_ms(); 

		struct epoll_event epev = {m_events_info[fd_index].m_event, {0}};		
		epev.data.u32 = fd_index;
		epoll_ctl(m_epoll_fd, EPOLL_CTL_MOD, fd, &epev);		

		//if(m_events_info[fd_index].m_timeout_ms >0)
              //{
	          //       m_timer_manager.create_timer(fd_index, m_events_info[fd_index].m_timeout_ms);
             // }
		//LOG4CPLUS_DEBUG(logger, "epoll_ctl(EPOLL_CTL_MOD) called on fd=" << fd << " in modify_event_status().");			
	}	
}

void EpollEventServer::check_timer_events(_u64 current_ms)
{
	list<TimerInfo> triggered_timers;
	for(list<TimerInfo>::iterator it = m_registered_timers.begin(); it != m_registered_timers.end(); )
	{
		TimerInfo& timer_info = *it;
		if(current_ms > timer_info.m_start_time_ms && current_ms - timer_info.m_start_time_ms >= (_u32)timer_info.m_timeout_ms)
		{
			triggered_timers.push_back(timer_info);
			
			list<TimerInfo>::iterator cur_it = it++;
			list<TimerInfo>::iterator next_it = it;
			m_registered_timers.erase(cur_it);
			it = next_it;
		}
		else
		{
			it++;
		}
	}

	for(list<TimerInfo>::iterator it = triggered_timers.begin(); it != triggered_timers.end(); it++)
	{
		TimerInfo& timer_info = *it;	
		timer_info.m_ev_cb->on_fd_timeout(0, &timer_info);
	}
	
}

void EpollEventServer::request_exit()
{
	LOG4CPLUS_WARN(logger, "IOEventServer::request_exit() called!!");

	m_should_exit = true;
}

