<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}"/>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'editSubtitleList.css')}"/>
<script type="text/javascript" src="${resource(dir: 'js/boful/programMgr',file: 'editSubtitle.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/progedit.js')}"></script>
<DIV id="subtitleList" class="bg" style="width:500px;display: ${serial == null ? 'none' : 'block'};>
<g:if test="${serial}">
    <DIV class="rg1"></DIV>
    <DIV class="rg2"></DIV>

    <DIV class="edit_title">字幕列表</DIV>

    <DIV>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
        <g:hasErrors
                bean="${serial}">style="border-collapse:collapse;border:1px solid #A5DA94" border="1" bordercolor="#A5DA94"
            <div class="errors">
                <g:renderErrors bean="${serial}" as="list" />
            </div>
            </g:hasErrors>

        <table class="table table-hover">
            <tr>
                <th width="50" align="center">序号</th>
                <th width="300" align="center">语种</th>
                <th align="center">字幕文件路径</th>
                <g:if test="${serial?.id > 0}">
                    <th width="160" align="center">修改</th>
                    <th width="160" align="center">删除</th>
                </g:if>
				</tr>
            <g:if test="${subtitleList && subtitleList.size() > 0}">
                <g:each var="s" status="i" in="${subtitleList}">
                    <tr>
                        <td id="subtitleSN${s.serialNo}" width="50">${s.serialNo}</td>
                        <td>${s?.lang?.zhName}</td>
                        <td>${s.filePath}</td>
                        <g:if test="${serial?.id > 0}">
                            <td>%{--<a href="#MOD" onclick="${remoteFunction(action:'editSubtitle',params:'\'serialId='+serial?.id+'&subtitleId='+s.id+'&urlType='+serial?.urlType+'&programId=\'+global.programId',update:'editSubtitle',onComplete:'editSubtitle('+serial?.id+',false)')};return false;">修改</a>--}%
                                <a href="${createLink(controller: 'programMgr', action: 'editSubtitle', params: [serialId: serial?.id, serialNo: serial?.serialNo, urlType: serial?.urlType, subtitleId: s?.id, programId: serial?.program?.id])}"
                                   class="buttons" style="cursor:pointer;width:40px;">修改</a>
                            </td>
                            <td><a href="${createLink(action: 'deleteSubtitle', controller: 'programMgr', params: [serialId: serial?.id, subtitleId: s?.id])}">删除</a>
                            </td>
                        </g:if>
                    </tr>
                </g:each>
            </g:if>
			
			</table>

        <div align="center" class="word_add">
            <a href="${createLink(controller: 'programMgr', action: 'editSubtitle', params: [serialId: serial?.id, serialNo: serial?.serialNo, urlType: serial?.urlType, programId: serial?.program?.id])}"
               class="btn btn-primary" style="color:#FFF;">添加</a>
            <a class="btn btn-primary"
               href="${createLink(controller: 'programMgr', action: 'editSerialList', params: [id: serial?.program?.id])}"
               style="color:#FFF;">返回</a>
            %{--<input type="buttom" onclick="${remoteFunction(action:'editSubtitle',params:'serialId='+serial?.id+'&serialNo='+serial?.serialNo+'&urlType='+serial?.urlType+'&programId='+serial?.program.id,update:'editSubtitle',onComplete:'editSubtitle('+serial?.id+',false)')};" class="buttons" style="cursor:pointer;width:40px;" value="添加">--}%
            %{--&nbsp;<input type="buttom" onclick="hideWnd('subtitleList');" class="buttons" style="cursor:pointer;width:40px;" value="关闭">--}%
        </div>

    </DIV>
	<DIV class="rg3"></DIV>
	<DIV class="rg4"></DIV> 
</g:if>
</DIV>