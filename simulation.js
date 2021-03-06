var  sdim=3; //number of dimensions in physical space
var  dim=3; //dimensions of simulation

var  n=800; //number of objects
var  dark=0; //what percent of objects have no collision
var  dt=.25; //timestep
var  s=10; //visual size multiplier
var  c=10; //collision size multiplier
var  box=400; //box size
var boundary=true;
var initialv=0;
var initialr=400;
var g=1;
var cdim=Math.max(sdim,dim); //camera dimensions, equal to max(3,dim)
var showbox=true;
var showaxes=false;
var isometric=false;
var showW=false;
var centerCamera=false;
var run=true;

var mouseX=0;
var mouseY=0;
var pmouseX=0;
var pmouseY=0;
var rotation;
var ri=0; //which plane is being rotated

var pos=[];
var pos1=[];
var mass=[];
var center=[]; //center of mass
var w=[]; //angular momentum
var totalmass;
var e=20; //softening radius

function getCoords(event){
  mouseX = event.clientX;
  mouseY = event.clientY;
}

function project(rotations,vector){  
  tempVec=[...vector];//copy
  for(let k=cdim-1;k>=0;k--){
    k1=((k-1)%cdim+cdim)%cdim;//the two axes to rotate around
    k2=((k)%cdim+cdim)%cdim;
    temp=Math.cos(rotations[k])*tempVec[k1]+Math.sin(rotations[k])*tempVec[(k2)%cdim];
    temp1=-Math.sin(rotations[k])*tempVec[k1]+Math.cos(rotations[k])*tempVec[(k2)%cdim];
    tempVec[k1]=temp;
    tempVec[(k1+1)%cdim]=temp1;
  }
  tempVec[2]=isometric?1:(tempVec[2]+1200)/Math.max(width,height); //camera angle
  return tempVec;
}

function line(rotations,point1,point2){  //line projected from n dimensional space
  point1=project(rotations,point1);
  point2=project(rotations,point2);
  ctx.beginPath();
  ctx.moveTo(Math.floor(point1[0]/point1[2]+width/2),Math.floor(point1[1]/point1[2]+height/2));
  ctx.lineTo(Math.floor(point2[0]/point2[2]+width/2),Math.floor(point2[1]/point2[2]+height/2));
  ctx.stroke();
}


function reDimension(dim1){//adds/removes dimensions
  if(dim1!=dim){
    cdim1=Math.max(sdim,dim1);
    center=new Array(cdim1).fill(0);
    tempVec=new Array(cdim1).fill(0); 
    tempVec1=new Array(cdim1).fill(0);
    tempVec2=new Array(cdim1).fill(0);
    if (dim1>dim){//add dimensions
      for(i=0;i<n;i++){
        for(k=dim;k<cdim1;k++){
          pos[i][k]=Math.random()*2-1;
          pos1[i][k]=(Math.random()*2-1)*dt;
          rotation[k]=0;
        }
      }
    }
    if (dim1<dim){ //remove dimensions
      temp=cdim1-dim1;
      rotation.splice(cdim1);
      ri=0;
      for(i=0;i<n;i++){
        pos[i].splice(cdim1);
        pos1[i].splice(cdim1);
        for(k=dim1;k<cdim1;k++){
          pos[i][k]=0;
          pos1[i][k]=0;
        }
      }
    }
    rotation[0]=0
    dim=dim1;
    cdim=cdim1;
  }
}

function reParticle(n1){//adds/removes particles
  /*if (n1>n){//add particles
    for(i=n;i<n1;i++){
      mass[i]=Math.random()*100+100;
      totalmass+=mass[i];
      pos[i]=[];
      pos1[i]=[];
      for(k=0;k<dim;k++){
        pos[i][k]=(Math.random()*2-1)*initialr;
        pos1[i][k]=pos[i][k]-(Math.random()*2-1)*initialv*dt;
      }
    }
  }*/
  if (n1<n){ //remove particles
    mass.splice(n1);
    pos.splice(n1);
    pos1.splice(n1);
    totalmass=0;
    for(i=0;i<n1;i++){
      totalmass+=mass[i];
    }
  }
  n=n1;
}

