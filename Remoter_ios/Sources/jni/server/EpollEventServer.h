//========================================================================
// EpollEventServer.h : interface of class EpollEventServer   (IO event server based on epoll)
//                             
//
// Author: JeffLuo
// Created: 2007-01-26
//=========================================================================

#ifndef __EPOLL_EVENT_SERVER_H_20070126_14
#define  __EPOLL_EVENT_SERVER_H_20070126_14

#include "common/common.h"
#include <sys/epoll.h>
#include "common/IOEventServer.h"
#include "common/Utility.h"
#include <ext/hash_map>
#include <list>
#include <map>
#include <set>

using namespace __gnu_cxx;
using std::list;

struct timer_item
{	
	unsigned   data;
	unsigned period;
	_u64 next_expired_time;
};




class timer_manager  
{
public:
	timer_manager()
	{
	
	}
	
	virtual ~timer_manager()
	{
	
	}

public:
	bool create_timer( unsigned data, unsigned millisecond);
	
	
	void remove_timer( unsigned data );
	
	void get_timer_of_out(_u64 time_now, vector<unsigned> & result );

protected:
	
protected:
	typedef std::multiset<timer_item> timer_set;
       struct op_timer_item
       {
	       timer_set::iterator timer_set_iterator;
       };
       typedef std::multimap<unsigned, op_timer_item> op_timer_map;

	timer_set    _expired_set;
	op_timer_map _handler_map;
	DECL_LOGGER(logger );
};


class EpollEventServer : public IOEventServer
{
	const static int MAX_EPOLL_EVENTS = 51200;

	enum ENUM_TRIGGERED_EVENT
	{
		ACTIVE_EVENT_READ = 1,
		ACTIVE_EVENT_WRITE = 2,
		ACTIVE_EVENT_TIMEOUT = 4,
		ACTIVE_EVENT_ERROR = 8	
	};

	struct EventInfoEx : public EventInfo
	{
		int m_fd;
		int16_t m_event;
		bool m_is_persist_event;
		bool m_is_used;
		_u64 m_start_time_ms;
	};	

	struct TriggeredEvent : public EventInfo
	{
		int m_fd;
		int16_t m_event;
	};		

	struct TimerInfo : public EventInfo
	{
		_u64 m_start_time_ms;
	};	
	
public:
	EpollEventServer() ;

	bool add_event(int fd, int event_type, EventInfo* event_info);
	bool del_event(int fd, int event_type);

	bool add_timer_event(EventInfo* event_info);
	void notify_fd_closed(int fd);

	void run_event_loop();
	void request_exit();

private:
	void init_epoll_fd();
	bool should_exit() { return m_should_exit; }	
	int find_free_index();
	void check_timer_events(_u64 current_ms);
	void set_triggered_event(TriggeredEvent& event, int fd_index, int16_t event_type, _u64 current_ms);
	void modify_event_status(int fd_index, bool error_occured, int epoll_event);
	void trigger_active_events(const list<TriggeredEvent>& events);	
	void remove_fd_from_epoll(int fd);
	

private:
	void read_conf();

	// configurable params
	int m_epoll_timeout_ms;

private:
	int m_epoll_fd;
	struct epoll_event m_events[MAX_EPOLL_EVENTS];
	EventInfoEx m_events_info[MAX_EPOLL_EVENTS];	
	SimpleStack<int> m_free_indexes;	

	hash_map<int, int> m_fdindex_map; // fd => index
	int m_max_fd_index;	

	list<TimerInfo> m_registered_timers;

     //  timer_manager   m_timer_manager;  
	
	bool m_should_exit;	
	 _u64 m_last_check_timer;
	 _u64 m_last_check_timeout;

private:
	DECL_LOGGER(logger);	
};

#endif // #ifndef __EPOLL_EVENT_SERVER_H_20070126_14

