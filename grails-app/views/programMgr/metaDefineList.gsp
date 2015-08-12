<%@ page import="nts.meta.domain.MetaDefine" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" rel="stylesheet" type="text/css">

    <title>元数据列表</title>


    <script type="text/javascript">
        <!--
        function onClassChange(theObj) {
            self.location.href = "${createLink(action:'metaDefineList')}?directoryId=" + theObj.value;
        }

        function setShowOrder(vUp, trId) {
            var curIndex = 0;
            var arr = trId.split("|");
            if (arr.length != 2) {
                alert("data error" + vUp);
                return;
            }

            var otherId = -1;
            var curParentId = arr[0];
            var curId = arr[1];
            var wtab = document.getElementById("metaListTab");
            for (var i = 0; i < wtab.rows.length; i++) {
                if (wtab.rows[i].id == trId) {
                    curIndex = i;
                }
            }

            if (vUp == 0 && curIndex == wtab.rows.length - 1) return;
            if (vUp == 1 && i == 0) return;

            if (vUp == 1) {
                if (curParentId == 0) {
                    for (var j = 0; j < curIndex; j++) {
                        arr = wtab.rows[j].id.split("|");
                        if (arr[0] == 0) {
                            otherId = arr[1];
                        }
                    }

                }
                else {
                    arr = wtab.rows[curIndex - 1].id.split("|");
                    if (arr[0] > 0) otherId = arr[1];
                }
            }
            else//(vUp == 0)
            {
                if (curParentId == 0) {
                    for (var k = curIndex + 1; k < wtab.rows.length; k++) {
                        arr = wtab.rows[k].id.split("|");
                        if (arr[0] == 0) {
                            otherId = arr[1];
                            break;
                        }
                    }
                }
                else {
                    arr = wtab.rows[curIndex + 1].id.split("|");
                    if (arr[0] > 0) otherId = arr[1];
                }
            }

            if (curId > 0 && otherId > 0) {
                var dirId = document.getElementById("directoryId");
                window.location.href = "<g:createLink controller="programMgr"  action="setShowOrder" />?curId=" + curId + "&otherId=" + otherId + "&directoryId=" + dirId.value;
            }
        }
        //alert(33);
        //-->
    </SCRIPT>

</head>

<body>

