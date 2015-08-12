<%@ page import="nts.program.domain.Program" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <meta name="layout" content="index"/>
    <!-- saved from url=(0048)http://www.supermap.com.cn/gb/solutions/emap.htm -->
    <title>订阅列表</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'reset.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'style_my.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'invalid.css')}" type="text/css"/>

    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script language="javascript">
        function myTagAdd() {
            document.myTagForm.action = "subScriptionTag";
            document.myTagForm.submit();

        }
        function addHotTag(id) {
            document.myTagForm.action = "addHotTag?id=" + id;
            document.myTagForm.submit();
        }
        function deleteTag() {
            if (!confirm('确定删除标签?')) {
                return false;
            }
            if (hasChecked("idList") == false) {
                alert("请至少选择一个标签！");
                return false;
            }

            document.myTagForm.action = "deleteTagList";
            document.myTagForm.submit();
        }
    </script>
</head>

<body>
<div style="margin-top:5px"></div>

<div id="body-wrapper">
    <g:render template="myLeft"/>
    <div id="main-content">
        <div class="content-box">
            <div class="content-box-header">
                <ul class="content-box-tabs">
                    <li><a href="${createLink(controller: 'my', action: 'myManageProgram')}">我的资源</a></li>
                    <li><a href="${createLink(controller: 'my', action: 'myRecommendProgramList')}">我的推荐</a></li>
                    <li><a href="${createLink(controller: 'my', action: 'myProgramList')}" class="default-tab current">我的订阅</a></li>
                    <li><a href="${createLink(controller: 'my', action: 'myCollectProgramList')}">我的收藏</a></li>
                    <li><a href="${createLink(controller: 'my', action: 'myManageProgram', params: [fromModel: 'myRecycler'])}"
                           <g:if test="${isFromRecycler}">class="default-tab current"</g:if>>回收站</a></li>
                </ul>

                <div class="clear"></div>
            </div>

            <div class="content-box-content">
                <div class="tab-content default-tab">
                    <form method="post" name="myTagForm" id="myGroupForm">
                        <input type="hidden" name="offset" value="${params.offset}"/>
                        <input type="hidden" name="sort" value="${params.sort}"/>
                        <input type="hidden" name="order" value="${params.order}"/>
                        <input type="hidden" name="max" value="${params.max}"/>

                        <g:if test="${flash.message}">
                            <!--<div class="message">${flash.message}</div>-->
                        </g:if>
                        <g:hasErrors bean="${programTag}">
                            <div class="errors">
                                <g:renderErrors bean="${programTag}" as="list"/>
                            </div>
                        </g:hasErrors>
                        <b class="pb10">订阅${Program.cnField['programTags']}</b>
                        <table style="border:none">
                            <tfoot>
                            <tr>
                                <td style="border:none; padding:0">
                                    <div class="align-left pb10">
                                        <fieldset style="width:827px">关键词/标签名称：
                                            <input class="text-input clear mr5" type="text" id="name" name="nameList"/>
                                            <input class="text-input clear mr5" type="text" id="name" name="nameList"/>
                                            <input class="text-input clear mr5" type="text" id="name" name="nameList"/>
                                            <input class="text-input clear mr5" type="text" id="name" name="nameList"
                                                   style="width:100px"/>
                                            <a class="button" href="javascript:void(0);" onClick="javascript:myTagAdd();
                                            return false;">订阅</a>
                                        </fieldset>
                                    </div>
                                </td>
                            </tr>
                            </tfoot>
                        </table>

                        <p>
                            <b>热门${Program.cnField['programTags']}：</b>
                            <g:each in="${hotTagList}" var="tagList">
                                <a href="javascript:void(0);" class="pr15" title="点击可订阅"
                                   onClick="javascript:addHotTag(${fieldValue(bean:tagList, field:'id')});
                                   return false;">${fieldValue(bean: tagList, field: 'name')}</a>
                            </g:each>
                        </p>

                        <b>我订阅的${Program.cnField['programTags']}</b>
                        <table cellpadding="0" cellspacing="0" width="782">
                            <thead>
                            <tr>
                                <th width="20" align="center"><input type="checkbox" id="selall" name="selall"
                                                                     onclick="checkAll(this, 'idList')"/></th>
                                <th width="180">标签名称</th>
                                <th width="82">订阅次数</th>
                                <th width="144">删除订阅</th>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${myTagList}" status="i" var="tag">
                                <tr class="${(i % 2) == 0 ? 'alt-row' : ''}">
                                    <td align="center"><g:checkBox name="idList" value="${tag.id}" checked=""
                                                                   onclick="unCheckAll('selall');"/></td>
                                    <td>${fieldValue(bean: tag, field: 'name')}</td>
                                    <td>${fieldValue(bean: tag, field: 'frequency')}</td>
                                    <td><g:link action="deleteTag" id="${tag.id}"
                                                onclick="return confirm('确定删除${Program.cnField['programTags']}?');"><img
                                                src="${resource(dir: 'images/skin', file: 'delete.gif')}" border="0" width="11"
                                                height="13"/></g:link></td>
                                </tr>
                            </g:each>
                            </tbody>
                        </table>

                        <div class="l pt10 pb10">
                            <input class="qqbut2" type="button" value="删除所选${Program.cnField['programTags']}"
                                   onClick="deleteTag()"/>
                            <input class="qqbut2" type="button" value="返回我的订阅"
                                   onClick="location.href = baseUrl + 'my/myProgramList';"/>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>

