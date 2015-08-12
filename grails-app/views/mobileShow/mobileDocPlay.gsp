<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <r:require modules="jquery"></r:require>
    <r:layoutResources></r:layoutResources>
    <r:layoutResources></r:layoutResources>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobileDoc_play.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobileDoc_play_views.css')}">
    <title>搜索</title>
</head>
<script type="text/javascript">
    $(function(){
        $("#programList").click(function(){
            $(".boful_mobile_docplay_list").show();
            $(".boful_mobile_content_play_content").hide();
        })
        $("#programDes").click(function(){
            $(".boful_mobile_docplay_list").hide();
            $(".boful_mobile_content_play_content").show();
        })

        //记录点播次数;
        var frequency=$("#frequency").val();
        var programId=$("#programId").val();
        var url="${createLink(action: 'frequencyNum')}";
        $.post(url,{frequency:frequency,programId:programId},function(data){

        })
    })
</script>
<body>
<input type="hidden" id="frequency" value="${program?.frequency}">
<input type="hidden" id="programId" value="${program?.id}">
<div class="boful_mobile_searchbox ">
    <!----------播放窗口------------>
    <div class="boful_mobile_back_play_win" id="boful_video_player">
        <img src="${posterLinkNew(program: program,size:'1024x355')}" width="1024" height="355"/>
    </div>
    <!----------播放窗口结束------------>
</div>

<!--检索类别-->
<div class="gridContainer clearfix">
    <div class="boful_mobile_content_recommend">
        <h1><span class="boful_mobile_content_recommend_name">${program?.name}</span></h1>
            <span class="boful_mobile_content_labe">播放${program?.frequency}次</span>
    </div>
    <div class="boful_mobile_content_play_infor">
        <a id="programList" style="cursor: pointer">资源列表</a>
        <a id="programDes" style="cursor: pointer">资源简介</a>
    </div>
    <div style="width: 180px" class="boful_mobile_content_play_download">
        <a onclick="return_apk()" href="javascript:void(0);">请点击安装文档播放器</a>
    </div>
    <div class="boful_mobile_content_play_content" style="display: none">
        <p>${CTools.htmlToBlank(program?.description)}</p>
    </div>
    <div class="boful_mobile_docplay_list">
        <g:each in="${program?.serials}" var="serial">
            <a href="javascript:void(0);" onclick="doc_btn('${mobilePlayLink(fileHash: serial?.fileHash,isPdf: true)}')">
                ${CTools.cutString(serial?.name,15)}
            </a>
        </g:each>
    </div>
</div>
<script type="text/javascript">
    function doc_btn(address){
        try{
            window.JSInterface.playPDF(address);
        }catch (e){}
    }
    function return_apk(){
        window.JSInterface.installAPK();
    }
</script>
</body>
</html>
