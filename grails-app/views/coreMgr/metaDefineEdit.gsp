<%@ page import="nts.meta.domain.MetaDefine" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>Edit nts.meta.domain.MetaDefine</title>
    <link href="${resource(dir: 'skin/blue/pc/admin/css', file: 'main.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/metaedit.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/isNum2.js')}"></script>
    <SCRIPT LANGUAGE="JavaScript">
        <!--
        //全局变量
        global = new globalVars();
        function globalVars() {
            this.metaDefineId = ${metaDefine.id};
            this.parentId = ${metaDefine.parentId};
            this.nameExist = false;
            this.maxEnumId = ${metaDefine.metaEnums.size()+1};
            this.parentMetaAction = "${createLink(action:'getParentMetaOption')}";
            this.nameAction = "${createLink(action:'checkNameExist')}";
        }
        window.onload = init;
        function init() {
            <g:if test="${application.detaDefineAllowModifyOpt == 1}">
            form1.dataType.value = '${metaDefine.dataType}';//允许自由修改时
            </g:if>
            onIsDeco();

        }


        //-->
    </SCRIPT>
    <style type="text/css">
    .dialog select {
        line-height: 30px;
        height: 30px;
        display: block;
        overflow: hidden;
    }

    .dialog td {
        line-height: 30px;
        height: 30px;
    }

    .dialog {
        padding-left: 10px;
    }

    .prop {
        height: 30px;
    }

    .button {
        color: #2e5b88;
        background: url("${resource(dir: 'skin/blue/pc/images',file: 'but_3.png')}") repeat-x;
        padding: 3px 15px;
        border: 1px solid #8fb2da;
        border-radius: 3px;
        height: 20px;
        overflow: visible;
        cursor: pointer;
    }

    .button {
        background: url("${resource(dir: 'skin/blue/pc/images',file:'but_4.png')}") repeat-x;
        padding: 3px 15px;
        cursor: pointer;
    }
    </style>
</head>

<body>


<div class="body">
<br>
<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>
<g:hasErrors bean="${metaDefine}">
    <div class="errors">
        <g:renderErrors bean="${metaDefine}" as="list"/>
    </div>
</g:hasErrors>
<g:form name="form1" action="metaDefineUpdate" method="post" onsubmit="return check();">
<input type="hidden" name="id" value="${metaDefine?.id}"/>
<input type="hidden" name="directoryId" value="${directoryId}"/>
<input type="hidden" name="maxEnumId" value="1">

<div class="dialog">
<table>
<tbody>

<tr class="prop">
    <td valign="top" class="directory" style="padding-top:6px;">
        <label>所属类库:</label>
    </td>
    <td class="value ">
        <input type="radio" style="border:0px;" name="allClass"
               value="1" ${metaDefine.directorys.size() == 0 ? 'checked' : ''}
               onclick="onAllClass(this.form);">所有库(包括现有库和以后添加的库)<br>
        <input type="radio" name="allClass" value="0"
               style="border:0px;" ${metaDefine.directorys.size() > 0 ? 'checked' : ''}
               onclick="onAllClass(this.form);">部分库(从下面列表中选择)<br>
        <g:each var="s" status="i" in="${directoryList}">
            <input type="checkbox"
                   onchange="onIsDeco();" ${metaDefine.directorys.size() > 0 ? '' : 'disabled'} ${metaDefine.directorys.id.contains(s.id) ? 'checked' : ''}
                   name="selDirectory" value="${s.id}">${s.name}
        </g:each>
    </td>
</tr>

<tr class="prop">
    <td class="name">
        <label for="name">类型:</label>
    </td>
    <td class="value ">
        <SELECT name="elementType" onchange="onIsDeco();">

            <g:if test="${metaDefine.parentId == 0 && metaDefine.dataType != 'decorate' && metaDefine.dataType != 'decorate2'}">
                <option value="0" selected>简单元素(不包含修饰词)</option>
            </g:if>
            <g:elseif test="${metaDefine.parentId == 0 && metaDefine.dataType == 'decorate'}">
                <option value="1">复合元素(包含修饰词)</option>
            </g:elseif>
            <g:elseif test="${metaDefine.parentId != 0 && metaDefine.dataType == 'decorate2'}">
                <option value="1">复合修饰词(包含修饰词)</option>
            </g:elseif>
            <g:elseif test="${metaDefine.parentId != 0 && metaDefine.dataType != 'decorate2'}">
                <option value="2">修饰词</option>
            </g:elseif>

        </SELECT>
    </td>
</tr>

<tr class="prop" id="decoTR" style="display:block">
    <td class="name">
        <label for="name">选择元素:</label>
    </td>
    <td class="value">
        <SELECT id="parentId" name="parentId">
        </SELECT>
    </td>
</tr>

<tr class="prop">
    <td class="name">
        <label for="name">名称:</label>
    </td>
    <td class="value ${hasErrors(bean: metaDefine, field: 'name', 'errors')}">
        <input type="text" maxlength="100" id="name" name="name" onchange="checkNameExist(this)"
               value="${fieldValue(bean: metaDefine, field: 'name')}"/>
    </td>
</tr>

<tr class="prop">
    <td class="name">
        <label for="cnName">中文名称:</label>
    </td>
    <td class="value ${hasErrors(bean: metaDefine, field: 'cnName', 'errors')}">
        <input type="text" maxlength="40" id="cnName" name="cnName"
               value="${fieldValue(bean: metaDefine, field: 'cnName')}"/>
    </td>
</tr>

