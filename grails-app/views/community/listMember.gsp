<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="communityMain"/>
    <title>讨论区块状视图列表</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'js/commonLib', file: 'string.js')}">
    <script type="text/javascript">
        function saveForumMainArticle() {
            saveForm.submit();
        }
        function openEditForumMainArticle(id, name, description) {
            editForm.id.value = id;
            editForm.name.value = name;
            editForm.description.value = description;
            void(0);
        }
        function editForumMainArticle() {
            editForm.submit();
        }

        //弹出发送消息
        function sendMessage(receiveId) {
            document.getElementById('qfbxtsun').style.display = 'block';
            document.getElementById('qfbxtbsun').style.display = 'block';
            document.getElementById('receiveId').value = receiveId;
        }

        //提交消息
        function toSendMessage() {
            //清空所有提示
            $('labTitle').innerHTML = '标题';
            $('labDescription').innerHTML = '内容';

            if ($("#msgTitle").val().length == 0) {
                $("labTitle").innerHTML += '&nbsp;&nbsp;<font style="color:red;">标题不能为空值</font>';
                $("msgTitle").focus();
                $("msgTitle").select();
                return;
            }
            else if ($('#msgContent').val().length == 0) {
                $('labDescription').innerHTML += '&nbsp;&nbsp;<font style="color:red;">内容不能为空值</font>';
                return;
            }
            else if ($("#msgTitle").val().length > 50) {
                var manyLength = (parseInt($(msgTitle).value.length) - 50);
                $('labTitle').innerHTML += '&nbsp;&nbsp;<font style="color:red;">标题超出了' + manyLength + '个字符</font>';
                $('msgTitle').select();
                return;
            }

            var request_url = baseUrl + "message/sendMessage"; // 需要获取内容的url
            var receiveId = document.getElementById('receiveId').value;
            var title = document.getElementById('msgTitle').value;
            var content = document.getElementById('msgContent').value;
            var request_pars = "receiveId=" + receiveId + "&name=" + title + "&description=" + content//请求参数

            try{
            var myAjax = new Ajax.Request(request_url, {
                method: 'post', //HTTP请求的方法,get or post
                parameters: request_pars, //请求参数
                onFailure: reportError, //失败的时候调用 reportError 函数
                onLoading: loading, //正在获得内容的时候
                onComplete: returnMessage //内容获取完毕的时候
            });
            }catch (e){
                $.ajax({
                    url:request_url,
                    data:request_pars,
                    success:function(data){
                        alert(data.msg);
                        if(data.success){
                            window.location.reload();
                        };
                    }
                })
            }


        }

        function returnMessage(obj) {
            console.log(obj)
            alert(obj.responseText);
            document.getElementById('qfbxtsun').style.display = 'none';
            document.getElementById('qfbxtbsun').style.display = 'none';
        }

        function loading() {
        }

        function done() {
        }

        function reportError(request) {
            alert(request);
        }
    </script>

</head>

