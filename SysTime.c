#include "SysTime.h"
#include <sys/time.h>
#include <time.h>

#define ONE_BILLION  1000000000L


JNIEXPORT jlong JNICALL Java_SysTime_clocktime(JNIEnv *env, jclass jobj)
{
#if _POSIX_TIMERS > 0   
  struct timespec ts;
  clock_gettime(CLOCK_REALTIME, &ts);
  return (((jlong)ts.tv_sec) * ONE_BILLION) + ((jlong)ts.tv_nsec);
#else
   struct timeval tv;
   gettimeofday(&tv, NULL);
   return (((jlong)tv.tv_sec) * ONE_BILLION) + ((jlong)tv.tv_usec*1000);
#endif
}


JNIEXPORT jlong JNICALL Java_SysTime_rdtsc(JNIEnv *env, jclass jobj)
{
  unsigned int lo, hi;
  asm volatile (
     "rdtsc" 
   : "=a"(lo), "=d"(hi) /* outputs */
   : "a"(0)             /* inputs */
   : "%ebx", "%ecx");     /* clobbers*/
  long long x = ((unsigned long long)lo) | (((unsigned long long)hi) << 32);      
  return (jlong) x;
}

JNIEXPORT jlong JNICALL Java_SysTime_cpuidrdtsc(JNIEnv *env, jclass jobj)
{
  unsigned int lo, hi;
  asm volatile (
     "cpuid \n"
     "rdtsc" 
   : "=a"(lo), "=d"(hi) /* outputs */
   : "a"(0)             /* inputs */
   : "%ebx", "%ecx");     /* clobbers*/
  long long x = ((unsigned long long)lo) | (((unsigned long long)hi) << 32);      
  return (jlong) x;
}

JNIEXPORT jlong JNICALL Java_SysTime_rdtscp(JNIEnv *env, jclass jobj)
{
  unsigned int lo, hi;
  asm volatile (
     "rdtscp" 
   : "=a"(lo), "=d"(hi) /* outputs */
   : "a"(0)             /* inputs */
   : "%ebx", "%ecx");     /* clobbers*/
  long long x = ((unsigned long long)lo) | (((unsigned long long)hi) << 32);      
  return (jlong) x;
}

