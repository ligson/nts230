<DIV id="subtitleList" class="bg" style="width:500px;display: ${serial==null?'none':'block'};margin-top:-30px;">
<g:if test="${serial}">
	<DIV class="rg1"></DIV><DIV class="rg2"></DIV> 
	<DIV class="t1">字幕列表</DIV>
	<DIV class="bc">
	
			<h1 align="center" >字幕列表</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${serial}">
            <div class="errors">
                <g:renderErrors bean="${serial}" as="list" />
            </div>
            </g:hasErrors>
            
			<table style="border-collapse:collapse;border:1px solid #A5DA94" border="1" bordercolor="#A5DA94">
				<tr>
				 <th align="center" style="background:#EBF8E7;width:40px;">序号</th>
				 <th align="center" style="background:#EBF8E7;width:60px;">语种</th>
				 <th align="center" style="background:#EBF8E7;width:400px;">字幕文件路径</th>
			<g:if test="${serial?.id > 0}">
				 <th align="center" style="background:#EBF8E7;width:40px;">修改</th>
				 <th align="center" style="background:#EBF8E7;width:40px;">删除</th>
			</g:if>
				</tr>
			<g:each var="s" status="i" in="${serial?.subtitles}">
				<tr>			 
				 <td style="height:22px;text-align:center;" id="subtitleSN${s.serialNo}" width="50">${s.serialNo}</td>
				 <td>${s?.lang?.zhName}</td>
				 <td>${s.filePath}</td>
				<g:if test="${serial?.id > 0}">
				  <td style="height:22px;text-align:center;"><a href="#MOD" onclick="${remoteFunction(action:'editSubtitle',params:'\'serialId='+serial?.id+'&subtitleId='+s.id+'&urlType='+serial?.urlType+'&programId=\'+global.programId',update:'editSubtitle',onComplete:'editSubtitle('+serial?.id+',false)')};return false;">修改</a></td>				
				 <td style="height:22px;text-align:center;"><a href="javascript:void(0);" onclick="deleteSubtitle(${serial.id},${s.id})">删除</a></td>
				 </g:if>
				 </tr>
			</g:each>
			
			</table>
			<div align="center" style="margin-top:7px;">
			   <input type="buttom" onclick="${remoteFunction(action:'editSubtitle',params:'\'serialId='+serial?.id+'&serialNo='+serial?.serialNo+'&urlType='+serial?.urlType+'&programId=\'+global.programId',update:'editSubtitle',onComplete:'editSubtitle('+serial?.id+',false)')};" class="buttons" style="cursor:pointer;width:40px;" value="添加">&nbsp;<input type="buttom" onclick="hideWnd('subtitleList');" class="buttons" style="cursor:pointer;width:40px;" value="关闭">
			</div>
            
			
	</DIV> 
	<DIV class="rg3"></DIV>
	<DIV class="rg4"></DIV> 
</g:if>
</DIV>