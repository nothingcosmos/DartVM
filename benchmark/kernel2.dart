#library('kernel2');
#import('dart:math', prefix:'Math');
#import('drand.dart');
#import('dart:scalarlist');
    Float64List NewVectorCopy(Float64List x)
  {
		int N = x.length;

		Float64List y = new Float64List(N);
		for (int i=0; i<N; i++)
			y[i] = x[i];

		return y;
  }
	
  CopyVector(Float64List B, Float64List A) {
		int N = A.length;

		for (int i=0; i<N; i++)
			B[i] = A[i];
  }

	  Float64List RandomVector(int N)
	{
		Float64List A = new Float64List(N);

		for (int i=0; i<N; i++)
			A[i] = random();
		return A;
	}

	  List<Float64List> createMatrix(int M, int N) {
	    List<Float64List> ret = new List<Float64List>(N);
	    for (int i=0; i<N; i++) {
	      ret[i] = new Float64List(M);
	    }
	    return ret;
	  }
	  
	  List<Float64List> RandomMatrix(int M, int N)
	  {
      List<Float64List> A = createMatrix(M, N);
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
