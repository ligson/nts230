<%@ page import="nts.utils.CTools; nts.program.domain.Program" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="my"/>
    <title>我的记录</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'myHistoryProgramlist.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>
    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'truevod.js')}"></script>--}%

    <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
        <!--

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
            changePageImg(${CTools.nullToOne(params.max)});
        }

        //-->
    </SCRIPT>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_coursesytyle.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'dropdown.js')}"></script>
    %{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/css', file: 'myHistoryProgramlist_course.css')}">--}%
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_userspace_index.css')}">
</head>

<body>

<div class="userspace_title" style="width:100%">
    <a href="" style="font-size: 16px; font-weight: bold; margin-left: 10px; margin-bottom: 10px;">创建课程</a>
</div>

<table class="table">
    <tr>
        <td align="left" valign="middle"><span class="course_bigtitle">课程名称</span></td>
    </tr>
    <tr>
        <td align="left" valign="middle"><label for="textfield"></label>
            <input class="form-control" type="text" name="textfield" id="textfield"></td>
    </tr>
    <tr>
        <td align="left" valign="middle"><span class="course_bigtitle">课程封面</span></td>
    </tr>
    <tr>
        <td align="left" valign="middle">
            <table class="table">
                <tr>
                    <td>
                        <div class="thumbnail_cat">
                            <img src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item1.png')}"
                                 alt="">
                        </div></td>
                    <td>

                        <div class="col-xs-6 col-md-2">
                            <a href="#" class="thumbnail">
                                <img src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item1.png')}"
                                     alt="">
                            </a>
                        </div>

                        <div class="col-xs-6 col-md-2">
                            <a href="#" class="thumbnail">
                                <img src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item1.png')}"
                                     alt="">
                            </a>
                        </div>

                        <div class="col-xs-6 col-md-2">
                            <a href="#" class="thumbnail">
                                <img src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item1.png')}"
                                     alt="">
                            </a>
                        </div>

                        <div class="col-xs-6 col-md-2">
                            <a href="#" class="thumbnail">
                                <img src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item1.png')}"
                                     alt="">
                            </a>
                        </div>

                        <div class="col-xs-6 col-md-2">
                            <a href="#" class="thumbnail">
                                <img src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item1.png')}"
                                     alt="">
                            </a>
                        </div>

                        <div class="col-xs-6 col-md-2">
                            <a href="#" class="thumbnail">
                                <img src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item1.png')}"
                                     alt="">
                            </a>
                        </div>

                        <div class="col-xs-6 col-md-2">
                            <a href="#" class="thumbnail">
                                <img src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item1.png')}"
                                     alt="">
                            </a>
                        </div>

                        <div class="col-xs-6 col-md-2">
                            <a href="#" class="thumbnail">
                                <img src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item1.png')}"
                                     alt="">
                            </a>
                        </div>

                        <div class="col-xs-6 col-md-2">
                            <a href="#" class="thumbnail">
                                <img src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item1.png')}"
                                     alt="">
                            </a>
                        </div>

                        <div class="col-xs-6 col-md-2">
                            <a href="#" class="thumbnail">
                                <img src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item1.png')}"
                                     alt="">
                            </a>
                        </div>
                        <a class="btn btn-default" style="margin-left:40%;">上传封面</a>
                    </td>
                </tr>
            </table></td>
    </tr>
    <tr>
        <td align="left" valign="middle"><span class="course_bigtitle">课程简介</span><span
                class="course_smailtitle">（前已输入71个字符, 您还可以输入9929个字符。）</span></td>
    </tr>
    <tr>
        <td align="left" valign="middle">

            %{--<img src="${resource(dir: 'images', file: 'coursewy.jpg')}" width="760px;" alt="">--}%
            <textarea name="textarea" style="text-align:left; padding-left: 0; height: 350px;" class="form-control"
                      rows="5" id="textarea">

            </textarea>

        </td>
    </tr>
    <tr>
        <td align="left" valign="middle"><span class="course_bigtitle">授课老师</span><span
                class="course_smailtitle">（添加多个老师用,隔开）</span></td>
    </tr>
    <tr>
        <td align="left" valign="middle">

            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><input class="form-control" type="text" name="textfield2" id="textfield2"></td>
                    <td width="60"><a class="btn btn-success" href="/">添加</a></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="left" valign="middle"><a href="/">某某老师</a>，<a href="/">某某老师</a>，<a href="/">某某老师</a>点击删除)</td>
    </tr>
    <tr>
        <td align="left" valign="middle"><span class="course_bigtitle">课程助教</span><span
                class="course_smailtitle">（添加多个老师用,隔开）</span></td>
    </tr>
    <tr>
        <td align="left" valign="middle">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><input class="form-control" type="text" name="textfield3" id="textfield3"></td>
                    <td width="60"><a class="btn btn-success" href="/">添加</a></td>
                </tr>
            </table>

    </tr>
    <tr>
        <td align="left" valign="middle"><a href="/">某某老师</a>，<a href="/">某某老师</a>，<a href="/">某某老师</a>点击删除)</td>
    </tr>
    <tr>
        <td align="left" valign="middle"><span class="course_bigtitle">添加课程资源</span></td>
    </tr>
    <tr>
        <td align="left" valign="middle">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><input class="form-control" type="text" name="textfield2" id="textfield2"></td>
                    <td width="60"><a class="btn btn-success" href="/">添加</a></td>
                </tr>
            </table></td>
    </tr>
    <tr>
        <td align="left" valign="middle"><span class="course_bigtitle">隐私权限</span></td>
    </tr>
    <tr>
        <td align="left" valign="middle"><input type="checkbox" name="checkbox" id="checkbox">
            公开
            <span class="course_smailtitle">选择公开，课程将被工作人员审核。审核通过的课程将被放置在公开课页面中。</span></td>
    </tr>
    <tr>
        <td align="left" valign="middle" style="line-height: 18px;"><input type="checkbox" name="checkbox"
                                                                           id="checkbox">
            不公开
            <span class="course_smailtitle">选择不公开，课程将不会出现在公开课页面中。适用于私人性质的授课、会议等。</span></td>
    </tr>
    <tr>
        <td align="left" valign="middle"><span class="course_bigtitle">设置课程密码</span></td>
    </tr>
    <tr>
        <td align="left" valign="middle"><input name="" checked="true" type="radio" value="">
            不需要密码</td>
    </tr>
    <tr>
        <td align="left" valign="middle"><input name="" type="radio" value="">
            需要密码<span class="course_smailtitle">(密码为4位字符或数字)</span></td>
    </tr>
    <tr>
        <td align="left" valign="middle"><span class="course_bigtitle">费用</span></td>
    </tr>
    <tr>
        <td align="left" valign="middle">免费，如有收费需求请与我们联系。</td>
    </tr>
