<%@ page import="nts.utils.CTools; nts.program.domain.Program" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>无标题文档</title>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'index.css')}"/>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'right.css.css')}"/>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/prototype.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/truevod.js')}"></script>

    <SCRIPT LANGUAGE="JavaScript">
        <!--

        function submitSch() {
            document.form1.offset.value = 0;
            document.form1.submit();
        }

        function onPageNumPer(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;
            submitSch();
        }

        //如果右边页面用类库(目录) 则metaId2是目录ID，enumId2为0 名称后缀2表示是右边的类别,如此设计是为了用户如果...
        function categorySch(metaId2, enumId2) {
            document.form1.metaId2.value = metaId2;
            document.form1.keyword.value = "";//点击时不使用搜索条件
            submitSch();
        }

        function init() {
            document.form1.type.value = "${CTools.nullToOne(params.type)}";
            changePageImg(${CTools.nullToOne(params.max)});
        }

        //-->
    </SCRIPT>
</head>

<body style="background: #fff;">
<form name="form1" method="POST" action="categoryView">
    <input type="hidden" name="max" value="${params.max}">
    <input type="hidden" name="offset" value="${params.offset}">

    <input type="hidden" name="category" value="${params.category}">
    <input type="hidden" name="metaId" value="${params.metaId}">
    <input type="hidden" name="enumId" value="${params.enumId}">
    <input type="hidden" name="isAll" value="${params.isAll}">

    <input type="hidden" name="metaId2" value="${params.metaId2}">
    <input type="hidden" name="enumId2" value="${params.enumId2}">

    <input type="hidden" name="canPublic" value="${params.canPublic}">

    <div class="x_caseDiv">
        <div class="x_daohang">
            <p>当前位置：<a href="${createLink(controller: 'program', action: 'categoryView')}">资源浏览</a>>>资源列表</p>
        </div>
        <!--搜索S-->
        <div class="x_search">
            <span>搜索:</span>
            <span>
                <select name="type">
                    <option value="1">${Program.cnField.name}</option>
                    <option value="2">${Program.cnField.actor}</option>
                    <option value="4">${Program.cnField.programTags}</option>
                    <option value="5">${Program.cnField.description}</option>
                </select>
            </span>
            <span><input name="keyword" type="text" class="ac_input" size="50" value="${params.keyword}"></span>
            <span><button class="x_searchB" onclick="submitSch();"></button></span>
        </div>
        <!--搜索E-->
        <!--类库排序S-->
        <div class="x_nkpx">

            <div style="padding-bottom:10px;"><b>类库：</b><a href="#"
                                                           class="${CTools.nullToZero(params.metaId2) == 0 ? 'curLink' : ''}"
                                                           onclick="categorySch(0, 0);
                                                           return false;">全部</a>
                <g:each in="${directoryList}" status="i" var="directory">
                    <a href="#" class="${directory.id == CTools.strToInt(params.metaId2) ? 'curLink' : ''}"
                       onclick="categorySch(${directory.id});
                       return false;">${directory.name}</a>
                </g:each></div>
            <b>排序：</b><IMG src="${resource(dir: 'images/skin', file: 'list_6.gif')}"/> <g:sortableHref property="id"
                                                                               title="${Program.cnField.dateCreated}"
                                                                               params="${params}"/> <IMG
                src="${resource(dir: 'images/skin', file: 'list_6.gif')}"/> <g:sortableHref property="name" title="${Program.cnField.name}"
                                                                    params="${params}"/>

        </div>
    <!--类库排序E-->

    <!--oneS-->
        <g:each in="${programList ?}" status="i" var="program">
            <div class="x_firstLeft">
                <div class="x_firstImg2"><A title="${fieldValue(bean: program, field: 'name')}"
                                            href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}" target="_blank"><IMG
                            style="width: 90px; height: 85px;" border="0"
                            src="${posterLink(serials: program?.serials, isAbbrImg: true)}"/></A></div>

                <div class="x_firstFont2">
                    <strong><A title="${fieldValue(bean: program, field: 'name')}"
                               href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                               target="_blank">${CTools.cutString(fieldValue(bean: program, field: 'name'), 14)}</A>
                    </strong><br/>
                    ${Program.cnField.actor}：${CTools.cutString(fieldValue(bean: program, field: 'actor'), 10)}<BR>
                    ${Program.cnField.dateCreated}：<g:formatDate format="yyyy-MM-dd"
                                                                 date="${program?.dateCreated}"/><BR>
                    ${Program.cnField.frequency}：${fieldValue(bean: program, field: 'frequency')}
                </div>
            </div>
        </g:each>
    <!--oneE-->

    <!--翻页S-->
        <div class="x_pages">
            <div class="paginateButtons">资源个数：${total}&nbsp;&nbsp;<g:paginate total="${total}" maxsteps="8"
                                                                              params="${params}"/></div>
        </div>
        <!--翻页E-->
        <!--use time:${(System.currentTimeMillis() - t1)} ms-->
    </div>
</form>
</body>
</html>
