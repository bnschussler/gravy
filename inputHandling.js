var linkedInputs=[
[document.getElementById("ntext"),document.getElementById("nslider")],
[document.getElementById("gtext"),document.getElementById("gslider")],
[document.getElementById("darktext"),document.getElementById("darkslider")],
[document.getElementById("sizetext"),document.getElementById("sizeslider")],
[document.getElementById("boxtext"),document.getElementById("boxslider")],
[document.getElementById("startveltext"),document.getElementById("startvelslider")],
[document.getElementById("startpostext"),document.getElementById("startposslider")],
];

var checkboxes=[
document.getElementById("box"),
document.getElementById("axes"),
document.getElementById("bound"),
document.getElementById("isometric"),
document.getElementById("w"),
document.getElementById("centerCamera"),
];

linkedInputs.forEach(function(element){
	element[0].addEventListener("input",function(){ //these should only trigeer with use input, not when they edit eachother's values
		element[1].value=element[0].value;
		updateSettings("sketch");
	});
	element[1].addEventListener("input",function(){
		element[0].value=element[1].value;
		updateSettings("sketch");	
	});
});

checkboxes.forEach(function(element){
	element .addEventListener("input",function(){
		updateSettings("sketch");
	})
});

function updateVisibility(show,id){
	var obj=document.getElementById(id);
	obj.style.display=show?"initial":"none";
}

function updateSettings(id) {	//help from http://processingjs.nihongoresources.com/processing%20on%20the%20web/#interface
	var pjs = Processing.getInstanceById(id);

	var n = document.getElementById('nslider').value;
	var g = document.getElementById('gslider').value/10;
	var dark=document.getElementById('darkslider').value/100;
	var size=document.getElementById('sizeslider').value/10;
	var startvel=document.getElementById('startvelslider').value;
	var startpos=document.getElementById('startposslider').value;
	var boxsize=document.getElementById('boxslider').value;
	var showbox=document.getElementById('box').checked;
	var showaxes=document.getElementById('axes').checked;
	var border=document.getElementById('bound').checked;
	var isometric=document.getElementById('isometric').checked;
	var showw=document.getElementById('w').checked;
	var center=document.getElementById('centerCamera').checked;
	pjs.updateSettings(n,g,dark,size,startvel,startpos,boxsize,showbox,showaxes,border,isometric,showw,center); }