</table>

%{--创建课程结束--}%










<script>
    function wmyok() {
        alert('成功保存。');
    }
</script>

<div class="course_right_nav" style="margin-top: 30px;">
    <a class="btn btn-primary btn-lg" style="margin-left: 30px; width: 215px;" onclick="wmyok();">保存课程</a>

    <div class="space_height" style="height: 20px;"></div>
    <a class="btn btn-primary btn-lg" style="margin-left: 30px; width: 215px;" target="_blank"
       href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: 226])}">预览课程</a>
</div>





<script type="text/javascript">
    $(document).ready(function () {
        var intervalID;
        var curLi;
        var tabNav = $(".tabs_nav li a");
        tabNav.mouseover(function () {
            curLi = $(this);
//鼠标移入的时候有一定的延时才会切换到所在项，防止用户不经意的操作
            intervalID = setInterval(onMouseOver, 250);
        });
        function onMouseOver() {
            $(".cur-sub-con").removeClass("cur-sub-con");
            $(".sub-con").eq(tabNav.index(curLi)).addClass("cur-sub-con");
            $(".cur").removeClass("cur");
            curLi.addClass("cur");
        }

        tabNav.mouseout(function () {
            clearInterval(intervalID);
        });

//鼠标点击也可以切换
        tabNav.click(function () {
            clearInterval(intervalID);
            $(".cur-sub-con").removeClass("cur-sub-con");
            $(".sub-con").eq(tabNav.index(curLi)).addClass("cur-sub-con");
            $(".cur").removeClass("cur");
            curLi.addClass("cur");
        });
    });
</script>
</body>
</html>

