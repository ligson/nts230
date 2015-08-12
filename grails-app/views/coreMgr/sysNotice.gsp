<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-4-1
  Time: 上午11:51
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>系统公告</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'sysNotice.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <script Language="JavaScript" type="text/javascript">
        var localObj = window.location;
        var contextPath = localObj.pathname.split("/")[1];
        var baseUrl = '';
        if('nts' != contextPath) {
            baseUrl = localObj.protocol + "//" + localObj.host + "/";
        } else {
            baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
        }
        function sysNoticeSet() {
            var text=$("#notice").val();
            if(text.length<1){
                myAlert(" 内容为空")
                return;
            }else {
                text = text.replace(/\ +/g,""); // 去掉空格
                text  = text.replace(/[ ]/g,""); // 去掉空格
                text = text.replace(/[\r\n]/g,""); //去掉换行
                if(text.length>66){
                    myAlert("公告内容在66个字以内")
                    return;
                } else {
                    $.post(baseUrl+"coreMgr/sysNoticeSet", {
                        notice: text
                    }, function (data) {
                        if(data.success) {
                            myAlert(data.msg, "提示");
                        } else {
                            myAlert(data.msg);
                        }
                    })
                }
            }
        }
    </script>
</head>

<body>
<g:form name="configForm" action="sysNoticeSet">
    <div id="tblist2">
        <div class="notic_title">
            <h1><span>发布系统公告：</span><span class="warm_in">(注意：公告内容在66字以内;如果页面设置了缓存,则需要过了缓存时间,才能在页面显示.)</span></h1>
        </div>
        <table class="table ">
            <tr>
                <td width="120" align="right">系统公告：</td>
                <td><textarea name="notice" class="form-control" id="notice" size="80" rows="5"
                              style="width: 600px">${sysNotice?.configValue}</textarea></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <input class="admin_default_but_blue" type="button" value="${(sysNotice?.configValue && sysNotice?.configValue != "") ? '重新发布' : '发布'} "
                           onclick="sysNoticeSet()"/>
                </td>
            </tr>
        </table>
    </div>
</g:form>
</body>
</html>