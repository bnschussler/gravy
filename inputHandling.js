var linked=[
[document.getElementById("ntext"),document.getElementById("nslider")],
[document.getElementById("gtext"),document.getElementById("gslider")],
[document.getElementById("darktext"),document.getElementById("darkslider")],
[document.getElementById("sizetext"),document.getElementById("sizeslider")],
[document.getElementById("boxtext"),document.getElementById("boxslider")],
[document.getElementById("startveltext"),document.getElementById("startvelslider")],
[document.getElementById("startpostext"),document.getElementById("startposslider")],
];

var inputs=[
document.getElementById("box"),
document.getElementById("axes"),
document.getElementById("bound"),
document.getElementById("isometric"),
document.getElementById("w"),
document.getElementById("centerCamera"),
document.getElementById("dimensions"),
document.getElementById("ntext"),document.getElementById("nslider"),
document.getElementById("gtext"),document.getElementById("gslider"),
document.getElementById("darktext"),document.getElementById("darkslider"),
document.getElementById("sizetext"),document.getElementById("sizeslider"),
document.getElementById("boxtext"),document.getElementById("boxslider"),
document.getElementById("startveltext"),document.getElementById("startvelslider"),
document.getElementById("startpostext"),document.getElementById("startposslider"),
];

linked.forEach(function(element){
	element[0].addEventListener("input",function(){ //these should only trigeer with use input, not when they edit eachother's values
		element[1].value=element[0].value;
	});
	element[1].addEventListener("input",function(){
		element[0].value=element[1].value;
	});
});

inputs.forEach(function(element){
	element.addEventListener("input",function(){
		updateSettings("sketch");
	});
});

function updateVisibility(show,id){
	let obj=document.getElementById(id);
	obj.style.display=show?"initial":"none";
}

function updateSettings() {	//help from http://procesMath.singjs.nihongoresources.com/procesMath.sing%20on%20the%20web/#interface
	let n = document.getElementById('nslider').value;
	let dim1=document.getElementById('dimensions').value;
	let g = document.getElementById('gslider').value/10;
	let dark=document.getElementById('darkslider').value/100;
	let size=document.getElementById('sizeslider').value/10;
	let startvel=document.getElementById('startvelslider').value;
	let startpos=document.getElementById('startposslider').value;
	let boxsize=document.getElementById('boxslider').value;
	let showbox=document.getElementById('box').checked;
	let showaxes=document.getElementById('axes').checked;
	let border=document.getElementById('bound').checked;
	let isometric=document.getElementById('isometric').checked;
	let showw=document.getElementById('w').checked;
	let center=document.getElementById('centerCamera').checked;
	updateSettings1(n,dim1,g,dark,size,startvel,startpos,boxsize,showbox,showaxes,border,isometric,showw,center); }
