Code to test various clocks under Linux
=======================================

Some quick notes on the code:

-   The ClockTest.sh script compiles the code, and executes the test programs.
    It uses taskset to ensure that the tests don't migrate to different CPUs.
    (taskset is done only for the C++ test – the JVM uses so many threads that
    pinning them all to a single CPU is probably not a good idea). You'll need
    to modify the script to specify the correct location for JAVA_HOME on your
    system, or set JAVA_HOME prior to calling the script.

-   The script detects whether the rdtscp instruction is available by querying
    /proc/cpuinfo. If not, it bypasses that code (which would otherwise throw a
    SIGILL).

-   You can also pass in the CPU frequency, in GHz. If you don't, then a
    frequency of 1 is used, which has the effect of returning the tick count
    unmodified for those clock sources that use tick counts (i.e., anything
    having to do with the RDTSC instruction).

-   If the script doesn't seem to be working, execute it with “bash -xv
    ClockTest.sh” to see the actual commands.


&copy; Copyright 2014 by Bill Torpey.   All Rights Reserved.
This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/deed.en_US">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
