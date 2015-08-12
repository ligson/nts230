<%@ page import="nts.utils.CTools; nts.system.domain.Directory" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>nts.program.domain.Program List</title>
    <link rel="stylesheet" href="${createLinkTo(dir: 'skin/blue/pc/admin/css', file: 'tree.css')}"/>
    <link href="${createLinkTo(dir: 'skin/blue/pc/admin/css', file: 'zhigaiban.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/meta.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/metalist.js')}"></script>
    <SCRIPT LANGUAGE="JavaScript">
        <!--
        var metaList = new Array();//当前类
        var directoryList = new Array();//目录
        var selectedLink = null;//当前选中的树节点
        var simpleSearchMeta = ['title', 'creator'];//简单检索元素名

        //初始化
        window.onload = init;
        function init() {
            //setCurMetaList(0,4,-1);//4分类浏览
            metaList = allMetaList;
            //setSchOptions();
            showTree();
        }

        function showTree() {
            document.getElementById("CategoryTree").innerHTML = treeHtml;//getDirectoryLi()+treeHtml;
            //alert(document.getElementById("CategoryTree").innerHTML);
        }

        //参数：linkObj,category(浏览类别：0库 1元数据),metaId(在库浏览中是directoryId,在元数据是metaId),enumId(元数据枚举值)
        function toViewAction(linkObj, category, metaId, enumId, isAll) {
            if (selectedLink) selectedLink.className = "";
            linkObj.className = "curLink";
            selectedLink = linkObj;
            changeStatus(linkObj);
            parent.rightFrame.location.href = baseUrl + 'program/categoryView?category=' + category + '&metaId=' + metaId + '&enumId=' + enumId + '&isAll=' + isAll + '&canPublic=${CTools.nullToZero(params.canPublic)}';
        }

        function changeStatus(o) {
            if (o.parentNode && (o.parentNode.className == "Opened" || o.parentNode.className == "Closed")) {
                o.parentNode.className = (o.parentNode.className == "Opened") ? "Closed" : "Opened";
            }
        }

        function getDirectoryLi() {
            var libName = '${Directory.cnTableName}';
            var tree = '<ul>';
            tree += '<li class="Closed"><a href="#" onclick="toViewAction(this,0,0,0,1);return false;"><img class="s" src="../images/tree/sp.gif">' + libName + '</a>';
            tree += '<ul>';
            for (var i = 0; i < directoryList.length; i++) {
                tree += '<li class="Child"><img class="s" src="../images/tree/sp.gif"><a href="#" onclick="toViewAction(this,0,' + directoryList[i].id + ',0,0);return false;">' + directoryList[i].name + '</a></li>';
            }
            tree += '</ul>';
            tree += '</li>';
            tree += '</ul>';
            return tree;
        }

        //目录数据
        <g:each in="${directoryList}" status="i" var="directory">
        directoryList[${i}] = new CDirectoryTypeObj(${directory.id}, '${directory.name.encodeAsJavaScript()}');
        </g:each>

        //-->
    </SCRIPT>
</head>

<body topmargin="5" leftmargin="0" style="background: #f0f0f0;">
<div class="TreeHead"><span style="vertical-align:middle;"><img src="../images/tree/base.gif"></span>多媒体资源库浏览</div>

<div class="TreeMenu" id="CategoryTree"></div>
</body>
</html>
