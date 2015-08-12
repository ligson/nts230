package nts.community.services

import grails.transaction.Transactional
import nts.commity.domain.*
import nts.system.domain.LogsPublic
import nts.user.domain.Consumer
import nts.user.file.domain.UserFile
import nts.user.special.domain.SpecialComment
import nts.user.special.domain.SpecialFile
import nts.user.special.domain.SpecialFileRemark
import nts.user.special.domain.SpecialScore
import nts.user.special.domain.UserSpecial
import nts.utils.CTools
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.multipart.commons.CommonsMultipartFile

@Transactional
class CommunityMgrService {
    def utilService;
    /**
     * 板块保存,saveOrUpdate
     * @param params
     * @return
     */
    public Map forumBoradSave(Map params) {
        def result = [:];
        result.success = true;
        result.notFind = false;
        def session = utilService.getSession();
        def servletContext = utilService.getServletContext();
        def request = utilService.getRequest();

        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunity = params.studyCommunity;
        //板块管理员
        def forumBoardManagerId = params.forumBoardManagerId;
        String name = params.forumBoardname;
        String description = CTools.htmlToBlank(params.forumBoardDescription);
        def forumBoardId = params.forumBoardId;

        ForumBoard forumBoard = null;
        def realPath = servletContext.getRealPath("/");
        //提交数据
        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
        def file = multipartRequest.getFile("forumBoardPhoto");
        //判断update还是save,判断是不是社区管理员
        if (!forumBoardId || forumBoardId == "" && params.type == "community") {
            forumBoard = new ForumBoard();
            //如果是update,那studyCommunity就不用修改了，如果是save，那就要得到studyCommunity，然后赋值
            forumBoard.studyCommunity = studyCommunity;
            forumBoard.createConsumer = session.consumer;
            //社区管理员在创建板块的时候不需要再去审批
            forumBoard.state = 1;
            result.saveOrUpdate = "save";
            forumBoard.photo = "default.jpg";
        } else {
            forumBoard = ForumBoard.findById(Long.parseLong(forumBoardId));
            //判断修改的板块是否属于当前社区，是是否当前用户所创建，或是是板块管理员在修改,如果不是则，设置为null，
            if (!(forumBoard && forumBoard.studyCommunity.id == studyCommunity.id && (params.type == 'community' || forumBoard.createConsumer.id == session.consumer.id))) {
                forumBoard = null;
            } else {
                //更改板块管理员，也就是更改板块的创建者
                if (forumBoardManagerId) {
                    Consumer forumBoardManager = Consumer.get(Long.parseLong(forumBoardManagerId));
                    if (forumBoardManager) {
                        //将原管理员变更为小组成员
                        ForumMember member = ForumMember.findByConsumerAndForumBoard(forumBoard.createConsumer, forumBoard);
                        if(!member) {
                            member = new ForumMember();
                            member.consumer =forumBoard.createConsumer;
                            member.forumBoard = forumBoard;
                            member.studyCommunity = forumBoard.studyCommunity;
                            member.state = 0;
                            member.save(flush: true);
                        }

                        // 修改管理员
                        forumBoard.createConsumer = forumBoardManager;
                    }
                } else {
                }
            }
            result.saveOrUpdate = "update";
        }
        //判断forumBoard是否存在
        if (forumBoard) {
            //判断是否上传文件
            if (file && file.getContentType().startsWith("image")) {
                //得到文件后缀名
                String fileType = CTools.readExtensionName(file.getOriginalFilename());
                //上传路径
                String relativePath = "upload/communityImg/forumboard";
                File relativeFile = new File(realPath + relativePath) ;
                if(!relativeFile.exists())
                {
                    relativeFile.mkdirs()
                }
                forumBoard.photo = new Date().getTime() + "." + fileType;//得到当前毫秒值，负责文件重复
                //上传文件
                file.transferTo(new File(realPath + relativePath + "/" + forumBoard.photo));
            }
            //赋值
            forumBoard.type = 2;
            forumBoard.name = name;
            forumBoard.description = description;

            //保存文件
            if (!forumBoard.hasErrors() && forumBoard.save(flash: true)) {
                result.message = "创建小组成功";
                result.success = true;
            } else {
                result.forumBoard = forumBoard;
                result.message = "创建小组失败，参数错误";
                result.success = false;
            }
        } else {
            result.notFind = true;
            result.success = false;
            result.message = "修改小组错误!!!";
        }
        return result;
    }
    /**
     * 学习社区公告公告save
     * @param params
     * @return
     */
    public Map noticeSave(Map params) {
        def result = [:];
        result.success = false;
        def session = utilService.getSession();
        def studyCommunity = params.studyCommunity;

        String name = params.name;
        String description = CTools.htmlToBlank(params.description);
        def noticeId = params.noticeId;

        Notice notice = null;
        if (name && description && name.length() <= 100 && description.length() <= 300) {
            //判断前台是save还是update
            if (!noticeId || noticeId == "") {
                notice = new Notice();
                notice.studyCommunity = studyCommunity;
                result.saveOrUpdate = "save";
            } else {
                notice = Notice.get(noticeId)
                result.saveOrUpdate = "update";
                //如果是update，判断更新的notice是否是当前板块,如果不是，则设置为null；
                if (!notice.studyCommunity.id == studyCommunity.id) {
                    notice = null
                }
            }
            if (notice) {
                notice.name = name;
                notice.description = description;
                if (!notice.hasErrors() && notice.save(false: true)) {
                    result.success = true;
                    result.message = "保存成功!!";
                } else {
                    result.notice = notice;
                    result.success = false;
                    result.message = "保存失败！请重新填写!!";
                }
            }
        } else {
            result.success = false;
            result.message = "保存失败！参数错误!!";
        }
        return result;
    }
    /**
     * 公告删除
     * @param params
     * @return
     */
    public Map noticeDelete(Map params) {
        def result = [:];
        result.success = false;
        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunity = params.studyCommunity;
        //得到notice的id，可能有批量删除
        String noticeIds = params.noticeId;
        if ((params.type=='community') && noticeIds) {
            String[] ids = noticeIds.split(",");
            Notice notice = null;
            for (String noticeId : ids) {
                notice = Notice.get(Integer.parseInt(noticeId));
                //只能删除该社区的
                if (notice && notice.studyCommunity.id == studyCommunity.id) {
                    notice.delete(flash: true);
                }
            }
            result.success = true;
            result.message = "删除成功!!!";
        } else {
            result.success = false;
            result.message = "删除失败!!!";
        }
        return result;
    }
    /**
     * 社区成员踢出
     * @param params
     * @return
     */
    public Map deletemMember(Map params) {
        def session = utilService.getSession();
        def result = [:];
        result.success = false;
        def studyCommunityManager = params.studyCommunityManager;
        def forumMemberIds = params.forumMemberIds;
        try {
            Consumer consumer = session.consumer;
            //可能是批量删除
            String[] ids = forumMemberIds.split(",");
            for (String forumMemberId : ids) {
                ForumMember forumMember = ForumMember.get(Long.parseLong(forumMemberId));
                //判断查询数据是否存在，如果是社区管理员在删除，那就直接删除，如果是板块管理员，则对查询的数据进行判断，是否是当前用户创建的板块
                if (forumMember) {
                    //如果是社区管理员在删除，那就直接删除,因为是依据社区查询出来的，所以不需要的，所以不需要判断是否属于当前社区,   或者该删除对象属于当前用户所创建的社区
                    if (params.type == 'community' || (forumMember.forumBoard.createConsumer.id == consumer.id)) {
                        //如果是社区管理员在删除的时候，该成员是板块管理员，那么就收回该成员的管理员权限
                        if (forumMember.forumBoard.createConsumer.id == forumMember.consumer.id) {
                            ForumBoard forumBoard = forumMember.forumBoard;
                            forumBoard.createConsumer = consumer;
                            forumBoard.save(flush: true);
                        }
                        forumMember.delete();
                    }
                }
            }
            result.success = true;
            result.message = "踢出成功";
        } catch (Exception e) {
            log.error(e.message, e);
            result.success = false;
            result.message = "踢出失败";
        }
        return result;
    }
    /**
     * 修改板块成员的属性状态
     * @param params
     * @return
     */
    public Map changeForumMemberAttr(Map params) {
        def result = [:];
        result.success = true;
        result.forumMemberAttr = "";
        def session = utilService.getSession();
        def attrName = params.attrName;
        def forumMemberId = params.forumMemberId;
        def studyCommunityManager = params.studyCommunityManager;
        //可能是批量删除
        if (attrName && forumMemberId) {
            try {
                String[] ids = forumMemberId.split(",");
                for (String id : ids) {
                    def forumMember = ForumMember.get(Long.parseLong(id));
                    if (forumMember) {
                        //如果是社区管理员在删除，那就直接删除,因为是依据社区查询出来的，所以不需要的，所以不需要判断是否属于当前社区,   或者该删除对象属于当前用户所创建的社区
                        if (params.type == 'community' || (forumMember.forumBoard.createConsumer.id == session.consumer.id)) {
                            if ("canDownload".equals(attrName)) {
                                if (forumMember.canDownload) {
                                    forumMember.canDownload = false;
                                    result.forumMemberAttr = "否"
                                } else {
                                    forumMember.canDownload = true;
                                    result.forumMemberAttr = "是"
                                }
                            } else if ("canUpload".equals(attrName)) {
                                if (forumMember.canUpload) {
                                    forumMember.canUpload = false;
                                    result.forumMemberAttr = "否"
                                } else {
                                    forumMember.canUpload = true;
                                    result.forumMemberAttr = "是"
                                }
                            } else if ("canCreateArticle".equals(attrName)) {
                                if (forumMember.canCreateArticle) {
                                    forumMember.canCreateArticle = false;
                                    result.forumMemberAttr = "否"
                                } else {
                                    forumMember.canCreateArticle = true;
                                    result.forumMemberAttr = "是"
                                }
                            } else if ("canReply".equals(attrName)) {
                                if (forumMember.canReply) {
                                    forumMember.canReply = false;
                                    result.forumMemberAttr = "否"
                                } else {
                                    forumMember.canReply = true;
                                    result.forumMemberAttr = "是"
                                }
                            } else if ("canComment".equals(attrName)) {
                                if (forumMember.canComment) {
                                    forumMember.canComment = false;
                                    result.forumMemberAttr = "否"
                                } else {
                                    forumMember.canComment = true;
                                    result.forumMemberAttr = "是"
                                }
                            } else if ("canPlay".equals(attrName)) {
                                if (forumMember.canPlay) {
                                    forumMember.canPlay = false;
                                    result.forumMemberAttr = "否"
                                } else {
                                    forumMember.canPlay = true;
                                    result.forumMemberAttr = "是"
                                }
                            } else if ("state".equals(attrName)) {
                                def state = params.state;
                                forumMember.state = Integer.parseInt(state);
                            }
                            forumMember.save(flush: true);
                        }
                    }
                }
                result.message = "修改成功!!!";
            } catch (Exception e) {
                log.error(e.message, e);
                result.success = false;
                result.message = "修改失败!!!";
            }
        }
        else if(params.forumBoardId){
            def forumBoard = ForumBoard.get(params.forumBoardId as long)
            def forumMember = ForumMember.findByForumBoardAndConsumer(forumBoard, session.consumer)
            if(forumMember){
                forumMember.state = 2;
                if (!forumMember.save()) {
                    forumMember.errors.each {
                        println it
                    }
                }
                result.success = true ;
                result.message = "退出成功！"
            }
            else{
                result.success = false;
                result.message = "退出失败!";
            }
        }
        else {
            result.success = false;
            result.message = "修改失败!!!";
        }
        return result;
    }
    /**
     * 帖子删除
     * @param params
     * @return
     */
    public Map forumMainArticleDelete(Map params) {
        def result = [:];
        result.success = false;
        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunity = params.studyCommunity;
        def session = utilService.getSession();
        Consumer consumer = session.consumer
        String forumMainArticleIds = params.forumMainArticleId;
        try {
            String[] ids = forumMainArticleIds.split(",");
            for (String forumMainArticleId : ids) {
                ForumMainArticle forumMainArticle = ForumMainArticle.get(Long.parseLong(forumMainArticleId));
                if (forumMainArticle) {
                    //是社区管理员，且删除的帖子，且属于该社区，或者该帖子是属于当前用户所创建
                    if ((params.type == 'community' && forumMainArticle.forumBoard.studyCommunity.id == studyCommunity.id) || (forumMainArticle.forumBoard.createConsumer.id == consumer.id)) {
                        forumMainArticle.delete(flash: true);
                    }
                }
            }
            result.success = true;
            result.message = "删除成功！！";
        } catch (Exception e) {
            log.error(e.message, e);
            result.deleteSuccess = false;
            result.msg = "删除失败！！";
        }
        return result;
    }
    /**
     * 精华贴修改
     * @param params
     * @return
     */
    public Map changeElite(Map params) {
        def result = [:];
        result.success = false;
        def studyCommunityManager = params.studyCommunityManager;
        def type = params.type;
        def studyCommunity = params.studyCommunity;
        def session = utilService.getSession();
        def forumMainArticleId = params.forumMainArticleId;
        Consumer consumer = session.consumer;
        try {
            ForumMainArticle forumMainArticle = ForumMainArticle.get(forumMainArticleId);
            if (forumMainArticle) {
                //是社区管理员，且该帖子是属于该社区  或者 帖子属于的社区是当前用户所创建，也就是社区管理员
                if ((type && type == 'community' && forumMainArticle.forumBoard.studyCommunity.id == studyCommunity.id) || (forumMainArticle.forumBoard.createConsumer.id == consumer.id)) {
                    if (forumMainArticle.isElite == 0) {
                        forumMainArticle.isElite = 1;
                        result.success = true;
                        result.message = "是";
                    } else {
                        forumMainArticle.isElite = 0;
                        result.success = true;
                        result.message = "否";
                    }
                    forumMainArticle.save(flush: true);
                } else {

                }
            }
        } catch (Exception e) {
            log.error(e.message, e);
            result.success = false;
        }
        return result;
    }
    /**
     * 置顶贴修改
     * @param params
     * @return
     */
    public Map changeTop(params) {
        def result = [:];
        result.success = false;
        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunity = params.studyCommunity;
        def session = utilService.getSession();
        def forumMainArticleId = params.forumMainArticleId;
        Consumer consumer = session.consumer;

        try {
            ForumMainArticle forumMainArticle = ForumMainArticle.get(forumMainArticleId);
            if (forumMainArticle) {
                //是社区管理员，且该帖子是属于该社区  或者 帖子属于的社区是当前用户所创建，也就是社区管理员
                if ((params.type == 'community' && forumMainArticle.forumBoard.studyCommunity.id == studyCommunity.id) || (forumMainArticle.forumBoard.createConsumer.id == consumer.id)) {
                    if (forumMainArticle.isTop == 0) {
                        forumMainArticle.isTop = 1;
                        result.success = true;
                        result.message = "是";
                    } else {
                        forumMainArticle.isTop = 0;
                        result.success = true;
                        result.message = "否";
                    }
                    forumMainArticle.save(flush: true);
                }
            }
        } catch (Exception e) {
            log.error(e.message, e);
            result.success = false;
        }
        return result;
    }
    /**
     * 共享删除
     * @param params
     * @return
     */
    public Map sharingDelete(Map params) {
        def result = [:];
        String sharingId = params.sharingId;
        List<Long> ids = [];

        if(sharingId){
            if(sharingId.indexOf(',')!=-1){
                def strs=sharingId.split(',');
                strs.each {
                    ids.add(it as Long)
                }
            }else{
                ids.add(sharingId as Long);
            }
            ids?.each {
                ForumSharing forumSharing = ForumSharing.get(it);
                forumSharing.delete();
                result.success=true;
            }
        }else {
            result.success=false;
            result.msg = "参数不全";
        }
        return result;
    }
    /**
     * 共享文件播放修改
     * @param params
     * @return
     */
    public Map changeCanPlay(Map params) {
        def result = [:];
        result.success = false;
        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunity = params.studyCommunity;
        def sharingId = params.sharingId;
        try {
            Sharing sharing = Sharing.get(sharingId);
            if (Sharing) {
                //社区管理员，且属于该社区
                if (params.type == 'community' && sharing.studyCommunity.id == studyCommunity.id) {
                    if (sharing.canPlay) {
                        sharing.canPlay = false;
                        result.success = true;
                        result.message = "否";
                    } else {
                        sharing.canPlay = true;
                        result.success = true;
                        result.message = "是";
                    }
                }
                sharing.save(flush: true);
            }
        } catch (Exception e) {
            log.error(e.message, e);
            result.success = false;
        }
        return result;
    }
    /**
     * 共享文件下载修改
     * @param params
     * @return
     */
    public Map changeCanDownload(Map params) {
        def result = [:];
        def sharingId = params.sharingId;
        def canDownload = params.canDownload;
        if(sharingId){
            ForumSharing sharing = ForumSharing.get(sharingId as Long);
            if(canDownload=="true"){
                sharing.canDownload=false;
                result.msg = "否";
            }else if(canDownload=="false"){
                sharing.canDownload=true;
                result.msg = "是";
            }
            if(sharing.save(flush: true)&&(!sharing.hasErrors())){
                result.success=true;
            }else {
                result.success=false;
                result.msg = "设置失败";
            }
        }else {
            result.success=false;
            result.msg = "参数不全";
        }
        return result;
    }
    /**
     * 保存活动
     * @param params
     * @return
     */
    public Map activitySave(Map params) {
        def result = [:];
        result.success = false;
        def session = utilService.getSession();
        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunity = params.studyCommunity;
        if ("0".equals(params.isOpen)) {
            params.isOpen = false;
        } else if ("1".equals(params.isOpen)) {
            params.isOpen = true;
        }
        def description = CTools.htmlToBlank(params.description);
        Activity activity = new Activity(
                name: params.name,
                description: description,
                isOpen: params.isOpen,
                photo: params.image,
                startTime: params.startTime,
                endTime: params.endTime,
                dateCreated: new Date(),
                createConsumer: session.consumer,
                studyCommunity: studyCommunity
        )
        studyCommunity.addToActivitys(activity)
        if (!activity.hasErrors() && activity.save()) {
            result.message = "活动 ${activity.name} 发布成功";
            result.success=true;
            String photo = session.consumer?.photo == null || session.consumer?.photo == "" ? "/images/default.gif" : session.consumer?.photo
            def logsDescription = "<li><div class='qc01l'><img src='" + photo + "' class='qimg' onerror='this.src='/skin/blue/pc/front/images/photo.gif''/><a href='javascript:void(0)' onclick='sendMessage(" + session.consumer.id + ")' class='g3f'>发送消息</a></div><div class='qc01r'>" + session.consumer.name + "&nbsp;&nbsp;发起了活动<a href='/activity/show?id=" + activity.id + "' class='gblue qck qh2'>查看</a><p>" + params.name + "</p></div></li>";
            /*def logsDescription = "<li><div class='qc01l'><img src='"+photo+"' class='qimg' /><a href='javascript:void(0)' onclick='sendMessage("+session.consumer.id+")' class='g3f'>发送消息</a></div><div class='qc01r'>"+session.consumer.name+"&nbsp;&nbsp;发起了活动<a href='/activity/show?id="+activity.id+"' class='gblue qck qh2'>查看</a><p>"+params.name+"</p></div></li>"*/
            def logsPublic = new LogsPublic(
                    studyCommunity_id: studyCommunity.id,
                    description: logsDescription,
                    dateCreated: new Date(),
                    type: LogsPublic.type_activity,
                    typeId: activity.id
            )
            if (!logsPublic.hasErrors() && logsPublic.save()) {
                result.message = "活动创建成功";
                result.success=true;
            }
        } else {
            activity.errors.each {
                println it
            }
            result.message = "活动创建失败"
        }
        return result;
    }/**
     * 更新活动
     * @param params
     * @return
     */
    public Map activityUpdate(Map params) {
        def result = [:];
        result.success = false;
        def session = utilService.getSession();
        def activityId = params.activityId;
        def studyCommunity = null;
        if (params.studyCommunityId) {
            studyCommunity = StudyCommunity.findById(params.studyCommunityId as long);
        }
        def activity = Activity.get(activityId);
        if ("0".equals(params.isOpen)) {
            params.isOpen = false;
        } else if ("1".equals(params.isOpen)) {
            params.isOpen = true;
        }
        def description = CTools.htmlToBlank(params.description);
        activity.name = params.name;
        activity.description = description;
        activity.isOpen = params.isOpen;
        activity.photo = params.image;
        activity.startTime = params.startTime;
        activity.endTime = params.endTime;

        if (!activity.hasErrors() && activity.save()) {
            result.message = "活动 ${activity.name} 修改成功"
            String photo = session.consumer?.photo == null || session.consumer?.photo == "" ? "/images/default.gif" : session.consumer?.photo
            def logsDescription = "<li><div class='qc01l'><img src='" + photo + "' class='qimg' onerror='this.src='/skin/blue/pc/front/images/photo.gif''/><a href='javascript:void(0)' onclick='sendMessage(" + session.consumer.id + ")' class='g3f'>发送消息</a></div><div class='qc01r'>" + session.consumer.name + "&nbsp;&nbsp;发起了活动<a href='/activity/show?id=" + activity.id + "' class='gblue qck qh2'>查看</a><p>" + params.name + "</p></div></li>";
            /*def logsDescription = "<li><div class='qc01l'><img src='"+photo+"' class='qimg' /><a href='javascript:void(0)' onclick='sendMessage("+session.consumer.id+")' class='g3f'>发送消息</a></div><div class='qc01r'>"+session.consumer.name+"&nbsp;&nbsp;发起了活动<a href='/activity/show?id="+activity.id+"' class='gblue qck qh2'>查看</a><p>"+params.name+"</p></div></li>"*/
            def logsPublic = new LogsPublic(
                    studyCommunity_id: studyCommunity?.id,
                    description: logsDescription,
                    dateCreated: new Date(),
                    type: LogsPublic.type_activity,
                    typeId: activity.id
            )
            if (!logsPublic.hasErrors() && logsPublic.save()) {
                result.message = "活动修改成功"
            }
        } else {
            activity.errors.each {
                println it
            }
            result.message = "活动修改失败"
        }
        return result;
    }

