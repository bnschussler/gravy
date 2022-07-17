var linked=[
["ntext","nslider"],
["gtext","gslider"],
["darktext","darkslider"],
["sizetext","sizeslider"],
["boxtext","boxslider"],
["startveltext","startvelslider"],
["startpostext","startposslider"],
];

var inputs=[
"box",
"axes",
"bound",
"isometric",
"w",
"centerCamera",
"dimensions",
"ntext","nslider",
"gtext","gslider",
"darktext","darkslider",
"sizetext","sizeslider",
"boxtext","boxslider",
"startveltext","startvelslider",
"startpostext","startposslider",
];

linked.forEach(function(element){
	document.getElementById(element[0]).addEventListener("input",function(){ //these should only trigeer with use input, not when they edit eachother's values
		document.getElementById(element[1]).value=document.getElementById(element[0]).value;
	});
	document.getElementById(element[1]).addEventListener("input",function(){
		document.getElementById(element[0]).value=document.getElementById(element[1]).value;
	});
});

inputs.forEach(function(element){
	document.getElementById(element).addEventListener("input",function(){
		updateSettings();
	});
});

function updateVisibility(show,id){
	let obj=document.getElementById(id);
	obj.style.display=show?"initial":"none";
}

document.addEventListener('keydown', function(event) {//from https://stackoverflow.com/questions/1846599/how-to-find-out-what-character-key-is-pressed
  const key = event.key; // "a", "1", "Shift", etc.
  if(key=='r'){
    reset();
  }
  if(key=='q'){
    ri=(ri+1)%(cdim-1);
  }
  if(key=='a'){
    rotation.fill(0);
    ri=0;
  }
  if(key=='l'){
    document.getElementById('dimensions').value=parseInt(document.getElementById('dimensions').value)+1;
    updateSettings();
  }
  if(key=='k'){
    document.getElementById('dimensions').value=parseInt(document.getElementById('dimensions').value)-1;
    updateSettings();
  }
});

function updateSettings() {
	reParticle(document.getElementById('ntext').value);
	reDimension(document.getElementById('dimensions').value);
	g = document.getElementById('gtext').value/10;
	dark=document.getElementById('darktext').value/100;
	s=c=document.getElementById('sizetext').value/10;
	initialv=document.getElementById('startveltext').value;
	initialr=document.getElementById('startpostext').value;
	box=document.getElementById('boxtext').value;
	showbox=document.getElementById('box').checked;
	showaxes=document.getElementById('axes').checked;
	boundary=document.getElementById('bound').checked;
	isometric=document.getElementById('isometric').checked;
	showW=document.getElementById('w').checked;
	centerCamera=document.getElementById('centerCamera').checked;
}
