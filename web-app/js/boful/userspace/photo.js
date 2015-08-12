	var Style,offset=3,timer,dir=1      
																													//offset为图片抖动时的偏移量，dir为抖动方向 
	document.onmouseover=function(){										   			  //鼠标移上对象时执行函数 
	    with(event.srcElement) 
																													//如果鼠标移上的对象是图片，并且class为shade，执行下面的代码 
	       if(tagName=="IMG"&&className=="shade"){          
																													//将变量Style的赋值为对象的CSS对象，方便下面写代码(简短) 
		   Style=style 
		   shade()																								  //调用shade函数 
	       } 
	} 
	document.onmouseout=function(){														//鼠标在对象上移开时执行函数 
	    if(Style){																								//如果是之前抖动的图片对象，执行下面的代码 
	//       clearTimeout(timer)																			//清除计时器以停止图片的抖动 
	       Style.posTop=Style.posLeft=0													    	  //图归原位 
	    } 
	} 
	function shade(){ 

	    eval("Style.pos"+["Top","Top"][(1)]+"+=3")  	//先实现dir的自加：如果dir小于4，自增1，等于4时重设为1 ,然后根据它的值判断应该改变对象X或Y坐标的值//(1、2、3和4分别对应着向左、下、右和上四个方向的偏移运动)，eval()的功能是先进行字符串连接再执行连接后的JS代码
		alert(eval);
	} 