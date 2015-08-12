<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>搜索学习圈、学习社区类别列表</title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" type=text/css
          rel=stylesheet>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'main.css')}" type=text/css
          rel=stylesheet>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}" rel="stylesheet" type="text/css">
    <style>
    table {
        border: 0px solid #ccc;
        margin-left: 20px;
        margin-right: 20px;
    }

    a:link, a:visited {
        font-weight: normal;
    }

    a:hover {
        color: #FF6600;
        font-weight: normal;
    }

    #catetab .curLink {
        color: #f60;
    }

    #progListTab td {
        line-height: 18px;
        padding-left: 2px;
    }

    </style>

    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript">
        function submitSch() {
            if (!widthCheck($('#schName').val().trim(), 100)) {
                alert('搜索名称不能大于100个字符');
                $('#schName').val().select();
                return;
            }

            document.form1.submit();
        }

        function onPageNumPer(max) {
            document.form1.max.value = max;
            submitSch();
        }

        function operate(controller, action, operation) {
            if (action == "toRecycler") {
                if (hasChecked("idList") == false) {
                    alert("请至少选择一条记录！");
                    return false;
                }
                if (confirm("确实要删除该类别吗？") == false) return;
            }

            if (operation != null) document.form1.operation.value = operation;
            //if(operation != "public" && operation != "close") document.form1.offset.value = 0;

            document.form1.action = baseUrl + controller + "/" + action;
            document.form1.submit();
        }

        function maxShow(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;
            document.form1.action = baseUrl + "appMgr/searchRMSCategory";
            document.form1.submit();
        }
    </script>
</head>

<body>
<form name="form1" method="post" action="/appMgr/searchRMSCategory">
    <input type="hidden" name="max" value="${params.max}">
    <input type="hidden" name="offset" value="${params.offset}">
    <input type="hidden" name="operation">

    <div class="x_daohang">
        <p>当前位置：<a href="${createLink(controller: 'appMgr', action: 'RMSCategoryList')}">学习圈(学习社区)类别管理</a>>> 类别列表</p>
    </div>
    <table width="96%" border="0" cellspacing="0" cellpadding="0" class="biaoge-hui"
           style="margin-top:10px;margin-bottom:10px;">
        <tr>
            <td align="center" style="display:none;">类型:</td>
            <td style="display:none;">
                <select name="type">
                    <option value="0" <g:if test="${params?.type == '0'}">selected</g:if>>公共</option>
                    <option value="1" <g:if test="${params?.type == '1'}">selected</g:if>>学习圈</option>
                    <option value="2" <g:if test="${params?.type == '2'}">selected</g:if>>学习社区</option>
                </select>
            </td>
            <td align="center">分类级别</td>
            <td>
                <select name="level">
                    <option value="1" <g:if test="${params?.level == '1'}">selected</g:if>>一级分类</option>
                    <option value="2" <g:if test="${params?.level == '2'}">selected</g:if>>二级分类</option>
                </select>
            </td>
            <td align="center">检索名称:</td>
            <td>
                <input name="schName" id="schName" value="${params?.schName}" style="width:200px;">
            </td>

            <td width="10%"><img src="${resource(dir: 'images/skin', file: 'search.gif')}" style="cursor:pointer;" onclick="submitSch();"
                                 border="0"></td>
        </tr>
    </table>

    <table width="96%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF" id="progListTab">
        <tr>
            <td width="4%" align="left" bgcolor="#BDEDFB" class="STYLE5">选择</td>
            <td width="6%" align="left" bgcolor="#BDEDFB" class="STYLE5">类别名称</td>
            <td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5">创建时间</td>
            <td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5">上级类别</td>
            <td width="4%" align="center" bgcolor="#BDEDFB" class="STYLE5">修改</td>
            <td width="4%" align="center" bgcolor="#BDEDFB" class="STYLE5">删除</td>
            <g:if test="${params?.level == '1'}">
                <td width="4%" align="center" bgcolor="#BDEDFB" class="STYLE5">下级类别</td>
            </g:if>
        </tr>
        <g:each in="${categoryList ?}" status="i" var="category">
            <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                <td align="left"><input type="checkbox" name="idList" value="${category.id}"
                                        onclick="unCheckAll('selall');" id="idList"/></td>
                <td align="left">${category?.name.encodeAsHTML()}</td>
                <td align="center" class="STYLE5"><g:formatDate format="yyyy-MM-dd HH:mm:ss"
                                                                date="${category?.dateCreated}"/></td>
                <td align="center">${category?.parentName.encodeAsHTML()}</td>
                <td align="center"><a
                        href="${createLink(controller: 'appMgr', action: 'editRMSCategory', id: category?.id, params: [type: category?.type])}"><img
                            src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="修改" border="0"></a></td>
                <td align="center"><a
                        href="${createLink(controller: 'appMgr', action: 'toRecycler', params: [idList: category?.id, operation: params?.level, type: params?.type])}"
                        onclick="return confirm('确实要删除该类别吗？');"><img src="${resource(dir: 'images/skin', file: 'delete.gif')}" alt="删除"
                                                                     border="0"></a></td>
                <g:if test="${params?.level == '1'}">
                    <td align="center"><a
                            href="${createLink(controller: 'appMgr', action: 'lowerList', params: [parentid: category?.id, type: category?.type])}"><img
                                src="${resource(dir: 'images/skin', file: 'page_copy.gif')}" alt="查看下级类别" border="0"></a></td>
                </g:if>
            </tr>
        </g:each>
    </table>

    <div id="progDeal">
        <input id="selall" name="selall" onclick="checkAll(this, 'idList')" type="checkbox">全选
        <input class="button" type="button" value="删除" onClick="operate('appMgr', 'toRecycler', '${params?.level}');"/>
        <input class="button" type="button" value="添加类别" onClick="operate('appMgr', 'toAdd', '0');"/>
        <input class="button" style="display:none;" type="button" value="添加学习圈类别"
               onClick="operate('appMgr', 'toAdd', '1');"/>
        <input class="button" style="display:none;" type="button" value="添加学习社区类别"
               onClick="operate('appMgr', 'toAdd', '2');"/>
        <g:if test="${params?.level == '2'}">
            <input class="button" type="button" value="返回" onClick="operate('appMgr', 'RMSCategoryList', '');"/>
        </g:if>
    </div>

    <table width="96%" style="border: 0px;" height="16" border="0" cellpadding="1" cellspacing="1" bgcolor="#E9E8E7">
        <tr>
            <td width="300" height="16" align="center">
                类别数：${total}&nbsp; 每页显示:
                <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0"
                     onclick="maxShow(10)">&nbsp;
                <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0"
                     onclick="maxShow(50)">&nbsp;
                <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0"
                     onclick="maxShow(100)">&nbsp;
                <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0"
                     onclick="maxShow(200)">
            </td>
            <td align="right"><div class="paginateButtons"><g:paginate controller="appMgr" action="searchRMSCategory"
                                                                       total="${total}" params="${params}"/></div></td>
        </tr>
    </table>
</form>
</body>
</html>
