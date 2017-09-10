// Copyright 2014 by Bill Torpey. All Rights Reserved.
// This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 United States License.
// http://creativecommons.org/licenses/by-nc-nd/3.0/us/deed.en

inline unsigned long long cpuid_rdtsc() {
  unsigned int lo, hi;
  asm volatile (
     "cpuid \n"
     "rdtsc"
   : "=a"(lo), "=d"(hi) /* outputs */
   : "a"(0)             /* inputs */
   : "%ebx", "%ecx");     /* clobbers*/
  return ((unsigned long long)lo) | (((unsigned long long)hi) << 32);
}

inline unsigned long long rdtsc() {
  unsigned int lo, hi;
  asm volatile (
     "rdtsc"
   : "=a"(lo), "=d"(hi) /* outputs */
   : "a"(0)             /* inputs */
   : "%ebx", "%ecx");     /* clobbers*/
  return ((unsigned long long)lo) | (((unsigned long long)hi) << 32);
}

inline unsigned long long rdtscp() {
  unsigned int lo, hi;
  asm volatile (
     "rdtscp"
   : "=a"(lo), "=d"(hi) /* outputs */
   : "a"(0)             /* inputs */
   : "%ebx", "%ecx");     /* clobbers*/
  return ((unsigned long long)lo) | (((unsigned long long)hi) << 32);
}