    /**
     * 版块状态修改
     * @param params
     * @return
     */
    public Map changeForumBoardState(Map params) {
        def result = [:];
        result.success = false;
        def studyCommunity = StudyCommunity.get(params.studyCommunityId as Long);
        def session = utilService.getSession();
        def forumBoardId = params.forumBoardId;
        Consumer consumer = session.consumer;
        try {
            ForumBoard forumBoard = ForumBoard.get(forumBoardId as Long);
            if (forumBoard) {
                //该帖子是属于该社区  或者 帖子属于的社区是当前用户所创建，也就是社区管理员
                if ((forumBoard.studyCommunity.id == studyCommunity.id) || (forumBoard.createConsumer.id == consumer.id)) {
                    if (forumBoard.state == 0) {
                        forumBoard.state = 1;
                        result.success = true;
                        result.message = "审核通过";
                    } else {
                        forumBoard.state = 0;
                        result.success = true;
                        result.message = "待审核";
                    }
                    forumBoard.save(flush: true);
                }
            }
        } catch (Exception e) {
            log.error(e.message, e);
            result.success = false;
        }
        return result;
    }

    /**
     * 版块状态修改
     * @param params
     * @return
     */
    public Map deleteForumBoards(Map params) {
        def result = [:]

        def delIdList = params.idList
        if(delIdList){
            String[] ids = delIdList.split(",");
            ids?.each { id ->
                def forumBoard = ForumBoard.get(id);
                List<ForumMember> forumMemberList = ForumMember.findAllByForumBoard(forumBoard);
                forumMemberList?.each {ForumMember forumMember->
                    forumMember.delete(flush: true);
                }
                deleteForumSharing(forumBoard);
                forumBoard.delete()
            }
            result.deleteSuccess = true
            result.msg = '删除成功'
        }
        else{
            result.deleteSuccess = false
            result.msg = '参数错误'
        }

        return result
    }
    public void deleteForumSharing(ForumBoard forumBoard){
        List<ForumSharing> forumSharingList = ForumSharing.findAllByForumBoard(forumBoard);
        forumSharingList?.each {ForumSharing forumSharing->
            UserFile userFile = forumSharing.userFile;
            if(userFile){
                forumSharing.userFile = null;
                forumSharing.save(flush: true);
            }
            UserSpecial userSpecial = forumSharing.special;
            if(userSpecial){
                forumSharing.special = null;
                forumSharing.save(flush: true);
            }
            forumSharing.delete(flush: true);
        }
    }

