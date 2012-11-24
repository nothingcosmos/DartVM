import 'dart:math';
import 'dart:io';
import 'drand.dart';

double rand = -0.100;

void main() {
  print("### start aobench ###");
  for (var i = 0; i<4; i++) {
    var stime = new Date.now();
    var result = AOBench.run();
    var etime = new Date.now();
    var elapsedTime = etime.difference(stime).inMilliseconds;
    print("elapsed time = $elapsedTime ms");
  }
  print("### end   aobench ###");
  return ;
}

class Vec {
    double x, y, z;

    Vec(this.x, this.y, this.z);

    Vec.copy(Vec v) {
        this.x = v.x;
        this.y = v.y;
        this.z = v.z;
    }

    operator+ (Vec b) => new Vec(this.x + b.x, this.y + b.y, this.z + b.z);
    operator- (Vec b) => new Vec(this.x - b.x, this.y - b.y, this.z - b.z);

    Vec cross(Vec b) {
        double u = this.y * b.z - b.y * this.z;
        double v = this.z * b.x - b.z * this.x;
        double w = this.x * b.y - b.x * this.y;
        return new Vec(u, v, w);
    }

    void normalize() {
        double d = this.len;

        if ((d.abs()) > 1.0e-6) {
            double invlen = 1.0 / d;
            this.x *= invlen;
            this.y *= invlen;
            this.z *= invlen;
        }
    }

    double get len => sqrt(this.x * this.x + this.y * this.y + this.z * this.z);

    double dot(Vec b) {
        return this.x * b.x + this.y * b.y + this.z * b.z;
    }

