<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="index">
    <title>资源下载</title>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'resource_download.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
</head>

<body>
<div class="resource_download_content ">
    <div class="resource_download_list">
        <h1>资源列表</h1>

        <div class="resource_list">
            <table class="table table-hover table-striped resource_list_tab">
                <tbody>
                <tr>
                    <th>资源名称</th>
                    <th width="120" align="center">上传者</th>
                    <th width="120" align="center">操作</th>
                </tr>
                <tr>
                    <td>斯坦福大学：人与计算机的互动</td>
                    <td>resoutce</td>
                    <td>
                        <label><input class="save_icon" type="button" value="" title="收藏"></label>
                        <label><input class="recommend_icon" type="button" value="" title="推荐"></label>
                        <label><input class="download_icon" type="button" value="" title="下载"></label>
                    </td>
                </tr>
                <tr>
                    <td>斯坦福大学：人与计算机的互动</td>
                    <td>resoutce</td>
                    <td>
                        <label><input class="save_icon" type="button" value="" title="收藏"></label>
                        <label><input class="recommend_icon" type="button" value="" title="推荐"></label>
                        <label><input class="download_icon" type="button" value="" title="下载"></label>
                    </td>
                </tr>   <tr>
                    <td>斯坦福大学：人与计算机的互动</td>
                    <td>resoutce</td>
                    <td>
                        <label><input class="save_icon" type="button" value="" title="收藏"></label>
                        <label><input class="recommend_icon" type="button" value="" title="推荐"></label>
                        <label><input class="download_icon" type="button" value="" title="下载"></label>
                    </td>
                </tr>
                <tr>
                    <td>斯坦福大学：人与计算机的互动</td>
                    <td>resoutce</td>
                    <td>
                        <label><input class="save_icon" type="button" value="" title="收藏"></label>
                        <label><input class="recommend_icon" type="button" value="" title="推荐"></label>
                        <label><input class="download_icon" type="button" value="" title="下载"></label>
                    </td>
                </tr>   <tr>
                    <td>斯坦福大学：人与计算机的互动</td>
                    <td>resoutce</td>
                    <td>
                        <label><input class="save_icon" type="button" value="" title="收藏"></label>
                        <label><input class="recommend_icon" type="button" value="" title="推荐"></label>
                        <label><input class="download_icon" type="button" value="" title="下载"></label>
                    </td>
                </tr>
                <tr>
                    <td>斯坦福大学：人与计算机的互动</td>
                    <td>resoutce</td>
                    <td>
                        <label><input class="save_icon" type="button" value="" title="收藏"></label>
                        <label><input class="recommend_icon" type="button" value="" title="推荐"></label>
                        <label><input class="download_icon" type="button" value="" title="下载"></label>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

        <h1>资源评价</h1>

        <div class="boful_video_remark">
            <div class="video_remark_create">
                %{-- 主题:<input id="topic">--}%

                <p></p>
                <textarea class="photo_remark_create1" id="content">发表评论</textarea>

                <div class="remark_bot">
                    <div class="remark_bot_star"><div id="rankScore"></div></div>
                    <label><input type="button" class="photo_remark_create_but" id="remarkBtn" value="发表"></label>
                </div>
            </div>

            <div class="video_remarks">
                <div class="video_remark">
                    <div class="video_remark_user">
                        <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}"/>
                    </div>

                    <div class="video_remark_content">
                        <p class=" resource_talk_user"><span class="resource_user_name">masdrf</span><span
                                class="resource_user_time">2014-05-06</span></p>

                        <p class="resource_talk_user_word">国家级的政治家们似乎总是制造僵局比解决世界性的难题要多。那么，应该由谁来挑起重任解决问题？
                        答案是市长们。政治理论家本杰明·巴伯建议，“让市长们多一点处理全球性事务的权利。”
                        巴伯同时说明这些“哥们儿”们是如何解决他们自己管辖范围的要事，并可能将其方法推广到世界性的范围。</p>

                        <p class="resource_talk_back"><span>回&nbsp;复</span></p>

                    </div>

                </div>

                <div class="resource_talk_back_box">
                    <p class="back_input">
                        <label><textarea class="back_input_word"></textarea></label>
                    </p>

                    <p class="back_bot"><label><input type="button" class="photo_remark_create_but" value="回&nbsp;复">
                    </label></p>
                </div>
            </div>

        </div>
    </div>

    <div class="resource_download_right">
        <h1>资源简介</h1>
        <table>
            <tbody>
            <tr><td>资源名称：</td><td>斯坦福大学：人与计算机的互动</td></tr>
            <tr><td>上传者：</td><td>master</td></tr>
            <tr><td>上传时间：</td><td>2014-05-06</td></tr>
            <tr><td>资源简介：</td><td>斯坦福大学：人与计算机的互动</td></tr>
            </tbody>
        </table>
    </div>


    %{-- <div class="resource_download_right">

     </div>--}%
</div>
</body>
</html>
