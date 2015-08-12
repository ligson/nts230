<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/bfUploadSubtitle.js')}"></script>
<script type="text/javascript">
    $(function () {
        //serialId,fileEntity
        var subtitleId = $("#editSubtitleForm").find("input[name=id]").val();
        var params = {subtitleId: subtitleId};
        initSubtitleUpload(params);
    });
</script>

<DIV id="editSubtitle" class="bg" style="width:390px;display: ${serial == null ? 'none' : 'block'};">
    <g:if test="${serial}">
        <DIV class="rg1"></DIV>

        <DIV class="rg2"></DIV>

        <DIV class="t1">字幕信息</DIV>

        <DIV class="bc">

            <h1 align="center" id="subtitleTitle">字幕信息</h1>
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${serial}">
                <div class="errors">
                    <g:renderErrors bean="${serial}" as="list"/>
                </div>
            </g:hasErrors>
            <g:formRemote method="post" name="editSubtitleForm" url="[action: 'operateSubtitle']" update="subtitleList"
                          onComplete="hideWnd('editSubtitle');">
                <input type="hidden" name="id" value="${subtitle?.id}"/>
                <input type="hidden" name="programId" value="${serial?.program?.id}"/>
                <input type="hidden" name="serialId" value="${serial?.id}"/>
                <input type="hidden" name="oldSerialNo" value="${serial?.serialNo}"/>
                <input type="hidden" name="operation" value=""/>

                <div class="dialog">
                    <table>
                        <tbody>

                        <tr class="prop">
                            <td class="name" style="width:160px;">
                                序列号:
                            </td>
                            <td>
                                <input type="text" class="text-input datepicker" style="width:50px;" id="serialNo"
                                       name="serialNo" value="1"/>
                            </td>
                        </tr>

                        <tr class="prop">
                            <td>
                                语种:
                            </td>
                            <td class="value ${hasErrors(bean: serial, field: 'serialNo', 'errors')}">
                                <g:select id="langId" name='langId' from='${langList}' optionKey="id"
                                          value="${subtitle?.lang ? subtitle?.lang?.id : 37}"
                                          optionValue="zhName"></g:select>
                            </td>
                        </tr>

                        <tr class="prop">
                            <td>
                                字幕文件:
                            </td>
                            <td class="value ${hasErrors(bean: serial, field: 'name', 'errors')}">
                                <input type="text" style="width:200px;" maxlength="150" id="filePath" name="filePath"
                                       value="${subtitle?.filePath}"/>
                                <input type="button" name="upbtn" id="bfSubtitleUploadBtn" style="width:40px;"
                                       value="上传">
                            </td>
                        </tr>

                        </tbody>
                    </table>
                </div>

                <div align="center" style="margin-top:7px;">
                    <g:submitButton name="subupbtn" class="buttons" style="cursor:pointer;width:40px;" value="确定"
                                    onclick="return checkSubtitle(this.form);"/>&nbsp;<input type="buttom"
                                                                                             onclick="hideWnd('editSubtitle');"
                                                                                             class="buttons"
                                                                                             style="cursor:pointer;width:40px;"
                                                                                             value="关闭">
                </div>
            </g:formRemote>

        </DIV>

        <DIV class="rg3"></DIV>

        <DIV class="rg4"></DIV>
    </g:if>
</DIV>