#!/bin/bash
#
# Copyright 2014 by Bill Torpey. All Rights Reserved.
# This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 United States License. 
# http://creativecommons.org/licenses/by-nc-nd/3.0/us/deed.en
#

# Either set JAVA_HOME before running, or change to point to jdk installation
#export JAVA_HOME=/Library/java/JavaVirtualMachines/jdk1.7.0_11.jdk/Contents/Home
if [ "$JAVA_HOME" == "" ] ; then
  export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.45.x86_64
fi
export PATH=$JAVA_HOME/bin:$PATH

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
gcc clocks.c ${LIBRT} && ./a.out

# benchmark clocks
# cpp side
echo;echo "ClockBench.cpp"
  g++ -march=native -O3 -ggdb ${LIBRT} ${RDTSCP} ClockBench.cpp && ${TASKSET} ./a.out $*

# java side
rm -f SysTime.h
rm -f SysTime.class
rm -f ClockBench.class
rm -f libsystime.${SOEXT}
javac -classpath . SysTime.java
javah -classpath . SysTime
javac -classpath . ClockBench.java
#gcc -O3 -o libsystime.so -shared -Wl,-soname,systime.so -I${JAVA_HOME}/include -I${JAVA_HOME}/include/${JAVAINC} -lc -fPIC ${LIBRT} SysTime.c
gcc -O3 -o libsystime.${SOEXT} -shared -I${JAVA_HOME}/include -I${JAVA_HOME}/include/${JAVAINC} -lc -fPIC ${LIBRT} SysTime.c
echo;echo "ClockBench.java"
(export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH;java -Djava.library.path=. ${RDTSCP} -server -classpath . ClockBench $*)
