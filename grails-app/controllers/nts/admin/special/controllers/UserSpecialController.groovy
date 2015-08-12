package nts.admin.special.controllers

import com.sun.xml.internal.messaging.saaj.packaging.mime.internet.MimeUtility
import grails.converters.JSON
import nts.commity.domain.ForumBoard
import nts.commity.domain.ForumMember
import nts.commity.domain.ForumSharing
import nts.commity.domain.StudyCommunity
import nts.user.domain.Consumer
import nts.user.file.domain.UserCategory
import nts.user.file.domain.UserFile
import nts.user.special.domain.SpecialFile
import nts.user.special.domain.SpecialPoster
import nts.user.special.domain.SpecialTag
import nts.user.special.domain.UserSpecial
import org.apache.http.HttpEntity
import org.apache.http.HttpResponse
import org.apache.http.client.HttpClient
import org.apache.http.client.methods.HttpGet
import org.apache.http.impl.client.HttpClientBuilder
import org.spockframework.compiler.model.Spec

class UserSpecialController {
    def userFileService

    def index() {}

    /**
     * 制作专辑
     * @return
     */
    def saveUserSpecial() {
        def result = [:];
        params.consumer = session.consumer;
        result = userFileService.saveUserSpecial(params);
        return render(result as JSON)
    }


    def querySpecialById() {
        def result = [:];
        def id = params.id;
        UserSpecial special = UserSpecial.get(id as Long);
        List<SpecialFile> fileList = SpecialFile.findAllByUserSpecial(special);
        List<SpecialTag> tags = SpecialTag.findAllBySpecial(special);
        result.special = special;
        result.fileList = fileList;
        result.tags = tags;
        return render(result as JSON)
    }

    def querySpecial() {
        def result = [:];
        List<UserSpecial> specialList = UserSpecial.list();
        return render(result as JSON)
    }
    //通过文件夹获取用户文件
    def queryUserFileByCategoryId() {
        def result = [:];
        def categoryId = params.categoryId;
        def fileList = [];
        //判断文件夹ID是否存在
        if (categoryId) {
            UserCategory userCategory = UserCategory.get(categoryId as Long);
            if (userCategory) {
                //根据文件夹找到自己的文件
                fileList = UserFile.findAllByConsumerAndUserCategory(session.consumer, userCategory);
                result.success = true;
                result.fileList = fileList;
            } else {
                result.success = false;
                result.msg = "文件夹不存在!";
            }
        } else {
            result.success = false;
            result.msg = "错误参数!";
        }
        return render(result as JSON)
    }

    def queryCategoryAndFile() {
        Consumer consumer = session.consumer;
        def res = userFileService.queryCategoryAndFile(params.parentId, consumer);
        def categories = res.categories;
        return render(categories as JSON)
    }

    def deleteSpecialById() {
        def id = params.id;
        if (id) {
            userFileService.deleteSpecialById(id.toString());
        }
        return redirect(controller: 'my', action: 'myAlbumResource')
    }

    def deleteSpecialFileById() {
        def id = params.id;
        def specialId = params.specialId;
        if (id) {
            SpecialFile specialFile = SpecialFile.get(id as Long);
            //userSpec我的文件增加批量移动功能
            UserSpecial userSpecial = UserSpecial.get(specialId as Long);
            ForumSharing forumSharing = ForumSharing.findByUserFile(specialFile.userFile);
            if (forumSharing) forumSharing.delete();
            if (userSpecial?.files.toList().contains(specialFile)) {
                userSpecial?.files.remove(specialFile)
                userSpecial.save();
            }
            userFileService.deleteSpecialFileRemark(specialFile);
            specialFile.delete();
        }
        return redirect(controller: 'my', action: 'myAlbumResourceList', params: [id: specialId])
    }

    def updateSpecial() {
        def id = params.id;
        if (id) {
            userFileService.updateSpecial(params);
        }
        return redirect(controller: 'my', action: 'myAlbumResourceList', params: [id: id])
    }

    def deleteSpecialPoster() {
        def id = params.id;
        UserSpecial userSpecial = null;
        if (id) {
            SpecialPoster specialPoster = SpecialPoster.get(id as Long);
            userSpecial = specialPoster.special;
            userSpecial.removeFromPosters(specialPoster);
            userSpecial.save()
            specialPoster.delete();
        }
        return redirect(controller: 'my', action: 'myAlbumResourceEdit', params: [id: userSpecial?.id])
    }

