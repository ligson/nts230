<%@ page import="nts.meta.domain.MetaContent" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>编辑资源元数据信息</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'style_my.css')}" type="text/css"
          media="screen"/>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'editMetaContent.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/isNum2.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/metaContentEdit.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/meta.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'metalist.js')}"></script>

    <script type="text/javascript">
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

    </script>

</head>

<body>

<g:form controller="programMgr" action="dealMetaData" name="form1" onsubmit="return check();">
    <input type="hidden" name="id" value="${program?.id}"/>

    <div id="main-content"><!-- Main Content Section with everything -->
        <div class="content-box"><!-- Start Content Box -->

            <div class="content-box-header" style="background: none;">
                <ul class="content-box-tabs">
                    <!-- <li><a href="#tab1" id="tab0" class="default-tab current" onclick="setShowType(SHOW_OPT_SIMPLE);
        return false;">简单编目项</a></li> -->
                    <li><a href="javascript:void(0);" id="tab1" class="default-tab current"
                           onclick="setShowType(SHOW_OPT_DEFAULT);
                           return false;">元数据缺省编目项</a></li>
                    <li><a href="javascript:void(0);" id="tab2" class="default-tab"
                           onclick="setShowType(SHOW_OPT_ALL);">元数据所有编目项</a></li>
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

                    <div style="width: 100%; height: 20px"></div>
                    <table class="table" id="wtab" style="border:none; width: 650px" cellpadding="0" cellspacing="0"
                           width=""></table>
                    <table class="table" id="wtab2" style="border:none" cellpadding="0" cellspacing="0">
                        <tr style="border:none; display: block">
                            <td width="155"></td>
                            <td style="border:none">
                                <input class="admin_default_but_blue" type="submit" value="保存">
                                <input class="admin_default_but_blue" type="button" value="关闭" id="closeBtn">
                                %{--<input class="admin_default_but_blue" type="button" value="关闭"--}%
                                       %{--onclick="window.opener = null;--}%
                                       %{--window.open('', '_self', '');--}%
                                       %{--window.close();">--}%
                            </td>
                        </tr>

                    </table>

                </div> <!-- End #tab1 -->
            </div> <!-- End .content-box-content -->
        </div> <!-- End .content-box -->
    </div> <!-- End #main-content -->
</g:form>

</body>
</html>
