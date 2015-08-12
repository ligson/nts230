<%@ page import="nts.system.domain.Directory" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>添加元数据</title>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/isNum2.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/metaedit.js')}"></script>
    <SCRIPT LANGUAGE="JavaScript">
        <!--
        //全局变量
        global = new globalVars();
        function globalVars() {
            this.metaDefineId = 0;
            this.maxEnumId = 1;//初始值不要改动，添加时用1作默认值。
            this.nameExist = false;
            this.nameAction = "${createLink(action:'checkMetaNameExist')}";
        }
        $(function(){
            onIsDeco();
        });
        //-->
    </SCRIPT>
</head>

<body>

    <br>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${metaDefine}">
        <div class="errors">
            <g:renderErrors bean="${metaDefine}" as="list"/>
        </div>
    </g:hasErrors>
    <g:form id="form1" name="form1" action="metaDefineSave" method="post" onsubmit="return check();">
        <input type="hidden" name="maxEnumId" value="1">
        <input type="hidden" name="directoryId" value="${directoryId}"/>

        <div class="dialog">
            <table>
                <tbody>
                <tr class="prop">
                    <td valign="top" class="directory" style="padding-top:6px;">
                        <label>所属类库:</label>
                    </td>
                    <td class="value ">

                        <input type="radio" style="border:0;" name="allClass" value="1" checked
                               onclick="onAllClass(this.form);">所有库(包括现有库和以后添加的库)<br>
                        <input type="radio" name="allClass" value="0" style="border:0;"
                               onclick="onAllClass(this.form);">部分库(从下面列表中选择)<br>&nbsp;&nbsp;
                        <g:each var="s" status="i" in="${Directory.list()}">
                            <label class="checkbox-inline">
                                <input type="checkbox" disabled name="selDirectory"
                                       value="${s.id}" onclick="onIsDeco()">${s.name}</label>
                        </g:each>
                    </td>
                </tr>

                <tr class="prop">
                    <td class="name">
                        <label>类型:</label>
                    </td>
                    <td class="value ">
                        <select name="elementType" onchange="onIsDeco();">
                            <option value="0" selected>简单元素(不包含修饰词)</option>
                            <option value="1">复合元素(包含修饰词)</option>
                            <option value="2">修饰词</option>
                            %{--<option value="3" >复合修饰词(包含修饰词)</option>--}%
                        </select>
                    </td>
                </tr>

                <tr class="prop" id="decoTR" style="display:none">
                    <td class="name">
                        <label>选择元素:</label>
                    </td>
                    <td class="value ">
                        <select id="parentId" name="parentId"></select>
                    </td>
                </tr>

                <tr class="prop">
                    <td class="name">
                        <label>名称:</label>
                    </td>
                    <td class="value ">
                        <input type="text" maxlength="100" onchange="checkNameExist(this)" name="name" value="" onblur="checkNameExist(this)"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td class="name">
                        <label for="cnName">中文名称:</label>
                    </td>
                    <td class="value ">
                        <input type="text" maxlength="40" id="cnName" name="cnName" value=""/>
                    </td>
                </tr>

                <tr class="prop">
                    <td class="name">
                        <label for="dataType">数据类型:</label>
                    </td>
                    <td class="value ">
                        <SELECT name="dataType" onchange="onChangeData();" id="dataType">
                            <OPTION value="string">字符串</OPTION>
                            <OPTION value="textarea">长字符串</OPTION>
                            <OPTION value="number">数字</OPTION>
                            <OPTION value="date">日期</OPTION>
                            <OPTION value="time">时间</OPTION>
                            <OPTION value="datetime">日期时间</OPTION>
                            <OPTION value="enumeration">枚举</OPTION>
                            <OPTION value="link">链接</OPTION>
                            <OPTION value="img">图片</OPTION>
                        </SELECT>
                    </td>
                </tr>

                <tr class="prop" id="enumTR" name="enumTR" style="display:none;">
                    <td></td>
                    <td class="name">
                        <INPUT TYPE="button" value="添加枚举元素" onclick="javascript:addtr();">
                        <INPUT TYPE="button" value="删除枚举元素" onclick="deltr(null);">
                        <table id="enumTab" cellspacing="1" width="100%"
                               style="border-collapse: collapse;border:1px solid #fff;">
                            <tr>
                                <th align="center">ID(数字)</th>
                                <th align="center">名称</th>
                                <th align="center">操作</th>
                            </tr>
                            <tr>
                                <td width="40%"><input type="text" name="enumId1"></td>
                                <td width="40%"><input type="text" name="enumName1"></td>
                                <td align="center" width="20%"><a href="#" onclick='javascript:deltr(this);
                                return false;'>删除</a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <tr class="prop">
                    <td class="name">
                        <label for="maxLength">最大长度:</label>
                    </td>
                    <td class="value ">
                        <input type="text" id="maxLength" name="maxLength" value="0"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td class="name">
                        <label for="defaultValue">默认值:</label>
                    </td>
                    <td class="value ">
                        <input type="text" maxlength="40" id="defaultValue" name="defaultValue" value=""/>
                    </td>
                </tr>

                <tr class="prop">
                    <td class="name">
                        <label for="description">描述:</label>
                    </td>
                    <td class="value ">
                        <input type="text" maxlength="250" id="description" name="description" value=""/>
                    </td>
                </tr>


                <tr class="prop">
                    <td class="name">
                        <label>显示:</label>
                    </td>
                    <td class="value ">
                        <INPUT type="checkbox" checked value="1" name="showTypeList">详细页面显示
                        <INPUT type="checkbox" value="2" name="showTypeList">摘要页面显示
                        <INPUT type="checkbox" value="4" name="showTypeList">设为浏览类别
                    </td>
                </tr>

                <tr class="prop">
                    <td class="name">
                        <label>检索点:</label>
                    </td>
                    <td class="value ">
                        <INPUT type="checkbox" value="1" name="searchTypeList"> 客户端检索点
                    <!-- <INPUT  type="checkbox"  value= "2" name="searchTypeList"> 管理端检索点 -->
                    </td>
                </tr>

                <tr class="prop">
                    <td class="name">
                        <label>其它属性:</label>
                    </td>
                    <td class="value ">
                        <input type="checkbox" name="isNecessary" value="1">必备
                        <input type="checkbox" name="showTypeList" value="8">编目缺省显示
                        <input type="checkbox" name="showTypeList" value="16">导出
                        <input type="checkbox" name="showTypeList" value="32">唯一
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
</body>
</html>
