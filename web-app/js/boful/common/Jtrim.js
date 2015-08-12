function Jtrim(str)
	{
			if(str==null || str=="")
				return "";
	        var i = 0;
	        var len = str.length;
	        j = len -1;
	        flagbegin = true;
	        flagend = true;
	        while ( flagbegin == true && i< len)
	        {
	           if ( str.charAt(i) == " " )
	                {
	                  i=i+1;
	                  flagbegin=true;
	                }
	                else
	                {
	                        flagbegin=false;
	                }
	        }
	
	        while  (flagend== true && j>=0)
	        {
	            if (str.charAt(j)==" ")
	                {
	                        j=j-1;
	                        flagend=true;
	                }
	                else
	                {
	                        flagend=false;
	                }
	        }
	
	        if ( i > j ) return ("")
	
	        trimstr = str.substring(i,j+1);
	        return trimstr;
	}
