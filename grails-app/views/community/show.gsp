<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="communityMain"/>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'xindex.css')}"
          media="all">
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'css', file: 'table.css')}" media="all">
    <title>讨论区块状视图列表</title>

    <script type="text/javascript">
        function editCommunity() {
            location.href = baseUrl + "community/edit?id=${communityInstance.id}&editType=editCommunity";
        }
    </script>

</head>

<body style="background:none;">
<div class="l w785">
    <div class="commend mt1">
        <DIV id=con>
            <dl class="tbox light2">
                <dt class="light"><strong class="icos3">基本信息</strong></dt>
            </dl>

            <DIV id=tagContent>
                <DIV class="tagContent selectTag" id=tagContent0>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="35%" align="right">社区名称：</td>
                            <td width="65%"><label for="textfield"></label>${communityInstance.name}</td>
                        </tr>
                        <tr>
                            <td align="right">社区类别：</td>
                            <td><label for="select"></label>${communityInstance.communityCategory.name}</td>
                        </tr>
                        <tr>
                            <td align="right">创建时间：</td>
                            <td><g:formatDate format="yyyy-MM-dd" date="${communityInstance.dateCreated}"/></td>
                        </tr>
                        <tr>
                            <td align="right">总&nbsp;&nbsp;人&nbsp;&nbsp;数：</td>
                            <td>${communityInstance.members.size() + 1}</td>
                        </tr>
                        <tr>
                            <td align="right">描&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;述：</td>
                            <td><label for="textarea"></label>${CTools.htmlToBlank(communityInstance.description)}</td>
                        </tr>
                        <tr>
                            <td align="right"></td>
                            <td>
                                <g:if test="${session.consumer?.id == communityInstance?.create_comsumer_id}">
                                    <input type="button" onclick="editCommunity()" class="but" id="button2"
                                           value="修 改"/>
                                </g:if>
                            </td>
                        </tr>
                    </table>
                </DIV>
            </DIV>
        </DIV>
    </div>
</div>

</body>
</html>