function reset(){
  totalmass=0;
  for (i=0; i<n; i++){
    mass[i]=Math.random()*100+100;
    totalmass+=mass[i];
    for (k=0;k<dim;k++){
      pos[i][k]=(Math.random()*2-1)*initialr;
      pos1[i][k]=pos[i][k]-(Math.random()*2-1)*initialv*dt;
    }
  }
}

function drawBox(dim,size){//terrible implementation but I'm tired rn
  if(dim<=9){ //this is to protect the computer from drawing too many lines when rendering the box in higher dimensions. Remove it if you have faith in your computer :)
  for(i=0;i<(2**dim);i++){
    for(k=0;k<dim;k++){
      tempVec1[k]=size*(2*((i>>k)&1)-1);
      tempVec2[k]=size*(2*((i>>k)&1)-1);
    }
    for(k=0;k<dim;k++){
      tempVec2[k]=0;
      line(rotation,tempVec1,tempVec2);
      tempVec2[k]=tempVec1[k];
    }
  }
  }
}

function isDark(x){ //determine if a particle is dark matter
  //temp=x*dark
  //return (temp-Math.floor(temp))<dark;
  return x<(n*dark);
}

const canvas = document.getElementById('sketch');
width=canvas.width;
height=canvas.height;
const ctx = canvas.getContext('2d');
function start(){
  ctx.lineWidth=1;
  center=new Array(cdim);
  w=new Array(3); //only relevant in 3- dimensions
  rotation=new Array(cdim).fill(0); //this isn't enough for any rotation we could want (that would take dim*(dim-1) floats), but it's enough for our tiny 3d minds to be satisfied.
    //it also means that you can get gimbal lock, but I'm not dealing with quaternions/octonians etc. to do n dimentional rotations the right way. This was supposed to be a quick add-on, not an overhaul.
  tempVec=new Array(cdim);
  tempVec1=new Array(cdim);
  tempVec2=new Array(cdim);
  totalmass=0;
  for (i=0; i<n; i++){
    mass[i]=Math.random()*100+100;
    totalmass+=mass[i];
    pos[i]=[];
    pos1[i]=[];
    for (k=0;k<cdim;k++){
      pos[i][k]=(Math.random()*2-1)*initialr;
      pos1[i][k]=pos[i][k]-(Math.random()*2-1)*initialv*dt;
    }
  }
}

