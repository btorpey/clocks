#!/bin/bash 


# Need to change JAVA_HOME to point to jdk installation
if [ "$JAVA_HOME" == "" ] ; then
  export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.45.x86_64
fi
export PATH=$JAVA_HOME/bin:$PATH

if [[ $(grep rdtscp /proc/cpuinfo | wc -l) -gt 0 ]] ; then
  RDTSCP=" -DRDTSCP=1 "
fi

echo;echo "clocks.c"
gcc clocks.c -lrt && ./a.out

# test cpp side
echo;echo "ClockBench.cpp"
g++ -O3 -lrt ${RDTSCP} ClockBench.cpp && taskset -c 1 ./a.out $*

# test java side
rm -f SysTime.h
rm -f SysTime.class
rm -f ClockBench.class
rm -f libsystime.so
javac -classpath . SysTime.java
javah -classpath . SysTime
javac -classpath . ClockBench.java
gcc -O3 -o libsystime.so -shared -Wl,-soname,systime.so -I$JAVA_HOME/include -I$JAVA_HOME/include/linux -lc -fPIC -lrt SysTime.c
echo;echo "ClockBench.java"
LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH java ${RDTSCP} -server -classpath . ClockBench $*

