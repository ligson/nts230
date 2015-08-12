//参数：max每页记录数，laststep最大页数,linkstr链接字符串
function turnPageTo(max,laststep,linkstr)
{
	var link = "";
	var offset = 0;
	var toPage = 1;

	str = document.getElementById("turnPage").value;
	if(str.length == 0)	
	{ 
	   alert("请输入跳转的页数") ;
	   return; 
	} 
	for(i=0;i<str.length;i++)	
	{ 
		if(str.charAt(i)<'0' ||	str.charAt(i) >'9')	
		{	
			alert("只能输入数字"); 
			return ;
		 } 
	 }	
 
	toPage = parseInt(str);
	if(toPage < 1) toPage = 1;
	if(toPage > laststep) toPage = laststep;

	offset = (toPage - 1) * max;
	
	//offset=1234554321是约定的
	link = linkstr.replace("offset=1234554321","offset="+offset);
	self.location.href = link;
}
