function showMenu(sid){
    var whichEl = eval("menu"+sid);
    if(whichEl.style.display == "none"){
	for(i=1;i<=5;i++){
   	if(sid!=i){
		eval("Img"+i+".src='images/arrow-right.gif'");
		eval("menu"+i+".style.display='none'");
	}else{
		eval("Img"+sid+".src='images/arrow-down.gif'");
		eval("menu" + sid + ".style.display=''");
	}
       }	
    }else{
		eval("Img"+sid+".src='images/arrow-right.gif'");
		eval("menu"+sid+".style.display='none'");
    }
}
function showSubMenu(tdName,imgName){
     if(tdName.style.display=="none"){
		imgName.src="images/left-2-2.gif";
		tdName.style.display="";           
     }else{
		tdName.style.display="none"; 
		imgName.src="images/left-2.gif";       
     }
}
function showUrl(menu,Url){
    parent.bodyFrame.addMenu(menu,Url);
}