#library('kernel');
#import('dart:math', prefix:'Math');
#import('drand.dart');
    List<double> NewVectorCopy(List<double> x)
  {
		int N = x.length;

		List<double> y = new List<double>(N);
		for (int i=0; i<N; i++)
			y[i] = x[i];

		return y;
  }
	
  CopyVector(List<double> B, List<double> A) {
		int N = A.length;

		for (int i=0; i<N; i++)
			B[i] = A[i];
  }

	  List<double> RandomVector(int N)
	{
		List<double> A = new List<double>(N);

		for (int i=0; i<N; i++)
			A[i] = random();
		return A;
	}

	  List<List<double>> createMatrix(int M, int N) {
	    List<List<double>> ret = new List<List<double>>(N);
	    for (int i=0; i<N; i++) {
	      ret[i] = new List<double>(M);
	    }
	    return ret;
	  }
	  
	  List<List<double>> RandomMatrix(int M, int N)
	  {
      List<List<double>> A = createMatrix(M, N);
      for (int i=0; i<N; i++)
        for (int j=0; j<N; j++)
          A[i][j] = random();
      return A;
    }
	  
	  class matrix<T> {
	    int M;
	    int N;
	    List<T> mat;
	    matrix(this.M, this.N);
	    void set(int x, int y, T val) {
	      mat[y*M+x] = val;
	    }
	    T get(int x, int y) {
	      return mat[y*M+x];
	    }
	  }
