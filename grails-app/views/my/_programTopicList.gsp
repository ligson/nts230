<DIV id="groupList" class="bg" style="width:390px;POSITION: absolute;display: ${program==null?'none':'block'};">

	<DIV class="rg1"></DIV><DIV class="rg2"></DIV> 
	<DIV class="t1">设置${priType == 'play'?'浏览':'下载'}权限</DIV>
	<DIV class="bc">
		<g:if test="${groupList}">
		 <g:formRemote method="post" style='padding:0px;margin:0px;' name="setPrivilegeForm" url="[action:'setPrivilegeGroups']" onSuccess="onOperateSuccess('groupList')" onFailure="onOperateFailure('groupList')">
		 <input type="hidden" name="programId" value="${program.id}" />
		 <input type="hidden" name="priType" value="${priType}" />
            <div style="font-size:12px;">资源名称：${program.name}</div>
			<div style="font-size:12px;">浏览权限：<input type="radio" name="canAll" value="1" ${canAll?'checked':''} onclick="onCanAll(this)">允许所有用户组<input type="radio" name="canAll" value="0" ${canAll?'':'checked'} onclick="onCanAll(this)">允许指定用户组 </div>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${groupList}">
            <div class="errors">
                <g:renderErrors bean="${groupList}" as="list" />
            </div>
            </g:hasErrors>
				
            
			<div class="dialog">
				<table id="groupListTab" style="display:${canAll?'none':'block'};">
					<thead>
						<tr>                      
							<th style="width:40px;" class="sortable">选择</th>                       
							<th style="width:40px" class="sortable" >序号</th>
							<th style="width:120px" class="sortable" >组名</th>
							<th style="width:160px" class="sortable" >描述</th>
						</tr>
					</thead>
					<tbody>

					<g:each in="${groupList?}" status="i" var="userGroup">
						<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
							<td><input type="checkbox" name="gidList" value="${userGroup.id}" id="gidList" ${priType == 'play'?(program.playGroups.contains(userGroup)?'checked':''):(program.downloadGroups.contains(userGroup)?'checked':'')} /></td>
							<td>${i+1}</td>                                            
							<td>${userGroup.name.encodeAsHTML()}</td>
							<td>${userGroup.description?.encodeAsHTML()}</td>
							
						</tr>
					</g:each>
					 
					</tbody>
				</table>
			</div>

			<div align="center" style="margin-top:6px;">
				<g:submitButton name="upbtn" class="button"  style="cursor:pointer;width:40px;" value="确定" onclick="return checkGroup(this.form);"/>&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" onclick="hideWnd('groupList');" class="button" style="cursor:pointer;width:40px;" value="关闭">
			</div>
          </g:formRemote>
		</g:if>
		<g:else>
		您还没有设置用户组，请在用户管理->用户组管理中设置。
		<div align="center" style="margin-top:6px;">
			<input type="button" onclick="hideWnd('groupList');" class="button" style="cursor:pointer;width:40px;" value="关闭">
		</div>
		</g:else>
	</DIV>

	<DIV class="rg3"></DIV>
	<DIV class="rg4"></DIV> 

</DIV>