    public Map changeSharingState(Map params){
        def result = [:];
        def sharingId = params.sharingId;
        if(sharingId){
            ForumSharing sharing = ForumSharing.get(sharingId as Long);
            sharing.state =1;
            if(sharing.save(flush: true)&&(!sharing.hasErrors())){
                result.success=true;
            }else{
                result.success=false;
                result.msg = "审批失败";
            }
        }else{
            result.success=false;
            result.msg = "参数不全";
        }
        return result
    }

    public Map querySpecialSharing(Map params){
        def result = [:];
        def sharingId = params.sharingId;
        ForumSharing sharing = null;
        UserSpecial userSpecial = null;
        List<SpecialFile> specialFiles = [];
        List<UserFile> userFiles = [];
        if(sharingId){
            sharing = ForumSharing.get(sharingId as Long);
            userSpecial = sharing.special;
            specialFiles = SpecialFile.findAllByUserSpecial(userSpecial);
            specialFiles?.each {
                userFiles.add(it.userFile)
            }
            // 按照海报ID排序
            if(userSpecial.posters?.size()>1) {
                userSpecial.posters = userSpecial.posters.sort{e1,e2 ->
                    return e1.id - e2.id;
                }
            }
        }
        result.userSpecial = userSpecial;
        result.userFiles = userFiles;
        result.consumer = userSpecial.consumer;
        result.sharing = sharing;
        result.imgFileHash = userSpecial?.posters[0]?.fileHash;
        return result
    }

