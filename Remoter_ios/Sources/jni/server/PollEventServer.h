//============================================================
// PollEventServer.h : interface of class PollEventServer
//                                
// Author: JeffLuo
// Created: 2006-08-29
//============================================================

#ifndef __POLL_EVENT_SERVER_H_20060829_11
#define  __POLL_EVENT_SERVER_H_20060829_11

#include <sys/socket.h>
#include <sys/poll.h>
#include <ext/hash_map>
#include <vector>
#include "common/common.h"
#include "common/SDLogger.h"
#include "common/SDMutexLock.h"
#include "common/SimpleStack.h"
#include "common/IOEventServer.h"

class PollEventServer : public IOEventServer
{
	struct EventExtraInfo : public EventInfo
	{
		bool m_is_persist_event;
		bool m_is_used;
		_u64 m_start_time_ms;
	};

	
	const static int MAX_POLL_SIZE = 10240;	

	typedef __gnu_cxx::hash_map<int, int> FdIndexMap;

	const static int EVENT_EXCEPTION = 4;
	const static int EVENT_TIMEOUT = 8;	
	
public:

	PollEventServer() : m_event_count(0),  m_fd_index_map(MAX_POLL_SIZE/4), m_free_poll_indexes(MAX_POLL_SIZE), m_max_poll_index(0), m_poll_timeout_ms(100), m_should_exit(false) { }

	bool add_event(int fd, int event_type, EventInfo* attach_info);
	bool add_timer_event(EventInfo* event_info);	
	bool del_event(int fd, int event_type);
	void notify_fd_closed(int fd);	

	int get_event_count() const { return m_event_count; }

	void run_event_loop();
	void request_exit() { m_should_exit = true; }

private:
	bool remove_event(int index, int event_type, bool force_remove = false);
	bool handle_event(int index, bool& event_removed);	
	bool should_exit() { return m_should_exit; }
	void dump_header_poll_info(const char* prefix);
	

private:
	int m_event_count;		
	struct pollfd m_poll_fds[MAX_POLL_SIZE];	
	EventExtraInfo m_extra_info_list[MAX_POLL_SIZE];
	FdIndexMap m_fd_index_map;
	SimpleStack<int> m_free_poll_indexes;
	int m_max_poll_index;

	int m_poll_timeout_ms;
	bool m_should_exit;

private:
	DECL_LOGGER(logger);	
};

#endif // __POLL_EVENT_SERVER_H_20060829_11

