float[][] pos;
float[][] vel;
float[]   acc;
float[] mass;
int n=10;
float t=1;

int i;
int j;
int k;
float d;

void setup(){
  size(800,800,P3D);
  
  noFill();
  pos=new float[n][3];
  vel=new float[n][3];
  acc=new float[3];
  mass=new float[n];
  for (i=0; i<n; i++){
    pos[i][0]=random(width);
    pos[i][1]=random(height);
    pos[i][2]=random(-800,0);
    mass[i]=random(200,1000);
    for (j=0; j<3; j++){
      vel[i][j]=random(-5,5);
    }
  }
}

void draw(){
  background(129);
  pushMatrix();
  
  translate(400,400,-400);
  rotateY(mouseX*2*PI/width);
  rotateX(mouseY*2*PI/height);
  box(800);
  popMatrix();
  for (i=0; i<n; i++){
    for (j=0; j<n; j++){
      d=dist(pos[i][0],pos[i][1],pos[i][2],pos[j][0],pos[j][1],pos[j][2]);
      if (i!=j){
        for (k=0; k<3; k++){
          acc[k]-=mass[j]*(pos[i][k]-pos[j][k])/pow(d,3);
        }
      }
    }
    for (k=0; k<3; k++){
      vel[i][k]+=t*acc[k];
      if (abs(vel[i][k])>10){
        vel[i][k]*=.99;
      }
      acc[k]=0;
    }
  }
  for (i=0; i<n; i++){
    for (k=0; k<3; k++){
      pos[i][k]+=t*vel[i][k];
      pos[i][k]=((pos[i][k]%800)+800)%800;
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