    public Map specialRemarkSave(Map params){
        def result = [:];
        try{
            if(params.fileId && params.studyCommunityId){
                def rs = chkForumMemberCommentRights(params.studyCommunityId as long);
                if(rs.success==true || rs.success=='true'){
                    UserFile userFile = UserFile.findById(params.fileId as Long);
                    SpecialFile specialFile = SpecialFile.findByUserFile(userFile);
                    if(params.rank&&(params.rank!='0')){
                        SpecialScore score = new SpecialScore();
                        score.score = params.rank as double;
                        score.consumer = params.consumer;
                        score.userSpecial = specialFile.userSpecial;
                        score.save(flush: true);
                    }
                    SpecialFileRemark fileRemark = new SpecialFileRemark();
                    fileRemark.consumer =params.consumer;
                    fileRemark.remarkContent = params.content;
                    fileRemark.file =specialFile;
                    if(fileRemark.save(flush: true)&&(!fileRemark.hasErrors())){
                        specialFile.addToRemarks(fileRemark);
                        result.success=true;
                        result.remark = fileRemark;
                        result.consumer = fileRemark.consumer;
                    }else{
                        result.success=false;
                        result.msg = "保存失败";
                    }
                } else {
                    result.success=false;
                    result.msg = rs.msg;
                }

            } else{
                result.success = false;
                result.msg = "参数不全";
            }
        }catch (e){
            result.success=false;
            result.msg = e.getMessage();
        }

        return result;
    }

