int     n=200; //number of objects
int     dark=0; //how many objects have no collision
float    dt=0.25; //timestep
float   s=1; //visual size multiplier
float   c=1; //collision size multiplier
float   box=400; //box size
boolean boundary=true;
float   initialv=0;
float   initialr=400;
float   g=1;
int     dim=3; //dimensions
boolean showbox=true;
boolean showaxes=false;
boolean isometric=false;
boolean showW=false;
boolean centerCamera=false;

float[] rotation;
int ri=0; //which plane is being rotated

float[][] pos;
float[][] pos1;
float[][] acc;
float[]  mass;
float[] center; //center of mass
float[] w; //angular momentum
float totalmass;
float   e=20; //softening radius

int i;  //some looping constants because you can't iterate through an array...
int j;
int k;
int k1;
float d;
float dsq;
float[] tempVec; //temp variables
float[] tempVec1;
float[] tempVec2;
float temp;
float temp1;
float l;//collision radius
float time;

void updateSettings(int n1,int dim1,float g1,float dark1,float size,float startvel,float startpos,float boxsize,boolean showbox1,boolean showaxes1,boolean boundary1,boolean isometric1,boolean showW1,boolean centerCamera1){
  reDimension(dim1);
  reParticle(n1);
  
  n=n1;
  dim=dim1;
  g=g1;
  dark=floor(n*dark1);
  s=size;
  c=size;
  initialv=startvel;
  initialr=startpos;
  box=boxsize;
  showbox=showbox1;
  showaxes=showaxes1;
  boundary=boundary1;
  isometric=isometric1;
  showW=showW1;
  centerCamera=centerCamera1;
}

float[] project(float[] rotations,float[] vector){  
  tempVec=new float[max(3,dim)];
  arrayCopy(vector,tempVec);
  for(int k=0;k<max(3,dim);k++){
    k1=(k+2)%max(3,dim);
    temp=cos(rotations[k1])*tempVec[k1]+sin(rotations[k1])*tempVec[(k1+1)%max(3,dim)];
    temp1=-sin(rotations[k1])*tempVec[k1]+cos(rotations[k1])*tempVec[(k1+1)%max(3,dim)];
    tempVec[k1]=temp;
    tempVec[(k1+1)%max(3,dim)]=temp1;
  }
  tempVec[2]=isometric?1:(tempVec[2]+1200)/800; //camera angle
  return tempVec;
}

void line3(float[] rotations,float[] point1,float[] point2){
  point1=project(rotations,point1);
  point2=project(rotations,point2);
  line(point1[0]/point1[2]+width/2,point1[1]/point1[2]+height/2,point2[0]/point2[2]+width/2,point2[1]/point2[2]+height/2);
}

void reDimension(int dim1){//adds/removes dimensions
  if(dim1!=dim){
    center=new float[max(3,dim1)];
    acc=new float[n][max(3,dim1)];
    tempVec=new float[max(3,dim1)]; 
    tempVec1=new float[max(3,dim1)];
    tempVec2=new float[max(3,dim1)];
    if (dim1>dim){//add dimensions
      int temp=max(3,dim1)-max(3,dim);
      for(i=0;i<n;i++){
        if(temp>0){
          pos[i]=concat(pos[i],new float[temp]);
          pos1[i]=concat(pos1[i],new float[temp]);
          rotation=concat(rotation,new float[temp]);
        }
        for(j=dim;j<dim1;j++){
          pos1[i][j]=random(-1,1)*dt;
        }
      }
    }
    if (dim1<dim){ //remove dimensions
      int temp=max(3,dim)-max(3,dim1);
      int temp1=max(3,dim)-dim1;
      rotation=subset(rotation,0,max(3,dim1));
      ri=0;
      for(i=0;i<n;i++){
        pos[i]=subset(pos[i],0,dim1);
        pos1[i]=subset(pos1[i],0,dim1);
        if(temp<=0){
          pos[i]=concat(pos[i],new float[temp1]);
          pos1[i]=concat(pos1[i],new float[temp1]);
        }
      }
    }
  }
}

void reParticle(int n1){//adds/removes particles
  if (n1>n){//add particles
    mass=concat(mass,new float[n1-n]);
    acc=new float[n1][dim];
    float[][] tempPos=new float[n1][dim];
    float[][] tempPos1=new float[n1][dim];
    for(i=0;i<n;i++){
      tempPos[i]=pos[i];
      tempPos1[i]=pos1[i];
    }
    for(i=n;i<n1;i++){
      for(k=0;k<dim;k++){
        tempPos[i][k]=random(-1,1)*initialr;
        tempPos1[i][k]=tempPos[i][k]-random(-1,1)*initialv*dt;
      }
      mass[i]=random(100,200);
      totalmass+=mass[i];
    }
    pos=tempPos;
    pos1=tempPos1;
  }
  
  if (n1<n){ //remove particles
    mass=subset(mass,n1);
    totalmass=0;
    acc=new float[n1][dim];
    float[][] tempPos=new float[n1][dim];
    float[][] tempPos1=new float[n1][dim];
    for(i=0;i<n1;i++){
      tempPos[i]=pos[i];
      tempPos1[i]=pos1[i];
      totalmass+=mass[i];
    }
    pos=tempPos;
    pos1=tempPos1;
  }
}

