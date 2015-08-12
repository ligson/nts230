<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 14-3-25
  Time: 下午2:28
--%>

<%@ page import="java.text.SimpleDateFormat" contentType="text/html;charset=UTF-8" %>
<html xmlns="http://www.w3.org/1999/html" xmlns="http://www.w3.org/1999/html" xmlns="http://www.w3.org/1999/html">
<head>
    <title>用户访问排行</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/css', file: 'statisticsResource.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
</head>

<body>
<div class="statistics_resource_content">
    <div class="x_daohang"><span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>><a
            href="${createLink(controller: 'appMgr', action: 'statistics')}">信息统计</a>>>排行</div>

    <div class="statistics_resource_list">
        <div class="statistics_resource_nav">
            <p>
                <span class="btn btn-warning" onclick="last_btn()">最后访问记录</span>
                <span class="btn btn-warning" onclick="view_btn()">人员访问排行</span>
            </p>

            <div class="export_exc">
                <a href="${createLink(controller: 'appMgr', action: 'userVisitRanking')}"
                   class="btn btn-success">导出excel</a>
            </div>

        </div>

        <div class="statistics_resource_items">
            <div class="statistics_resource_item s_rank" id="resourceView">
                <!-------用户排行-------->
                <table class="table table-hover ">
                    <tbody>
                    <tr>
                        <th width="200">用户帐号</th>
                        <th>用户姓名</th>
                        <th width="110"><span>访问次数</span></th>
                        <th width="110"><span>浏览次数</span></th>
                        <th width="110"><span>上传数量</span></th>
                        <th width="110"><span>下载数量</span></th>
                        <th width="110"><span>收藏次数</span></th>
                    </tr>
                    <!--------列表--------->
                    <g:each in="${viewCmrSta}" var="consumer">
                        <tr>
                            <td>${consumer?.name}</td>
                            <td>${consumer?.nickname}</td>
                            <td class="download_numbers">${consumer?.loginNum}次</td>
                            <td class="download_numbers">${consumer?.viewNum}次</td>
                            <td class="download_numbers">${consumer?.uploadNum}次</td>
                            <td class="download_numbers">${consumer?.downloadNum}次</td>
                            <td class="download_numbers">${consumer?.collectNum}次</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>

                <div>
                    <g:paginate total="${total}" action="statisticsUserVisit" controller="appMgr"></g:paginate>
                </div>
            </div>


            <div class="statistics_resource_item s_rank" id="resourceLastView" style="display: none">
                <!-------最后登录记录-------->
                <table class="table table-hover">
                    <tbody>
                    <tr>
                        <th width="200">用户帐号</th>
                        <th>用户姓名</th>
                        <th width="300">登陆时间</th>
                    </tr>
                    <g:each in="${lastLoginCmrSta}" var="consumer">
                        <tr>
                            <td>${consumer?.name}</td>
                            <td>${consumer?.nickname}</td>
                            <td>${new SimpleDateFormat('yyyy-MM-dd').format(consumer?.dateLastLogin)}</td>
                        </tr>
                    </g:each>

                    </tbody>
                </table>

                <div>
                    <g:paginate total="${total}" action="statisticsUserVisit" controller="appMgr"></g:paginate>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    function last_btn() {
        $("#resourceView").hide();
        $("#resourceLastView").show();
        $(".statistics_resource_nav p span:eq(0)").removeClass("btn-warning").addClass("btn-default");
        $(".statistics_resource_nav p span:eq(1)").removeClass("btn-default").addClass("btn-warning");
        var appendDiv = "<a href='${createLink(controller:'appMgr',action:'userLastloginRanking')}' class='btn btn-success'>导出excel</a>";
        $(".export_exc").empty().append(appendDiv);
    }
    function view_btn() {
        $("#resourceView").show();
        $("#resourceLastView").hide();
        $(".statistics_resource_nav p span:eq(0)").removeClass("btn-default").addClass("btn-warning");
        $(".statistics_resource_nav p span:eq(1)").removeClass("btn-warning").addClass("btn-default");
        var appendDiv = "<a href='${createLink(controller:'appMgr',action:'userVisitRanking')}' class='btn btn-success'>导出excel</a>";
        $(".export_exc").empty().append(appendDiv);
    }
</script>
</body>
</html>