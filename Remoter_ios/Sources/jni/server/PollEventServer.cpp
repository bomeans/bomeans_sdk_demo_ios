//============================================================
// IOEventSelector.cpp : implementation of class IOEventSelector
//                                 monitor socket I/O event using poll
// Author: JeffLuo
// Created: 2006-08-30
//============================================================

#include "PollEventServer.h"
#include "common/Utility.h"
#include <errno.h>

IMPL_LOGGER(DefaultEventCallBack, logger);
IMPL_LOGGER(PollEventServer, logger);

bool PollEventServer::add_event(int fd, int event_type, EventInfo * event_info)
{
	if(event_info == NULL || event_info->m_ev_cb == NULL)
	{
		LOG4CPLUS_WARN(logger, "Parameter event_info is NULL!!");
		return false;
	}

	if((event_type & EVENT_ALL) == 0 && event_info->m_timeout_ms <= 0)
	{
		LOG4CPLUS_WARN(logger, "Invalid parameter: event_type is " << event_type << " and timeout = " << event_info->m_timeout_ms );
		return false;
	}

	int16_t poll_event = 0;
	if(event_type & EVENT_READABLE)
		poll_event |= POLLIN;
	if(event_type & EVENT_WRITABLE)
		poll_event |= POLLOUT;

	if(fd > 0)
	{
		LOG4CPLUS_DEBUG(logger, "poll_event=" << poll_event << " when call add_event() for fd=" << fd);
	}

	bool is_new_fd = true;
	int fd_index = m_max_poll_index;

	if(fd > 0)
	{
		FdIndexMap::iterator it = m_fd_index_map.find(fd);
		if(it != m_fd_index_map.end())
		{
			is_new_fd = false;
			fd_index = it->second;
			poll_event |= m_poll_fds[fd_index].events;
			LOG4CPLUS_DEBUG(logger, "poll_event=" << poll_event << " after merge  for fd=" << fd << " at #" << fd_index);
		}
	}

	if(is_new_fd)
	{
		int free_index;
		if(m_free_poll_indexes.pop(free_index))
		{
			fd_index = free_index;
		}
		else if(m_max_poll_index >= MAX_POLL_SIZE)
		{
			// report to monitor
			LOG4CPLUS_ERROR(logger, "poll event capacity is " << MAX_POLL_SIZE << ", but current max poll index is " << m_max_poll_index);
			return false;
		}
		else
		{
			fd_index = m_max_poll_index;
			m_max_poll_index++;
		}

		if(fd > 0)
		{
			LOG4CPLUS_DEBUG(logger, "fd " << fd << " added to poll at #" << fd_index);
		}
		m_event_count++;		
	}

	m_poll_fds[fd_index].fd = fd;
	m_poll_fds[fd_index].events = poll_event;
	if(is_new_fd)
		m_poll_fds[fd_index].revents = 0;
	event_info->m_ev_cb->set_event_server(this);

	memcpy(m_extra_info_list + fd_index, event_info, sizeof(EventInfo));
	if(event_info->m_timeout_ms > 0)
		m_extra_info_list[fd_index].m_start_time_ms = Utility::current_time_ms();
             // (_u64)g_app.get_current_time() * 1000;
	else
		m_extra_info_list[fd_index].m_start_time_ms = 0;
	m_extra_info_list[fd_index].m_is_persist_event = ((event_type & EVENT_PERSIST) != 0);
	m_extra_info_list[fd_index].m_is_used = true;

	if(fd > 0)
	{
		dump_header_poll_info("after add_event() poll fdlist is ");
	}

	if(fd > 0 && is_new_fd)
	{
		m_fd_index_map[fd] = fd_index;
	}

	return true;
}

bool PollEventServer::add_timer_event(EventInfo* event_info)
{
	return add_event(0, 0, event_info);
}

void PollEventServer::notify_fd_closed(int fd)
{
	LOG4CPLUS_DEBUG(logger, "notify_fd_closed() called on fd=" << fd);

	FdIndexMap::iterator it = m_fd_index_map.find(fd);
	if(it != m_fd_index_map.end())
	{
		int fd_index = it->second;	
		LOG4CPLUS_INFO(logger, "fd " << fd << " is in fd-index map when notify_fd_closed() called, index=" << fd_index);	

		remove_event(fd_index, 0, true);								
	}
}

void PollEventServer::dump_header_poll_info(const char* prefix)
{
#if 1

	char fdlist[256], fdtext[32];
	if(prefix)
		strcpy(fdlist, prefix);
	else
		fdlist[0] = '\0';
	for(int i = 0; i < 8 && i < m_max_poll_index; i++)
	{
		if(m_extra_info_list[i].m_is_used)
		{
			snprintf(fdtext, 31, "#%d=%d(ev=%d)", i, m_poll_fds[i].fd, m_poll_fds[i].events);
			strcat(fdlist, fdtext);
			strcat(fdlist, ",");
		}
	}
	
	LOG4CPLUS_DEBUG(logger, fdlist);
	
#endif
}

