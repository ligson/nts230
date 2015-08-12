<%@ page import="nts.program.domain.Serial" %>

<DIV id="editMaterial" class="bg" style="width:450px;display: ${program==null?'none':'block'};">

    <g:if test="${program}">
        <DIV class="t1">提取资源</DIV>

        <DIV class="bc">

            <h1 align="center" id="serialTitle" style="text-align:center;font-size: 14px;margin: 5px 0"">资源信息</h1>
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${serial}">
                <div class="errors">
                    <g:renderErrors bean="${serial}" as="list"/>
                </div>
            </g:hasErrors>
            <g:formRemote method="post" name="editMaterialForm" url="[action: 'saveMaterial']" update="serialList"
                          onComplete="hideWnd('editMaterial');">
                <input type="hidden" name="selSerialId" value=""/>
                <input type="hidden" name="programId" value=""/>
                <input type="hidden" name="oldSerialNo" value=""/>
                <input type="hidden" name="urlType" value=""/>
                <input type="hidden" name="progType" value=""/>
                <input type="hidden" name="timeLength" value=""/>
                <input type="hidden" name="bandWidth" value=""/>
                <input type="hidden" name="svrAddress" value=""/>
                <input type="hidden" name="operation" value=""/>
                <input type="hidden" name="startTime" value="00:00:00"/>
                <input type="hidden" name="endTime" value="00:00:00"/>
                <input type="hidden" name="transcodeState" value="0"/>

                <div class="dialog">
                    <table>
                        <tbody>

                        <tr class="edit_box1">
                            <td class="name">
                                <label for="serialNo">序列号:</label>
                            </td>
                            <td class="value ${hasErrors(bean: serial, field: 'serialNo', 'errors')}">
                                <input type="text" id="serialNo" name="serialNo" value="${serial?.serialNo}"/>
                            </td>
                        </tr>

                        <tr class="edit_box1">
                            <td class="name">
                                名称:
                            </td>
                            <td class="value ${hasErrors(bean: serial, field: 'name', 'errors')}">
                                <input type="text" maxlength="80" id="name" name="name"
                                       value="${fieldValue(bean: serial, field: 'name')}"/>

                            </td>
                        </tr>

                        <tr class="edit_box1">
                            <td class="name">
                                <label for="filePath">文件路径:</label>
                            </td>
                            <td class="value ${hasErrors(bean: serial, field: 'filePath', 'errors')}">
                                <input type="text" maxlength="120" id="filePath" name="filePath"
                                       value="${fieldValue(bean: serial, field: 'filePath')}"/>
                            </td>
                        </tr>

                        <tr class="edit_box1">
                            <td class="name">
                                <label for="filePath">选择文件:</label>
                            </td>
                            <td class="value ${hasErrors(bean: serial, field: 'startTime', 'errors')}">
                                <select name="selectSerial" onchange="onSelectSerial(this);">
                                    <g:findAll var="s" status="i" in="${program?.serials}"
                                               expr="${it.urlType == Serial.URL_TYPE_VIDEO}">
                                        <option value="${s.urlType}*${s.progType}*${s.svrAddress}*${s.filePath}*${s.id}">${s.name}</option>
                                    </g:findAll>
                                </select>
                            </td>
                        </tr>

                        <tr class="edit_box1">
                            <td class="name">
                                <label>开始时间:</label>
                            </td>
                            <td class="value ${hasErrors(bean: serial, field: 'startTime', 'errors')}">
                                <g:select name="starttmH" from="${0..30}"
                                          value="${serial?.startTime?.length() == 8 ? serial?.startTime[0, 1] : 00}"/>时
                                <g:select name="starttmM" from="${0..59}"
                                          value="${serial?.startTime?.length() == 8 ? serial?.startTime[3, 4] : 00}"/>分
                                <g:select name="starttmS" from="${0..59}"
                                          value="${serial?.startTime?.length() == 8 ? serial?.startTime[6, 7] : 00}"/>秒
                            </td>
                        </tr>

                        <tr class="edit_box1">
                            <td class="name">
                                <label>结束时间:</label>
                            </td>
                            <td class="value ${hasErrors(bean: serial, field: 'endTime', 'errors')}">
                                <g:select name="endtmH" from="${0..30}"
                                          value="${serial?.endTime?.length() == 8 ? serial?.endTime[0, 1] : 00}"/>时
                                <g:select name="endtmM" from="${0..59}"
                                          value="${serial?.endTime?.length() == 8 ? serial?.endTime[3, 4] : 00}"/>分
                                <g:select name="endtmS" from="${0..59}"
                                          value="${serial?.endTime?.length() == 8 ? serial?.endTime[6, 7] : 00}"/>秒
                            </td>
                        </tr>

                        <tr class="edit_box1">
                            <td class="name">
                                <label>描述:</label>
                            </td>
                            <td class="value ${hasErrors(bean: serial, field: 'description', 'errors')}">
                                <textarea style="width:282px;height:40px;padding-right:1px;margin-right:1px;"
                                          name="description">${fieldValue(bean: serial, field: 'description')}</textarea>
                            </td>
                        </tr>

                        </tbody>
                    </table>
                </div>

                <div align="center" style="margin-top:6px;" class="but_infor">
                    <input type="button" onclick="playLink(this.form);" class="buttons"
                           style="cursor:pointer;width:40px;" value="播放">&nbsp;<g:submitButton name="upbtn"
                                                                                               class="buttons"
                                                                                               style="cursor:pointer;width:40px;"
                                                                                               value="确定"
                                                                                               onclick="return checkSerial(this.form);"/>&nbsp;<input
                        type="button" onclick="hideWnd('editMaterial');" class="buttons"
                        style="cursor:pointer;width:40px;" value="关闭">
                </div>
            </g:formRemote>

        </DIV>

        <DIV class="rg3"></DIV>

        <DIV class="rg4"></DIV>
    </g:if>
</DIV>
