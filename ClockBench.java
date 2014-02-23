class ClockBench
{
   
   static double CPU_FREQ = 1;
   static int ITERS=100;             // how many iterations to run
   static final int BUCKETS=201;    // how many samples to collect per iteration
   
   
   public static class deltaT   {
   
      deltaT(long[] v) 
      {
         sum=0; sum2=0; min=-1; max=0; avg=0; median=0; stdev=0;
          
         // create vector with deltas between adjacent entries
         x = v;
         for (int i = 0; i < x.length-1; ++i) {
            x[i] = x[i+1] - x[i];
         }      
         count = x.length -1;
         
         for (int i = 0; i < count; ++i) {
            sum    += x[i];
            sum2   += (x[i] * x[i]);
            if (x[i] > max) max = x[i];
            if ((min == -1) || (x[i] < min)) min = x[i];
         }
         
         avg = sum / count;
         median = min + ((max - min) / 2);
         stdev =  Math.sqrt((count  * sum2 - (sum * sum)) / (count * count));
      }
      
      void print()
      {
         System.out.printf("%d\t%7.2f\t%7.2f\t%7.2f\t%7.2f\t%7.2f\n", count, min, max, avg, median, stdev);
      } 
      
      void dump()
      {
         System.out.printf("%7.2f\t%7.2f\n", sum, sum2);
         System.out.printf("\n");
         for (int i = 0 ; i < count; ++i )
            System.out.printf("[%d]=%d\t", i, x[i]);
      } 
   
      long[] x;
      long   count;   
      double sum;
      double sum2;
      double min;
      double max;
      double avg;
      double median;
      double stdev;
   };

   
   public static volatile long[] timestamp = new long[BUCKETS];
   
   public static void main(String[] args)
   {
      if (args.length > 0) {
         CPU_FREQ = Double.parseDouble(args[0]);
      }

      System.out.printf("%25s\t%7s\t%7s\t%7s\t%7s\t%7s\t%7s\n", "Method", "samples","min","max","avg","median","stdev");
      {
         for (int i = 0; i < (ITERS * BUCKETS); ++i) {
            timestamp[i % BUCKETS] = System.nanoTime();
         }    
         System.out.printf("%25s\t", "System.nanoTime");
         deltaT x = new deltaT(timestamp);
         x.print();
         //x.dump();
      }      
      
      {
         for (int i = 0; i < (ITERS * BUCKETS); ++i) {
            timestamp[i % BUCKETS]  = SysTime.clocktime();
         }    
         System.out.printf("%25s\t", "CLOCK_REALTIME");
         deltaT x = new deltaT(timestamp);
         x.print();
         //x.dump();
      }
      
      {
         for (int i = 0; i < (ITERS * BUCKETS); ++i) {
            timestamp[i % BUCKETS]  = SysTime.cpuidrdtsc();
         }    
         for (int i = 0; i < BUCKETS; ++i) { 
            timestamp[i] = (long) ((double) timestamp[i] / CPU_FREQ);
         }
         System.out.printf("%25s\t", "cpuid+rdtsc");
         deltaT x = new deltaT(timestamp);
         x.print();
         //x.dump();
      }
      
      if (System.getProperty("RDTSCP") != null) 
      {
         for (int i = 0; i < (ITERS * BUCKETS); ++i) {
            timestamp[i % BUCKETS]  = SysTime.rdtscp();
         }    
         for (int i = 0; i < BUCKETS; ++i) { 
            timestamp[i] = (long) ((double) timestamp[i] / CPU_FREQ);
         }
         System.out.printf("%25s\t", "rdtscp");
         deltaT x = new deltaT(timestamp);
         x.print();
         //x.dump();
      }

      {
         for (int i = 0; i < (ITERS * BUCKETS); ++i) {
            timestamp[i % BUCKETS]  = SysTime.rdtsc();
         }    
         for (int i = 0; i < BUCKETS; ++i) { 
            timestamp[i] = (long) ((double) timestamp[i] / CPU_FREQ);
         }
         System.out.printf("%25s\t", "rdtsc");
         deltaT x = new deltaT(timestamp);
         x.print();
         //x.dump();
      }
      
      System.out.printf("Using CPU frequency = %,f\n", CPU_FREQ);
   }

}
