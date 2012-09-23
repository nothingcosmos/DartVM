#import('dart:math', prefix:'Math');
#import('drand.dart');
#import('kernel.dart');


class Jacobi
{
	static double num_flops(int M, int N, int num_iterations)
	{
		double Md = M.toDouble();
		double Nd = N.toDouble();
		double num_iterD = num_iterations.toDouble();

		return (Md-1)*(Nd-1)*num_iterD*6.0;
	}

	static void SOR(double omega, List<List<double>> G, int num_iterations)
	{
		int M = G.length;
		int N = G[0].length;

		double omega_over_four = omega * 0.25;
		double one_minus_omega = 1.0 - omega;

		// update interior points
		//
		int Mm1 = M-1;
		int Nm1 = N-1; 
		for (int p=0; p<num_iterations; p++)
		{
			for (int i=1; i<Mm1; i++)
			{
				List<double> Gi = G[i];
				List<double> Gim1 = G[i-1];
				List<double> Gip1 = G[i+1];
				for (int j=1; j<Nm1; j++)
					Gi[j] = omega_over_four * (Gim1[j] + Gip1[j] + Gi[j-1] 
								+ Gi[j+1]) + one_minus_omega * Gi[j];
			}
		}
	}
}

double measureSOR(int N, double min_time)
{
  var elapsedTime;
  List<List<double>> G = RandomMatrix(N, N);

  int cycles=1;
  while(true)
  {
    var stime = new Date.now();
    Jacobi.SOR(1.25, G, cycles);
    var etime = new Date.now();
    elapsedTime = etime.difference(stime).inMilliseconds;
    print("cycles time = ${cycles} : ${elapsedTime}[ms]");
    if (elapsedTime >= min_time) {
      break;
    }
    cycles *= 2;
  }
  // approx Mflops
  return Jacobi.num_flops(N, N, cycles) / (min_time /1000.0) * 1.0e-6;
}

/** Simple Test routine. */
main(){
  print("ret = ${measureSOR(100, 2000.0)}");
}
			