bool PollEventServer::del_event(int fd, int event_type)
{
	if(fd <= 0)
	{
		LOG4CPLUS_WARN(logger, "Invalid parameter(del_event): fd is " << fd);
		return false;
	}

	if(m_event_count <= 0)
		return false;

	bool found = false;
	event_type &= EVENT_ALL;
	int poll_event = 0;
	if(event_type & EVENT_READABLE)
		poll_event |= POLLIN;
	if(event_type & EVENT_WRITABLE)
		poll_event |= POLLOUT;	

	FdIndexMap::iterator it = m_fd_index_map.find(fd);
	found = (it != m_fd_index_map.end());

	if(found)
	{
		int idx = it->second;
		int prev_event = m_poll_fds[idx].events;
		m_poll_fds[idx].events &= ~poll_event;
		if(prev_event != 0 && m_poll_fds[idx].events == 0)
		{
			// events is 0, so this fd should removed from poll
			remove_event(idx, event_type, true);								
		}
	}

	if(!found)
		LOG4CPLUS_WARN(logger, "del_event on fd=" << fd << ", but no such fd found.");

	return found;
}

bool PollEventServer::remove_event(int index, int event_type, bool force_remove)
{
	if(index < 0 || index >= m_max_poll_index)
	{
		LOG4CPLUS_WARN(logger, "invalid parameter for remove_event(): index=" << index << ", m_max_poll_index=" << m_max_poll_index);
		return false;
	}

	bool must_remove = force_remove;

	if(!must_remove)
	{
		int poll_event = 0;
		if(event_type & EVENT_READABLE)
			poll_event |= POLLIN;
		if(event_type & EVENT_WRITABLE)
			poll_event |= POLLOUT;			
		
		int prev_event = m_poll_fds[index].events;
		m_poll_fds[index].events &= ~poll_event;
		m_poll_fds[index].revents = 0;		
		if(prev_event != 0 && m_poll_fds[index].events == 0)
		{
			LOG4CPLUS_DEBUG(logger, "fd " << m_poll_fds[index].fd << " should removed now (event_type=" << event_type << ", poll_event=" << poll_event << ", prev_event=" << prev_event << ").");			
			must_remove = true;
		}
		else
		{
			// poll events updated, no need to remove it from poll
			return false;
		}
	}

	int fd = m_poll_fds[index].fd;

	m_extra_info_list[index].m_is_used = false;
	memset(m_poll_fds + index, 0, sizeof(m_poll_fds[0]));
	if(index + 1 == m_max_poll_index)
	{
		m_max_poll_index--;
	}
	else if(!m_free_poll_indexes.push(index))
	{
		// report to monitor
		LOG4CPLUS_ERROR(logger, "!! failed to push unused poll index " << index << " to free index list");
		return false;
	}

	// decrease event count
	m_event_count--;

	if(fd > 0)
	{
		LOG4CPLUS_DEBUG(logger, "fd " << fd << " removed from poll at #" << index);
	}

	if(fd > 0)
	{
		if(0 == m_fd_index_map.erase(fd))
		{
			LOG4CPLUS_WARN(logger, "fd " << fd << " not found in fd-index map!!");
		}
	}

	return true;
}

void PollEventServer::run_event_loop()
{
	while(!should_exit())
	{
		int ret = poll(m_poll_fds, m_max_poll_index, m_poll_timeout_ms);
		if(ret == -1)
		{
			if(errno == EINTR){
				continue;
			}
			else{
				// report to monitor
				LOG4CPLUS_ERROR(logger, "poll() returns -1, errno=" << errno);
				break;					
			}
		}
		else
		{
			if(ret > 0)
			{
				dump_header_poll_info(">>> poll() returned, fdlist is ");			
			}

			_u64 start = Utility::current_time_ms();

			int index = 0, total_events = 0;
			bool ev_removed = false;
			// check eveny fd if some event occured or timeout			
			int cur_max_index = m_max_poll_index;
			while(index < cur_max_index)
			{
				ev_removed = false;
				bool succ = handle_event(index, ev_removed);
				index++;

				if(succ)
					total_events++;
			}

			int elapsed = (int)(Utility::current_time_ms() - start);
			if(elapsed > 40)
			{
				LOG4CPLUS_WARN(logger, "Total " << total_events << " events  checked, takes " << elapsed << " ms.");			
			}
			else if(ret > 0){
				LOG4CPLUS_DEBUG(logger, "<<< Total " << total_events << " events  checked in " << elapsed << " ms.");			
			}
		}
	}

	if(should_exit())
	{
		LOG4CPLUS_WARN(logger, "exit event loop requested by user!!");
	}
}

