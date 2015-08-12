package nts.front.community.controllers

import grails.converters.JSON
import nts.commity.domain.*
import nts.system.domain.LogsPublic
import nts.user.domain.Consumer
import nts.utils.CTools

class CommunityMgrController {
    //注入communityService
    def communityService
    def communityMgrService;
    def communityManagerService

    /**
     * 在这个controller里面，每次都要校验studyCommunityId，可以抽取出来，写个util或者加个拦截器
     */
    def index() {
        redirect(action: "forumBoradList", params: params)
    }
    //板块创建
    def forumBoradCreate() {
        def studyCommunityManager = params.studyCommunityManager;//是否是社区管理员
        def studyCommunity = params.studyCommunity;
        def studyCommunityId = params.studyCommunityId;
        //如果是save出错这里返回数据
        ForumBoard forumBoard = params.forumBoard;
        //这里不知道有什么用
        session.communityId = studyCommunityId;
        if (params.type=='community') {
            return render(view: 'forumBoardCreate', model: [type:params.type,msg:params.msg, forumBoard: forumBoard, studyCommunity: studyCommunity, studyCommunityManager: studyCommunityManager]);
        }
        return render(view: 'forumBoardList', model: [type:params.type,msg:params.msg,studyCommunityManager: studyCommunityManager, studyCommunity: studyCommunity])
    }
    //板块保存
    def forumBoradSave() {
        def studyCommunityManager = params.studyCommunityManager;
        def result = [:];
        result = communityMgrService.forumBoradSave(params)
        flash.message = result.message;
        if (result.noFind) {
            return redirect(action: 'forumBoradEdit', params: params);
        } else {
            if (result.success) {
                return redirect(action: 'forumBoradList', params: params)
            } else {
                params.forumBoard = result.forumBoard;
                if ("save".equals(result.saveOrUpdate)) {
                    return redirect(action: 'forumBoradSave', params: params)
                } else if ("update".equals(result.saveOrUpdate)) {
                    return redirect(action: 'forumBoradEdit', params: params)
                }
            }
        }
    }
    //板块修改页面转跳
    def forumBoradEdit() {
        def studyCommunityManager = params.studyCommunityManager;
        def consumer = session.consumer;
        def studyCommunity = params.studyCommunity;
        def forumBoardId = params.forumBoardId;
        ForumBoard forumBoard = ForumBoard.findById(Long.parseLong(forumBoardId));

        //判断修改的板块，是否是当前社区，是否是当前用户创建，或者当前用户为社区管理员
        if (forumBoard && forumBoard.studyCommunity.id == studyCommunity.id && (params.type == 'community' || forumBoard.createConsumer.id == consumer.id)) {
            //查询该板块的所有加入者，用于确定板块管理员
            def forumMemberList = ForumMember.createCriteria().list(order: 'desc', sort: 'id') {
                eq("forumBoard", forumBoard);
                eq("state", 0)
            }
            return render(view: 'forumBoardCreate', model: [type: params.type, msg: params.msg, forumMemberList: forumMemberList, forumBoard: forumBoard, studyCommunity: studyCommunity, studyCommunityManager: studyCommunityManager]);
        } else {
            return redirect(action: 'forumBoradList', params: params);
        }
    }
    /**
     * 板块管理列表
     * @return
     */
    def forumBoradList() {
        Consumer consumer = session.consumer;
        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunity = params.studyCommunity;
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        List<ForumBoard> forumBoardList = null;
        forumBoardList = ForumBoard.createCriteria().list(order: params.order, sort: params.sort, max: params.max, offset: params.offset) {
            eq("studyCommunity", studyCommunity)
            if(params.type=='board'){
                eq("createConsumer", consumer)
            }
        }

        def total = 0;
        if (forumBoardList) {
            total = forumBoardList.totalCount;
        }
        return render(view: 'forumBoardList', model: [type:params.type,msg:params.msg,total: total, forumBoardList: forumBoardList, studyCommunity: studyCommunity, studyCommunityManager: studyCommunityManager]);
    }
    /**
     * 公告创建
     * @return
     */
    def noticeCreate() {
        Consumer consumer = session.consumer;
        def studyCommunity = params.studyCommunity;
        Notice notice = params.notice;
        if (params.type=='community') {
            return render(view: 'noticeCreate', model: [type:params.type,msg:params.msg,studyCommunity: studyCommunity]);
        } else {
            return redirect(action: 'noticeList', params: params);
        }
    }
    /**
     * 学习社区公告公告save
     * @return
     */
    def noticeSave() {
        def result = [:];
        def studyCommunity = params.studyCommunity;
        result = communityMgrService.noticeSave(params);
        flash.message = result.message;
        if (result.success) {
            return redirect(action: 'noticeList', params: params);
        } else {
            params.notice = result.notice;
            if ("save".equals(result.saveOrUpdate)) {
                return redirect(action: 'noticeCreate', params: params);
            } else if ("update".equals(result.saveOrUpdate)) {
                return redirect(action: 'noticeEdit', params: params);
            }
        }

    }
    //学习社区公告公告修改转跳
    def noticeEdit() {
        def studyCommunity = params.studyCommunity;
        def noticeId = params.noticeId;
        Notice notice = Notice.findById(Long.parseLong(noticeId));
        //修改公告存在，社区管理员，修改公告属于该社区
        if (notice && (params.type=='community') && notice.studyCommunity.id == studyCommunity.id) {
            return render(view: 'noticeCreate', model: [type: params.type, msg: params.msg, notice: notice, studyCommunity: studyCommunity]);
        } else {
            return redirect(action: 'noticeList', params: params);
        }
    }
    //学习社区公告公告列表
    def noticeList() {
        def studyCommunity = params.studyCommunity;
        List<Notice> noticeList = null;

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        if (params.type=='community') {
            noticeList = Notice.createCriteria().list(order: params.order, sort: params.sort, max: params.max, offset: params.offset) {
                eq("studyCommunity", studyCommunity)
            };

        }

        def total = 0;
        if (noticeList) {
            total = noticeList.totalCount;
        }
        return render(view: 'noticeList', model: [type:params.type,msg:params.msg,total: total, noticeList: noticeList, studyCommunity: studyCommunity]);
    }
    //学习社区公告公告删除
    def noticeDelete() {
        def result = [:];
        result = communityMgrService.noticeDelete(params);
        render(contentType: "text/json") {
            model: [
                    "deleteSuccess": result.message
            ]
        }
    }
    /**
     * 社区成员列表
     * @return
     */
    def membersList() {
        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunityId = params.studyCommunityId;
        StudyCommunity studyCommunity = StudyCommunity.findById(studyCommunityId as long);
        def memberName = params.memberName;
        Consumer consumer = session.consumer;

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'joinDate'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        def forumMember = null;
        def total = 0;

        List<Consumer> consumerList = [];
        if (memberName) { //成员查询
            consumerList = Consumer.createCriteria().list() {
                like('name', "%" + memberName + "%")
            }
            if (!consumerList) {
                consumerList = [];
            }
        }

        if ((params.type == 'community') || (params.type == 'board')) {
            if (memberName) {
                if (consumerList.size() > 0) {
                    forumMember = ForumMember.createCriteria().list(order: params.order, sort: params.sort, max: params.max, offset: params.offset) {
                        'in'('consumer', consumerList.toArray())
                        eq("studyCommunity", studyCommunity)
                    }
                    if (forumMember) {
                        total = forumMember.totalCount;
                    }
                } else {
                    forumMember = [];
                    total = 0;
                }

            } else {
                forumMember = ForumMember.createCriteria().list(order: params.order, sort: params.sort, max: params.max, offset: params.offset) {
                    eq("studyCommunity", studyCommunity)
                }
                if (forumMember) {
                    total = forumMember.totalCount;
                }
            }
        } else {
            if (memberName) {
                forumMember = ForumMember.findAll("from ForumMember where studyCommunity = :studyCommunity and forumBoard.createConsumer = :createConsumer and consumer.id != :consumerId and consumer.name like :consumerName", [studyCommunity: studyCommunity, createConsumer: consumer, consumerId: consumer.id, consumerName: "%" + memberName + "%"], [order: params.order, sort: params.sort, max: params.max, offset: params.offset]);
                total = ForumMember.executeQuery("select count(id) from ForumMember  where studyCommunity = :studyCommunity and forumBoard.createConsumer = :createConsumer and consumer.id != :consumerId and consumer.name like :consumerName", [studyCommunity: studyCommunity, createConsumer: consumer, consumerId: consumer.id, consumerName: "%" + memberName + "%"])[0];
            } else {
                forumMember = ForumMember.findAll("from ForumMember where studyCommunity = :studyCommunity and forumBoard.createConsumer = :createConsumer and consumer.id != :consumerId", [studyCommunity: studyCommunity, createConsumer: consumer, consumerId: consumer.id], [order: params.order, sort: params.sort, max: params.max, offset: params.offset]);
                total = ForumMember.executeQuery("select count(id) from ForumMember  where studyCommunity = :studyCommunity and forumBoard.createConsumer = :createConsumer and consumer.id != :consumerId", [studyCommunity: studyCommunity, createConsumer: consumer, consumerId: consumer.id])[0];
            }
        }


        return render(view: 'memberList', model: [params: params, memberName: params.memberName, type: params.type, msg: params.msg, total: total, studyCommunity: studyCommunity, forumMember: forumMember, studyCommunityManager: studyCommunityManager]);
    }
    /**
     * 社区成员踢出
     * @return
     */
    def deleteMember() {
        def result = [:];
        result = communityMgrService.deletemMember(params);
        result.msg = result.message
        result.deleteSuccess = result.success;
        return render(result as JSON);
    }
    /**
     * 修改成员属性状态
     */
    def changeForumMemberAttr() {
        def result = [:];
        result = communityMgrService.changeForumMemberAttr(params);
        result.message = result.message
        result.success = result.success;
        return render(result as JSON);
    }
    /**
     * 社区主帖
     * @return
     */
    def forumMainArticleList() {
        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunity = params.studyCommunity;
        Consumer consumer = session.consumer;

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        def forumMainArticleList = null;
        def forumMainArticleAllList = null;
        //社区管理员，查询所有的社区，板块管理员，只查询该板块的
        def forumBoardIds = null;
        if ((params.type=='community')||(params.type=='board')) {
            forumBoardIds = ForumBoard.executeQuery("select id from ForumBoard where studyCommunity.id = :studyCommunityId", [studyCommunityId: studyCommunity.id])
        } else {
            forumBoardIds = ForumBoard.executeQuery("select id from ForumBoard where studyCommunity.id = :studyCommunityId and createConsumer.id = :createConsumerId", [studyCommunityId: studyCommunity.id, createConsumerId: consumer.id])
        }
        if (forumBoardIds) {
            //分页需要
            forumMainArticleList = ForumMainArticle.findAll("from ForumMainArticle where forumBoard.id in :forumBoardIds", [forumBoardIds: forumBoardIds], [order: params.order, sort: params.sort, max: params.max, offset: params.offset])
            //总数
            forumMainArticleAllList = ForumMainArticle.findAll("from ForumMainArticle where forumBoard.id in :forumBoardIds", [forumBoardIds: forumBoardIds])
        }

        def total = 0;
        if (forumMainArticleAllList) {
            total = forumMainArticleAllList.size();
        }

        return render(view: 'forumMainArticleList', model: [type:params.type,msg:params.msg,total: total, studyCommunity: studyCommunity, forumMainArticleList: forumMainArticleList, studyCommunityManager: studyCommunityManager]);
    }
    /**
     * 社区主帖删除
     */
    def forumMainArticleDelete() {
        def result = [:];
        result = communityMgrService.forumMainArticleDelete(params)
        result.deleteSuccess = result.success;
        result.msg = result.message;
        return render(result as JSON);
    }
    /**
     *  精华贴修改
     */
    def changeElite() {
        def result = [:];
        result = communityMgrService.changeElite(params);
        result.changeSuccess = result.success;
        result.msg = result.message;
        return render(result as JSON)
    }
    /**
     * 置顶贴修改
     */
    def changeTop() {
        def result = [:];
        result = communityMgrService.changeTop(params);
        result.changeSuccess = result.success;
        result.msg = result.message;
        return render(result as JSON)
    }
    /**
     * 共享列表
     */
    def sharingList() {
        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunity = params.studyCommunity;

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'createdDate'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        List<ForumSharing> sharingList = null;
        if ((params.type=='community')||(params.type=='board')) {
            List<ForumBoard> forumBoardList = ForumBoard.findAllByStudyCommunity(studyCommunity);
            if(forumBoardList.size()>0){
                sharingList = ForumSharing.createCriteria().list(max:params.max,offset: params.offset,order:params.order,sort: params.sort){
                    inList('forumBoard',forumBoardList)
                }
            }
        }

        def total = 0;
        if (sharingList) {
            total = sharingList.totalCount;
        }

        return render(view: 'sharingList', model: [type:params.type,msg:params.msg,total: total, sharingList: sharingList, studyCommunity: studyCommunity, studyCommunityManager: studyCommunityManager]);
    }
    //共享审批
    def changeSharingState(){
        def res = [:];
        res = communityMgrService.changeSharingState(params);
        return render(res as JSON)
    }
    /**
     * 共享删除
     */
    def sharingDelete() {
        def result = [:];
        result = communityMgrService.sharingDelete(params)
        return render(result as JSON);
    }
    /**
     * 共享文件播放修改
     */
    def changeCanPlay() {
        def result = [:];
        result = communityMgrService.changeCanPlay(params);
        result.changeSuccess = result.success;
        result.msg = result.message;
        return render(result as JSON)
    }
    /**
     * 共享文件下载修改
     */
    def changeCanDownload() {
        def result = [:];
        result = communityMgrService.changeCanDownload(params);
        return render(result as JSON)
    }
    /**
     * 活动列表
     * @return
     */
    def activityList() {
        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunity = params.studyCommunity;
        def activityList;
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0
        def total = 0;
        //只有社区管理员才能看见
        if (params.type=='community') {
            activityList = Activity.createCriteria().list(max: params.max, order: params.order, sort: params.sort, offset: params.offset) {
                if (studyCommunity) {
                    eq("studyCommunity", studyCommunity)
                }
            }
        }
        if (activityList) {
            total = activityList.totalCount;
        }
        return render(view: 'activityList', model: [type:params.type,msg:params.msg,activityList: activityList, total: total, studyCommunity: studyCommunity, studyCommunityManager: studyCommunityManager]);
    }
    /**
     * 活动创建
     * @return
     */
    def activityCreate() {
        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunity = params.studyCommunity;
        if (params.type=='community') {
            return render(view: 'activityCreate', model: [type:params.type,msg:params.msg,studyCommunity: studyCommunity, studyCommunityManager: studyCommunityManager])
        } else {
            return redirect(action: 'activityList', params: params);
        }
    }
    /**
     * 活动保存
     * @return
     */
    def activitySave() {
        def studyCommunityManager = params.studyCommunityManager;
        def result = [:];
        //社区管理员才能创建
        if (params.type=="community") {
            def image = uploadImg('save')
            if (image == null || image == "" || image == "null") {
                image = "default.jpg"
            }
            params.image = image;
            result = communityMgrService.activitySave(params);
            flash.message = result.message;
        }
        return redirect(action: 'activityList', params: params)
    }
    /**
     * 活动修改
     * @return
     */
    def activityEdit() {
        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunity = params.studyCommunity;
        def activityId = params.activityId;
        Activity activity = Activity.get(activityId)
        //活动是否存在，是否是社区管理员，是否该活动属于该社区
        if (activity && params.type=="community" && activity.studyCommunity.id == studyCommunity.id) {
            return render(view: 'activityEdit', model: [activity: activity, studyCommunity: studyCommunity, studyCommunityManager: studyCommunityManager,type:params.type,msg:params.msg]);
        } else {
            return redirect(action: 'forumBoradList', params: params);
        }
    }
    /**
     * 活动更新
     * @return
     */
    def activityUpdate() {
        def result = [:];
        def studyCommunityManager = params.studyCommunityManager;
        def studyCommunity = params.studyCommunity;
        if (params.type == "community") { //只有管理员才能修改
            def image = uploadImg('update')
            if (image == null || image == "" || image == "null") {
                image = "default.jpg";
            }
            params.image = image;
            result = communityMgrService.activityUpdate(params);
            flash.message = result.message;
        } else {
            result.success = false;
            flash.message = "只有社区管理员才能修改!";
        }

        return redirect(action: 'activityList', params: params)
    }

