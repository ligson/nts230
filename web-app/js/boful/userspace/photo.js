	var Style,offset=3,timer,dir=1      
																													//offsetΪͼƬ����ʱ��ƫ������dirΪ�������� 
	document.onmouseover=function(){										   			  //������϶���ʱִ�к��� 
	    with(event.srcElement) 
																													//���������ϵĶ�����ͼƬ������classΪshade��ִ������Ĵ��� 
	       if(tagName=="IMG"&&className=="shade"){          
																													//������Style�ĸ�ֵΪ�����CSS���󣬷�������д����(���) 
		   Style=style 
		   shade()																								  //����shade���� 
	       } 
	} 
	document.onmouseout=function(){														//����ڶ������ƿ�ʱִ�к��� 
	    if(Style){																								//�����֮ǰ������ͼƬ����ִ������Ĵ��� 
	//       clearTimeout(timer)																			//�����ʱ����ֹͣͼƬ�Ķ��� 
	       Style.posTop=Style.posLeft=0													    	  //ͼ��ԭλ 
	    } 
	} 
	function shade(){ 

	    eval("Style.pos"+["Top","Top"][(1)]+"+=3")  	//��ʵ��dir���Լӣ����dirС��4������1������4ʱ����Ϊ1 ,Ȼ���������ֵ�ж�Ӧ�øı����X��Y�����ֵ//(1��2��3��4�ֱ��Ӧ�������¡��Һ����ĸ������ƫ���˶�)��eval()�Ĺ������Ƚ����ַ���������ִ�����Ӻ��JS����
		alert(eval);
	} 