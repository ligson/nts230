function isNum2(str,min,max) {
		//str=txtcntrl.value;
		//str=txtcntrl;//by jianlf
	
		minval = min-1;
		maxval = max+1;
	
		for (var i=0; i < str.length; i++) {
  			num = parseInt(str.substring(i,i+1));
			if (isNaN(num)){				
			   //alert("请输入一个整数.");
				//txtcntrl.value = txtcntrl.defaultValue; rem by jianglf
				return false;
  			}			
	 	}
		num = str;

		if (min != ""){	
			if (num < min) {
				
				return false;
			}
		}
		
		if (max != ""){
			if (num > max) {
				
				return false;
			}		
		}
		return true;
	}
