<%@ page import="nts.utils.CTools; nts.meta.domain.MetaDefine" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>编辑元数据</title>
    %{--<link href="${resource(dir: 'skin/blue/pc/admin/css', file: 'main.css')}" rel="stylesheet" type="text/css">--}%
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/metaedit.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/isNum2.js')}"></script>
    <script language="JavaScript" type="text/javascript">
        <!--
        //全局变量

        function GlobalVars() {
            this.metaDefineId = ${metaDefine.id};
            this.parentId = ${metaDefine.parentId};
            this.nameExist = false;
            this.maxEnumId = ${metaDefine.metaEnums.size()+1};
            this.parentMetaAction = "${createLink(action:'getParentMetaOption')}";
            this.nameAction = "${createLink(action:'checkNameExist')}";
        }
        global = new GlobalVars();

        window.onload = init;
        function init() {
            <g:if test="${application.detaDefineAllowModifyOpt == 1}">
            form1.dataType.value = '${metaDefine.dataType}';//允许自由修改时
            </g:if>
            onIsDeco();

        }


        //-->
    </SCRIPT>

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
<table class="table">
<tbody>

<tr>
    <td valign="right">
        <label>所属类库:</label>
    </td>
    <td class="value ">
        <input type="radio" style="border:0;" name="allClass"
               value="1" ${metaDefine.directorys.size() == 0 ? 'checked' : ''}
               onclick="onAllClass(this.form);">所有库(包括现有库和以后添加的库)<br>
        <input type="radio" name="allClass" value="0"
               style="border:0;" ${metaDefine.directorys.size() > 0 ? 'checked' : ''}
               onclick="onAllClass(this.form);">部分库(从下面列表中选择)<br>
        <g:each var="s" status="i" in="${directoryList}">
            <input type="checkbox"
                   onchange="onIsDeco();" ${metaDefine.directorys.size() > 0 ? '' : 'disabled'} ${metaDefine.directorys.id.contains(s.id) ? 'checked' : ''}
                   name="selDirectory" value="${s.id}">${s.name}
        </g:each>
    </td>
</tr>

<tr>
    <td width="100">
        <label>类型:</label>
    </td>
    <td class="value ">
        <SELECT name="elementType" onchange="onIsDeco();" class="form-control " style=" width: 220px">

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

<tr id="decoTR">
    <td>
        <label for="name">选择元素:</label>
    </td>
    <td>
        <select id="parentId" name="parentId" class="form-control " style=" width: 220px"></select>
    </td>
</tr>

<tr class="prop">
    <td class="name">
        <label for="name">名称:</label>
    </td>
    <td class="value ${hasErrors(bean: metaDefine, field: 'name', 'errors')}">
        <input type="text" maxlength="100" id="name" name="name" onchange="checkNameExist(this)" class="form-control "
               style=" width: 220px"
               value="${fieldValue(bean: metaDefine, field: 'name')}"/>
    </td>
</tr>

<tr class="prop">
    <td class="name">
        <label for="cnName">中文名称:</label>
    </td>
    <td class="value ${hasErrors(bean: metaDefine, field: 'cnName', 'errors')}">
        <input type="text" maxlength="40" id="cnName" name="cnName" class="form-control " style=" width: 220px"
               value="${fieldValue(bean: metaDefine, field: 'cnName')}"/>
    </td>
</tr>

<tr class="prop">
    <td class="name">
        <label>数据类型:</label>
    </td>
    <td class="value ${hasErrors(bean: metaDefine, field: 'dataType', 'errors')}">
        <SELECT name="dataType" onchange="onChangeData();" class="form-control " style=" width: 220px">
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

<tr id="enumTR" name="enumTR" style="visibility:${metaDefine?.dataType == "enumeration" ? "visibile" : "hidden"};">
    <td></td>
    <td class="name">
        <INPUT TYPE="button" class="btn btn-primary btn-xs" value="添加枚举元素" onclick="javascript:addtr();">
        <INPUT TYPE="button" class="btn btn-primary btn-xs" value="删除枚举元素" onclick="deltr();">
        <table id="enumTab" cellspacing="1" class="table" style="width: 500px"
               style="border-collapse: collapse;border:1px solid #ccc;">
            <tr>
                <th align="center">ID(数字)</th>
                <th align="center">名称</th>
                <th align="center">操作</th>
            </tr>

            <g:each status="i" var="m" in="${metaDefine?.metaEnums ?}">
                <tr>
                    <td><input type=text name="enumId${i + 1}" value="${m?.enumId}"></td>
                    <td><input type=text name="enumName${i + 1}" value="${m?.name}"></td>
                    <td align="center"><a href=# class="btn  btn-warning btn-xs" style="color:#FFF"
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
        <input type="text" id="maxLength" name="maxLength" class="form-control " style=" width: 220px"
               value="${fieldValue(bean: metaDefine, field: 'maxLength')}"/>
    </td>
</tr>

<tr class="prop">
    <td class="name">
        <label for="defaultValue">默认值:</label>
    </td>
    <td class="value ${hasErrors(bean: metaDefine, field: 'defaultValue', 'errors')}">
        <input type="text" maxlength="40" id="defaultValue" name="defaultValue" class="form-control "
               style=" width: 220px"
               value="${fieldValue(bean: metaDefine, field: 'defaultValue')}"/>
    </td>
</tr>



<tr class="prop">
    <td class="name">
        <label for="description">描述:</label>
    </td>
    <td class="value ${hasErrors(bean: metaDefine, field: 'description', 'errors')}">
        <input type="text" maxlength="250" id="description" name="description" class="form-control "
               style=" width: 220px"
               value="${CTools.htmlToBlank(fieldValue(bean: metaDefine, field: 'description'))}"/>
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

<div class="buttons" style="margin-left: 120px">
    <span class="button"><input class="btn btn-primary" type="submit" value="提交"/></span>
    <span class="button"><input class="btn btn-primary" type="button" onclick="history.back();" value="取消"/></span>
</div>
</g:form>
</div>
</body>
</html>
