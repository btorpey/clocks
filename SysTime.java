//
// Definition of native methods to get various clock values from Java
//
public class SysTime
{
  static
  {
    System.loadLibrary("systime");
  }

  public native static long clocktime();
  public native static long cpuidrdtsc();
  public native static long rdtsc();
  public native static long rdtscp();

  public static void main(String[] args)
  {
    int count = (0 < args.length)? Integer.parseInt(args[0]): 10;
    for (int i = count; 0 <= --i; ) {
      long msNow = System.currentTimeMillis();
      long nsNow = System.nanoTime();
      long sysTime = SysTime.clocktime();
      long cpuid_tsc = SysTime.cpuidrdtsc();
      long tsc = SysTime.rdtsc();
      long tscp = SysTime.rdtscp();
      
      System.out.println();
      System.out.printf("System.millis          =%,d\n",msNow);
      System.out.printf("System.nanoTime        =%,d\n",nsNow);
      System.out.printf("SysTime.clocktime      =%,d\n",sysTime);
      System.out.printf("SysTime.cpuid_rdtsc    =%,d\n",cpuid_tsc);
      System.out.printf("SysTime.rdtsc          =%,d\n",tsc);
      System.out.printf("SysTime.rdtscp         =%,d\n",tscp);
    }
  }
}
