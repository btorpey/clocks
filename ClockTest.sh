#!/bin/bash
#
# Copyright 2014 by Bill Torpey. All Rights Reserved.
# This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 United States License.
# http://creativecommons.org/licenses/by-nc-nd/3.0/us/deed.en
#

if [[ ${OSTYPE} == *linux* ]]; then
  LIBRT="-lrt"
  TASKSET="taskset -c 1"
  JAVAINC=linux
  SOEXT=so
  # does this machine have rdtscp instruction?
  if [[ $(grep rdtscp /proc/cpuinfo | wc -l) -gt 0 ]] ; then
    RDTSCP=" -DRDTSCP=1 "
  fi
elif [[ ${OSTYPE} == *darwin* ]]; then
  # assume RDTSCP -- not sure what else to do
  RDTSCP=" -DRDTSCP=1 "
  JAVAINC=darwin
  SOEXT=jnilib
fi


## show available clocks
echo;echo "clocks.c"
gcc -o clocks clocks.c ${LIBRT} && ./clocks

# benchmark clocks
# cpp side
echo;echo "ClockBench.cpp"
g++ -O3 -ggdb ${LIBRT} ${RDTSCP} -o ClockBench ClockBench.cpp && ${TASKSET} ./ClockBench $*

if [[ -z ${JAVA_HOME} ]]; then
   echo
   echo "Set JAVA_HOME to run Java benchmark"
else
   # java side
   export PATH=$JAVA_HOME/bin:$PATH
   rm -f SysTime.h
   rm -f SysTime.class
   rm -f ClockBench.class
   rm -f libsystime.${SOEXT}
   javac -classpath . SysTime.java
   javah -classpath . SysTime
   javac -classpath . ClockBench.java
   #gcc -O3 -o libsystime.so -shared -Wl,-soname,systime.so -I${JAVA_HOME}/include -I${JAVA_HOME}/include/${JAVAINC} -lc -fPIC ${LIBRT} SysTime.c
   gcc -O3 -o libsystime.${SOEXT} -shared -I${JAVA_HOME}/include -I${JAVA_HOME}/include/${JAVAINC} -lc -fPIC ${LIBRT} SysTime.c
   echo;echo -n "ClockBench.java - "; java -version 2>&1 | grep "java version"
   (export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH;java -Djava.library.path=. ${RDTSCP} -server -classpath . ClockBench $*)
fi