function draw(){

  ctx.fillStyle="#000000";
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.strokeStyle = '#ffffff';

  //println(millis()-time);
  //time=millis();

  rotation[ri]+=(mouseX-pmouseX)*2*Math.PI/width;
  rotation[(ri+1)%cdim]+=(mouseY-pmouseY)*2*Math.PI/height;

  for (i=0; i<n; i++){
    if(pos[i]==undefined){
      mass[i]=Math.random()*100+100;
      totalmass+=mass[i];
      pos[i]=new Array(cdim).fill(0);
      pos1[i]=new Array(cdim).fill(0);
      for(let k=0;k<dim;k++){
        pos[i][k]=(Math.random()*2-1)*initialr;
        pos1[i][k]=pos[i][k]-(Math.random()*2-1)*initialv*dt;
      }
      for(let k=dim;k<cdim;k++){
        pos[i][k]=0;
        pos1[i][k]=pos[i][k];
      }
    }
    if(run){
      for (k=0; k<dim; k++){
        temp=pos[i][k];
        pos[i][k]+=(pos[i][k]-pos1[i][k]);
        pos1[i][k]=temp;
        if(boundary){
          if(pos[i][k]>box){
            pos[i][k]-=(pos[i][k]-box)/2;
          }
          if(pos[i][k]<-box){
            pos[i][k]+=(-box-pos[i][k])/2;
          }
        }
      }
      for (j=0; j<i; j++){
        dsq=0;
        for (k=0; k<dim; k++){
          dsq+=(pos[i][k]-pos[j][k])**2;
        }
        if(!isDark(i) && !isDark(j)){  //if both particles are normal matter
          d=Math.sqrt(dsq);
          l=(mass[i]+mass[j])/40*c;
          if(d<=l){//collisions
            if(d==0){
              for (k=0; k<dim; k++){
                pos1[i][k]+=Math.random();
                pos1[j][k]+=Math.random();
              } 
            }
            else{
              for (k=0; k<dim; k++){
                temp=.5*(pos[i][k]-pos[j][k])/d*(l-d);
                pos[i][k]+=temp;
                pos[j][k]-=temp;
              } 
            }
          }
        }
        dsq+=e**2; //softening; not ideal, but a good quick fix
        for (k=0; k<dim; k++){
          temp=g*mass[j]*(pos[i][k]-pos[j][k])/(dsq**(3/2.));
          pos1[i][k]+=temp*dt*dt; //subtracting the acceleration from the last position to change the speed (implements acceleration without an acceleration variable)
          pos1[j][k]-=temp*dt*dt;
        }
      }
    }
    tempVec=project(rotation,pos[i]);

    if(tempVec[2]>0){
      ctx.beginPath();  //draw particle
      ctx.arc(Math.floor(tempVec[0]/tempVec[2]+width/2),
              Math.floor(tempVec[1]/tempVec[2]+height/2),
              Math.abs(s*mass[i]/(40*tempVec[2])),
              0,2 * Math.PI);
      ctx.fillStyle=(isDark(i))?"#000000":"#ffffff";
      ctx.fill();
      ctx.stroke();
    }
  }
  //console.log(pos[0]);

  //box=(box+399)%400;

  //box
  if(showbox){
    drawBox(dim,box);
  }//centering camera
  if(centerCamera){
    if(totalmass!=totalmass){
      totalmass=0;
      for (i=0; i<n; i++){
        totalmass+=mass[i];
      }
    }
    for (k=0; k<dim; k++){
      center[k]=0;
    }
    for (i=0; i<n; i++){
      for (k=0; k<dim; k++){
        center[k]+=Math.min(Math.max(pos[i][k],-800),800)*mass[i]/totalmass;//we constrain so free particles don't skew the average
      }
    }
    for (i=0; i<n; i++){
      for (k=0; k<dim; k++){
        pos[i][k]-=center[k]/2;//recentering camera
        pos1[i][k]-=center[k]/2;   
      }
    }
  }
  if(dim<=3 && showW){//showing angular momentum
    w[0]=0;
    w[1]=0;
    w[2]=0;
    for (i=0; i<n; i++){
      for (k=0; k<3; k++){
        w[k]+=(pos[i][(k+1)%3]*(pos[i][(k+2)%3]-pos1[i][(k+2)%3])-pos[i][(k+2)%3]*(pos[i][(k+1)%3]-pos1[i][(k+1)%3]))/n;
      }
    }
    ctx.strokeStyle = '#ff00ff';
    line(rotation,[0,0,0],w);
  }
  //axes
  if(showaxes){
    for(k=0;k<dim;k++){
      tempVec.fill(0);
      tempVec[k]=100;
      switch(k){
        case 0:
          ctx.strokeStyle = '#ff0000';
          break;
        case 1:
          ctx.strokeStyle = '#00ff00';
          break;
        case 2:
          ctx.strokeStyle = '#0000ff';
          break;
        case 3:
          ctx.strokeStyle = '#ffff00';
          break;
        case 4:
          ctx.strokeStyle = '#00ffff';
          break;
        case 5:
          ctx.strokeStyle = '#ff00ff';
          break;
        default:
          ctx.strokeStyle = '#ffffff';
          break;
      }
      line(rotation,new Array(cdim).fill(0),tempVec);
    }
  }
  pmouseX=mouseX;
  pmouseY=mouseY;
}