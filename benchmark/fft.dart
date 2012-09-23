#import('dart:math', prefix:'Math');
#import('drand.dart');
#import('kernel.dart');

/** Computes FFT's of complex, double precision data where n is an integer power of 2.
  * This appears to be slower than the Radix2 method,
  * but the code is smaller and simpler, and it requires no extra storage.
  * <P>
  *
  * @author Bruce R. Miller bruce.miller@nist.gov,
  * @author Derived from GSL (Gnu Scientific Library), 
  * @author GSL's FFT Code by Brian Gough bjg@vvv.lanl.gov
  */

  /* See {@link ComplexDoubleFFT ComplexDoubleFFT} for details of data layout.
   */

 class FFT {

   static double num_flops(int N)
  {
	 double Nd = N.toDouble();
	 double logN = log2(N).toDouble();

	 return (5.0*Nd-2)*logN + 2*(Nd+1);
   }


  /** Compute Fast Fourier Transform of (complex) data, in place.*/
   static void transform (List<double> data) {
    transform_internal(data, -1); }

  /** Compute Inverse Fast Fourier Transform of (complex) data, in place.*/
   static void inverse (List<double> data) {
    transform_internal(data, +1);  
    // Normalize
    int nd=data.length;
    int n =(nd/2).toInt();
    double norm=1/(n);
    for(int i=0; i<nd; i++)
      data[i] *= norm;
  }

  /** Accuracy check on FFT of data. Make a copy of data, Compute the FFT, then
    * the inverse and compare to the original.  Returns the rms difference.*/
   static double test(List<double> data){
    int nd = data.length;
    // Make duplicate for comparison
    //List<double> copy = new List<double>(nd);
    //System.arraycopy(data,0,copy,0,nd);
    //List<double> copy = new List<double>(nd);
    //Arrays.copy(data,0,copy,0,nd);
    
    List<double> copy = new List.from(data);
    
    // Transform & invert
    transform(data);
    inverse(data);
    // Compute RMS difference.
    double diff = 0.0;
    for(int i=0; i<nd; i++) {
      double d = data[i]-copy[i];
      diff += d*d; }
    return Math.sqrt(diff/nd); }

  /** Make a random array of n (complex) elements. */
   static List<double> makeRandom(int n){
    int nd = 2*n;
    List<double> data = new List<double>(nd);
    for(int i=0; i<nd; i++) {
      data[i]= random();
    }
    return data; }

  /* ______________________________________________________________________ */

   static int log2 (int n){
    int log = 0;
    for(int k=1; k < n; k *= 2, log++);
    if (n != (1 << log)) {
      print("FFT: Data length is not a power of 2!: $n");
    }
    return log; }

   static void transform_internal (List<double> data, int direction) {
	if (data.length == 0) return;    
	int n = (data.length/2).toInt();
    if (n == 1) return;         // Identity operation!
    int logn = log2(n);

    /* bit reverse the input data for decimation in time algorithm */
    bitreverse(data) ;

    /* apply fft recursion */
	/* this loop executed log2(N) times */
    for (int bit = 0, dual = 1; bit < logn; bit++, dual *= 2) {
      double w_real = 1.0;
      double w_imag = 0.0;

      double theta = 2.0 * direction * Math.PI / (2.0 * dual);
      double s = Math.sin(theta);
      double t = Math.sin(theta / 2.0);
      double s2 = 2.0 * t * t;

      /* a = 0 */
      for (int b = 0; b < n; b += 2 * dual) {
        int i = 2*b ;
        int j = 2*(b + dual);

        double wd_real = data[j] ;
        double wd_imag = data[j+1] ;
          
        data[j]   = data[i]   - wd_real;
        data[j+1] = data[i+1] - wd_imag;
        data[i]  += wd_real;
        data[i+1]+= wd_imag;
      }
      
      /* a = 1 .. (dual-1) */
      for (int a = 1; a < dual; a++) {
        /* trignometric recurrence for w-> exp(i theta) w */
        {
          double tmp_real = w_real - s * w_imag - s2 * w_real;
          double tmp_imag = w_imag + s * w_real - s2 * w_imag;
          w_real = tmp_real;
          w_imag = tmp_imag;
        }
        for (int b = 0; b < n; b += 2 * dual) {
          int i = 2*(b + a);
          int j = 2*(b + a + dual);

          double z1_real = data[j];
          double z1_imag = data[j+1];
              
          double wd_real = w_real * z1_real - w_imag * z1_imag;
          double wd_imag = w_real * z1_imag + w_imag * z1_real;

          data[j]   = data[i]   - wd_real;
          data[j+1] = data[i+1] - wd_imag;
          data[i]  += wd_real;
          data[i+1]+= wd_imag;
        }
      }
    }
  }


   static void bitreverse(List<double> data) {
    /* This is the Goldrader bit-reversal algorithm */
    int n=(data.length/2).toInt();
	int nm1 = n-1;
	int i=0; 
	int j=0;
    for (; i < nm1; i++) {

      //int ii = 2*i;
      int ii = i << 1;

      //int jj = 2*j;
      int jj = j << 1;

      //int k = n / 2 ;
      int k = n >> 1;

      if (i < j) {
        double tmp_real    = data[ii];
        double tmp_imag    = data[ii+1];
        data[ii]   = data[jj];
        data[ii+1] = data[jj+1];
        data[jj]   = tmp_real;
        data[jj+1] = tmp_imag; }

      while (k <= j) 
	  {
        //j = j - k ;
		j -= k;

        //k = k / 2 ; 
        k >>= 1 ; 
	  }
      j += k ;
    }
  }
}
 
 double measureFFT(int N, double mintime) {
   // initialize FFT data as complex (N real/img pairs)

   List<double> x = RandomVector(2*N);
   List<double> oldx = NewVectorCopy(x);
   int cycles = 1;
   var elapsedTime;

   while(true)
   {
     var stime = new Date.now();
     for (int i=0; i<cycles; i++)
     {
       FFT.transform(x);       // forward transform
       FFT.inverse(x);         // backward transform
     }
     var etime = new Date.now();
     elapsedTime = etime.difference(stime).inMilliseconds;
     print("cycles time = ${cycles} : ${elapsedTime}[ms]");
     if (elapsedTime >= mintime) {
       break;
     }
     cycles *= 2;
   }
   // approx Mflops

   final double EPS = 1.0e-10;
   if ( FFT.test(x) / N > EPS )
     return 0.0;
   
   return FFT.num_flops(N)*cycles/ (elapsedTime/1000.0) * 1.0e-6;
 }
 
 /** Simple Test routine. */
 main(){
   var args = new Options().arguments;
   if (args.length == 0) { 
     int n = 1024;
     print("n= ${n} => RMS Error= ${FFT.test(FFT.makeRandom(n))}");
   }
   for(int i=0; i<args.length; i++) {
     int n = Math.parseInt(args[i]);
     print("n= ${n} => RMS Error= ${FFT.test(FFT.makeRandom(n))}");
   }
   print("ret = ${measureFFT(1024, 2000.0)}");
 }
