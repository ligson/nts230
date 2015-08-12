<%@ page import="nts.program.domain.Serial" %>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/bfUploadPhoto.js')}"></script>
<script type="text/javascript">
    $(function () {
        //serialId,fileEntity
        global.posterPath = "${application.uploadRootPath}/${session.consumer.name}/Img${classLibId}/";//海报路径
        var uploadServerRootUrl = "http://" + global.videoSevr + ":" + global.videoPort + "/bmc";
        var uploadUrl = "http://" + global.videoSevr + ":" + global.videoPort + "/bmc/upload/uploadFile";
        var posterPath = global.posterPath;
        var serialId = $("#editSerialForm").find("input[name=id]").val();
        var params = {serialId: serialId,uploadPath:posterPath};
        initPhotoUpload(uploadServerRootUrl,uploadUrl,params);
    });
</script>

<DIV id="editSerial" class="editSerial_all" style="width:450px;  ${serial == null ? 'none' : 'block'};">
<g:if test="${serial}">
    <DIV class="t1">子目信息</DIV>
     <DIV class="bc">
        <h1 id="serialTitle" style="text-align:center;font-size: 14px;margin: 5px 0">子目信息</h1>
        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>
        <g:hasErrors bean="${serial}">
            <div class="errors">
                <g:renderErrors bean="${serial}" as="list"/>
            </div>
        </g:hasErrors>
        <g:formRemote method="post" name="editSerialForm" url="[action: 'operateSerial']" update="serialList"
                      onComplete="hideWnd('editSerial');">
            <input type="hidden" name="id" value="${serial?.id}"/>
            <input type="hidden" name="programId" value="${serial?.program?.id}"/>
            <input type="hidden" name="oldSerialNo" value="${serial?.serialNo}"/>
            <input type="hidden" name="progType" value="${serial?.progType}"/>
            <input type="hidden" name="timeLength" value="${serial?.timeLength}"/>
            <input type="hidden" name="bandWidth" value="${serial?.bandWidth}"/>
            <input type="hidden" name="svrAddress" value="${serial?.svrAddress}"/>
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
                            <input type="text" style="width:100px;" id="serialNo" name="serialNo"
                                   value="${serial.serialNo}"/>
                        </td>
                    </tr>

                    <tr class="edit_box1">
                        <td>
                            名称:
                        </td>
                        <td class="value ${hasErrors(bean: serial, field: 'name', 'errors')}">
                            <label><input type="text" style="width:282px;" maxlength="80" id="name" name="name"
                                          value="${fieldValue(bean: serial, field: 'name')}"/></label>
                        </td>
                    </tr>

                    <tr class="edit_box1">
                        <td>
                            浏览方式:
                        </td>
                        <td class="value ${hasErrors(bean: serial, field: 'name', 'errors')}">
                            <div id="dd1" style="float:left;display:inline;"><input type="hidden" name="oldUrlType"
                                                                                    value="${serial.urlType}">
                                <g:select from="${Serial.urlTypeName}" name="urlType"
                                          onchange="onSerialUrlTypeChange()" value="${serial.urlType}"
                                          optionKey="key" optionValue="value"/>
                            </div>

                            <div id="tranStateDiv${Serial.URL_TYPE_VIDEO}" style="float:left;display:inline;">
                                <input type="checkbox" name="transcodeStateList"
                                       value="${Serial.OPT_VIDEW_STANDARD}" ${(serial?.transcodeState & Serial.OPT_VIDEW_STANDARD) == Serial.OPT_VIDEW_STANDARD ? "checked" : ""}>标清&nbsp;
                                <input type="checkbox" name="transcodeStateList"
                                       value="${Serial.OPT_VIDEW_HIGH}" ${(serial?.transcodeState & Serial.OPT_VIDEW_HIGH) == Serial.OPT_VIDEW_HIGH ? "checked" : ""}>高清&nbsp;
                                <input type="checkbox" name="transcodeStateList"
                                       value="${Serial.OPT_VIDEW_SUPER}" ${(serial?.transcodeState & Serial.OPT_VIDEW_SUPER) == Serial.OPT_VIDEW_SUPER ? "checked" : ""}>超清&nbsp;
                            </div>

                            <div id="tranStateDiv${Serial.URL_TYPE_COURSE}" style="float:left;display:inline;">
                                <input type="checkbox" name="transcodeStateList"
                                       value="${Serial.OPT_ISO_VIRTUAL}" ${(serial?.transcodeState & Serial.OPT_ISO_VIRTUAL) == Serial.OPT_ISO_VIRTUAL ? "checked" : ""}>虚拟光驱&nbsp;
                            </div>

                            <div id="tranStateDiv${Serial.URL_TYPE_IMAGE}" style="float:left;display:inline;">
                                <input type="checkbox" name="transcodeStateList"
                                       value="${Serial.OPT_IMG_POSTER}" ${(serial?.transcodeState & Serial.OPT_IMG_POSTER) == Serial.OPT_IMG_POSTER ? "checked" : ""}>海报&nbsp;
                            </div>

                            <div id="tranStateDiv${Serial.URL_TYPE_DOCUMENT}" style="float:left;display:inline;">
                                <input type="checkbox" name="transcodeStateList"
                                       value="${Serial.OPT_DOC_LIB}" ${(serial?.transcodeState & Serial.OPT_DOC_LIB) == Serial.OPT_DOC_LIB ? "checked" : ""}>文库&nbsp;
                            </div>

                        </td>
                    </tr>

                    <tr class="edit_box1">
                        <td>
                            转码状态:
                        </td>
                        <td class="value ${hasErrors(bean: serial, field: 'name', 'errors')}">
                            <input type="hidden" name="oldState" value="${serial.state}">
                            <g:select from="${Serial.stateName}" name="state" value="${serial.state}"
                                      optionKey="key" optionValue="value"></g:select>
                        </td>
                    </tr>

                    <tr class="edit_box1">
                        <td class="name">
                            <label for="filePath">文件路径:</label>
                        </td>
                        <td class="value ${hasErrors(bean: serial, field: 'filePath', 'errors')}">
                            <input type="text" style="width:282px;" maxlength="250" id="filePath" name="filePath"
                                   value="${fieldValue(bean: serial, field: 'filePath')}"/>
                        </td>
                    </tr>

                    <g:if test="${serial?.urlType == Serial.URL_TYPE_VIDEO}">
                        <tr class="edit_box1">
                            <td class="name">
                                <label for="filePath">海报路径:</label>
                            </td>
                            <td class="value ${hasErrors(bean: serial, field: 'filePath', 'errors')}">
                                <input type="text" style="width:170px;" maxlength="250" id="photo" name="photo"
                                       value="${fieldValue(bean: serial, field: 'photo')}"/>
                                <input type="button" name="upbtn" id="bfSelectPhotoBtn"
                                       style="width:40px;" value="上传">
                            </td>
                        </tr>
                    </g:if>
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
                            <textarea style="width:282px;height:40px;"
                                      name="description">${fieldValue(bean: serial, field: 'description')}</textarea>
                        </td>
                    </tr>

                    <tr class="edit_box1">
                        <td class="name">
                            <label>说明:</label>
                        </td>
                        <td class="value ${hasErrors(bean: serial, field: 'description', 'errors')}">
                            开始时间，结束时间只对视音频文件有效。
                        </td>
                    </tr>

                    </tbody>
                </table>
            </div>

            <div  align="center" style="margin-top:7px;">
                <g:if test="${serial.urlType == Serial.URL_TYPE_VIDEO}"><input type="buttom"
                                                                               onclick="playLink(this.form);"
                                                                               class="buttons"
                                                                               value="播放"></g:if><g:submitButton
                    name="upbtn2" class="buttons"  value="确定"
                    onclick="return checkSerial(this.form);"/>&nbsp;<input type="buttom"
                                                                           onclick="hideWnd('editSerial');"
                                                                           class="buttons" style="width: 40px; height: 25px;"
            value="关闭">
            </div>
        </g:formRemote>

    </DIV>
</g:if>
</DIV>