    def downloadSpecialFile() {
        def id = params.id;

        SpecialFile specialFile = SpecialFile.get(id as Long);
        UserFile userFile = specialFile.userFile;
        String fileHash = userFile.fileHash;
        String fileName = userFile.name;
        String videoSevr = servletContext.getAttribute("videoSevr");
        String videoPort = servletContext.getAttribute("videoPort");    //视频服务器端口
        String url = "http://" + videoSevr + ":" + videoPort + "/bmc/upload/downloadFile?fileHash=" + fileHash;
        HttpClient client = HttpClientBuilder.create().build();
        HttpGet getMethod = new HttpGet(url);
        getMethod.setHeader("Referer", "http://192.168.1.0")
        try {
            HttpResponse httpResponse = client.execute(getMethod);
            HttpEntity httpEntity = httpResponse.getEntity()
            InputStream inputStream = httpResponse.getEntity().getContent()
            response.setContentType("application/octet-stream")
            def userAgent = request.getHeader("User-Agent");
            def newFileName = URLEncoder.encode(fileName, "UTF-8");
            def rtn = "filename=\"" + newFileName + "\"";
            if (userAgent != null) {
                userAgent = userAgent.toLowerCase();
                // IE浏览器，只能采用URLEncoder编码
                if (userAgent.indexOf("msie") != -1) {
                    rtn = "filename=\"" + newFileName + "\"";
                } // Opera浏览器只能采用filename*
                else if (userAgent.indexOf("opera") != -1) {
                    rtn = "filename*=UTF-8''" + newFileName;
                }
                // Safari浏览器，只能采用ISO编码的中文输出
                else if (userAgent.indexOf("safari") != -1) {
                    rtn = "filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO8859-1") + "\"";
                }
                // Chrome浏览器，只能采用MimeUtility编码或ISO编码的中文输出
                else if (userAgent.indexOf("applewebkit") != -1) {
                    newFileName = MimeUtility.encodeText(fileName, "UTF8", "B");
                    rtn = "filename=\"" + newFileName + "\"";
                }
                // FireFox浏览器，可以使用MimeUtility或filename*或ISO编码的中文输出
                else if (userAgent.indexOf("mozilla") != -1) {
                    rtn = "filename*=UTF-8''" + newFileName;
                }

            }


            response.addHeader("Content-disposition", "attachment;" + rtn);
            response.outputStream << inputStream
        } catch (Exception e) {
            log.error(e.message, e);
        }
    }

    def queryAllCommunity() {
        def res = [:];
        Consumer consumer = session.consumer;
        List<StudyCommunity> communityList = StudyCommunity.createCriteria().list {
            eq('state', StudyCommunity.STUDYCOMMUNITY_STATE_PASS)
            order('id', 'asc')
        };
        res.communityList = communityList;
        return render(res as JSON)
    }

    def queryAllBoards() {
        def res = [:];
        Consumer consumer = session.consumer;
        StudyCommunity studyCommunity = null;
        if (params.id) {
            List<ForumBoard> boardList = [];
            studyCommunity = StudyCommunity.get(params.id as Long);
            // 用户创建的小组
            List<ForumBoard> boardCreateList = ForumBoard.findAllByStudyCommunityAndCreateConsumer(studyCommunity, consumer);
            // 用户加入的小组
            List<ForumBoard> boardAddList = ForumMember.createCriteria().list {
                projections {
                    distinct('forumBoard')
                }
                eq('studyCommunity', studyCommunity)
                eq('consumer', consumer)
                order('id', 'asc')
            }

            if(boardCreateList && boardCreateList.size()>0) {
                boardList.addAll(boardCreateList);
            }
            if(boardAddList && boardAddList.size()>0) {
                boardAddList.each {
                    if(boardList.indexOf(it)<0){
                        boardList.add(it);
                    }
                }
            }
            res.boardList = boardList;
        }
        return render(res as JSON)
    }

    //分享专辑到社区板块中
    def specialSharing() {
        params.consumer = session.consumer;
        def res = userFileService.specialSharing(params);
        return render(res as JSON)
    }
    //分享文件到社区板块中
    def userFileSharing() {
        params.consumer = session.consumer;
        def res = userFileService.userFileSharing(params);
        return render(res as JSON)
    }

}
