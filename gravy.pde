boolean test=false;

int      n=test?2:200; //number of objects
int     dark=100; //how many objects have no collision
float    dt=0.25; //timestep
float   s=1; //visual size multiplier
float   c=1; //collision size multiplier
float   box=400; //box size
boolean boundary=true;
float   initalvelocities=6;
float   initialspheresize=400;
boolean showbox=true;
boolean showaxes=false;
boolean isometric=false;

float[][] pos;
float[] vel;
float[][] pos1;
float[][] acc;
float[]  mass;
float[] center; //center of mass
float totalmass;
int     dim=3; //dimensions
float   e=20; //softening radius
float   l;//collision radius
float   time;

int i;  //some looping constants because you can't iterate through an array...
int j;
int k;
float d;
float dsq;
float[] out; //temp variables
float temp;
float temp1;
float rx;
float ry;
float x;
float y;
float z;

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

void project(float rx,float ry,float x1,float y1,float z1){ //dumps values into x,y,z variables
  x=cos(rx)*x1+sin(rx)*z1;
  y=cos(ry)*y1+sin(ry)*(-sin(rx)*x1+cos(rx)*z1);
  z=isometric?1:(-sin(ry)*y1+cos(ry)*(-sin(rx)*x1+cos(rx)*z1)+1200)/800;
}

void line3(float rx,float ry,float x1,float y1,float z1,float x2,float y2,float z2){
  project(rx,ry,x1,y1,z1);
  temp=x/z;
  temp1=y/z;
  project(rx,ry,x2,y2,z2);
  line(temp+width/2,temp1+height/2,x/z+width/2,y/z+height/2);
}

void setup(){
  stroke(255);
  strokeWeight(10);
  size(800,800,P3D);
  pos=new float[n][dim];
  pos1=new float[n][dim];
  vel=new float[dim];
  acc=new float[n][dim];
  mass=new float[n];
  center=new float[dim];
  float[] c = {0,0,0};
  for (i=0; i<n; i++){
    pos[i]=random_point_in_sphere(c,test?40:initialspheresize);
    mass[i]=random(100,200);
    totalmass+=mass[i];
    vel=random_point_in_sphere(new float[3],test?0:initalvelocities);
    for(k=0;k<dim;k++){
      pos1[i][k]=pos[i][k]-vel[k]*dt;
    }
  }
}

void draw(){
  background(0);
  //println(millis()-time);
  time=millis();
  
  rx=mouseX*2*PI/width;
  ry=mouseY*2*PI/height;
  
  //box
  if(showbox){
    for(i=-1;i<=1;i+=2){
      for(j=-1;j<=1;j+=2){
        line3(rx,ry,box*i,box*j,box,box*i,box*j,-box);
        line3(rx,ry,box*i,box,box*j,box*i,-box,box*j);
        line3(rx,ry,box,box*i,box*j,-box,box*i,box*j);
      }
    }
  }
  //axes
  if(showaxes){
    stroke(255,0,0);
    line3(rx,ry,0,0,0,100,0,0);
    stroke(0,255,0);
    line3(rx,ry,0,0,0,0,100,0);
    stroke(0,0,255);
    line3(rx,ry,0,0,0,0,0,100);
    stroke(255);
  }
  
  
  center[0]=0;
  center[1]=0;
  center[2]=0;
  for (i=0; i<n; i++){
    for (k=0; k<dim; k++){
      center[k]+=constrain(pos[i][k],-800,800)*mass[i]/totalmass;//we constrain so free particles don't skew the average
    }
  }
  //printArray(center);
  
  for (i=0; i<n; i++){
    for (j=i+1; j<n; j++){
      dsq=0;
      for (k=0; k<dim; k++){
        dsq+=pow(pos[i][k]-pos[j][k],2);
      }
      if(i>=dark && j>=dark){  //if both particles are normal matter
        d=sqrt(dsq);
        l=(mass[i]+mass[j])/40*c;
        if(d<l){//collisions
          for (k=0; k<dim; k++){
            temp=(pos[i][k]-pos[j][k])*(l-d)/l;
            pos[i][k]+=temp/2;
            pos[j][k]-=temp/2;
          } 
        }
      }
      dsq+=pow(e,2); //softening; not ideal, but a good quick fix
      for (k=0; k<dim; k++){
        temp=mass[j]*(pos[i][k]-pos[j][k])/pow(dsq,dim/2.);
        acc[i][k]-=temp;
        acc[j][k]+=temp;
      }
    }
  }
  for (i=0; i<n; i++){
    for (k=0; k<dim; k++){
      temp=pos[i][k];
      pos[i][k]=2*pos[i][k]-pos1[i][k]+acc[i][k]*dt*dt;
      pos1[i][k]=temp;
      acc[i][k]=0;
      pos[i][k]-=center[k];//recentering camera
      pos1[i][k]-=center[k];
      if(boundary) pos[i][k]=constrain(pos[i][k],-box,box);
    }
    //if(test) pos[i][2]=0;
    fill(i<dark?0:255);
    project(rx,ry,pos[i][0],pos[i][1],pos[i][2]);
    if(z>0) ellipse(x/z+width/2,
                   y/z+height/2,
                   s*2*mass[i]/(40*z),
                   s*2*mass[i]/(40*z));
  }
}