<g:form controller="programMgr" action="metaDefineList" name="form1">
    <div class="admin_content_nav">
        <span>选择标准：</span>
        <label>
            <g:select class="admin_default_inp admin_default_inp_size2" from="${directoryList}" name="directoryId"
                      value="${directoryId}"
                      noSelection="${['0': '所有标准']}" optionKey="id" optionValue="name"
                      onchange="onClassChange(this);"/>
        </label>
        <label>
            <g:link action="metaDefineCreate" class="admin_default_but_yellow" style="color:#FFF"
                    params="[directoryId: directoryId]">添加</g:link>
        </label>
        <label>
            <g:remoteLink action="metaToXml" update="message" class="admin_default_but_yellow"
                          style="color:#FFF">备份元数据</g:remoteLink>
        </label>
        %{--<label>

            <g:link action="syncMeta" class="admin_default_but_yellow"
                    style="color:#FFF">同步元数据显示</g:link>
        </label>--}%
    </div>

    <div id="message" style="color:#006dba;padding:2px 0 2px 10px;"></div>
    <table width="98%" style="margin-left: 10px;" border="0" cellspacing="0">
        <tr>
            <td align="left"><span class="zi-cu">元数据列表</span></td>
        </tr>
    </table>
    <table id="metaListTab" class="table table-hover" style="background: #FFF">
        <thead>
        <tr class="list_bg">
            <th class="STYLE5" height="28">序号</th>
            <th class="STYLE5">ID</th>
            <th class="STYLE5">名称</th>
            <th class="STYLE5">中文名称</th>
            <th class="STYLE5">数据类型</th>
            <th class="STYLE5">所属元数据标准</th>
            <th class="STYLE5">修改</th>
            <th class="STYLE5">删除</th>
            <th class="STYLE5">排序</th>
        </tr>
        </thead>
        <tbody>
        <g:set var="serialNo" value="${1}"/>
        <g:set var="counter" value="${1}"/>
        <g:each in="${metaDefineList}" status="i" var="metaDefine">
            <g:if test="${metaDefine.parentId == 0}">
                <tr id="${metaDefine.parentId}|${metaDefine.id}" class="${counter % 2 == 0 ? 'odd' : 'even'}">
                    <td>${serialNo++}<g:set var="counter" value="${counter + 1}"/></td>
                    <td>${fieldValue(bean: metaDefine, field: 'id')}</td>
                    <td style="color:red">${fieldValue(bean: metaDefine, field: 'name')}</td>
                    <td>${fieldValue(bean: metaDefine, field: 'cnName')}</td>
                    <td>${MetaDefine.dataTypeMap[metaDefine.dataType]}</td>
                    <td>
                        <g:if test="${metaDefine.directorys.size() > 0}">
                            <g:each in="${metaDefine.directorys}">
                                ${it.name}
                            </g:each>
                        </g:if>
                        <g:else>
                            所有标准
                        </g:else>
                    </td>
                    <td align="left"><g:link action="metaDefineEdit" id="${metaDefine.id}"
                                             params="[directoryId: directoryId]"><img
                                src="${resource(dir: 'images/skin', file: 'modi.gif')}"
                                alt="" width="14" height="14"
                                border="0"></g:link></td>
                    <td align="left">
                        <g:if test="${MetaDefine.sysMeta.contains(metaDefine.name)}">
                            &nbsp;
                        </g:if>
                        <g:else>
                            <g:link action="metaDefineDelete" id="${metaDefine.id}"
                                    onclick="return confirm('确实要删除该元数据吗？');"><img
                                    src="${resource(dir: 'images/skin', file: 'delete.gif')}" border="0" width="11"
                                    height="13"/></g:link>
                        </g:else>
                    </td>
                    <td align="left"><img src="${resource(dir: 'images/skin', file: 'up.gif')}" border=0
                                          onclick="setShowOrder(1, '${metaDefine.parentId}|${metaDefine.id}')"><img
                            src="${resource(dir: 'images/skin', file: 'down.gif')}" border=0
                            onclick="setShowOrder(0, '${metaDefine.parentId}|${metaDefine.id}')"></td>
                </tr>

                <g:findAll in="${metaDefineList}" expr="${it.parentId == metaDefine.id}">
                    <tr id="${it.parentId}|${it.id}" class="${counter % 2 == 0 ? 'odd' : 'even'}">
                        <td>&nbsp;<g:set var="counter" value="${counter + 1}"/><g:set var="subMetaDefineId"
                                                                                      value="${fieldValue(bean: it, field: 'id')}"/></td>
                        <td>${subMetaDefineId}</td>
                        <td style="color:blue">&nbsp;&nbsp;&nbsp;&nbsp;${fieldValue(bean: it, field: 'name')}</td>
                        <td>${fieldValue(bean: it, field: 'cnName')}</td>
                        <td>${MetaDefine.dataTypeMap[it.dataType]}</td>
                        <td>
                            <g:if test="${it.directorys.size() > 0}">
                                <g:each in="${it.directorys}" var="dir">
                                    ${dir.name}
                                </g:each>
                            </g:if>
                            <g:else>
                                所有标准
                            </g:else>
                        </td>
                        <td align="left">
                            <g:link action="metaDefineEdit"
                                    params="[directoryId: directoryId, id: subMetaDefineId]"><img
                                    src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="" width="14"
                                    height="14"
                                    border="0"></g:link>
                        </td>
                        <td align="left">
                            <g:if test="${MetaDefine.sysMeta.contains(it.name)}">
                                &nbsp;
                            </g:if>
                            <g:else>
                                <g:link action="metaDefineDelete" id="${subMetaDefineId}"
                                        onclick="return confirm('确实要删除该元数据吗？');"><img
                                        src="${resource(dir: 'images/skin', file: 'delete.gif')}" border="0" width="11"
                                        height="13"/></g:link>
                            </g:else>
                        </td>
                        <td align="left"><img src="${resource(dir: 'images/skin', file: 'up.gif')}" border=0
                                              onclick="setShowOrder(1, '${it.parentId}|${subMetaDefineId}')"><img
                                src="${resource(dir: 'images/skin', file: 'down.gif')}" border=0
                                onclick="setShowOrder(0, '${it.parentId}|${subMetaDefineId}')"></td>
                    </tr>
                    <g:each in="${metaDefineList}" var="decorate">
                        <g:if test="${subMetaDefineId == decorate.parentId}">
                            <tr id="${decorate.parentId}|${decorate.id}"
                                class="${counter % 2 == 0 ? 'odd' : 'even'}">
                                <td>&nbsp;<g:set var="counter" value="${counter + 1}"/></td>
                                <td>${fieldValue(bean: decorate, field: 'id')}</td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${fieldValue(bean: decorate, field: 'name')}</td>
                                <td>${fieldValue(bean: decorate, field: 'cnName')}</td>
                                <td>${MetaDefine.dataTypeMap[decorate.dataType]}</td>
                                <td>
                                    <g:if test="${decorate.directorys.size() > 0}">
                                        <g:each in="${decorate.directorys}">
                                            ${decorate.name}
                                        </g:each>
                                    </g:if>
                                    <g:else>
                                        所有标准
                                    </g:else>
                                </td>
                                <td align="left"><g:link action="metaDefineEdit" id="${decorate.id}"
                                                         params="[directoryId: directoryId]"><img
                                            src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="" width="14"
                                            height="14"
                                            border="0"></g:link></td>
                                <td align="left">
                                    <g:if test="${MetaDefine.sysMeta.contains(decorate.name)}">
                                        &nbsp;
                                    </g:if>
                                    <g:else>
                                        <g:link action="metaDefineDelete" id="${decorate.id}"
                                                onclick="return confirm('确实要删除该元数据吗？');"><img
                                                src="${resource(dir: 'images/skin', file: 'delete.gif')}" border="0"
                                                width="11"
                                                height="13"/></g:link>
                                    </g:else>
                                </td>
                                <td align="left"><img src="${resource(dir: 'images/skin', file: 'up.gif')}"
                                                      border=0
                                                      onclick="setShowOrder(1, '${decorate.parentId}|${decorate.id}')"><img
                                        src="${resource(dir: 'images/skin', file: 'down.gif')}" border=0
                                        onclick="setShowOrder(0, '${decorate.parentId}|${decorate.id}')"></td>
                            </tr>
                        </g:if>
                    </g:each>
                </g:findAll>

            </g:if>
        </g:each>
        </tbody>
    </table>

</g:form>
</body>
</html>

