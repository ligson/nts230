<%@ page import="nts.commity.domain.ForumMember; com.boful.common.file.utils.FileType; java.text.SimpleDateFormat; nts.utils.CTools" %>
<%@ page import="com.boful.common.file.utils.FileType; nts.commity.domain.ForumMember; java.text.SimpleDateFormat; nts.utils.CTools" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>小组首页</title>
    <meta name="layout" content="index">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'communiuty_share_list.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'turnPage.js')}"></script>
</head>

<body>
<div class="commubity_share_title">
    <div class="wrap">
        <div class="commubity_share_nav">
            <a href="${createLink(controller: 'community',action: 'communityIndex',params: [id: studyCommunity?.id])}">社区首页</a>
            %{--<span>/</span>--}%
            %{--<a href="${createLink(controller: 'community', action: 'createSharing', params: [communityId: studyCommunity?.id])}">上传共享</a>--}%
        </div>

        <div class="share_upload">
            %{--<a href="javascript:void(0);" onclick="checkAuthority(1, ${studyCommunity?.id},null,null,null)">上传共享</a>--}%%{--${createLink(controller: 'community', action: 'createSharing', params: [communityId: studyCommunity?.id])}--}%
        </div>
    </div>
</div>


<div class="commubity_share_plate">

    <div class="commubity_share_plate_left">
        <div class="community_see_s_tit">
            <h1><span class="see_share_icon"></span>共享学习</h1>
        </div>

        <div class="commubity_share_plate_items">
            <div class="commubity_share_plate_items_nav">
                <table>
                    <tbody>
                    <tr>
                        <td class="share_class">资源类型</td>
                        <td class="share_names">资源名称</td>
                        <td class="share_user">贡献者</td>
                        <td class="share_download">下载</td>
                        <td class="share_time">共享时间</td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <g:each in="${sharings}" var="sharing">
                <div class="commubity_share_plate_item">
                    <table>
                        <tbody>
                        <tr>
                            <%
                                if (FileType.isVideo(new File(sharing?.url).getName())) {
                            %><td class="share_class_icon share_class" title="视频"></td><%
                            } else if (FileType.isImage(new File(sharing?.url).getName())) {
                        %><td class="share_class_icon1 share_class" title="图片"></td><%
                            } else if (FileType.isDocument(new File(sharing?.url).getName()) || new File(sharing?.url).getName().endsWith("pdf") || new File(sharing?.url).getName().endsWith("PDF")) {
                        %><td class="share_class_icon2 share_class" title="文档"></td><%
                            } else if (new File(sharing?.url).getName().endsWith("swf") || new File(sharing?.url).getName().endsWith("SWF")) {
                        %><td class="share_class_icon2 share_class" title="flash动画"></td><%
                            } else {
                        %><td class="share_class_icon4 share_class" title="未知"></td><%
                            }

                        %>

                            <td class="share_names"><p>

                                <g:if test="${FileType.isVideo(sharing?.url)||FileType.isImage(sharing?.url)||FileType.isDocument(sharing?.url)}">
                                    <a href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id: sharing?.id,communityId: studyCommunity?.id])}">${CTools.cutString(sharing?.name, 20)}</a>
                                </g:if>
                                <g:else>
                                    <a href="${createLink(controller: 'community', action: 'downloadSharing', params: [id: sharing?.id, fileHash: sharing?.fileHash, fileType: sharing?.fileType])}">专辑描述：${CTools.cutString(sharing?.description, 20)}</a>
                                </g:else>
                            </p></td>
                            <td class="share_user">
                                <span class="share_user_photo">
                                    <img src="${generalUserPhotoUrl(consumer: sharing?.shareConsumer)}" width="28"
                                         height="28"
                                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                                </span>
                                <span class="share_user_name">${CTools.cutString(sharing?.shareConsumer?.name, 10)}</span>
                            </td>
                            <td class="share_download" id="download${sharing?.id}">
                                <g:if test="${(ForumMember.findByConsumer(session?.consumer))||(sharing?.shareConsumer?.name==session.consumer.name)}">
                                    <a class="share_class_iconss" title="下载" style="cursor: pointer" href="javascript:void(0);" onclick="checkAuthority(2, ${studyCommunity?.id}, ${sharing?.id}, '${sharing?.fileHash}', '${sharing?.fileType}')">%{--${createLink(controller: 'community', action: 'downloadSharing', params: [communityId: studyCommunity.id, id: sharing?.id, fileHash: sharing?.fileHash, fileType: sharing?.fileType])}--}%
                                    </a></g:if>
                                <span class="download_number">${sharing?.download}次</span>
                            </td>
                            <td class="share_time">${new SimpleDateFormat("yyyy-MM-dd").format(sharing?.dateCreated)}</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </g:each>


        %{--<div class="commubity_share_plate_item">
            <table>
                <tbody>
                <tr>
                    <td class="share_class_icon4 share_class"></td>
                    <td class="share_names"><p>专辑描述：《纸牌屋》由大卫·芬奇、鲍尔·威利蒙联合制作，凯文·史派西主演，改编自英国同名小说</p></td>
                    <td class="share_user">
                        <span class="share_user_photo"><img
                                src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item15.png')}"/>
                        </span>
                        <span class="share_user_name">大卫·芬奇</span></td>
                    <td class="share_download">
                        <span class="share_class_iconss" title="下载">

                        </span>
                        <span class="download_number">500次</span>
                    </td>
                    <td class="share_time">2013-05-06</td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="commubity_share_plate_item">
            <table>
                <tbody>
                <tr>
                    <td class="share_class_icon3 share_class"></td>
                    <td class="share_names"><p>专辑描述：《纸牌屋》由大卫·芬奇、鲍尔·威利蒙联合制作，凯文·史派西主演，改编自英国同名小说</p></td>
                    <td class="share_user">
                        <span class="share_user_photo"><img
                                src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item15.png')}"/>
                        </span>
                        <span class="share_user_name">大卫·芬奇</span></td>
                    <td class="share_download">
                        <span class="share_class_iconss" title="下载">

                        </span>
                        <span class="download_number">500次</span>
                    </td>
                    <td class="share_time">2013-05-06</td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="commubity_share_plate_item">
            <table>
                <tbody>
                <tr>
                    <td class="share_class_icon1 share_class"></td>
                    <td class="share_names"><p>专辑描述：《纸牌屋》由大卫·芬奇、鲍尔·威利蒙联合制作，凯文·史派西主演，改编自英国同名小说</p></td>
                    <td class="share_user">
                        <span class="share_user_photo"><img
                                src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item15.png')}"/>
                        </span>
                        <span class="share_user_name">大卫·芬奇</span></td>
                    <td class="share_download">
                        <span class="share_class_iconss" title="下载">

                        </span>
                        <span class="download_number">500次</span>
                    </td>
                    <td class="share_time">2013-05-06</td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="commubity_share_plate_item">
            <table>
                <tbody>
                <tr>
                    <td class="share_class_icon2 share_class"></td>
                    <td class="share_names"><p>专辑描述：《纸牌屋》由大卫·芬奇、鲍尔·威利蒙联合制作，凯文·史派西主演，改编自英国同名小说</p></td>
                    <td class="share_user">
                        <span class="share_user_photo"><img
                                src="${resource(dir: 'skin/blue/pc/images', file: 'aa_ouknow_community_bananr_item15.png')}"/>
                        </span>
                        <span class="share_user_name">大卫·芬奇</span></td>
                    <td class="share_download">
                        <span class="share_class_iconss" title="下载">

                        </span>
                        <span class="download_number">500次</span>
                    </td>
                    <td class="share_time">2013-05-06</td>
                </tr>
                </tbody>
            </table>
        </div>--}%
        </div>
    </div>
</div>

<div class="page">
    <g:paginate controller="community" action="communityShareList" total="${total}"/>
</div>
<script type="text/javascript" language="JavaScript">
    function checkAuthority(type, communityId, sharingId, fileHash, fileType){
        $.ajax({
            url: baseUrl + 'community/checkAuthority',
            data:"type="+type+"&communityId="+communityId,
            success:function(data){
                if(data == 'true'){
                    if(type == 1){
                        window.location.href = baseUrl + 'community/createSharing?communityId='+communityId ;
                    }
                    else{
                        window.location.href = baseUrl + 'community/downloadSharing?communityId='+communityId+"&id="+sharingId+'&fileHash='+fileHash+'&fileType='+fileType ;
                    }
                }
                else{
                    if(type == 1){
                        alert('对不起，您没有权限上传共享！');
                    }
                    else{
                        alert('对不起，您没有权限下载共享！');
                    }
                }
            }
        })

    }
</script>
</body>
</html>