<body>
<div class="l w785">
    <div class="qtlqtit">
        <h2>贴子列表</h2>

        <div class="r pt15">
        </div>

        <div class="cl"></div>

        <div class="qtdblb">
            <table cellpadding="0" cellspacing="0" width="100%">
                <tr class="qtawb f14 wh lh24 b pt5" bgcolor="#f4f4f4">
                    <td class="qtawb" width="30%">用户名</td><td class="qtawb qtawl" width="12%">真实姓名</td><td
                        class="qtawb qtawl" width="15%">角色</td><td class="qtawb qtawl" width="12%">所属院系</td><td
                        class="qtawb qtawl" width="17%">发消息</td>
                </tr>
                <g:each in="${members}" status="i" var="member">
                    <tr class="qtabbg">
                        <td class="qtabl qtabb">${member?.name}</td><td class="qtabl qtabb">${member?.trueName}</td>
                        <td class="qtabl qtabb g9">${member?.role == 2 ? "老师" : "学生"}</td><td
                            class="qtabl qtabb g9">${member?.college?.name}</td>
                        <td class="qtabl qtabb  qtabt"><a href="javascript:void(0)"
                                                          onclick="sendMessage('${member.id}')"
                                                          class="qh2 qsqsm g3f">发消息</a></td>
                    </tr>
                </g:each>
            </table>
        </div>

        <div class="qfy cl">
            <dl class="mt5">
                <% if (pageCount != 0) { %>
                <dt>共${pageCount}页</dt>
                <dt><a href='${createLink(controller: 'community', action: 'listMember', params: [pageIndex: 1])}'>首页</a></dt>
                <% if (pageIndex != 1) { %>
                <dt><a href='${createLink(controller: 'community', action: 'listMember', params: [pageIndex: pageIndex == 1 ? 1 : pageIndex - 1])}'>上一页</a></dt>
                <% } %>
                <%
                        for (int i = 1; i <= pageCount; i++) {
                %>
                <% if (pageIndex == i && pageIndex + 2 >= i && pageIndex - 2 <= i) { %>
                <dt class="qdqy"}>${i}</dt>
                <% } %>
                <% if (pageIndex != i && pageIndex + 2 >= i && pageIndex - 2 <= i || (pageIndex <= 2 && (i == 4 || i == 5)) || (pageIndex >= pageCount - 2 && (i == pageCount - 3 || i == pageCount - 4))) { %>
                <dt><a href="${createLink(controller: 'community', action: 'listMember', params: [pageIndex: i])}">${i}</a></dt>
                <% } %>
                <% } %>
                <% if (pageIndex != pageCount) { %>
                <dt><a href='${createLink(controller: 'community', action: 'listMember', params: [pageIndex: pageIndex == pageCount ? pageCount : pageIndex + 1])}'>下一页</a></dt>
                <% } %>
                <dt><a href='${createLink(controller: 'community', action: 'listMember', params: [pageIndex: pageCount])}'>末页</a></dt>
                <% } %>
                <% if (pageCount == 0) { %>
                抱歉，学习社区还没有成员加入&nbsp;&nbsp;
                <% } %>
            </dl>
        </div></div>
</div>

<!--发送消息-->
<form id="msgForm" name="msgForm" method="post">
    <div id="qfbxtsun" class="qfbxt">
        <div class="qhdtit">
            <a href="javascript:void(0)" onclick="document.getElementById('qfbxtsun').style.display = 'none';
            document.getElementById('qfbxtbsun').style.display = 'none'" class="qhdclose"><img
                    src="${resource(dir: 'images/skin', file: 'close.gif')}"/></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;发送消息
        </div>

        <div class="h24 cl"></div>

        <div class="qtd">
            <h2 id="labTitle">标题</h2>

            <div class="qtdcon"><input name="name" id="msgTitle" type="text" class="qtdin" value="标题必填，不得多于50个字。"
                                       maxlength="100" onFocus="nameFocus('msgTitle');" onBlur="nameBlur('msgTitle');"/>
            </div>
        </div>

        <div class="h24 cl"></div>

        <div class="qtd">
            <h2 id="labDescription">内容</h2>

            <div class="qtdcon"><textarea name="description" id="msgContent" cols="" rows="5" class="qtdte"></textarea>
            </div>
        </div>

        <div class="h14 cl"></div>

        <div class="qtdb">
            <div class="qtdbr"><br/>
                <input name="" type="button" value=" 提 交 " class="qtdbbut"
                       onclick="toSendMessage()"/>&nbsp;&nbsp;&nbsp;&nbsp;
                <input name="" type="button" value=" 取 消 " class="qtdbbut"
                       onclick="document.getElementById('qfbxtsun').style.display = 'none';
                       document.getElementById('qfbxtbsun').style.display = 'none'"/>
            </div>
        </div>
    </div>

    <div id="qfbxtbsun" class="black_overlay"></div>
    <input type="hidden" name="receiveId" id="receiveId">
</form>

</body>
</html>
