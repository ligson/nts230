<%@ page import="nts.utils.CTools; nts.program.domain.Program" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>我的资源</title>
    <r:require modules="zTree"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'myManagerProgram.css')}">
    %{--<link rel="stylesheet" href="${resource(dir: 'skin/default/pc/css', file: 'page.css')}" type="text/css"/>--}%
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/myManageProgram.js')}"></script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'dropdown.js')}"></script>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_userspace_index.css')}">
</head>

<body>
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">当前位置：资源管理</a>
</div>

<div class="content-box-header">
    <ul class="content-box-tabs">

        <li><a href="${createLink(controller: 'my', action: 'myManageProgram')}" class="default-tab current">我的资源</a>
        </li>
        %{--<li><a href="${createLink(controller: 'my', action: 'myRecommendProgramList')}">我的推荐</a></li>--}%
        %{--<li><a href="${createLink(controller: 'my', action: 'myProgramList')}">我的订阅</a></li>--}%
        %{--<li><a href="${createLink(controller: 'my', action: 'myCollectProgramList')}">我的收藏</a></li>--}%
        <li><a href="${createLink(controller: 'my', action: 'myDeleteProgram')}">回收站</a></li>
    </ul>

    <div class="clear"></div>
</div>

<g:form action="myManageProgram" method="post" name="programForm">
    <table style="margin: 15px 0">
        <tr>
            <td style="width: 38px; text-align: right;"><span>${Program.cnField.state}:</span></td>
            <td style="width:130px; text-align: right;"><select name="schState" ${isFromRecycler ? 'disabled' : ''}
                                                                class="">
                <option value="0">全部</option>
                <option value="${Program.NO_APPLY_STATE}">${Program.cnState.get(Program.NO_APPLY_STATE)}</option>
                <option value="${Program.NO_PASS_STATE}">${Program.cnState.get(Program.NO_PASS_STATE)}</option>
                <option value="${Program.APPLY_STATE}">${Program.cnState.get(Program.APPLY_STATE)}</option>
                <option value="${Program.CLOSE_STATE}">${Program.cnState.get(Program.CLOSE_STATE)}</option>
                <option value="${Program.PUBLIC_STATE}">${Program.cnState.get(Program.PUBLIC_STATE)}</option>
            </select></td>
            <td style="width: 60px; text-align: right;">检索类型:</td>
            <td style="width: 130px; text-align: right;"><select name="schType" class="space_selectsty">
                <option value="name" ${params?.schType == 'name' ? 'selected' : ''}>${Program.cnField.name}</option>
                <option value="actor" ${params?.schType == 'actor' ? 'selected' : ''}>${Program.cnField.actor}</option>
                <option value="programTags" ${params?.schType == 'programTags' ? 'selected' : ''}>${Program.cnField.programTags}</option>
            </select></td>
            <td style="width: 192px; text-align: right;"><input class="" type="text"
                                                                name="schWord" value="${params?.schWord}"/></td>
            <td style="width: 95px; text-align: right;"><a class="btn btn-success btn-sm space_buttop"
                                                           href="javascript:void(0);"
                                                           onclick="javascript:submitSch();">检索</a></td>
            <td style="width: 95px; text-align: right;">
                %{--<a class="btn btn-success btn-sm space_buttop" href="${createLink(controller: 'my', action: 'createProgram')}">资源上传</a>--}%
            </td>

        </tr>

    </table>
</g:form>


