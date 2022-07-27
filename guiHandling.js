Array.from(document.getElementsByClassName('dropdown')).forEach(dropdown => {
  
  let options=dropdown.querySelector(".options")
  let temp=options.offsetHeight;

  dropdown.querySelector(".options").setAttribute('style', dropdown.querySelector(".toggle input").checked?('height:'+temp+"px"):"height: 0px");

  dropdown.querySelector(".toggle input").addEventListener('change', function handle(event) {
    dropdown.querySelector(".toggle").style.background=this.checked?"#505050":"#303030";
    dropdown.querySelector(".options").setAttribute('style', this.checked?('height:'+temp+"px"):"height: 0px");
  });
});

Array.from(document.getElementsByClassName('toggle')).forEach(toggle => {
  toggle.style.background=toggle.querySelector("input").checked?"#505050":"#303030";
  toggle.querySelector("input").addEventListener('change', function handle(event) {
    toggle.style.background=this.checked?"#505050":"#303030";
  });
});

/*window.addEventListener('resize', function handle(event){
  Array.from(document.querySelectorAll('.interactive')).forEach(interactive =>{
    interactive.style.maxWidth="auto";
    let min=screen.width;
    let max=0;
    let elements= Array.from(interactive.querySelectorAll(":scope > .column"));
    for(let i=0;i<elements.length;i++){
      min=Math.min(elements[i].getBoundingClientRect().left,min);
      max=Math.max(elements[i].getBoundingClientRect().right,max);
    }
    console.log(max-min);
    interactive.style.maxWidth=(max-min)+"px";
  });
});*/