<%@ page import="nts.program.domain.Serial" %>
<div id="serialList" style="width:602px;">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <table border="0" cellspacing="1">
        <tr>
            <th align="center">选择</th>
            <th align="center">序号</th>
            <th align="center">标题</th>
            <th align="center">类型</th>
            <th align="center">子类型</th>
            <th align="center">起止时间</th>
            %{--<th align="center">字幕</th>--}%
            <th align="center">修改</th>
            <th align="center">添加</th>
        </tr>
        <g:each var="s" status="i" in="${program?.serials ?}">
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                <td align="center"><g:checkBox name="idList" value="${s?.serialNo + '-' + s?.urlType}" checked=""
                                               onclick="unCheckAll('selall');"/></td>
                <td align="center">${s?.serialNo}</td>
                <td>${s?.name}</td>
                <td>${Serial.urlTypeName[s?.urlType]}</td>
                <td>${s?.getCodeStateName()}</td>
                <td align="center">${s?.startTime}-${s?.endTime}</td>
                %{--<td align="center"><a href="#ZM"
                                      onclick="${remoteFunction(action: 'editSerial', params: '\'isSubtitle=1&serialNo=' + s?.serialNo + '&urlType=' + s?.urlType + '&programId=\'+global.programId', update: 'subtitleList', onComplete: 'subtitleList(' + s?.serialNo + ')')}">字幕</a>
                </td>--}%
                <td align="center"><a href="#ED"
                                      onclick="${remoteFunction(action: 'editSerial', params: '\'serialNo=' + s?.serialNo + '&urlType=' + s?.urlType + '&programId=\'+global.programId', update: 'editSerial', onComplete: 'editSerial(' + s?.serialNo + ',true)')}">修改</a>
                </td>
                <td align="center"><a href="#AD"
                                      onclick="${remoteFunction(action: 'editSerial', params: '\'serialNo=' + s?.serialNo + '&urlType=' + s?.urlType + '&programId=\'+global.programId', update: 'editSerial', onComplete: 'editSerial(' + s?.serialNo + ',false)')}">添加</a>
                </td>
            </tr>
        </g:each>
        <tr>
            <td colspan="9" class="operation">
                <input id="selall" name="selall" onclick="checkAll(this, 'idList')" type="checkbox">全选&nbsp;<input
                    type="button" onclick="deleteSerial(this.form);" value="删除所选"/>
            </td>
        </tr>
    </table>
</div>