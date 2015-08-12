function showMenu(sid,count){
    var whichEl = eval("menu"+sid);
    if(whichEl.style.display == "none"){
		for(i=1;i<=count;i++){
			if(sid!=i){
				try
				{
					eval("Img"+i+".src='../images/skin/point.gif'");
					eval("menu"+i+".style.display='none'");
				}
				catch(err)
				{
				}
				
			}else{

				eval("Img"+sid+".src='../images/skin/arrow-down.gif'");
				eval("menu" + sid + ".style.display=''");
			}
		}	
    }else{
		eval("Img"+sid+".src='../images/skin/point.gif'");
		eval("menu"+sid+".style.display='none'");
    }
}

function showSubMenu(tdName,imgName){
     if(tdName.style.display=="none"){
		imgName.src="../images/skin/left-2-2.gif";
		tdName.style.display="";           
     }else{
		tdName.style.display="none"; 
		imgName.src="../images/skin/left-2.gif";       
     }
}

function showUrl(menu,Url){
    parent.bodyFrame.addMenu(menu,Url);
}