    Vec neg() {
        return new Vec(-this.x, -this.y, -this.z);
    }
}


 class Ray {
    final Vec org, dir;

    Ray(this.org, this.dir);
}


 class Intersection {
    double t;
    Vec p; // hit point
    Vec n; // normal
    bool hit;

    Intersection() {
        hit = false;
        t = 1.0e+30;
        n = new Vec(0.0, 0.0, 0.0);
    }
}


 class Sphere {
    final Vec center;
    final double radius;

    Sphere(this.center, this.radius);

    void intersect(Intersection isect, Ray ray) {
        Vec rs = ray.org - (this.center);
        double B = rs.dot(ray.dir);
        double C = rs.dot(rs) - (this.radius * this.radius);
        double D = B * B - C;

        if (D > 0.0) {
            double t = -B - sqrt(D);
            if ((t > 0.0) && (t < isect.t)) {
                isect.t = t;
                isect.hit = true;

                // calculate normal.
                Vec p = new Vec(ray.org.x + ray.dir.x * t,
                                ray.org.y + ray.dir.y * t,
                                ray.org.z + ray.dir.z * t);
                Vec n = p - (center);
                n.normalize();
                isect.n = n;
                isect.p = p;
            }
        }
    }
}


 class Plane {
    final Vec p; // point on the plane
    final Vec n; // normal to the plane

    Plane(this.p, this.n);

    void intersect(Intersection isect, Ray ray) {
        double d = -p.dot(n);
        double v = ray.dir.dot(n);

        if ((v.abs()) < 1.0e-6)
            return; // the plane is parallel to the ray.

        double t = -(ray.org.dot(n) + d) / v;

        if ((t > 0) && (t < isect.t)) {
            isect.hit = true;
            isect.t = t;
            isect.n = n;

            Vec p2 = new Vec(ray.org.x + t * ray.dir.x,
                            ray.org.y + t * ray.dir.y,
                            ray.org.z + t * ray.dir.z);
            isect.p = p2;
        }
    }
}


 class AOBench {
    // render settings
     int IMAGE_WIDTH = 256;
     int IMAGE_HEIGHT = 256;
     int NSUBSAMPLES = 2;
     int NAO_SAMPLES = 8; // # of sample rays for ambient occlusion

    // scene data
    List<Sphere> spheres;
    Plane plane;

    void setup() {
        spheres = new List<Sphere>(3);
        spheres[0] = new Sphere(new Vec(-2.0, 0.0, -3.5), 0.5);
        spheres[1] = new Sphere(new Vec(-0.5, 0.0, -3.0), 0.5);
        spheres[2] = new Sphere(new Vec(1.0, 0.0, -2.2), 0.5);
        plane = new Plane(new Vec(0.0, -0.5, 0.0), new Vec(0.0, 1.0, 0.0));
    }

    int clamp(double f) {
        int i = (f * 255.5).toInt();
        if (i < 0)
            i = 0;
        if (i > 255)
            i = 255;
        return i;

    }

    void orthoBasis(List<Vec> basis, Vec n) {
        int i;
        basis[2] = new Vec.copy(n);
        basis[1] = new Vec(0.0, 0.0, 0.0);

        if ((n.x < 0.6) && (n.x > -0.6)) {
            basis[1].x = 1.0;
        } else if ((n.y < 0.6) && (n.y > -0.6)) {
            basis[1].y = 1.0;
        } else if ((n.z < 0.6) && (n.z > -0.6)) {
            basis[1].z = 1.0;
        } else {
            basis[1].x = 1.0;
        }

        basis[0] = basis[1].cross(basis[2]);
        basis[0].normalize();

        basis[1] = basis[2].cross(basis[0]);
        basis[1].normalize();
    }

    Vec ambientOcclusion(Intersection isect) {
        int i, j;
        int ntheta = NAO_SAMPLES;
        int nphi = NAO_SAMPLES;
        double eps = 0.0001;

        // Slightly move ray org towards ray dir to avoid numerical probrem.
        Vec p = new Vec(isect.p.x + eps * isect.n.x,
                        isect.p.y + eps * isect.n.y,
                        isect.p.z + eps * isect.n.z);

        // Calculate orthogonal basis.
        List<Vec> basis; basis = new List<Vec>(3);
        orthoBasis(basis, isect.n);

        double occlusion = 0.0;

        for (j = 0; j < ntheta; j++) {
            for (i = 0; i < nphi; i++) {
                // Pick a random ray direction with importance sampling.
                //double r = Math.random();
                double r = random();
                //rand = rand + 0.1;
                //double r = rand + 0.1;
                //double phi = 2.0 * Math.PI * Math.random();
                double phi = 2.0 * PI * random();
                //rand = rand + 0.1;
                //double phi = 2.0 * Math.PI * rand + 0.1;

                double sq = sqrt(1.0 - r);
                double x = cos(phi) * sq;
                double y = sin(phi) * sq;
                double z = sqrt(r);

                // local -> global
                double rx = x * basis[0].x + y * basis[1].x + z * basis[2].x;
                double ry = x * basis[0].y + y * basis[1].y + z * basis[2].y;
                double rz = x * basis[0].z + y * basis[1].z + z * basis[2].z;

                Vec raydir = new Vec(rx, ry, rz);
                Ray ray = new Ray(p, raydir);

                Intersection occIsect = new Intersection();
                spheres[0].intersect(occIsect, ray);
                spheres[1].intersect(occIsect, ray);
                spheres[2].intersect(occIsect, ray);
                plane.intersect(occIsect, ray);

                if (occIsect.hit)
                    occlusion += 1.0;
            }
        }

        // [0.0, 1.0]
        occlusion = (ntheta * nphi - occlusion) / (ntheta * nphi);
        return new Vec(occlusion, occlusion, occlusion);
    }

    void rowRender(List<int> row, int width, int height, int y, int nsubsamples) {
        for (int x = 0; x < width; x++) {
            double r = 0.0;
            double g = 0.0;
            double b = 0.0;

            // subsampling
            for (int v = 0; v < nsubsamples; v++) {
                for (int u = 0; u < nsubsamples; u++) {
                    double px = (x + (u / nsubsamples) - (width / 2.0))/(width / 2.0);
                    double py = (y + (v / nsubsamples) - (height / 2.0))/(height / 2.0);
                    py = -py;     // flip Y

                    double t = 10000.0;
                    Vec eye = new Vec(px, py, -1.0);
                    eye.normalize();

                    Ray ray = new Ray(new Vec(0.0, 0.0, 0.0), new Vec.copy(eye));

                    Intersection isect = new Intersection();
                    spheres[0].intersect(isect, ray);
                    spheres[1].intersect(isect, ray);
                    spheres[2].intersect(isect, ray);
                    plane.intersect(isect, ray);

                    if (isect.hit) {
                        t = isect.t;
                        Vec col = ambientOcclusion(isect);
                        r += col.x;
                        g += col.y;
                        b += col.z;
                    }
                }
            }

            row[3 * x + 0] = clamp(r / (nsubsamples * nsubsamples));
            row[3 * x + 1] = clamp(g / (nsubsamples * nsubsamples));
            row[3 * x + 2] = clamp(b / (nsubsamples * nsubsamples));
        }
    }

    void generate(String fileName) {
        List<int> renderLine = new List<int>(IMAGE_WIDTH * 3);

        OutputStream fout = new File(fileName).openOutputStream();
        
        fout.writeString("P3\n");
        fout.writeString("$IMAGE_WIDTH $IMAGE_HEIGHT\n");
        fout.writeString("255\n");

        for (int y = 0; y < IMAGE_HEIGHT; y++) {
            rowRender(renderLine, IMAGE_WIDTH, IMAGE_HEIGHT, y, NSUBSAMPLES);

            for (int x = 0; x < (IMAGE_WIDTH * 3); x += 3) {
              var out = new StringBuffer();
              out.add(renderLine[x + 0]).add(" ");
              out.add(renderLine[x + 1]).add(" ");
              out.add(renderLine[x + 2]).add("\n");
              fout.writeString(out.toString());
            }
        }

        fout.close();
    }

    static void run() {
      var ao = new AOBench();
      ao.setup();
      ao.generate("ao2.ppm");
    } 
    
}
