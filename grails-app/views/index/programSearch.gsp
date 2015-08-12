<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 13-4-16
  Time: 上午9:46
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>搜索结果</title>
    %{--<link href="${resource(dir: 'skin/default/pc/css', file: 'uniform.default.css')}" rel="stylesheet"/>--}%
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'list_style.css')}"/>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'list_search.css')}"/>
</head>

<body>
<div id="contentA" class="area areabg1">
    <div class="program_list">
        <g:each in="${searchList}" var="program">
            <div class="list_content">
                <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"><img
                        src="${posterLinkNew(program: program, size: '90x90')}" title="${program.name}"
                        onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                </a>

                <div class="list_desc">
                    <span style="font-weight:bold;"><a
                            href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}">${CTools.cutString(program.name, 10)}</a>
                    </span>
                    <span>创建时间：${program.dateCreated.format("yyyy-MM-dd")}</span>
                    <span>播放次数:${program.frequency}
                    </span>
                    <span style="overflow:hidden;">
                        下载次数:${program.downloadNum}
                    </span>
                </div>
            </div>
        </g:each>

    </div>

    <div class="page">
        <g:paginate controller="index" action="programSearch" total="${total}"
                    params="${[key: key, condition: condition]}"/>
    </div>
</div>
</body>
</html>