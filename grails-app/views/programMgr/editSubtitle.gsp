<r:require modules="swfupload"/>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'editSubtitleList.css')}">
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/bfUploadSubtitle.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/progedit.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/isNum2.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
<DIV id="editSubtitle" class="bg"  ${serial == null ? 'none' : 'block'};">
    <g:if test="${serial}">
        <DIV class="rg1"></DIV>

        <DIV class="rg2"></DIV>

        <DIV class="edit_title">字幕信息</DIV>

        <DIV class="bc">

            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${serial}">
                <div class="errors">
                    <g:renderErrors bean="${serial}" as="list"/>
                </div>
            </g:hasErrors>
            <g:form method="post" name="editSubtitleForm" action="operateSubtitle">
                <input type="hidden" name="fileType" value="srt"/>
                <input type="hidden" name="fileHash" value="${subtitle?.fileHash}"/>
                <input type="hidden" name="id" value="${subtitle?.id}"/>
                <input type="hidden" name="programId" value="${serial?.program?.id}"/>
                <input type="hidden" name="serialId" value="${serial?.id}"/>
                <input type="hidden" name="oldSerialNo" value="${serial?.serialNo}"/>
                <input type="hidden" name="operation" value=""/>

                <div>
                    <table class="table">
                        <tbody>

                        <tr class="prop">
                            <th align="center" width="140">
                                序列号:
                            </th>
                            <td>
                                <input type="text" style="width:200px;" id="serialNo" class="form-control"
                                       name="serialNo" value="1"/>
                            </td>
                        </tr>

                        <tr class="prop">
                            <th align="center" width="140">
                                语种:
                            </th>
                            <td class="value ${hasErrors(bean: serial, field: 'serialNo', 'errors')}">
                                <g:select id="langId" name='langId' from='${langList}' optionKey="id"
                                          class="form-control" style="width:200px;"
                                          value="${subtitle?.lang ? subtitle?.lang?.id : 37}"
                                          optionValue="zhName"></g:select>
                            </td>
                        </tr>

                        <tr class="prop">
                            <th align="center" width="140">
                                字幕文件:
                            </th>
                            <td class="value ${hasErrors(bean: serial, field: 'name', 'errors')}">
                                <input type="hidden" style="width:200px; float: left ; margin-right: 10px "
                                       maxlength="150" id="filePath" name="filePath" class="form-control"
                                       value="${subtitle?.filePath}"/>
                                <span id="speed"></span>
                                <label class="chose_up">
                                    <input type="button" name="upbtn" id="bfSubtitleUploadBtn"
                                       value="上传">
                                </label>
                            </td>
                        </tr>

                        </tbody>
                    </table>
                </div>

                <div align="left" style="margin-top:7px;">
                    <g:submitButton name="subupbtn" class="btn btn-primary" value="确定"
                                    onclick="return checkSubtitle(this.form);"/>&nbsp;
                    <a class="btn btn-primary"
                       href="${createLink(controller: 'programMgr', action: 'editSubtitleList', params: [id: serial?.id])}"
                       style="color:#FFF;">返回</a>
                </div>
            </g:form>

        </DIV>

        <DIV class="rg3"></DIV>

        <DIV class="rg4"></DIV>
    </g:if>
</DIV>