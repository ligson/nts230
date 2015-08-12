<%@ page import="java.text.SimpleDateFormat; nts.program.domain.Program; nts.utils.CTools" %>
<html>
<head>
    <title>资源排行</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/css', file: 'statisticsResource.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'css', file: 'unknow_style.css')}">
</head>

<body>
<div class="statistics_resource_content">
    <div class="x_daohang"><span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>><a
            href="${createLink(controller: 'appMgr', action: 'statistics')}">信息统计</a>>>排行</div>

    <div class="statistics_resource_list">
        <div class="statistics_resource_nav">
            <p>
                <span class="btn btn-warning" onclick="down_btn()">资源下载排行</span>
                <span class="btn btn-warning" onclick="view_btn()">资源浏览排行</span>
            </p>

            <div class="export_exc">
                <a href="${createLink(action: 'programViewRanking', controller: 'appMgr')}"
                   class="btn btn-success">导出excel</a>
            </div>
        </div>

        <div class="statistics_resource_items">
            <div class="statistics_resource_item" id="resourceView">
                <table class="table table-hover ">
                    <tbody>
                    <tr>
                        <th>资源名称</th>
                        <th width="150">所属类库</th>
                        <th width="120">上传时间</th>
                        <th width="120">浏览次数</th>
                    </tr>
                    <!--------列表--------->
                    <g:each in="${viewProSta}" var="program">
                        <tr>
                            <td>
                                ${CTools.cutString(program?.name, 10)}
                            </td>
                            <td>
                                <p>
                                    <g:if test="${program?.otherOption == Program.ONLY_LESSION_OPTION}">
                                        课程资源
                                    </g:if>
                                    <g:elseif test="${program?.otherOption == Program.ONLY_TXT_OPTION}">
                                        文档资源
                                    </g:elseif>
                                    <g:elseif test="${program?.otherOption == Program.ONLY_TXT_OPTION}">
                                        图片资源
                                    </g:elseif>
                                    <g:else>
                                        视频资源
                                    </g:else>
                                </p>
                            </td>
                            <td>${new SimpleDateFormat('yyyy-MM-dd').format(program?.dateCreated)}</td>
                            <td class="download_numbers">${program?.frequency}次</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>

                <div style="height: 100px">
                    <g:paginate action="statisticsResource" controller="appMgr" total="${viewTotal}"></g:paginate>
                </div>
            </div>

            <div class="statistics_resource_item" style="display: none" id="resourceDown">
                <table class="table table-hover ">
                    <tbody>
                    <tr>
                        <th>资源名称</th>
                        <th width="150">所属类库</th>
                        <th width="120">上传时间</th>
                        <th width="120">下载次数</th>
                    </tr>
                    <!--------列表--------->
                    <g:each in="${downProSta}" var="program">
                        <tr>
                            <td>
                                ${CTools.cutString(program?.name, 10)}
                            </td>
                            <td>
                                <p>
                                    <g:if test="${program?.otherOption == Program.ONLY_LESSION_OPTION}">
                                        课程资源
                                    </g:if>
                                    <g:elseif test="${program?.otherOption == Program.ONLY_TXT_OPTION}">
                                        文档资源
                                    </g:elseif>
                                    <g:elseif test="${program?.otherOption == Program.ONLY_TXT_OPTION}">
                                        图片资源
                                    </g:elseif>
                                    <g:else>
                                        视频资源
                                    </g:else>
                                </p>
                            </td>
                            <td>${new SimpleDateFormat('yyyy-MM-dd').format(program?.dateCreated)}</td>
                            <td class="download_numbers">${program?.downloadNum}次</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
                <g:paginate action="statisticsResource" controller="appMgr" total="${downTotal}"></g:paginate>
            </div>

        </div>
    </div>
</div>
<script type="text/javascript">
    function down_btn() {
        $("#resourceDown").show();
        $("#resourceView").hide();
        $(".statistics_resource_nav p span:eq(0)").removeClass("btn-warning").addClass("btn-default");
        $(".statistics_resource_nav p span:eq(1)").removeClass("btn-default").addClass("btn-warning");
        var appendDiv = "<a href='${createLink(action:"programDownloadRanking",controller:"appMgr")}' class='btn btn-success'>导出excel</a>";
        $(".export_exc").empty().append(appendDiv);
    }
    function view_btn() {
        $("#resourceDown").hide();
        $("#resourceView").show();
        $(".statistics_resource_nav p span:eq(0)").removeClass("btn-default").addClass("btn-warning");
        $(".statistics_resource_nav p span:eq(1)").removeClass("btn-warning").addClass("btn-default");
        var appendDiv = "<a href='${createLink(action:"programViewRanking",controller:"appMgr")}' class='btn btn-success'>导出excel</a>";
        $(".export_exc").empty().append(appendDiv);
    }
</script>
</body>
</html>
