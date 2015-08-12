<%@ page import="com.boful.common.file.utils.FileType; nts.utils.CTools; nts.program.domain.Serial" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8"/>
    <r:require modules="jwplayer,jquery"/>
    <r:layoutResources/>
    <r:layoutResources/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_index.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_views.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_course_list.css')}">

    <title>课程详细</title>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
</head>
<script type="text/javascript">
    $(function () {
        $(".boful_coures_item_present_title a").click(function () {
            var coures_conteng = $(".boful_coures_item_present_infor_conteng");
            var coures_lists = $(".boful_coures_item_present_infor_lists");
            var coures_add = $(".boful_coures_item_present_add");
            var index = $(".boful_coures_item_present_title a").index(this);
            if (index == 0) {
                coures_conteng.css("display", "block");
                coures_lists.css("display", "none");
                coures_add.css("display", "none");
            }
            if (index == 1) {
                coures_conteng.css("display", "none");
                coures_lists.css("display", "block");
                coures_add.css("display", "none");
            }
            if (index == 2) {
                coures_conteng.css("display", "none");
                coures_lists.css("display", "none");
                coures_add.css("display", "block");
            }
        })
    })
</script>
<script type="text/javascript">
    var swfFileUrl = "${playDocumentLinksNew(serial:Serial.get(querySerialFirstId(program: program) as long))}";
    var firstSerialAddress = "${mobilePlayLink(fileHash:Serial.get(querySerialFirstId(program: program) as long)?.fileHash,isPdf: false)}";
    $(function () {
        var playList = ${playLinksNew(serials:[Serial.get(querySerialFirstId(program: program) as long)])};

        jwplayerInit("boful_video_player", playList, "100%", "100%", true, false);

        jwplayer("boful_video_player").onPlay(function(){
            try{
                jwplayer("boful_video_player").stop();
                window.JSInterface.startVideo(firstSerialAddress);
            } catch(e){

            }
        });
    });

    function serial_btn(address) {
        try {
            jwplayer("boful_video_player").stop();
            window.JSInterface.startVideo(address);
        } catch (e) {

        }
    }
    function doc_btn(address) {
        try {
            window.JSInterface.playPDF(address);
        } catch (e) {
        }
    }
    function img_btn(address) {
        try {
            window.JSInterface.playImage(address);
        } catch (e) {

        }
    }
</script>

<body>
<div class="gridContainer  clearfix">
    <!-----------图片-------------->
    %{--<div class="boful_coures_item_image_title">巴黎高等商学院公开课</div>--}%

    %{--<div class="boful_coures_item_image_bg"></div>--}%

    <div class="boful_coures_item_image">
        <!----------播放窗口------------>
        <div class="boful_mobile_back_play_win" id="boful_video_player">
        </div>
        <!----------播放窗口结束------------>
    </div>

    <div class="boful_coures_item_present">
        <div class="boful_coures_item_present_title">
            <a class="coures_name_introduce" href="#">课程简介</a>
            <a class="coures_name_list" href="#">课时列表</a>
            <a class="coures_name_add" href="#">课程附件</a>
        </div>

        <div class="boful_coures_item_present_infor">
            <!----------课程简介-------->
            <div class="boful_coures_item_present_infor_conteng">
                <table>
                    <tbody>
                    <tr>
                        <td width="20%">资源名称：</td>
                        <td width="80%">${program?.name}</td>
                    </tr>
                    <tr>
                        <td>讲师：</td>
                        <td>${program?.actor}</td>
                    </tr>
                    <tr>
                        <td>上传人：</td>
                        <td>${program?.consumer?.name}</td>
                    </tr>
                    <tr>
                        <td>资源简介：</td>
                        <td><p>${CTools.cutString(CTools.htmlToBlank(program?.description), 50)}</p>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <!----------课程列表-------->
            <div class="boful_coures_item_present_infor_lists" style="display: none">
                <g:each in="${videoSerial}" var="serial" status="sta">
                    <a onclick="serial_btn('${mobilePlayLink(fileHash:serial.fileHash,isPdf: false)}')"
                       href="javascript:void(0);" title="${serial?.name}">
                        <div class="boful_coures_item_present_infor_list">
                            <span class="ingfor_course_number">第${sta + 1}课时</span>

                            <p>${CTools.cutString(serial?.name, 10)}</p><span class="ingfor_course_paly"></span>
                        </div></a>
                </g:each>

            </div>
            <!----------课程附件-------->
            <div class="boful_coures_item_present_add" style="display: none">
                <g:each in="${otherSerial}" var="seri" status="ss">
                    <a href="javascript:void(0);"
                        <g:if test="${FileType.isDocument(seri?.filePath) || seri.filePath.endsWith("pdf") || seri.filePath.endsWith("PDF")}">
                            onclick="doc_btn('${mobilePlayLink(fileHash: seri?.fileHash, isPdf: true)}')"</g:if>
                        <g:elseif test="${FileType.isImage(seri?.filePath)}">
                            onclick="img_btn('${mobilePlayLink(fileHash: seri?.fileHash, isPdf: false)}')"</g:elseif>
                        <g:elseif test="${FileType.isAudio(seri?.filePath)}">
                            onclick="serial_btn('${mobilePlayLink(fileHash: seri?.fileHash, isPdf: false)}')"</g:elseif>>
                        <div class="boful_coures_item_present_add_sup">
                            <g:if test="${FileType.isDocument(seri?.filePath) || seri.filePath.endsWith("pdf") || seri.filePath.endsWith("PDF")}">
                                <span class="course_sup_word"></span>
                            </g:if>
                            <g:if test="${FileType.isImage(seri?.filePath)}">
                                <span class="course_sup_img"></span>
                            </g:if>
                            <g:if test="${FileType.isAudio(seri?.filePath)}">
                                <span class="course_sup_voice"></span>
                            </g:if>
                            <p>${CTools.cutString(seri?.name, 10)}</p>
                        </div></a>
                </g:each>
            %{--<div class="boful_coures_item_present_add_sup">
                <span class="course_sup_word"></span>

                <p>dsfgdgd</p>
            </div>

            <div class="boful_coures_item_present_add_sup">
                <span class="course_sup_voice"></span>

                <p>到底追求什么才是最重要的</p>
            </div>

            <div class="boful_coures_item_present_add_sup">
                <span class="course_sup_img"></span>

                <p>到底追求什么才是最重要的</p>
            </div>--}%
            </div>
        </div>
    </div>
</div>

</body>
</html>