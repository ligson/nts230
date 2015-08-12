<!DOCTYPE html>
<%@ page import="nts.utils.CTools" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>${message(code: 'my.activities.name')}${message(code: 'my.list.name')}</title>
    <meta name="layout" content="communityMgr">
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'activityCreate.css')}">
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'fromBordCreate.css')}">
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'activityList.css')}">

    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>

</head>

<body>
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.activities.name')}${message(code: 'my.list.name')}</a>
</div>

<div class="activityList_content">
    <g:if test="${activityList && activityList.size() > 0}">
        <div>
            <table class="table table-hover">
                <tbody>
                <tr>
                    <th align="center" width="45">${message(code: 'my.chose.name')}</th>
                    <th>${message(code: 'my.activities.name')}${message(code: 'my.title.name')}</th>
                    <th width="50">${message(code: 'my.state.name')}</th>
                    <th width="20" align="center">${message(code: 'my.edit.name')}</th>
                    <th width="120">${message(code: 'my.start.name')}${message(code: 'my.time.name')}</th>
                    <th width="120">${message(code: 'my.end.name')}${message(code: 'my.time.name')}</th>
                    <th width="80">${message(code: 'my.delete.name')}</th>
                </tr>
                <g:each in="${activityList}" var="activity">
                    <tr id="tr${activity?.id}">
                        <td>
                            <g:checkBox name="activityId" value="${activity?.id}" checked="false"></g:checkBox>
                        </td>
                        <td
                                title="${activity.name}">${CTools.cutString(fieldValue(bean: activity, field: 'name'), 20)}</td>
                        <td>${activity.isOpen ? "开启" : "关闭"}</td>
                        <td><a class="con_mode content_icon"
                               href="${createLink(controller: 'communityMgr', action: "activityEdit", params: [studyCommunityId: studyCommunity?.id, activityId: activity.id])}">
                        </a>
                        </td>
                        <td>${activity.startTime}</td>
                        <td>${activity.endTime}</td>
                        <td><a onclick="deleteActivity(${studyCommunity?.id}, ${activity?.id})"
                               class="btn  btn-warning btn-xs">${message(code: 'my.delete.name')}</a>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>

    %{--   <div class="activityList_content_title_list">
           <g:each in="${activityList}" var="activity">
             --}%%{--  <table class="table table-striped">
                   <tbody>
                   <tr>
                       <td class="con_titles"
                           title="${activity.name}">${CTools.cutString(fieldValue(bean: activity, field: 'name'), 20)}</td>
                       <td class="con_mode con_bor">${activity.isOpen == 0 ? "关闭" : "开启"}</td>
                       <td><a class="con_mode content_icon"
                              href="${createLink(controller: 'communityMgr', action: "activityEdit", params: [studyCommunityId: studyCommunity?.id, activityId: activity.id])}">修改</a>
                       </td>
                       <td class="con_starttime ">${activity.startTime}</td>
                       <td class="con_starttime">${activity.endTime}</td>
                   </tr>
                   </tbody>
               </table>--}%%{--
           </g:each>
       </div>--}%
    </g:if>
    <g:else>

        <span style="margin-top: 25%;margin-left: 45%; font-size: 18px; color:#22272e; font-family: 微软雅黑; font-weight: bold; display: block">目前没有活动</span>
    </g:else>
<!---------分页----------->

</div>
<g:if test="${activityList && activityList.size() > 0}">
    <input type="button" class="btn btn-default" onclick="deleteActivityList(${studyCommunity?.id})" value="批量删除">
</g:if>
<div class="page">
    <g:guiPaginate controller="communityMgr" action="activityList" total="${total}"
                   params="${[studyCommunityId: studyCommunity?.id]}"/>
</div>
<script type="text/javascript" language="JavaScript">
    //批量删除
    function deleteActivityList(studyCommunityId) {
        var checkboxList = $(".activityList_content").find("input:checked");
        if (checkboxList.size() == 0) {
            alert("请选择需要删除的活动！");
        } else if (confirm("您确定要都删除吗?")) {
            var activityIds = "";
            for (var i = 0; i < checkboxList.size(); i++) {
                activityIds += checkboxList[i].value;
                if (i != checkboxList.size() - 1) {
                    activityIds += ",";
                }
            }
            $.post(baseUrl + "communityMgr/activityDelete", {
                idList: activityIds,
                studyCommunityId: studyCommunityId
            }, function (data) {
                if (data.success) {
                    var ids = activityIds.split(",");
                    for (var i = 0; i < ids.length; i++) {
                        $("#tr" + ids[i]).remove();
                    }
                    alert("删除成功。");
                } else {
                    alert("删除失败。");
                }
            })
        }
    }
    //删除
    function deleteActivity(studyCommunityId, activityId) {
        if (confirm("您确定要删除？")) {
            $.post(baseUrl + "communityMgr/activityDelete", {
                studyCommunityId: studyCommunityId,
                idList: activityId
            }, function (data) {
                if (data.success) {
                    $("#tr" + activityId).remove();
                    alert(data.msg);
                } else {
                    alert(data.msg);
                }
            })
        }
    }
</script>
</body>
</html>