// check IO event status, if some event occured then call specified callback function
// 	event_removed: [out] set true if some event removed from poll
// returns true if handled successfully
bool PollEventServer::handle_event(int index, bool& event_removed)
{
	if(index < 0 || index >= m_max_poll_index)
	{
		// report to monitor
		LOG4CPLUS_ERROR(logger, "invalid handle_event() parameter: index=" << index << ", but m_max_poll_index=" << m_max_poll_index);
		return false;
	}
	if(!m_extra_info_list[index].m_is_used)
		return false;

	if(m_poll_fds[index].fd <= 0 && m_extra_info_list[index].m_timeout_ms <= 0)
	{
		LOG4CPLUS_WARN(logger, "both fd <=0 and timeout <= 0 at index " << index);
		return false;
	}

	if(m_poll_fds[index].fd <= 0 && m_extra_info_list[index].m_timeout_ms > 0)
	{
		_u64 now = Utility::current_time_ms();
		if(now - m_extra_info_list[index].m_start_time_ms >= (_u32)m_extra_info_list[index].m_timeout_ms)
		{
			int fd = m_poll_fds[index].fd;
			EventExtraInfo event_info = m_extra_info_list[index];

			if(!event_info.m_is_persist_event)
			{
				remove_event(index, EVENT_TIMEOUT, true);
				event_removed = true;
			}
		
			// timeout
			event_info.m_ev_cb->on_fd_timeout(fd, &event_info);
		}

		return true;
	}

	if(m_poll_fds[index].fd > 0)
	{
		int event_status = 0; 
		if(m_poll_fds[index].revents & POLLIN)
			event_status |= EVENT_READABLE;
		if(m_poll_fds[index].revents & POLLOUT)		
			event_status |= EVENT_WRITABLE;
		if(m_poll_fds[index].revents & (POLLERR | POLLHUP | POLLNVAL))	
			event_status |= EVENT_EXCEPTION;

		if(event_status == 0 && m_extra_info_list[index].m_timeout_ms > 0)
		{
			_u64 now = Utility::current_time_ms();
			if(now - m_extra_info_list[index].m_start_time_ms >= (_u32)m_extra_info_list[index].m_timeout_ms)
			{
				// timeout
				event_status |= EVENT_TIMEOUT;
			}		
		}

		if((event_status & 0xF) != 0)
		{
			LOG4CPLUS_DEBUG(logger, "handle_event() at #" << index << " for fd=" << m_poll_fds[index].fd << ", poll_event=" << m_poll_fds[index].revents);
		
			// some event occured, so this event should removed
			int fd = m_poll_fds[index].fd;
			EventExtraInfo event_info = m_extra_info_list[index];

			if(!event_info.m_is_persist_event)
			{
				bool must_remove = ((event_status & EVENT_EXCEPTION) != 0) || ((event_status & EVENT_TIMEOUT) != 0);
				event_removed = remove_event(index, event_status, must_remove);
//				LOG4CPLUS_DEBUG(logger, "for fd " << fd << "(#" << index << ") before remove_event() must_remove=" << must_remove << ", after that event_removed=" << event_removed);
			}

			if((event_status & EVENT_EXCEPTION) != 0)			
				event_info.m_ev_cb->on_fd_error(fd, &event_info);						
			if((event_status & EVENT_READABLE) != 0 && (event_status & EVENT_EXCEPTION) == 0)
				event_info.m_ev_cb->on_fd_readable(fd, &event_info);	
			if((event_status & EVENT_WRITABLE) != 0  && (event_status & EVENT_EXCEPTION) == 0)		
			{
				// remove EVENT_WRITABLE flag (maybe added in on_fd_readable() method)
				if((event_status & EVENT_READABLE) != 0)
				{
					FdIndexMap::iterator it = m_fd_index_map.find(fd);
					if(it != m_fd_index_map.end())
					{
						int fd_index = it->second;
						m_poll_fds[fd_index].events &= ~POLLOUT;
					}					
				}
				event_info.m_ev_cb->on_fd_writable(fd, &event_info);										
			}
			if((event_status & EVENT_TIMEOUT) != 0)			
				event_info.m_ev_cb->on_fd_timeout(fd, &event_info);							
		}
	}
	else
	{
		LOG4CPLUS_WARN(logger, "!! unexpected execution branch when handle_event at index " << index);
	}

	return true;
}

