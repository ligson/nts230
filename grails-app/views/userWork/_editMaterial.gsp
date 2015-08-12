<%@ page import="nts.program.domain.Serial" %>
<g:if test="${program}">
<DIV class="qfbxt928" style="text-align: left;">
    <g:formRemote method="post" name="editMaterialForm" url="[action:'saveMaterial']" update="serialList" onComplete="hideWnd('editMaterial');">
	  <input type="hidden" name="selSerialId" value="" />
	  <input type="hidden" name="programId" value="" />
	  <input type="hidden" name="oldSerialNo" value="" />
	  <input type="hidden" name="urlType" value="" />
	  <input type="hidden" name="progType" value="" />
	  <input type="hidden" name="timeLength" value="" />
	  <input type="hidden" name="bandWidth" value="" />
	  <input type="hidden" name="svrAddress" value="" />
	  <input type="hidden" name="operation" value="" />
	  <input type="hidden" name="startTime" value="00:00:00" />
	  <input type="hidden" name="endTime" value="00:00:00" />
	  <input type="hidden" name="transcodeState" value="0" />
	  <input type="hidden" name="selFilePath" value="" />

	  <div class="qhdtit"><a href = "javascript:void(0)" onclick = "closeMaterial('editMaterial','qfbxtb')" class="qhdclose"><img src="${resource(dir: 'images/skin', file: 'close.gif')}" /></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;提取文件</div>
	  <div class="h24 cl"></div>
	  <div class="qtd">
	   <h2 style="text-align: left;">文件名</h2>
	   <div class="qtdcon" style="padding-top:5px;"><input type="text" maxlength="80" readonly id="name" name="name" class="qtdin" value="${fieldValue(bean:serial,field:'name')}"/></div>	   
	  </div>
	  <div class="h24 cl"></div>
	  <div class="qtd">
	   <h2 style="text-align: left;">选择文件</h2>
	   <div class="qtdcon" style="padding-top:5px;">
		视频: <select name="selectSerial" onchange="onSelectSerial(this);">
		 <g:findAll var="s" status="i" in="${program?.serials}" expr="${it.urlType == Serial.URL_TYPE_VIDEO}">
			<option value="${s.urlType}*${s.progType}*${s.svrAddress}*${s.filePath}*${s.id}">${s.name}</option>
		 </g:findAll>
		</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;或&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		图片: <select name="selectSerial1" onchange="onSelectSerial(this);">
		 <g:findAll var="s" status="i" in="${program?.serials}" expr="${it.urlType == Serial.URL_TYPE_IMAGE}">
			<option value="${s.urlType}*${s.progType}*${s.svrAddress}*${s.filePath}*${s.id}">${s.name}</option>
		 </g:findAll>
		</select>
	   </div>
	  </div>
	  <div class="h24 cl"></div>
	  <div class="qtd">
	   <h2 style="text-align: left;">内容</h2>
	   <div class="qtdcon" style="padding-top:5px;"><textarea name="description" readonly class="qtdte">${fieldValue(bean:serial, field:'description')}</textarea></div>	   
	  </div>
	  <div class="h14 cl"></div>
	  <div class="qtdb">
	   <div class="qtdbr">
	   <g:submitButton name="upbtn" class="qtdbbut" value="确定" onclick="closeMaterial('editMaterial','qfbxtb');return checkSerial(this.form);"/>&nbsp;
	   <input type="button" onclick = "closeMaterial('editMaterial','qfbxtb');" class="qtdbbut" value="关闭">
	  </div>
	</g:formRemote>
</DIV>
</g:if>