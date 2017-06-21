#include <signal.h>

#include <sched.h>

#include <locale.h>
#include <time.h>
#ifdef LOGGER
#include <log4cplus/configurator.h>
using namespace log4cplus;
static log4cplus::Logger _logger = log4cplus::Logger::getInstance("server");

#endif

#include <string>
#include <sstream>
using namespace std;


#include "server/InterCmdHandler.h"
#include "server/InterCmdManager.h"


InterCmdManager *g_cmd_handler;



int main(int argc, char* argv[])
{
	fprintf(stderr, "start.....\n");
#ifdef LOGGER
	PropertyConfigurator::doConfigure("../conf/log4cpluscplus.properties");
#endif
	signal(SIGPIPE, SIG_IGN);

	//const char* old_locale = setlocale(LC_ALL, "zh_CN.gb2312");
	srand(time(NULL));
	

	InterCmdManager::Start("123");
	

    sleep(2);

	return 0;
}

