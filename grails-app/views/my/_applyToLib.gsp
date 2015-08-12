<DIV id="applyToLib" class="bg" style="width:290px;POSITION: absolute;display: ${program==null?'none':'block'};">

	<DIV class="rg1"></DIV><DIV class="rg2"></DIV> 
	<DIV class="t1">申请入库</DIV>
	<DIV class="bc">
		<g:if test="${program}">
		 <g:formRemote method="post" style='padding:0px;margin:0px;' name="applyToLibForm" url="[action:'applyToLib']" onSuccess="onApplyOperateSuccess('applyToLib')" onFailure="onOperateFailure('applyToLib')">
		 <input type="hidden" name="programId" value="${program.id}" />
		 <input type="hidden" name="priType" value="${priType}" />
            <div style="font-size:12px;">资源名称：${program.name}</div>
			<div style="font-size:12px;">是否允许下载：<input type="radio" name="canDownload" value="1" checked onclick="onCanAll(this)">允许下载<input type="radio" name="canDownload" value="0" onclick="onCanAll(this)">不允许下载</div>
            

			<div align="center" style="margin-top:6px;">
				<g:submitButton name="upbtn" class="button"  style="cursor:pointer;width:40px;" value="入库" />&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" onclick="hideWnd('applyToLib');" class="button" style="cursor:pointer;width:40px;" value="取消">
			</div>
          </g:formRemote>
		</g:if>
	</DIV> 
	<DIV class="rg3"></DIV>
	<DIV class="rg4"></DIV> 

</DIV>