    //上传图片(opt：值为save表示添加图片，值为update表示修改图片)
    def uploadImg(def opt) {
        def imgFile = request.getFile("photo")
        def imgType = imgFile.getContentType()

        def path = servletContext.getRealPath("/upload");

        def imgPath = ""

        if (imgFile && !imgFile.isEmpty()) {
            if (imgType == "image/pjpeg" || imgType == "image/jpeg" || imgType == "image/png" || imgType == "image/x-png" || imgType == "image/gif") {
                //获取文件后缀名
                String fileType = CTools.readExtensionName(imgFile.getOriginalFilename());
                if (opt == "save") {
                    def sc = Activity.createCriteria()
                    def id = sc.get {
                        projections {
                            max "id"
                        }
                    }
                    id = id == null ? 1 : id + 1
                    imgPath = "i_" + id + "." + fileType;
                } else if (opt == "update") {
                    def id = params.activityId
                    imgPath = "i_" + id + "." + fileType;
                }
                File file = new File("${path}/communityImg/activity");
                if(!file.exists())file.mkdirs();
                imgFile.transferTo(new File("${path}/communityImg/activity/" + imgPath))
            } else {
                flash.message = "上传图片格式不对..."
            }
        }
        return imgPath
    }

    /**
     *  版块状态修改
     */
    def changeForumBoardState() {
        def result = [:];
        result = communityMgrService.changeForumBoardState(params);
        result.changeSuccess = result.success;
        result.msg = result.message;
        return render(result as JSON)
    }

    //删除板块
    def deleteForumBoards(){
        def result = communityMgrService.deleteForumBoards(params);
        return render(result as JSON)
    }

    //社区活动删除
    def activityDelete(){
        def result=communityManagerService.deleteActivity(params);
        return render(result as JSON)
    }

    /**
     * 小组名称重复校验
     * @return
     */
    def checkExistForumBoardName() {
        def result = communityMgrService.checkExistForumBoardName(params);
        return render(result as JSON)
    }
}
