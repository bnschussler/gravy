float[][] pos;
float[][] vel;
float[]   acc;
float[]  mass;
int      n=100; //number of objects
float    dt=1; //timestep
int     dim=3; //dimensions
float   e=20; //softening radius

int i;  //some looping constants because you can't iterate through an array...
int j;
int k;
float d;
float dsq;
float[] out; //temp variable

float[] random_point_in_sphere(float[] center, float r){ //terrible implementation but I'm tired rn
  out=new float[3];
  out[0]=2;
  while(dist(0,0,0,out[0],out[1],out[2])>1){
    out[0]=random(-1,1);
    out[1]=random(-1,1);
    out[2]=random(-1,1);
  }
  out[0]=out[0]*r+center[0];
  out[1]=out[1]*r+center[1];
  out[2]=out[2]*r+center[2];
  return out;
}

float[] m;
float totalmass;

void setup(){
  size(800,800,P3D);
  noFill();
  pos=new float[n][dim];
  vel=new float[n][dim];
  acc=new float[dim];
  mass=new float[n];
  m=new float[dim];
  float[] c = {400,400,400};
  for (i=0; i<n; i++){
    pos[i]=random_point_in_sphere(c,400);
    mass[i]=random(100,200);
    for (k=0; k<dim; k++){
      vel[i][k]=random(-4,4);
    }
  }
  
  //remove net momentum
  for (i=0; i<n; i++){
    totalmass+=mass[i];
    for (k=0; k<dim; k++){
      m[k]+=mass[i]*vel[i][k];
    }
  }
  for (i=0; i<n; i++){
    for (k=0; k<dim; k++){
      vel[i][k]-=m[k]/totalmass;
    }
  }
}

void draw(){
  
  background(129);
  pushMatrix();  //3D rotation stuff (i'm really glad I wrote this back in 2019 so I don't have to deal with it now)
  translate(400,400,-400);
  rotateY(mouseX*2*PI/width);
  rotateX(mouseY*2*PI/height);
  box(800);
  popMatrix();
  
  for (i=0; i<n; i++){
    for (k=0; k<dim; k++){
      pos[i][k]+=dt/2*vel[i][k];
    }
  }
  for (i=0; i<n; i++){
    for (j=0; j<n; j++){
      dsq=0;
      for (k=0; k<dim; k++){
        dsq+=pow(pos[i][k]-pos[j][k],2);
      }
      dsq+=pow(e,2); //softening; not ideal, but a good quick fix
      if (i!=j){
        for (k=0; k<dim; k++){
          acc[k]-=mass[j]*(pos[i][k]-pos[j][k])/pow(dsq,dim/2.);
        }
      }
    }
    for (k=0; k<dim; k++){
      vel[i][k]+=dt*acc[k];
      acc[k]=0;
    }
  }
  for (i=0; i<n; i++){
    for (k=0; k<dim; k++){
      pos[i][k]+=dt/2*vel[i][k];
      //pos[i][k]=((pos[i][k]%800)+800)%800;
    }
    //pos[i][2]=0;
    
    pushMatrix();
    translate(400,400,-400);
    rotateY(mouseX*2*PI/width);
    rotateX(mouseY*2*PI/height);
    translate(-400,-400,400);
    translate(pos[i][0],pos[i][1],-pos[i][2]);
    sphere(mass[i]/50);
    popMatrix();
  }
}
