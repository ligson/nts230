<%@ page import="nts.utils.CTools; nts.program.domain.Program" %>
<html xmlns="http://www.w3.org/1999/html">
<head>
    %{--<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>--}%
    <title>${message(code: 'my.mined.name')}${message(code: 'my.recommend.name')}/${message(code: 'my.mined.name')}${message(code: 'my.collect.name')}</title>

    %{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'myManagerProgram.css')}">--}%
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'truevod.js')}"></script>--}%
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/truevod.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <SCRIPT LANGUAGE="JavaScript" type="text/javascript">

        var localObj = window.location;
        var contextPath = localObj.pathname.split("/")[1];
        var baseUrl = '';
        if('nts' != contextPath) {
            baseUrl = localObj.protocol + "//" + localObj.host + "/";
        } else {
            baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
        }
        function submitSch() {
            document.form1.action = "myRecommendProgramList";
            document.form1.submit();
        }

        function onPageNumPer(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;
            document.form1.searchDate.value = ${params.searchDate}
                    submitSch();
        }

        //如果右边页面用类库(目录) 则metaId2是目录ID，enumId2为0 名称后缀2表示是右边的类别,如此设计是为了用户如果...
        function categorySch(metaId2, enumId2) {
            document.form1.metaId2.value = metaId2;
            document.form1.keyword.value = "";//点击时不使用搜索条件
            submitSch();
        }

        function init() {
            changePageImg(${CTools.nullToOne(params.max)});
        }

        function programSearch() {
            document.form1.action = "myRecommendProgramList";
            document.form1.submit();
        }

        function delRecommend(deleteId) {
            if (confirm("确定取消推荐吗？")) {
                /*$.post("delRecommend", {deleteId : deleteId}, function(data){
                 alert(data.message);
                 if(data.success){
                 $("#recommendProgramId"+deleteId).remove();
                 }
                 })*/
                document.form1.action = "delRecommend?idList=" + deleteId;
                document.form1.submit();
            }

        }

        function deleteCheckRecommend() {
            if (hasChecked("idList") == false) {
                alert("请至少选择一个资源！");
                return false;
            }
            var strs = getCheckBoxListStr('idList');
            var idList = [];
            if (strs.indexOf(',') != -1) {
                idList = strs.split(',');
            } else {
                idList[0] = strs;
            }
            window.location.href = baseUrl + "my/delRecommend?idList=" + idList;
        }

    </SCRIPT>
    <script type="text/javascript">
        $(function () {
            $("#searchDate").datepicker();
        })
    </script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
</head>

<body onload="init();">
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">当前位置：${message(code: 'my.mined.name')}${message(code: 'my.recommend.name')}</a>
</div>

