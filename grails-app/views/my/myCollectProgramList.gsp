<%@ page import="nts.utils.CTools; nts.program.domain.Program; nts.program.domain.CollectedProgram" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>${message(code: 'my.mined.name')}${message(code: 'my.collect.name')}</title>
    %{--<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>--}%
    %{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'myManagerProgram.css')}">--}%
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/community/select2css.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'truevod.js')}"></script>--}%
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
        <!--
        var isAnony = ${(session.consumer == null || session.consumer.name == 'anonymity')?"true":"false"};//是否匿名用户
        function selectPage(opt) {
            if (isAnony) {
                if (opt == 4) {
                    alert("匿名用户不能进入个人空间，请先登录");
                    return;
                }

            }

            document.pageForm.selectPage.value = opt;
            document.pageForm.action = baseUrl + "index/main";
            document.pageForm.submit();
        }

        //全局变量
        var editorList = [];

        function submitSch() {
            document.form1.submit();
        }

        function onPageNumPer(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;
            submitSch();
        }

        //如果右边页面用类库(目录) 则metaId2是目录ID，enumId2为0 名称后缀2表示是右边的类别,如此设计是为了用户如果...
        function categorySch(metaId2, enumId2) {
            document.form1.metaId2.value = metaId2;
            document.form1.keyword.value = "";//点击时不使用搜索条件
            submitSch();
        }

        function init() {
            createEditorList();
            changePageImg(${CTools.nullToOne(params.max)});
        }

        function deleteCollect() {
            if (hasChecked("idList") == false) {
                alert("请至少选择一个收藏节目！");
                return false;
            }
            document.form1.action = "deleteCollectProgram";
            document.form1.submit();
        }

        //注意，此函数名是约定的，专门用来验证InPlaceEditor值的
        function checkInPlaceEditor(editor) {
            var value = Jtrim(editor.value);

            if (value == "") {
                alert("请输入值，不能为空。");
                editor.focus();
                return false;
            }

            if (value.length > 40) {
                alert("不能超过40个字符，请重新输入。");
                editor.focus();
                return false;
            }

            return true;
        }

        function refreshLeft() {
            window.parent.myLeftFrame.location.reload();
        }

        function createEditorObj(id) {
            var oEditor = new Ajax.InPlaceEditor("tag" + id, baseUrl + "my/inPlaceEditorCollect?id=" + id,
                    {
                        //okText:"确认",
                        okButton: false,
                        //cancelText:"取消",
                        cancelButton: false,
                        savingText: "正在提交...",
                        externalControl: "externalControl",
                        clickToEditText: "点击即可编辑,焦点移出则提交。",
                        rows: 1,
                        cols: 10,
                        loadTextURL: "",
                        onComplete: function () {
                            refreshLeft()
                        },
                        submitOnBlur: true
                    }
            );

            return oEditor;
        }


        //Event.observe(window, 'load', init);
        //        $(function () {
        //            init();
        //        });

        function createEditorList() {
            <g:each in="${collectProgramList}" status="i" var="collectProgram">
            editorList[${i}] = createEditorObj(${collectProgram.id});
            </g:each>
        }
        //-->
    </SCRIPT>

</head>

<body>
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">当前位置：${message(code: 'my.mined.name')}${message(code: 'my.collect.name')}</a>
</div>

<div id="main-content">

    <div class="content-box-header">
        <ul class="content-box-tabs">


            %{--<li><a href="${createLink(controller: 'my', action: 'myManageProgram')}">我的资源</a></li>--}%
            <li><a href="${createLink(controller: 'my', action: 'myRecommendProgramList')}">我的推荐</a></li>
            %{--<li><a href="${createLink(controller: 'my', action: 'myProgramList')}">我的订阅</a></li>--}%
            <li><a href="${createLink(controller: 'my', action: 'myCollectProgramList')}"
                   class="default-tab current">${message(code: 'my.mined.name')}${message(code: 'my.collect.name')}</a>
            </li>
            %{--<li><a href="${createLink(controller: 'my', action: 'myManageProgram')}">回收站</a></li>--}%
        </ul>

        <div class="clear"></div>
    </div>

    <div class="content-box-content">
        <div class="tab-content default-tab">
            <form name="form1" id="form1" method="post">
                <input type="hidden" name="max" value="${params.max}">
                <input type="hidden" name="offset" value="${params.offset}">
                <input type="hidden" name="sort" value="${params.sort}">
                <input type="hidden" name="order" value="${params.order}">
                <input type="hidden" name="tag" value="${tag}">

                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th width="20" align="left"><input type="checkbox" id="selall" name="selall"
                                                           onclick="checkAll(this, 'idList')"/></th>
                        <th align="left">${Program.cnField.name}</th>
                        <th width="140" align="left">收藏时间</th>
                        %{-- <th width="100" align="left">${Program.cnField.actor}</th>--}%
                        <th width="64" align="left">${Program.cnField.consumer}</th>
                        <th width="70" align="left">${Program.cnField.frequency}</th>
                        <th width="70" align="left">下载次数</th>
                        <th width="70" align="left">收藏次数</th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${collectProgramList}" status="i" var="collectProgram">
                        <tr class="${(i % 2) == 0 ? 'alt-row' : ''}">
                        <td height="23" align="left" class="STYLE5"><g:checkBox name="idList"
                                                                                value="${collectProgram.id}"
                                                                                checked=""
                                                                                onclick="unCheckAll('selall');"/></td>
                        <td align="left"><a
                                href="${createLink(controller: 'program', action: 'showProgram', params: [id: collectProgram?.program.id])}"
                                target="_blank">${CTools.cutString(collectProgram.program.name, 10).encodeAsHTML()}</a>
                        </td>
                        <td align="left"><g:formatDate format="yyyy.MM.dd HH:mm:ss"
                                                       date="${collectProgram?.dateCreated}"/></td>
                    %{--<td align="left">${collectProgram?.program.actor.encodeAsHTML()}</td>--}%
                        <td align="left">${collectProgram?.consumer.name.encodeAsHTML()}</td>
                        <td align="left">${collectProgram?.program.frequency}</td>
                        <td align="left">${collectProgram?.program.downloadNum}</td>
                        <td align="left">${collectProgram?.program.collectNum}</td>
                        </td>
                    </tr>
                    </g:each>
                    </tbody>
                </table>

                <table class="table">
                    <tr>
                        <td align="left">
                            <a href="#" class="btn btn-default" style="font-size: 12px;" id="sel" name="selall"
                               onclick="checkboxAll('idList')">全选</a>

                            <input class="btn btn-default" type="button" value="删除所选收藏" onClick="deleteCollect()"/>
                        </td>

                    </tr>

                </table>


                <div class="qfy mt5 mb10">
                    <g:paginate total="${total}" params="${params}" maxsteps="5"/>
                </div>

            </form>
        </div>
    </div>
</div>

</body>
</html>