<table class="table">

    <tbody>
    <g:each in="${programList}" status="i" var="program">

        <tr>
            <td width="20"><input id="idList" type="checkbox" onclick="unCheckAll('selall');" value="${program?.id}"
                                  name="idList"></td>
            <td width="60">
                <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                   target="_blank"><img width="25" height="25" src="${posterLinkNew(program: program, size: '54x54')}"/>
                </a></td>
            <td align="left"><a
                    href="${createLink(controller: 'my', action: "editSerialList", params: [id: program.id])}"
                    title="${program?.name.encodeAsHTML()}"
                    target="_blank">${CTools.cutString(program?.name, 26).encodeAsHTML()}</a></td>
            <td align="right" width="250">
                <span><g:if test="${program.canPublic}">公开</g:if><g:else>不公开</g:else></span>&nbsp;
                <span><g:if test="${program.canDownload}">允许下载</g:if><g:else>禁止下载</g:else></span>&nbsp;
                <span><g:if test="${program.canPlay}">允许点播</g:if><g:else>禁止点播</g:else></span>

            </td>
            <td width="80">
                <div class="btn-group">
                    <button type="button" class="btn btn-default dropdown-toggle"
                            style="font-size: 12px; padding: 3px 6px;" data-toggle="dropdown">
                        操作<span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <g:if test="${program.canDownload}">
                            <li><a href="${createLink(controller: 'my', action: 'setMyProgramState', params: params.putAll([idList: program?.id, canDownload: true]) ? params : params)}">禁止下载</a>
                            </li>
                        </g:if>
                        <g:else>
                            <li><a href="${createLink(controller: 'my', action: 'setMyProgramState', params: params.putAll([idList: program?.id, canDownload: false]) ? params : params)}">允许下载</a>
                            </li>
                        </g:else>
                        <g:if test="${program.state == Program.NO_APPLY_STATE}">
                            <li><a href="${createLink(controller: 'my', action: 'setMyProgramState', params: [idList: program?.id, applyState: Program.APPLY_STATE])}">申请入库</a>
                            </li>
                        </g:if>
                        <g:if test="${program.canPublic}">
                            <li><a href="${createLink(controller: 'my', action: 'setMyProgramState', params: [idList: program?.id, canPublic: true])}">不公开</a>
                            </li>
                        </g:if>
                        <g:else>
                            <li><a href="${createLink(controller: 'my', action: 'setMyProgramState', params: [idList: program?.id, canPublic: false])}">公开</a>
                            </li>
                        </g:else>
                        <g:if test="${program.canPlay}">
                            <li><a href="${createLink(controller: 'my', action: 'setMyProgramState', params: [idList: program?.id, canPlay: true])}">禁止点播</a>
                            </li>
                        </g:if>
                        <g:else>
                            <li><a href="${createLink(controller: 'my', action: 'setMyProgramState', params: [idList: program?.id, canPlay: false])}">允许点播</a>
                            </li>
                        </g:else>
                        <li><a href="${createLink(controller: 'my', action: 'myEditMetaContent', params: [id: program?.id])}"
                               target="_blank">编辑元数据</a>
                        </li>
                        <li><a href="${createLink(controller: 'my', action: 'editProgramInfo', params: [id: program?.id])}"
                               target="_blank">修改</a>
                        </li>
                        <li><a href="javascript:void(0)" onClick="deleteUserActivityList(${program?.id});">删除</a>
                        </li>
                    </ul>
                </div>
            </td>
        </tr>
    </g:each>

    </tbody>

</table>

<table class="table">
    <tr>
        <td align="left">
            <a href="javascript:void(0)" class="btn btn-default" style="font-size: 12px;" id="sel" name="selall"
               onclick="checkboxAll('idList')">全选</a>
            <a href="javascript:void(0)" class="btn btn-default" style="font-size: 12px;"
               onClick="deleteUserActivityList('');">删除</a>

            %{--<a name="categoryName" id="selectCategoryBtn" class="btn btn-default" style="font-size: 12px;">分类</a>--}%
            <a href="javascript:void(0)" class="btn btn-default" style="font-size: 12px;"
               onclick="programSet('canPublic', 'false')">公开</a>
            <a href="javascript:void(0)" class="btn btn-default" style="font-size: 12px;"
               onclick="programSet('canPublic', 'true')">不公开</a>
            <a href="javascript:void(0)" class="btn btn-default" style="font-size: 12px;"
               onclick="programSet('canDownload', 'false')">允许下载</a>
            <a href="javascript:void(0)" class="btn btn-default" style="font-size: 12px;"
               onclick="programSet('canDownload', 'true')">不允许下载</a>
            <a href="javascript:void(0)" class="btn btn-default" style="font-size: 12px;"
               onclick="programSet('canPlay', 'false')">允许点播</a>
            <a href="javascript:void(0)" class="btn btn-default" style="font-size: 12px;"
               onclick="programSet('canPlay', 'true')">禁止点播</a>

            %{--<div class="btn-group">--}%
            %{--<button type="button" class="btn btn-default dropdown-toggle" style="font-size: 12px;" data-toggle="dropdown">--}%
            %{--操作<span class="caret"></span>--}%
            %{--</button>--}%
            %{--<ul class="dropdown-menu" role="menu" style="width:80px;">--}%
            %{--<li><a href="#"  id="sel" name="selall" onclick="checkAll(this,'idList')"  >全选</a></li>--}%
            %{--<li><a href="#" onClick="deleteUserActivityList();">删除</a></li>--}%
            %{--<li><a href="#" >批量分类</a></li>--}%
            %{--</ul>--}%
            %{--</div>--}%
            %{--批量分类原代码 <g:select name="dirId" from="${Directory.list()}" optionKey="id"--}%
            %{--style="padding:5px;width: 100px" optionValue="name"--}%
            %{--value="${program.directory.id}"/>--}%
        </td>

    </tr>
    <tr>

        <td align="right" style="vertical-align: middle;">
            %{--<tfoot>--}%
            %{--<tr>--}%
            %{--<td colspan="3">--}%
            %{--<g:guiPaginate controller="my" action="myManageProgram" total="8000"/>--}%
            %{--</td>--}%
            %{--</tr>--}%
            %{--</tfoot>--}%
            <g:paginate controller="my" action="myManageProgram" total="${total}"/>
        </td>
    </tr>
</table>

%{--<div id="selectCategoryDialog" class="bg" style="display:none;" title="选择分类">--}%
%{--<div>--}%
%{--<input type="hidden" id="selectedCategoryId" value=""/>--}%
%{--选择的分类：<span id="selectedCategoryName">未选择</span>--}%
%{--</div>--}%

%{--<div id="zTree" class="ztree">--}%
%{--</div>--}%
%{--</div>--}%
</body>
</html>