    // 判断用户权限
    private Map chkForumMemberCommentRights(long studyCommunityId) {
        def result = [:];
        Consumer consumer = utilService.getSession()?.consumer;
        if(studyCommunityId) {
            StudyCommunity studyCommunity = StudyCommunity.get(studyCommunityId);
            if(studyCommunity) {
                if(consumer?.id == (studyCommunity.create_comsumer_id as long)){
                    result.success = true;
                } else {
                    //查看用户是否是社区的成员
                    ForumMember member = ForumMember.findByConsumerAndStudyCommunity(consumer, studyCommunity);
                    if(member) {
                        if(member.state==ForumMember.STATE_NORMAIL && member.canComment) {
                            result.success = true;
                        } else {
                            if(member.state!=ForumMember.STATE_NORMAIL) {
                                result.success = false;
                                result.msg = "您的用户状态不正常,请确认您在该社区的用户状态!";
                            } else {
                                result.success = false;
                                result.msg = "您没有评论专辑的权限!";
                            }
                        }
                    } else {
                        result.success = false;
                        result.msg = "您不是该社区的成员,不能评论!";
                    }
                }
            }
        } else {
            result.success = false;
            result.msg = "参数不全";
        }
        return result;
    }

    public Map specialReplySave(Map params){
        def result = [:];
        def content = params.content;
        def remarkId = params.remarkId;
        SpecialFileRemark fileRemark = null;
        try{
            if(remarkId){
                fileRemark = SpecialFileRemark.findById(remarkId as Long);
                SpecialComment comment = new SpecialComment();
                comment.remark = fileRemark;
                comment.consumer = params.consumer;
                comment.commentUser = fileRemark.consumer;
                comment.commentContent = content;
                if(comment.save(flush: true)&&(!comment.hasErrors())){
                    fileRemark.addToComments(comment);
                    result.success=true;
                    result.comment = comment;
                    result.consumer = comment.consumer;
                }else{
                    result.success=false;
                    result.msg = "保存失败";
                }
            }
        }catch (e){
            result.success=false;
            result.msg = e.getMessage();
        }

        return result
    }

