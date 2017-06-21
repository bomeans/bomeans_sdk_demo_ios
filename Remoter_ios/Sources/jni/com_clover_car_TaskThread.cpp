#include "com_clover_car_TaskThread.h"
#include <android/log.h>
#include "InterCmdManager.h"

jstring str2jstring(JNIEnv* env,const char* pat);
string jstring2str(JNIEnv* env, jstring jstr);

JNIEXPORT jstring JNICALL Java_com_clover_car_TaskThread_doTask(JNIEnv *env, jobject jobj, jstring param){
    
	const char* strValue = env->GetStringUTFChars(param, NULL);
	__android_log_print(ANDROID_LOG_INFO, "com_clover_car_TaskThread", "param %s", strValue);
    
    const char* str = InterCmdManager::Start(strValue).c_str();
	__android_log_print(ANDROID_LOG_INFO, "com_clover_car_TaskThread", "return %s", str);
    
    jstring strEncode = (env)->NewStringUTF(str);

    return strEncode;
}


JNIEXPORT void JNICALL Java_com_clover_car_TaskThread_stopTask(JNIEnv *env, jobject jobj){
	__android_log_print(ANDROID_LOG_INFO, "com_clover_car_TaskThread", "interCmdManager stop begin");
	InterCmdManager::Stop();
	__android_log_print(ANDROID_LOG_INFO, "com_clover_car_TaskThread", "interCmdManager stop end");
}
