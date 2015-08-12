<!-- saved from url=(0065)http://zgb.huizhou.gov.cn/personnel/portal/perdata/perdataAdd.jsp -->
<HTML>
<HEAD><title>aaa</title>


    <link href="${resource(dir: 'skin/blue/pc/front/css', file: 'style_1.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/apply.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/userspace/menu.js')}"></script>
</HEAD>

<BODY onkeydown="if (event.keyCode == 27) return false;">
<div class="x_daohang">
    <p>当前位置：<a href="${createLink(controller: 'my', action: 'myInfo')}">个人空间</a>>> 上传申请</p>
</div>

<DIV class=wrap>

    <FORM name="bbrules" action="applyTable" method="post">
        <TABLE width="630" border=0 align="center" cellPadding=0 cellSpacing=0>
            <TBODY>
            <TR>
                <TD background=${resource(dir: 'images/skin', file: 'text_title_zysc.gif')} height=60>&nbsp;</TD>
            </TR>
            </TBODY>
        </TABLE>

        <DIV class="mainbox formbox">

            <TABLE class=register cellSpacing=0 cellPadding=0 width="60%" align=center>
                <TBODY>
                <TR>
                    <TD class="register">
                        当您申请资源上传至个人空间时，表示您已经同意遵守本规章。
                        <BR>
                        欢迎您加入本站点参加交流和讨论，本站点为教学资源库，为全校师生教学服务。为维护网上公共秩序和社会稳定，请您自觉遵守以下条款：
                        <BR>
                        一、不得利用本站危害国家安全、泄露国家秘密，不得侵犯国家社会集体的和公民的合法权益，不得利用本站制作、上传和传播下列信息：<BR>
                        （一）煽动抗拒、破坏宪法和法律、行政法规实施的；<BR>　
                    （二）煽动颠覆国家政权，推翻社会主义制度的；<BR>　
                    （三）煽动分裂国家、破坏国家统一的；<BR>　
                    （四）煽动民族仇恨、民族歧视，破坏民族团结的；<BR>　
                    （五）捏造或者歪曲事实，散布谣言，扰乱社会秩序的；<BR>　
                    （六）宣扬封建迷信、淫秽、色情、赌博、暴力、凶杀、恐怖、教唆犯罪的；<BR>　
                    （七）公然侮辱他人或者捏造事实诽谤他人的，或者进行其他恶意攻击的；<BR>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（八）损害国家机关信誉的；<BR>　
                    （九）其他违反宪法和法律行政法规的；<BR>　
                    （十）进行商业广告行为的。<BR>
                        二、互相尊重，对自己上传的资源负责。<BR>
                        三、禁止上传带有侮辱、毁谤、造谣类的或是有其含义的各种资源，否则我们会取消您的上传权限。<BR>
                        四、禁止以任何方式对本站进行各种破坏行为。<BR>
                        五、如果您有违反国家相关法律法规的行为，本站概不负责，您的登录信息均被记录，必要时，我们会向相关的国家管理部门提供此类信息。
                        <BR></TD></TR></TBODY>
                <TBODY>
                <TR class=btns style="HEIGHT: 10px">
                    <TD id='rulebutton' align=middle>请仔细阅读以上的资源上传许可协议</TD>
                </TR></TBODY></TABLE></DIV></FORM>
    <SCRIPT type=text/javascript>
        var secs = 9;
        var wait = secs * 1000;
        $('rulebutton').innerHTML = "请仔细阅读以上的资源上传许可协议 (" + secs + ")";
        for (i = 1; i <= secs; i++) {
            window.setTimeout("update(" + i + ")", i * 1000);
        }
        window.setTimeout("timer()", wait);
        function update(num, value) {
            if (num == (wait / 1000)) {
                $('rulebutton').innerHTML = "请仔细阅读以上的资源上传许可协议";
            } else {
                printnr = (wait / 1000) - num;
                $('rulebutton').innerHTML = "请仔细阅读以上的资源上传许可协议 (" + printnr + ")";
            }
        }
        function timer() {
            $('rulebutton').innerHTML = '<button type="submit" onclick="location.href=\'applyTable\'"id="rulesubmit" name="rulesubmit" value="true">同 意</button> &nbsp;&nbsp;&nbsp;&nbsp; <button type="button" >不同意</button>';
        }
    </SCRIPT>
</DIV>

</BODY></HTML>