<tr class="prop">
    <td class="name">
        <label>数据类型:</label>
    </td>
    <td class="value ${hasErrors(bean: metaDefine, field: 'dataType', 'errors')}">
        <SELECT name="dataType" onchange="onChangeData();">
            <g:if test="${application.detaDefineAllowModifyOpt == 1}">
                <g:if test="${metaDefine.dataType == 'decorate'}">
                    <OPTION value="decorate">不确定</OPTION>
                </g:if>
                <g:else>

                    <OPTION value="string">字符串</OPTION>
                    <OPTION value="textarea">长字符串</OPTION>
                    <OPTION value="number">数字</OPTION>
                    <OPTION value="date">日期</OPTION>
                    <OPTION value="time">时间</OPTION>
                    <OPTION value="datetime">日期时间</OPTION>
                    <OPTION value="enumeration">枚举</OPTION>
                    <OPTION value="link">链接</OPTION>
                    <OPTION value="img">图片</OPTION>

                </g:else>
            </g:if>
            <g:else>
                <g:if test="${metaDefine.dataType == 'decorate'}">
                    <OPTION value="decorate">不确定</OPTION>
                </g:if>
                <g:else>
                    <OPTION value="${metaDefine.dataType}">${MetaDefine.dataTypeMap[metaDefine.dataType]}</OPTION>
                </g:else>
            </g:else>
        </select>
    </td>
</tr>

<tr class="prop" id="enumTR" name="enumTR"
    style="display:${metaDefine?.dataType == "enumeration" ? "block" : "none"};">
    <td colspan="2" class="name">
        <INPUT TYPE="button" value="添加枚举元素" onclick="javascript:addtr();">
        <INPUT TYPE="button" value="删除枚举元素" onclick="deltr();">
        <table id="enumTab" cellspacing="1" width="100%"
               style="border-collapse: collapse;border:1px solid #ccc;">
            <tr>
                <th align="center">ID(数字)</th>
                <th align="center">名称</th>
                <th align="center">操作</th>
            </tr>

            <g:each status="i" var="m" in="${metaDefine?.metaEnums ?}">
                <tr>
                    <td><input type=text name=enumId ${i + 1} value="${m?.enumId}"></td>
                    <td><input type=text name=enumName ${i + 1} value="${m?.name}"></td>
                    <td align="center"><a href=#
                                          onclick='javascript:deltr(event.srcElement.parentElement.parentElement.rowIndex)'>删除</a>
                    </td>
                </tr>
            </g:each>
        </table>
    </td>
</tr>

<tr class="prop">
    <td class="name">
        <label for="maxLength">最大长度:</label>
    </td>
    <td class="value ${hasErrors(bean: metaDefine, field: 'maxLength', 'errors')}">
        <input type="text" id="maxLength" name="maxLength"
               value="${fieldValue(bean: metaDefine, field: 'maxLength')}"/>
    </td>
</tr>

<tr class="prop">
    <td class="name">
        <label for="defaultValue">默认值:</label>
    </td>
    <td class="value ${hasErrors(bean: metaDefine, field: 'defaultValue', 'errors')}">
        <input type="text" maxlength="40" id="defaultValue" name="defaultValue"
               value="${fieldValue(bean: metaDefine, field: 'defaultValue')}"/>
    </td>
</tr>



<tr class="prop">
    <td class="name">
        <label for="description">描述:</label>
    </td>
    <td class="value ${hasErrors(bean: metaDefine, field: 'description', 'errors')}">
        <input type="text" maxlength="250" id="description" name="description"
               value="${fieldValue(bean: metaDefine, field: 'description')}"/>
    </td>
</tr>

<tr class="prop">
    <td class="name">
        <label>显示:</label>
    </td>
    <td class="value ">
        <INPUT type="checkbox" ${(metaDefine.showType & 1) == 1 ? "checked" : ""} value="1"
               name="showTypeList">详细页面显示
        <INPUT type="checkbox" ${(metaDefine.showType & 2) == 2 ? "checked" : ""} value="2"
               name="showTypeList">摘要页面显示
        <INPUT type="checkbox" ${(metaDefine.showType & 4) == 4 ? "checked" : ""} value="4"
               name="showTypeList">设为浏览类别
    </td>
</tr>

%{--<tr class="prop">
    <td class="name">
        <label>检索点:</label>
    </td>
    <td class="value ">
        <INPUT type="checkbox" ${(metaDefine.searchType & 1) == 1 ? "checked" : ""} value="1"
               name="searchTypeList"> 客户端检索点
    <!--<INPUT type="checkbox" ${(metaDefine.searchType & 2) == 2 ? "checked" : ""} value="2" name="searchTypeList"> 管理端检索点-->
    </td>
</tr>--}%

<tr class="prop">
    <td class="name">
        <label>其它属性:</label>
    </td>
    <td class="value ">
        <input type="checkbox" name="isNecessary" ${metaDefine.isNecessary == 1 ? "checked" : ""} value="1">必备
        <input type="checkbox" name="showTypeList" ${(metaDefine.showType & 8) == 8 ? "checked" : ""}
               value="8">编目缺省显示
        <input type="checkbox" name="showTypeList" ${(metaDefine.showType & 16) == 16 ? "checked" : ""}
               value="16">导出
        <input type="checkbox" name="showTypeList" ${(metaDefine.showType & 32) == 32 ? "checked" : ""}
               value="32">唯一
        <g:if test="${metaDefine?.dataType == 'enumeration' || metaDefine.dataType == 'decorate'}">
            <input type="checkbox" name="showTypeList" ${(metaDefine.showType & 64) == 64 ? "checked" : ""}
                   value="64">分类统计
        </g:if>
    </td>
</tr>

</tbody>
</table>
</div>

<div class="buttons">
    <span class="button"><input class="save" type="submit" value="提交"/></span>
    <span class="button"><input class="return" type="button" onclick="history.back();" value="取消"/></span>
</div>
</g:form>
</div>
</body>
</html>