    /***
     * 验证用户是否有管理社区的权限
     * @param consumerId 用户id
     * @param studyCommunityId 社区id
     * @return true ok false mustn't
     */
    public Map checkManagerLimit(long consumerId,long studyCommunityId){
        def result = [:];
        StudyCommunity studyCommunity = StudyCommunity.findById(studyCommunityId);
        if(studyCommunity){
            Consumer consumer = Consumer.findById(consumerId);
            if(consumer){
                if(consumer.id==studyCommunity.create_comsumer_id){
                    result.type = "community";
                    result.msg = true;
                }else{
                    List<ForumBoard> boardList = ForumBoard.findAllByStudyCommunity(studyCommunity);
                    for(ForumBoard forumBoard:boardList){
                        if(forumBoard.createConsumer==consumer){
                            if(consumer.userState){
                                result.type = "board";
                                result.msg = true;
                            }
                        }
                    }
                    /*List<ForumMember> memberList = ForumMember.findAllByStudyCommunity(studyCommunity);
                    for(ForumMember forumMember:memberList){
                        if(forumMember.consumer==consumer){
                            if(forumMember.state==ForumMember.STATE_NORMAIL){
                                if(consumer.userState){
                                    return true;
                                }
                            }
                        }
                    }*/
                }
            }else{
                result.type = null;
                result.msg = false;
            }
        }else{
            result.type = null;
            result.msg = false;
        }
        return result
    }

    /**
     * 小组名称重复校验
     * @param params
     * @return
     */
    public Map checkExistForumBoardName(Map params) {
        def result = [:];
        def forumBoardId = params.forumBoardId;
        def forumBoardName = params.forumBoardName;
        def studyCommunityId = params.studyCommunityId;
        if (forumBoardName && studyCommunityId) {
            def board = null;
            StudyCommunity community = StudyCommunity.findById(studyCommunityId as long);
            if (forumBoardId) { //修改
                board = ForumBoard.createCriteria().list() {
                    notEqual('id', forumBoardId as long)
                    eq('name', forumBoardName)
                    studyCommunity {
                        eq('id', studyCommunityId as long)
                    }
                }
            } else { //创建
                board = ForumBoard.findByNameAndStudyCommunity(forumBoardName, community);
            }
            if (board) {
                result.success = false;
                result.msg = "小组名称重复!";
            } else {
                result.success = true;
            }
        }
        return result;
    }
}
