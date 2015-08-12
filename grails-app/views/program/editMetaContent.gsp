<%@ page import="nts.meta.domain.MetaContent" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>编辑资源信息</title>
    <meta name="layout" content="index"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'reset.css')}" type="text/css"
          media="screen"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'style_my.css')}" type="text/css"
          media="screen"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'proedit.css')}" type="text/css"
          media="screen"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}" type="text/css"
          media="screen"/>

    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/isNum2.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/metaContentEdit.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/meta.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/metalist.js')}"></script>


    <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
        //全局变量
        global.programId = ${program.id};
        global.classId = ${program.directoryId};

        global.titleId = "${application.metaTitleId}";
        global.metaCreatorId = "${application.metaCreatorId}";

        //初始化
        window.onload = init;

        var contentList = [];

        <g:each in="${program.metaContents}" status="i" var="metaContent">
        contentList[${i}] = new CContentTypeObj(${metaContent.id}, ${metaContent.metaDefine.id}, ${metaContent.metaDefine.parentId}, ${MetaContent.numDataTypes.contains(metaContent.metaDefine.dataType)?1:2}, ${metaContent.numContent}, '${metaContent?.strContent?.encodeAsJavaScript()}');
        </g:each>
    </SCRIPT>

    <style type="text/css">
    label {
        float: left;
    }

    select {
        width: 100px;
    }
    </style>

</head>

<body>
<div style="clear:both;"></div>

<div id="body-wrapper"><!-- Wrapper for the radial gradient background -->
<g:render template="/my/myLeft"/>


    <form action="/program/dealMetaData" method="post" name="form1" onsubmit="return check();">

        <input type="hidden" name="id" value="${program?.id}"/>

        <div id="main-content"><!-- Main Content Section with everything -->
            <div class="content-box"><!-- Start Content Box -->

                <div class="content-box-header">
                    <ul class="content-box-tabs">
                        <!--  <li><a href="#tab1" id="tab0" class="default-tab current" onclick="setShowType(SHOW_OPT_SIMPLE);
        return false;">简单编目项</a></li> -->
                        <li><a href="#tab2" id="tab1" class="default-tab current"
                               onclick="setShowType(SHOW_OPT_DEFAULT);
                               return false;">元数据缺省编目项</a></li>
                        <li><a href="#" id="tab2" class="default-tab" onclick="setShowType(SHOW_OPT_ALL);">元数据所有编目项</a>
                        </li>
                    </ul>


                    <div class="clear"></div>

                </div> <!-- End .content-box-header -->

                <div class="content-box-content">

                    <div class="tab-content default-tab"
                         id="tab11"><!-- This is the target div. id must match the href of this div's tab -->

                        <g:if test="${flash.message}">
                            <div class="gblue gn pr30">${flash.message}</div>
                        </g:if>
                        <g:hasErrors bean="${program}">
                            <div class="gblue gn pr30">
                                <g:renderErrors bean="${program}" as="list"/>
                            </div>
                        </g:hasErrors>



                        <table id="wtab" style="border:none"></table>

                        <div><input class="qqbut" type="submit" value="保存">&nbsp;<input class="qqbut" type="button"
                                                                                        value="关闭"
                                                                                        onclick="window.opener = null;
                                                                                        window.open('', '_self', '');
                                                                                        window.close();"></div>

                    </div> <!-- End #tab1 -->
                </div> <!-- End .content-box-content -->
            </div> <!-- End .content-box -->
        </div> <!-- End #main-content -->
    </form>

</div>
</body>
</html>