<div id="main-content">

    <div class="content-box-header">
        <ul class="content-box-tabs">

            %{--<li><a href="${createLink(controller: 'my', action: 'myManageProgram')}">我的资源</a></li>--}%
            <li><a href="${createLink(controller: 'my', action: 'myRecommendProgramList')}"
                   class="default-tab current">${message(code: 'my.mined.name')}${message(code: 'my.recommend.name')}</a>
            </li>
            %{--<li><a href="${createLink(controller: 'my', action: 'myProgramList')}">我的订阅</a></li>--}%
            <li><a href="${createLink(controller: 'my', action: 'myCollectProgramList')}">我的收藏</a></li>
            %{--<li><a href="${createLink(controller: 'my', action: 'myManageProgram')}">回收站</a></li>--}%

        </ul>

        <div class="clear"></div>
    </div>

    <form name="form1" id="form1" method="post">
        <input type="hidden" name="max" value="${params.max}">
        <input type="hidden" name="offset" value="${params.offset}">
        <input type="hidden" name="sort" value="${params.sort}">
        <input type="hidden" name="order" value="${params.order}">

        <div class=" my_recommend_content">
            <span class="m_r_t_l">名称:</span>
            <label class="m_r_input"><input type="text" name="searchName"
                                            value="${params.searchName}"/></label>
            %{-- <span class="m_r_t_l">主演:</span>
            <label class="m_r_input"><input type="text" name="searchActor"
                                            value="${params.searchActor}"/></label> --}%
            <span class="m_r_t_l">创建者:</span>
            <label class="m_r_input"><input type="text" name="searchConsumer"
                                            value="${params.searchConsumer}"/></label>
            <span class="m_r_t_b">入库时间:</span>
            <label class="m_r_input"><input class="" type="text"
                                            name="searchDate" id="searchDate" readonly=""
                                            value="${params.searchDate}"/></label>
            <span width="60" align="left"><a class="btn btn-success btn-sm space_buttop"
                                             href="javascript:void(0);"
                                             onClick="javascript:programSearch();
                                             return false;">检索</a></span>

        </div>

        <table class="table table-striped">
            <thead>
            <tr>
                <td width="25"><input type="checkbox" id="selall" name="selall"
                                      onclick="checkAll(this, 'idList')"/></td>
                <g:sortableColumn align="left" style="font-weight:bold;" property="name"
                                  title="${Program.cnField.name}" params="${params}"/>

                %{--<g:sortableColumn width="100" align="left" style="font-weight:bold;" property="actor"
                                  title="${Program.cnField.actor}" params="${params}"/>--}%
                <g:sortableColumn width="110" align="center" style="font-weight:bold;" property="consumer"
                                  title="${Program.cnField.consumer}" params="${params}"/>
                <g:sortableColumn width="70" align="left" style="font-weight:bold;" property="frequency"
                                  title="${Program.cnField.frequency}" params="${params}"/>
                <g:sortableColumn width="70" align="left" style="font-weight:bold;" property="downloadNum"
                                  title="下载次数" params="${params}"/>
                <g:sortableColumn width="70" align="left" style="font-weight:bold;" property="collectNum"
                                  title="收藏次数" params="${params}"/>
                <th width="50">点播</th>
                %{--<th width="50">下载</th>--}%
                <th width="80">取消推荐</th>
            </tr>
            </thead>

            <g:each in="${programList ?}" status="i" var="program">
                <tbody id="recommendProgramId${program.id}">
                <tr class="${(i % 2) == 0 ? 'alt-row' : ''}">
                    <td><g:checkBox name="idList"
                                    value="${program?.recommendedPrograms.id[0]}"
                                    checked=""
                                    onclick="unCheckAll('selall');"/></td>
                    <td><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                           target="_blank">${CTools.cutString(program?.name, 10).encodeAsHTML()}</a></td>

                    %{--      <td>${program?.actor.encodeAsHTML()}</td>--}%
                    <td align="center">
                        <g:if test="${program?.consumer.nickname.encodeAsHTML() != null}">
                            ${program?.consumer.nickname.encodeAsHTML()}
                        </g:if>
                        <g:else>
                            ${program?.consumer.name.encodeAsHTML()}
                        </g:else>
                    </td>
                    <td>${program?.frequency}</td>
                    <td>${program?.downloadNum}</td>
                    <td>${program?.collectNum}</td>
                    <td align="left"><a target="_blank"
                                        href="${createLink(controller: 'program', action: 'showProgram', id: program.id)}"
                                        title="点击播放"
                    %{--onclick="${playPrgram(program: program, isPlay: true)}"--}%><img
                                src="${resource(dir: 'images/icons', file: 'pagination_1_next.png')}" alt="点击播放" title="点击播放"
                                class="pl5"/></a></td>
                    %{--<td align="left"><g:if test="${program?.canDownload}"><a href="javascript:void(0);"
                                                                             title="点击下载"
                                                                             onclick="${playPrgram(program: program, isPlay: false)}"><img
                                src="${resource(dir: 'images/skin', file: 'delete.gif')}" alt="点击下载" title="点击下载" class="pl5"/>
                    </a></g:if></td>--}%
                    <td align="left"><a href="javascript:void(0);" title="取消推荐"
                                        onclick="delRecommend(${program?.recommendedPrograms.id[0]})"><img
                                src="${resource(dir: 'images/skin', file: 'delete.gif')}" alt="取消推荐" title="取消推荐" class="p15"></a>
                    </td>
                </tr>
                </tbody>
            </g:each>
        </table>

    </form>

    <table>
        <tr>
            <td align="left">
                <a href="#" class="btn btn-default" style="font-size: 12px;" id="sel" name="selall"
                   onclick="checkboxAll('idList')">全选</a>
                <input class="btn btn-default" type="button" value="取消推荐" onClick="deleteCheckRecommend()"/>
            </td>

        </tr>

    </table>

    <g:paginate total="${total}"></g:paginate>
</div>

</body>
</html>