void setup(){
  stroke(255,255,255);
  size(800,800);
  pos=new float[n][max(3,dim)];  //the max thing is so that we can still look at things in 3d even if the positions are 2d
  pos1=new float[n][max(3,dim)];
  acc=new float[n][max(3,dim)];
  mass=new float[n];
  center=new float[max(3,dim)];
  w=new float[3]; //only relevant in 3 dimensions
  rotation=new float[max(3,dim)];  //this isn't enough for any rotation we could want (that would take dim*(dim-1) floats), but it's enough for our tiny 3d minds to be satisfied.
      //it also means that you can get gimbal lock, but I'm not dealing with quaternions/octonians etc. to do n dimentional rotations the right way. This was supposed to be a quick add-on, not an overhaul.
  tempVec=new float[max(3,dim)];
  tempVec1=new float[max(3,dim)];
  tempVec2=new float[max(3,dim)];
  reset();
}

void keyPressed(){
  if(key=='r'){
    reset();
  }
  if(key=='q'){
    ri=(ri+1)%(dim-1);
  }
  if(key=='a'){
    rotation=new float[max(3,dim)];
    ri=0;
  }
  if(key=='l'){
    reDimension(dim+1);
    dim++;
  }
  if(key=='k'){
    reDimension(dim-1);
    dim--;
  }
}

void reset(){
  for (i=0; i<n; i++){
    for (k=0;k<dim;k++){
      pos[i][k]=random(-1,1)*initialr;
      pos1[i][k]=pos[i][k]-random(-1,1)*initialv*dt;
    }
    mass[i]=random(100,200);
    totalmass+=mass[i];
  }
}

void drawBox(int dim, float size){//terrible implementation but I'm tired rn
  
  for(i=0;i<pow(2,dim);i++){
    for(k=0;k<dim;k++){
      tempVec1[k]=size*(2*((i>>k)&1)-1);
      tempVec2[k]=size*(2*((i>>k)&1)-1);
    }
    for(k=0;k<dim;k++){
      tempVec2[k]=0;
      line3(rotation,tempVec1,tempVec2);
      tempVec2[k]=tempVec1[k];
    }
  }
}

void draw(){
  stroke(255);
  background(0);
  //println(millis()-time);
  //time=millis();
  rotation[ri]+=(mouseX-pmouseX)*2*PI/width;
  rotation[ri+1]+=(mouseY-pmouseY)*2*PI/height;
  
  //box
  if(showbox){
    drawBox(dim,box);
  }//centering camera
  if(centerCamera){
    center[0]=0;
    center[1]=0;
    center[2]=0;
    for (i=0; i<n; i++){
      for (k=0; k<dim; k++){
        center[k]+=constrain(pos[i][k],-800,800)*mass[i]/totalmass;//we constrain so free particles don't skew the average
      }
    }
    for (i=0; i<n; i++){
      for (k=0; k<dim; k++){
        pos[i][k]-=center[k];//recentering camera
        pos1[i][k]-=center[k];   
      }
    }
  }
  if(dim<=3 && showW){//showing angular momentum
    w[0]=0;
    w[1]=0;
    w[2]=0;
    for (i=0; i<n; i++){
      for (k=0; k<max(3,dim); k++){
        w[k]+=(pos[i][(k+1)%3]*(pos[i][(k+2)%3]-pos1[i][(k+2)%3])-pos[i][(k+2)%3]*(pos[i][(k+1)%3]-pos1[i][(k+1)%3]))/n;
      }
    }
    stroke(255,0,255);
    line3(rotation,new float[3],w);
  }
  
  for (i=0; i<n; i++){
    for (j=i+1; j<n; j++){
      dsq=0;
      for (k=0; k<dim; k++){
        dsq+=pow(pos[i][k]-pos[j][k],2);
      }
      if(i>=dark && j>=dark){  //if both particles are normal matter
        d=sqrt(dsq);
        l=(mass[i]+mass[j])/40*c;
        if(d<l && d!=0){//collisions
          for (k=0; k<dim; k++){
            temp=(pos[i][k]-pos[j][k])*(l-d)/d;
            pos[i][k]+=temp/2;
            pos[j][k]-=temp/2;
          } 
        }
      }
      dsq+=pow(e,2); //softening; not ideal, but a good quick fix
      for (k=0; k<dim; k++){
        temp=g*mass[j]*(pos[i][k]-pos[j][k])/pow(dsq,3/2.);
        acc[i][k]-=temp;
        acc[j][k]+=temp;
      }
    }
  }
  for (i=0; i<n; i++){
    for (k=0; k<dim; k++){
      temp=pos[i][k];
      pos[i][k]+=(pos[i][k]-pos1[i][k])+acc[i][k]*dt*dt;
      pos1[i][k]=temp;
      acc[i][k]=0;
      if(boundary){
        if(pos[i][k]>box){
          pos[i][k]-=(pos[i][k]-box)/2;
        }
        if(pos[i][k]<-box){
          pos[i][k]+=(-box-pos[i][k])/2;
        }
      }
    }
    fill(i<dark?0:255);
    tempVec=project(rotation,pos[i]);
    stroke(255);
    if(tempVec[2]>0) ellipse(tempVec[0]/tempVec[2]+width/2,
                   tempVec[1]/tempVec[2]+height/2,
                   s*2*mass[i]/(40*tempVec[2]),
                   s*2*mass[i]/(40*tempVec[2]));
  }
  //box=(box+399)%400;
  //axes
  if(showaxes){
    for(k=0;k<dim;k++){
    tempVec=new float[max(3,dim)];
    tempVec[k]=100;
    switch(k){
      case 0:
        stroke(255,0,0);
        break;
      case 1:
        stroke(0,255,0);
        break;
      case 2:
        stroke(0,0,255);
        break;
      case 3:
        stroke(255,255,0);
        break;
      case 4:
        stroke(0,255,255);
        break;
      case 5:
        stroke(255,0,255);
        break;
      default:
        stroke(255,255,255);
        break;
    }
    line3(rotation,new float[max(3,dim)],tempVec);
    }
  }

}
