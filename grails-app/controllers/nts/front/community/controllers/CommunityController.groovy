package nts.front.community.controllers

import com.boful.common.file.utils.FileType
import grails.converters.JSON
import nts.commity.domain.Activity
import nts.commity.domain.ActivitySubject
import nts.commity.domain.ForumBoard
import nts.commity.domain.ForumMainArticle
import nts.commity.domain.ForumMember
import nts.commity.domain.ForumReplyArticle
import nts.commity.domain.ForumReplySubjectArticle
import nts.commity.domain.ForumSharing
import nts.commity.domain.Notice
import nts.commity.domain.Sharing
import nts.commity.domain.StudyCommunity
import nts.program.domain.Program
import nts.system.domain.LogsPublic
import nts.system.domain.Message
import nts.system.domain.SysConfig
import nts.user.domain.College
import nts.user.domain.Consumer
import nts.user.domain.Subjects
import nts.user.file.domain.UserFile
import nts.user.services.ActionNameAnnotation
import nts.user.services.ControllerNameAnnotation
import nts.user.special.domain.SpecialFile
import nts.utils.CTools
import org.apache.commons.io.FileUtils
import org.apache.http.HttpEntity
import org.apache.http.HttpResponse
import org.apache.http.client.HttpClient
import org.apache.http.client.methods.HttpGet
import org.apache.http.impl.client.HttpClientBuilder
import org.codehaus.groovy.grails.web.util.WebUtils
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.web.multipart.commons.CommonsMultipartFile
import nts.system.domain.RMSCategory
import javax.servlet.http.Cookie
import java.text.SimpleDateFormat

@ControllerNameAnnotation(name = "社区中心")
class CommunityController {
    def communityService
    def utilService
    def userService
    def communityMgrService

    @ActionNameAnnotation(name = "社区首页")
    def index() {
        params.communityType = 'all'

        def flag = 1
        if (params.categoryId) {
            flag = 2
        } else if (params.order) {
            flag = 3
        }

        //推荐学习圈
        def rmsCategoryList1 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {            //一级类别
            'in'("type", [0, 2])
            eq("parentid", 0)
            eq("state", true)
        }

        def rmsCategoryList11 = []
        rmsCategoryList1.each {
            def children = RMSCategory.findAllByParentid(it.id)
            if (children && children.size() > 0) {
                rmsCategoryList11.add(it)
            }
        }

        def rmsCategoryList2 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {                //二级类别
            'in'("type", [0, 2])
            ne("parentid", 0)
            eq("state", true)
        }
        //取得最大显示页面，并转换为整型
        //取得页面偏移量，并转换为整型


        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        Date begin_date = null;
        Date end_date = null;

        if (!params.max) params.max = 16
        if (!params.sort) params.sort = 'membersCount'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0
        if (!params.communityType) params.communityType = 'all'

        def setCount = 0
        if (params.pageIndex != null) {
            setCount = params.max.toInteger() * (params.pageIndex.toInteger() - 1)
        }
        if (params.pageIndex == null) params.pageIndex = 1

        def communityType = params.communityType
        def name = params.name
        def consumer = params.consumer

        def studyCommunityList = StudyCommunity.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (params.comId != null && params.comId != "") {
                eq('id', CTools.nullToZero(params.comId).longValue())
            }
            //if (communityType == 'all') {
            eq('state', 1)
            //}
            if (name) {
                name = name.trim()
                like('name', "%${name}%")
            }
            if (CTools.nullToZero(params?.categoryId).longValue() != 0) {
                def categoryID = RMSCategory.withCriteria {
                    eq("parentid", Integer.parseInt(params.categoryId))
                }
                def categoryIDList = [CTools.nullToZero(params?.categoryId).longValue()]
                categoryID?.each {
                    categoryIDList.add(it.id)
                }

                communityCategory {
                    //eq('id', CTools.nullToZero(params?.categoryId).longValue())
                    'in'("id", categoryIDList)
                }
            }
        }
        def total = studyCommunityList.totalCount

        return render(view: 'index', model: [flag: flag, studyCommunityList: studyCommunityList, rmsCategoryList1: rmsCategoryList1, rmsCategoryList2: rmsCategoryList2, total: total, params: params])
    }

    def autoLoading() {
        def result = [:];
        if (!params.max) params.max = 6;
        List<ForumMainArticle> articles = ForumMainArticle.list(max: params.max, offset: params.offset, sort: 'dateCreated', order: 'desc');
        def acticleTotal = articles.totalCount;
        List<ForumBoard> boards = ForumBoard.list(max: params.max, offset: params.offset, sort: 'dateCreated', order: 'desc');
        def boardTotal = boards.totalCount;
        List<Sharing> sharings = Sharing.list(max: params.max, offset: params.offset, sort: 'dateCreated', order: 'desc');
        def sharingTotal = sharings.totalCount;
        List<Activity> activities = Activity.list(max: params.max, offset: params.offset, sort: 'dateCreated', order: 'desc');
        def activityTotal = activities.totalCount;
        def articleHtml = "";
        def boardHtml = "";
        def sharingHtml = "";
        def activityHtml = "";
        //
        for (int i = 0; i < boards.size(); i++) {
            boardHtml += "<div class=\"community_other_group_item\">\n" +
                    "                    <div class=\"community_other_group_img\">";
            boardHtml += "<img src='${resource(dir: 'upload/communityImg/forumboard', file: boards[i].photo)}' width=\"50\" height=\"50\"\n" +
                    "                             onerror=\"this.src = '/skin/blue/pc/front/images/boful_default_img.png'\"/>";
            boardHtml += "</div>\n" +
                    "\n" +
                    "                    <div class=\"community_other_group_infors\">\n" +
                    "                        <div class=\"community_other_group_infors_title\">" +
                    "<a href=\"/community/communityGroupIndex.js?id=" + boards[i]?.id + "\">" +
                    "${boards[i]?.name}</div></a>\n" +
                    "\n" +
                    "                        <p class=\"community_other_group_infors_cont\">${boards[i]?.description}</p>\n" +
                    "\n" +
                    "                        <p class=\"community_other_group_infors_sup\"><span class=\"others_group_infors_number\">成员：${ForumMember.findAllByForumBoard(boards[i])?.size()}</span>\n" +
                    "                        </p>\n";
            if (judgeJoinBoard(consumer: session.consumer, forumBoard: boards) == 'true') {
                boardHtml += "<p class=\"other_group_jioned\" style=\"cursor: pointer\"><span class=\"\">√</span>&nbsp;已经加入</p>";
            } else {
                boardHtml += "<p class=\"other_group_jion\" onclick=\"addGroup(${boards[i]?.id})\" style=\"cursor: pointer\">+加入小组</p>";
            }
            boardHtml += "</div></div>";
        }

        //
        for (int i = 0; i < sharings.size(); i++) {
            sharingHtml += "<div class=\"community_other_left_item\">\n" +
                    "                    <a href=\"/my/userSpace?id=" + sharings[i]?.shareConsumer?.id + "\">\n" +
                    "                    <div class=\"community_other_left_user_img\">\n" +
                    "                        <img src=\"/upload/photo/" + sharings[i]?.shareConsumer.photo + "\" width=\"28\" height=\"28\"\n" +
                    "                             onerror=\"this.src = '/skin/blue/pc/front/images/photo.gif'\"/>\n" +
                    "                    </div></a>\n" +
                    "\n" +
                    "                    <div class=\"community_other_left_user_inform\">\n" +
                    "                        <div class=\"community_other_left_user_inform_small\">\n" +
                    "                            <p class=\"community_other_left_username\"><a href=\"/my/userSpace?id=" + sharings[i]?.shareConsumer?.id + "\">${sharings[i]?.shareConsumer?.name}</a></p>\n" +
                    "\n" +
                    "                            <p class=\"user_act\">上传了：<span class=\"user_resource_clas\">";
            if (FileType.isVideo(new File(sharings[i]?.url).getName())) {
                sharingHtml += "视频资源</td>";
            } else if (FileType.isImage(new File(sharings[i]?.url).getName())) {
                sharingHtml += "图片资源</td>";
            } else if (FileType.isDocument(new File(sharings[i]?.url).getName()) || (new File(sharings[i]?.url).getName()).endsWith("pdf") || (new File(sharings[i]?.url).getName()).endsWith("PDF")) {
                sharingHtml += "文档资源</td>";
            } else if ((new File(sharings[i]?.url).getName()).endsWith("swf") || (new File(sharings[i]?.url).getName()).endsWith("SWF")) {
                sharingHtml += "flash动画资源</td>";
            } else {
                sharingHtml += "未知资源</td>";
            }
            sharingHtml += "</span><a\n" +
                    "                                    href=\"/community/communitySharingShow?id=" + sharings[i]?.id + "\">${CTools.cutString(sharings[i]?.name, 15)}</a></p>\n" +
                    "\n" +
                    "                        </div>\n" +
                    "\n" +
                    "                        <div class=\"community_other_left_user_resources\">\n" +
                    "                            <div class=\"user_resources_images\">\n" +
                    "                                <a href=\"/community/communitySharingShow?id=" + sharings[i]?.id + "\">\n" +
                    "                                <img src=\"${playSharingLink(sharing: sharings[i])}\" width=\"255\" height=\"155\"\n" +
                    "                                     onerror=\"this.src = '/skin/blue/pc/front/images/boful_default_img.png'\"/></a>\n" +
                    "                            </div>\n" +
                    "                        </div>\n" +
                    "\n" +
                    "                        <p class=\"community_other_downs\">\n" +
                    "                            <span class=\"user_load_time\">" +
                    new SimpleDateFormat('yyyy-MM-dd').format(sharings[i]?.dateCreated) + "</span>\n" +
                    "                        </p>\n" +
                    "                    </div>\n" +
                    "                </div>";
        }

        for (int i = 0; i < articles.size(); i++) {
            def replayArticle = ForumReplyArticle.createCriteria().list(max: 1, order: 'desc', sort: "dateCreated") {
                if (articles[i]) {
                    eq("forumMainArticle", articles[i])
                }
            }
            articleHtml += "<table border=\"0\">\n" +
                    "                            <tbody>\n" +
                    "                            <tr>\n" +
                    "                                <td class=\"posts_th posts_large\">\n" +
                    "                                    <a href=\"/community/communityArticle?id=" + articles[i]?.id + "\">${articles[i]?.name}</a></td>\n" +
                    "                                <td class=\"posts_th_sd\">\n" +
                    "                                    <a href=\"/my/userSpace?id=" + articles[i]?.createConsumer?.id + "\">\n" +
                    "                                    <span class=\"posts_imgs\">\n" +
                    "                                        <img src=\"/upload/photo/" + articles[i]?.createConsumer.photo + "\" width=\"28\" height=\"28\"\n" +
                    "                                             onerror=\"this.src = '/skin/blue/pc/front/images/photo.gif'\"/>\n" +
                    "                                    </span></a>\n" +
                    "                                    <span class=\"posts_wid\">\n" +
                    "                                        <a href=\"/my/userSpace?id=" + articles[i]?.createConsumer?.id + "\" class=\"posts_th_name th_name_corl\">${articles[i]?.createConsumer?.name}</a>\n" +
                    "                                        <a class=\"posts_th_time\">" +
                    new SimpleDateFormat('yyyy-MM-dd').format(articles[i]?.dateCreated) + "</a>\n" +
                    "                                    </span>\n" +
                    "                                </td>\n" +
                    "                                <td class=\"posts_th_ss\">\n" +
                    "                                    <span class=\"posts_wids_back\">500</span>\n" +
                    "                                    <span class=\"posts_wid_back\">${articles[i]?.forumReplyArticle?.size()}</span>\n" +
                    "                                </td>\n" +
                    "                                <td class=\"posts_th_s\">\n" +
                    "                                    <a href=\"#\" class=\"posts_wid_back_name\">";
            if (replayArticle[0] != null) {
                articleHtml += "${CTools.cutString(replayArticle[0]?.name, 5)}";
            } else {
                articleHtml += "没有回复"
            }

            articleHtml += "</a>\n" +
                    "                                    <span class=\"posts_wid_back_time\">\n";
            if (replayArticle[0] != null) {
                articleHtml += "${replayArticle[0]?.dateCreated}";
            }
            articleHtml += "</span>\n" +
                    "                                    </span>\n" +
                    "                                </td>\n" +
                    "                            </tr>\n" +
                    "                            </tbody>\n" +
                    "                        </table>"
        }

        for (int i = 0; i < activities.size(); i++) {
            activityHtml += "<div class=\"community_other_activity_item\">\n" +
                    "                    <div class=\"community_other_activity_img\">\n" +
                    "                        <a href=\"/community/communityActivityShow?id=" + activities[i]?.id + "\">\n" +
                    "                            <img src=\"/upload/communityImg/activity/" + activities[i]?.photo + "\" width=\"140\" height=\"80\"\n" +
                    "                                 onerror=\"this.src = '/skin/blue/pc/front/images/boful_default_img.png'\"/></a>\n" +
                    "                    </div>\n" +
                    "\n" +
                    "                    <div class=\"community_other_activity_infors\">\n" +
                    "                        <h5>\n" +
                    "                            <a href=\"/community/communityActivityShow?id=" + activities[i]?.id + "\">${activities[i]?.name}</a>\n" +
                    "                        </h5>\n" +
                    "\n" +
                    "                        <p class=\"community_other_activity_infors_cont\">${activities[i]?.description}</p>\n" +
                    "                    </div>\n" +
                    "                </div>";
        }

        result.boardHtml = boardHtml;
        result.sharingHtml = sharingHtml;
        result.articleHtml = articleHtml;
        result.activityHtml = activityHtml;
        result.max = params.max;
        result.offset = params.offset;
        result.acticleTotal = acticleTotal;
        result.boardTotal = boardTotal;
        result.sharingTotal = sharingTotal;
        result.activityTotal = activityTotal;
        return render(result as JSON)
    }
    /**
     * 社区修改页面
     * @return
     */
    def communityEdit() {
        def communityId = params.communityId;
        if (communityId) {
            StudyCommunity studyCommunity = StudyCommunity.get(communityId);
            if (studyCommunity && studyCommunity.create_comsumer_id == session.consumer.id) {
                //查询所有第一节点
                def rmsCategoryList1 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {
                    'in'("type", [0, 2])
                    eq("parentid", 0)
                    eq("state", true)
                }
                //查询该社区的分类所属父分类的所有子分类
                def rmsCategoryList2 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {
                    'in'("type", [0, 2])
                    eq("parentid", studyCommunity.communityCategory.parentid)
                    eq("state", true)
                }
                return render(view: 'communityEdit', model: [rmsCategoryList1: rmsCategoryList1, rmsCategoryList2: rmsCategoryList2, studyCommunity: studyCommunity]);
            }
        }
        return redirect(controller: 'my', action: 'myCreatedCommunity');
    }
    /**
     * 社区更新
     */
    def communityUpdate() {
        def result = [:];
        if (params.description == null || params.description == "") params.description = "未填写"
        def image = uploadImg('update')
        def bgImage = uploadBgImg('update')
        if (image) {
            params.photo = image;
        }
        if (image) {
            params.bgPhoto = bgImage;
        }
        params.consumerId = session.consumer.id;
        result = communityService.communityUpdate(params);
        flash.message = result.message;
        if (result.success) {
            return redirect(controller: 'my', action: 'myCreatedCommunity');
        } else {
            return redirect(controller: 'my', action: 'communityEdit', communityId: params.communityId);
        }
    }

    def addConsumerAjax() {
        params.consumerId = session.consumer.id;
        def result = communityService.addConsumerAjax(params);
        return render(result as JSON)
    }

    def communityIndex = {
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0
        def boardList = [];
        def myBoradList = [];
        def myCommunityList = [];
        def myActivityList = [];
        def boards1 = [];
        def articleList = [];
        def total = 0;
        Notice noticeNew = null;
        Notice notice = null;
        StudyCommunity studyCommunity;
        if (params.id) {
            studyCommunity = StudyCommunity.get(params.id as Long);
            if (studyCommunity) {
                studyCommunity.visit = studyCommunity.visit + 1;
                studyCommunity.save(flush: true);
                if (studyCommunity.forumBoards.size() > 0) {
                    articleList = ForumMainArticle.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                        inList("forumBoard", studyCommunity.forumBoards.toList())
                        order("isTop", "desc")
                    }//.findAllByForumBoardInList(studyCommunity.forumBoards.toList();
                }
                total = articleList.totalCount

                // 取得最新公告
                if (studyCommunity.notices.size() > 0) {
                    noticeNew = Notice.createCriteria().list() {
                        eq("studyCommunity", studyCommunity)
                        order("dateCreated", "desc")
                    }.get(0);
                }
                if (judeLoginConsumer()) {
                    if (studyCommunity.activitys.size() > 0) {
                        List<ActivitySubject> subjectList = ActivitySubject.withCriteria {
                            eq("createConsumer", session.consumer)
                            "in"("activity", studyCommunity.activitys)
                        }
                        def activityList = subjectList*.activity
                        if (activityList.size() > 5) {
                            activityList = activityList.subList(0, 4);
                        }
                        activityList.each {
                            if (!myActivityList.contains(it)) {
                                myActivityList.add(it)
                            }
                        }
                    }
                    if (studyCommunity.forumBoards.size() > 0) {
                        // 取得未禁用的社区
                        def usableCriteria = StudyCommunity.createCriteria();
                        List<StudyCommunity> usableCommunity = usableCriteria.list{
                            eq("state", StudyCommunity.STUDYCOMMUNITY_STATE_PASS);
                        }

                        def memberCriteria = ForumMember.createCriteria();
                        myBoradList = memberCriteria.list(max: 5) {
                            eq("consumer", session.consumer)
                            eq("state", ForumMember.STATE_NORMAIL)
                            "in"("studyCommunity", usableCommunity)
                        }
                    }
                    boardList = ForumBoard.createCriteria().list() {
                        eq('studyCommunity', studyCommunity)
                    }
                }

                def hotMembers = ForumMember.withCriteria {
                    projections {
                        distinct("consumer")
                    }
                    eq("state", 0)
                    eq("studyCommunity", studyCommunity)
                    maxResults(9)
                    order("joinDate", "desc")
                }

                return render(view: 'communityIndex', model: [total: total, params: params, hotMembers: hotMembers, boardList: boardList, myBoradList: myBoradList, myActivityList: myActivityList, articleList: articleList, notice: notice, studyCommunity: studyCommunity, noticeNew: noticeNew])
            }


        } else {
            flash.message = "参数不全"
            return redirect(action: 'index')
        }

    }


    def search = {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        Date begin_date = null;
        Date end_date = null;

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0
        if (!params.communityType) params.communityType = 'all'

        def pageCount = 0
        def maxCount = params.max
        def setCount = 0
        if (params.totalCount != null) {
            pageCount = Math.round(Math.ceil(params.totalCount / params.max))
            maxCount = params.max * pageCount
            setCount = params.max * (pageCount - 1)
        }

        def communityType = params.communityType
        def name = params.name
        def consumer = params.consumer

        def searchList = StudyCommunity.createCriteria().list(max: 10, offset: 0, sort: params.sort, order: params.order) {
            //if (communityType == 'my'){
            //	eq('create_comsumer_id',session.consumer.id)
            //}
            //else if(communityType == 'join'){
            //	eq('members',session.consumer)
            //	eq('state',1)
            //}
            //else
            if (communityType == 'all') {
                eq('state', 1)
            }
            if (name) {
                name = name.trim()
                like('name', "%${name}%")
            }
            if (CTools.nullToZero(params?.categoryId).longValue() != 0) {
                communityCategory {
                    eq('id', CTools.nullToZero(params?.categoryId).longValue())
                }
            }
        }

        return searchList

    }

    def multipleSearch = {
        def type = params?.type
        def name = params?.title
        def searchType = "贴子"
        if (type == null || type == "") type = "post"
        session.communityMenuId = 0

        if (!params.max) params.max = 12
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        def setCount = 0
        if (params.pageIndex != null && params.pageIndex != "") {
            setCount = params.max.toInteger() * (params.pageIndex.toInteger() - 1)
        }
        if (params.pageIndex == null || params.pageIndex == "") params.pageIndex = 1

        def multipleList = null
        if (type == "post") {
            multipleList = ForumMainArticle.createCriteria().list(max: params.max, offset: setCount, sort: "dateCreated", order: "desc") {
                forumBoard {
                    studyCommunity {
                        eq('id', CTools.nullToZero(session.communityId).longValue())
                    }
                }
                if (name && name != "") {
                    name = name.trim()
                    like('name', "%${name}%")
                }
            }
            searchType = "贴子"
        } else if (type == "sharing") {
            multipleList = Sharing.createCriteria().list(max: params.max, offset: setCount, sort: "dateCreated", order: "desc") {
                studyCommunity {
                    eq('id', CTools.nullToZero(session.communityId).longValue())
                }
                if (name && name != "") {
                    name = name.trim()
                    like('name', "%${name}%")
                }
            }
            searchType = "共享"
        } else if (type == "activity") {
            multipleList = Activity.createCriteria().list(max: params.max, offset: setCount, sort: "dateCreated", order: "desc") {
                studyCommunity {
                    eq('id', CTools.nullToZero(session.communityId).longValue())
                }
                if (name && name != "") {
                    name = name.trim()
                    like('name', "%${name}%")
                }
                eq("isOpen", true)
            }
            searchType = "活动"
        } else if (type == "notice") {
            multipleList = Notice.createCriteria().list(max: params.max, offset: setCount, sort: "dateCreated", order: "desc") {
                studyCommunity {
                    eq("id", CTools.nullToZero(session.communityId).longValue())
                }
                if (name && name != "") {
                    name = name.trim()
                    like('name', "%${name}%")
                }
            }
            searchType = "公告"
        } else if (type == "recommend") {
            def studyCommunity = StudyCommunity.get(session.communityId)
            def idList = [CTools.nullToZero(studyCommunity.create_comsumer_id).longValue()]
            studyCommunity.members?.each { member ->
                idList.add(CTools.nullToZero(member.id).longValue())
            }
            if (idList != null && idList.size() != 0) {
                multipleList = Program.createCriteria().list(max: params.max, offset: setCount, sort: "recommendNum", order: "desc") {
                    ne("recommendNum", 0)
                    consumer {
                        'in'("id", idList)
                    }
                    if (name && name != "") {
                        name = name.trim()
                        like('name', "%${name}%")
                    }
                }
            }
            searchType = "推荐的资源"
        }

        def total = multipleList.totalCount
        def pageCount = Math.round(Math.ceil(total / params.max.toInteger()))
        render(view: "multipleSearchList", model: ["multipleList": multipleList, "total": total, "pageIndex": params.pageIndex.toInteger(), "pageCount": pageCount, "searchType": searchType, "params": params])
    }

    def show = {

        def communityInstance = StudyCommunity.get(params.communityId)
        session.classLibId = CTools.nullToOne(params.classLib?.id)//nullToZero

        def webUtils = WebUtils.retrieveGrailsWebRequest();
        def response = webUtils.getCurrentResponse();
        String uploadPath = servletContext.uploadRootPath + '/' + session.consumer.name + '/community' + session.classLibId + '/';
        Cookie cookie = new Cookie("uploadPath3", uploadPath);
        response.addCookie(cookie);

        if (!communityInstance) {
            flash.message = "nts.commity.domain.StudyCommunity not found with id ${params.id}"
            redirect(action: 'communityLeft')
        } else {
            session.studyCommunity = communityInstance;
            session.communityId = communityInstance.id;
            session.createConsumer = Consumer.findById(communityInstance.create_comsumer_id);
            return [communityInstance: communityInstance]
        }
    }

    def showInfo = {
        def communityInstance = StudyCommunity.get(session.communityId)
        session.communityMenuId = 8
        session.communityManagerMenuId = 1
        session.classLibId = CTools.nullToOne(params.classLib?.id)//nullToZero

        if (!communityInstance) {
            flash.message = "nts.commity.domain.StudyCommunity not found with id ${params.id}"
            redirect(action: communityLeft)
        } else {
            return [communityInstance: communityInstance]
        }
    }

    def delete = {
        def subject = Subjects.get(params.subjectId)
        if (subject) {
            try {
                subject.delete(flush: true)
                flash.message = "删除完成"
            }
            catch (DataIntegrityViolationException e) {
                flash.message = "Subject ${params.id} could not be deleted"
                redirect(action: list, params: params)
            }
        } else {
            flash.message = "找不到该主题"
        }
        redirect(action: list, params: params)
    }

    def edit = {
        def studyCommunityInstance = StudyCommunity.get(params.id)
        def rmsCategoryList1 = RMSCategory.findAllByParentid(0, [sort: "id", order: "desc"])                //一级类别
        def rmsCategoryList2 = RMSCategory.findAllByParentid(studyCommunityInstance.communityCategory.parentid, [sort: "id", order: "desc"])

        if (params.editType != null & params.editType != "") {
            render(view: params.editType, model: ['studyCommunityInstance': studyCommunityInstance, 'rmsCategoryList1': rmsCategoryList1, 'rmsCategoryList2': rmsCategoryList2, 'editType': params.editType])
            return
        }
        return ['studyCommunityInstance': studyCommunityInstance, 'rmsCategoryList1': rmsCategoryList1, 'rmsCategoryList2': rmsCategoryList2]
    }

    def update = {
        def studyCommunity = StudyCommunity.get(params.id)
        if (studyCommunity) {
            def rmsCategory = RMSCategory.get(params.categoryId)
            def photo = uploadImg('update')
            if (photo != "null" && photo != "") {
                studyCommunity.photo = photo
            }
            studyCommunity.name = params.name
            studyCommunity.communityCategory = rmsCategory
            studyCommunity.description = params.description

            if (!studyCommunity.hasErrors() && studyCommunity.save()) {
                flash.message = "学习社区修改成功"
                if (params.showType == "my") {
                    redirect(controller: 'my', action: 'myCommunity', params: params)
                }
                redirect(action: 'showInfo', params: params)
            } else {
                render(view: 'edit', model: [subject: subject])
            }
        } else {
            flash.message = "找不到该学习社区"
            redirect(action: edit, params: params)
        }

    }

    @ActionNameAnnotation(name = "创建社区")
    def create() {
        List<RMSCategory> rmsCategoryList1 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {
            //一级类别
            'in'("type", [2])
            eq("parentid", 0)
            eq("state", true)
        }

        List<RMSCategory> rmsCategoryList2 = []
        if (rmsCategoryList1 != null && rmsCategoryList1 != []) {
            rmsCategoryList2 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {                //二级类别
                'in'("type", [2])
                eq("parentid", rmsCategoryList1[0]?.id.toInteger())
                eq("state", true)
            }
        }

        def studyCommunityInstance = new StudyCommunity()
        studyCommunityInstance.properties = params
        return ['studyCommunityInstance': studyCommunityInstance, 'rmsCategoryList1': rmsCategoryList1, 'rmsCategoryList2': rmsCategoryList2]
    }

    def save = {
        //创建社区
        def rmsCategory = RMSCategory.get(params.categoryId);
        if (params.description == null || params.description == "") params.description = "未填写"
        def image = uploadImg('save')
        def bgImage = uploadBgImg('save')
        if (image == null || image == "" || image == "null") {
            image = "default.jpg"
        }
        def description = CTools.htmlToBlank(params.description);
        def studyCommunity = new StudyCommunity(
                name: params.name,                                    //社区名称
                description: description,                    //社区简介
                photo: image,                            //社区图片
                bgPhoto: bgImage,
                dateCreated: new Date(),                            //发起时间
                create_comsumer_id: session.consumer.id,            //创建者
                state: 2,                                //状态
                communityCategory: rmsCategory,
                membersCount: 0,
                isRecommend: false
        )

        if (!studyCommunity.hasErrors() && studyCommunity.save()) {
            return redirect(action: 'index', params: [id: studyCommunity?.id])
        } else {
            flash.message = "社区创建失败";
            return redirect(action: 'create')
        }
        return redirect(action: 'index')
    }

    def queryCategoryTwo = {
        def category1 = params.category1
        if (category1 != null) {
            category1 = category1.toInteger();
        } else {
            category1 = 0;
        }
        //用于活动创建时显示分类 为了别人的前台不用做修改，只有在创建活动时才传category_type=3
        def category_type = Integer.parseInt(params.category_type ? params.category_type as String : "2")

        def categoryList = RMSCategory.createCriteria().list() {
            eq("state", true)
            'in'("type", [0, category_type])
            eq("parentid", category1)
        }
        def str = ""
        categoryList?.each { category ->
            str += "<option value='" + category?.id + "'>" + category?.name + "</option>"
        }
        render(text: str, contentType: "text/plain");
    }
    //上传图片(opt：值为save表示添加图片，值为update表示修改图片)
    def uploadBgImg(def opt) {
        CommonsMultipartFile imgFile = request.getFile("bgImage");
        def imgName = imgFile.getOriginalFilename();
        def imgType = imgFile.getContentType();

        def path = servletContext.getRealPath("/upload");

        def imgPath = ""

        if (imgFile && !imgFile.isEmpty()) {
            if (imgType == "image/pjpeg" || imgType == "image/jpeg" || imgType == "image/png" || imgType == "image/x-png" || imgType == "image/gif") {
                if (opt == "save") {
                    def id = System.currentTimeMillis();
                    imgPath = "i_" + id + ".jpg"
                } else if (opt == "update") {
                    def id = params.id
                    imgPath = "i_" + id + ".jpg"
                }
                File file = new File("${path}/communityImg/bgimg");
                if (!file.exists()) file.mkdirs();
                imgFile.transferTo(new File("${path}/communityImg/bgimg/" + imgPath))

            } else {
                flash.message = "上传图片格式不对..."
            }
        }
        return imgPath
    }
    //上传图片(opt：值为save表示添加图片，值为update表示修改图片)
    def uploadImg(def opt) {
        CommonsMultipartFile imgFile = request.getFile("Img");
        def imgName = imgFile.getOriginalFilename();
        def imgType = imgFile.getContentType();

        def path = servletContext.getRealPath("/upload");

        def imgPath = ""

        if (imgFile && !imgFile.isEmpty()) {
            if (imgType == "image/pjpeg" || imgType == "image/jpeg" || imgType == "image/png" || imgType == "image/x-png" || imgType == "image/gif") {
                if (opt == "save") {
                    /*def sc = StudyCommunity.createCriteria()
                    def id = sc.get {
                        projections {
                            max "id"
                        }
                    }*/
                    def id = System.currentTimeMillis();
                    /*id = id == null ? 1 : id + 1*/
                    //UUID.randomUUID().toString()

                    imgPath = "i_" + id + ".jpg"
                } else if (opt == "update") {
                    def id = params.id
                    imgPath = "i_" + id + ".jpg"
                }
                if (params.activityImgPath) {
                    File file = new File("${path}/communityImg/activity");
                    if (!file.exists()) file.mkdirs();
                    imgFile.transferTo(new File("${path}/communityImg/activity/" + imgPath))
                } else if (params.forumBoardImgPath) {
                    File file = new File("${path}/communityImg/forumboard");
                    if (!file.exists()) file.mkdirs();
                    imgFile.transferTo(new File("${path}/communityImg/forumboard/" + imgPath))
                } else {
                    File file = new File("${path}/communityImg");
                    if (!file.exists()) file.mkdirs();
                    imgFile.transferTo(new File("${path}/communityImg/" + imgPath))
                }
            } else {
                flash.message = "上传图片格式不对..."
            }
        }
        return imgPath
    }

    //进入学习社区
    def community = {
        def studyCommunity = StudyCommunity.get(params.communityId)            //查询社区
        def createConsumer = Consumer.get(studyCommunity.create_comsumer_id);    //创建者

        if (session.communityVisit == null) {
            studyCommunity.visit = studyCommunity.visit + 1
            studyCommunity.save()
            session.communityVisit = studyCommunity.visit
        }
        session.communityId = params.communityId
        session.createConsumer = createConsumer

        ['studyCommunity': studyCommunity, 'createConsumer': createConsumer]
    }

    //加载学习社区左边
    def communityLeft = {

        def communityId = 0
        if (params.communityId != null && params.communityId != "") {
            communityId = params.communityId
            session.communityId = params.communityId
        } else {
            communityId = session.communityId
        }
        def communityInstance = StudyCommunity.get(communityId)            //查询社区
        def createConsumer = Consumer.get(communityInstance.create_comsumer_id);    //创建者

        if (session.communityVisit != session.communityId) {
            communityInstance.visit = communityInstance.visit + 1
            communityInstance.save()
            session.communityVisit = session.communityId
        }
        session.createConsumer = createConsumer
        session.communityMenuId = 1
        session.studyCommunity = communityInstance
        session.classLibId = CTools.nullToOne(params.classLib?.id)//nullToZero

        if (!params.max) params.max = 6
        if (!params.offset) params.offset = 0

        def setCount = 0

        //-----------最新动态begin--------------
        if (params.pageIndex != null) {
            setCount = 6 * (params.pageIndex.toInteger() - 1)
        }
        if (params.pageIndex == null) params.pageIndex = 1

        def logsPublicList = LogsPublic.createCriteria().list(max: 6, offset: setCount, sort: "dateCreated", order: "desc") {
            eq("studyCommunity_id", communityId.toInteger())
        }
        def total = logsPublicList.totalCount
        def pageCount = Math.round(Math.ceil(total / 6))
        //------------最新动态end---------------

        //-----------最新公告begin--------------
        setCount = 0
        if (params.pageNoticeIndex != null && params.pageNoticeIndex != "") {
            setCount = 7 * (params.pageNoticeIndex.toInteger() - 1)
        }
        if (params.pageNoticeIndex == null || params.pageNoticeIndex == "") params.pageNoticeIndex = 1

        def noticeList = Notice.createCriteria().list(max: 7, offset: setCount, sort: "dateCreated", order: "desc") {
            studyCommunity {
                eq("id", CTools.nullToZero(session.communityId).longValue())
            }
        }

        def totalNotice = noticeList.totalCount
        def pageNoticeCount = Math.round(Math.ceil(totalNotice / 7))
        //------------最新公告end---------------

        //-----------推荐的资源begin--------------
        setCount = 0
        if (params.pageTuiIndex != null && params.pageTuiIndex != "") {
            setCount = 8 * (params.pageTuiIndex.toInteger() - 1)
        }
        if (params.pageTuiIndex == null || params.pageTuiIndex == "") params.pageTuiIndex = 1

        def idList = [CTools.nullToZero(communityInstance.create_comsumer_id + "").longValue()]
        communityInstance.members?.each { member ->
            idList.add(CTools.nullToZero(member.id).longValue())
        }
        def programList = null
        if (idList != null && idList.size() != 0) {
            programList = Program.createCriteria().list(max: 8, offset: setCount, sort: "recommendNum", order: "desc") {
                ne("recommendNum", 0)
                consumer {
                    'in'("id", idList)
                }
            }
        }

        def totalTui = programList.totalCount
        def pageTuiCount = Math.round(Math.ceil(totalTui / 8))
        //------------推荐的资源end---------------

        //-----------共享begin--------------
        setCount = 0
        if (params.pageSharingIndex != null && params.pageSharingIndex != "") {
            setCount = 12 * (params.pageSharingIndex.toInteger() - 1)
        }
        if (params.pageSharingIndex == null || params.pageSharingIndex == "") params.pageSharingIndex = 1

        def sharingList = Sharing.createCriteria().list(max: 12, offset: setCount, sort: "dateCreated", order: "desc") {
            studyCommunity {
                eq('id', CTools.nullToZero(session.communityId).longValue())
            }
        }

        def totalSharing = sharingList.totalCount
        def pageSharingCount = Math.round(Math.ceil(totalSharing / 12))
        //------------共享end---------------
        if (params.liType == null || params.liType == "") params.liType = "m01"

        ['liType': params.liType, 'communityInstance': communityInstance, 'programList': programList, 'createConsumer': createConsumer, 'logsPublicList': logsPublicList, 'noticeList': noticeList, 'sharingList': sharingList, 'pageIndex': params.pageIndex.toInteger(), 'pageCount': pageCount, 'pageTuiIndex': params.pageTuiIndex.toInteger(), 'pageTuiCount': pageTuiCount, 'pageNoticeIndex': params.pageNoticeIndex.toInteger(), 'pageNoticeCount': pageNoticeCount, 'pageSharingIndex': params.pageSharingIndex.toInteger(), 'pageSharingCount': pageSharingCount]
    }

    //我的消息管理页，显示收信箱、发信箱、垃圾箱的数量
    def myMessageList = {
        if (!params.tag) params.tag = '1'

        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0

        params.sort = "id"
        params.order = "desc"

        def tag = params.tag

        request.singleFlag = 6 //个人空间左侧菜单标记 6-消息管理

        //写信
        if (tag == '0') {
            def collegeList = College.list()

            [params: params, collegeList: collegeList]
        }
        //收件箱
        else if (tag == '1') {
            def receiveMessageList = Message.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                eq("receiveConsumerID", session.consumer.id.intValue())
                ne("state", 2)
            }
            [
                    receiveMessageList : receiveMessageList,
                    receiveMessageTotal: receiveMessageList?.totalCount,
                    params             : params
            ]
        }
        //发件箱
        else if (tag == '2') {
            def sendMessageList = Message.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                eq("sendConsumerID", session.consumer.id.intValue())
                ne("state", 2)
            }
            [
                    sendMessageList : sendMessageList,
                    sendMessageTotal: sendMessageList?.totalCount,
                    params          : params
            ]
        }
        //垃圾箱
        else if (tag == '3') {
            def dustbinMessageList = Message.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                eq("state", 2)
                eq("receiveConsumerID", session.consumer.id.intValue())
            }
            [
                    dustbinMessageList : dustbinMessageList,
                    dustbinMessageTotal: dustbinMessageList?.totalCount,
                    params             : params
            ]
        }
        //默认消息首页
        else if (tag == '4') {
            def inboxCount = Message.countByReceiveConsumerID(session.consumer.id) //收件数
            def inboxNoReadCount = Message.countByReceiveConsumerIDAndState(session.consumer.id, 0) //收件箱未读数
            def outboxCount = Message.countBySendConsumerID(session.consumer.id) //发件数
            def outboxNoReadCount = Message.countBySendConsumerIDAndState(session.consumer.id, 0) //发件未被读数
            def dustbinCount = Message.countByReceiveConsumerIDAndState(session.consumer.id, 2) //垃圾箱数
            [
                    inboxCount       : inboxCount,
                    inboxNoReadCount : inboxNoReadCount,
                    outboxCount      : outboxCount,
                    outboxNoReadCount: outboxNoReadCount,
                    dustbinCount     : dustbinCount,
                    params           : params
            ]
        }
    }

    //社区成员管理
    //加入社区
    @ActionNameAnnotation(name = "加入社区")
    def saveMember() {
        def member = Consumer.get(session.consumer.id)
        def studyCommunity = StudyCommunity.get(params.communityId)
        if (studyCommunity != null) {
            studyCommunity.addToMembers(member)
        }

        redirect(action: 'communityIndex')
    }

    //显示成员
    def listMember = {
        def studyCommunity = StudyCommunity.get(session.communityId)

        if (!params.max) params.max = 5
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0
        if (!params.communityType) params.communityType = 'all'
        session.communityMenuId = 7
        session.communityManagerMenuId = 2
        session.classLibId = CTools.nullToOne(params.classLib?.id)//nullToZero

        def setCount = 0
        if (params.pageIndex != null) {
            setCount = params.max.toInteger() * (params.pageIndex.toInteger() - 1)
        }
        if (params.pageIndex == null) params.pageIndex = 1

        def members = studyCommunity.members
        def total = members.size()
        if (total == null || total == []) total = 0
        def pageCount = Math.round(Math.ceil(total / params.max.toInteger()))

        if (params.toPage != null & params.toPage != "") {
            session.communityMenuId = 8
            render(view: params.toPage, model: [studyCommunity: studyCommunity, members: members, pageIndex: params.pageIndex.toInteger(), total: total, pageCount: pageCount])
            return
        }
        [studyCommunity: studyCommunity, members: members, pageIndex: params.pageIndex.toInteger(), total: total, pageCount: pageCount]
    }

    //删除成员
    def deleteMember = {
        def member = Consumer.get(params.delId)
        def studyCommunity = StudyCommunity.get(session.communityId)
        studyCommunity.removeFromMembers(member)

        redirect(action: listMember, params: params)
    }

    //批量删除成员
    def deleteMemberList = {
        def delIdList = params.idList

        if (delIdList instanceof String) delIdList = [params.idList]

        delIdList?.each { id ->
            def member = Consumer.get(id)
            def studyCommunity = StudyCommunity.get(session.communityId)
            studyCommunity.removeFromMembers(member)
        }

        redirect(action: listMember, params: params)
    }

    //后台管理学习社区
    def listManager = {
        //取得最大显示页面，并转换为整型
        //取得页面偏移量，并转换为整型
        def communityList = searchManager()
        def nameList = []
        communityList?.each { community ->
            def consumer = Consumer.get(community.create_comsumer_id)
            nameList.add(consumer.name)
        }

        def total = communityList.totalCount

        def _max = params.max.toInteger()
        def _offset = params.offset.toInteger()
        int pageCount = Math.round(Math.ceil(total / _max))
        int pageNow = (_offset / _max) + 1

        [communityList: communityList, nameList: nameList, total: total, pageCount: pageCount, pageNow: pageNow]
    }

    def searchManager = {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        Date begin_date = null;
        Date end_date = null;

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        def name = params.name
        def state = params.state

        def searchTitle = params.searchTitle
        def searchCommunityType = params.searchCommunityType
        def searchConsumer = params.searchConsumer

        def searchList = StudyCommunity.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (name) {
                name = name.trim()
                like('name', "%${name}%")
            }
            if (state) {
                eq("state", state.toInteger())
            }
        }

        return searchList

    }

    //学习社区后台管理
    //学习社区审核
    def communityExamine = {
        def communityInstance = StudyCommunity.get(params.id)
        if (communityInstance != null) {
            communityInstance.state = params.communityState.toInteger()
            if (!communityInstance.hasErrors() && communityInstance.save(flush: true)) {
                flash.message = "学习社区审核成功"
            }
        } else {
            flash.message = "学习社区未找到"
        }
        redirect(action: "listManager", params: params)
    }

    //删除学习社区
    def deleteCommunity = {

        def communityInstance = StudyCommunity.get(params.delId)

        if (communityInstance) {
            try {
                def forumBoards = communityInstance.forumBoards
                forumBoards?.each { forumBoard ->
                    deleteForumBoard(forumBoard.id)
                }
                communityInstance.delete(flush: true)
                flash.message = "学习社区删除完成";

            }
            catch (DataIntegrityViolationException e) {
                flash.message = "nts.commity.domain.StudyCommunity ${params.delId} could not be deleted"
                redirect(action: 'listManager', params: params)
            }
        } else {
            flash.message = "找不到该主题"
        }
        redirect(action: 'listManager', params: params)
    }

    //批量删除学习社区
    def deleteCommunityList = {
        def delIdList = params.idList
        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            def community = StudyCommunity.get(id)
            def forumBoards = community.forumBoards
            forumBoards?.each { forumBoard ->
                deleteForumBoard(forumBoard.id)
            }
            community.delete()
        }

        redirect(action: listManager, params: params)
    }

    def deleteForumBoard(id) {
        def forumBoard = ForumBoard.get(id)
        if (forumBoard) {
            forumBoard.delete()
        }
    }

    //学习社区推荐
    def communityRecommend = {
        def communityInstance = StudyCommunity.get(params.id)
        if (communityInstance != null) {
            if (params.isRecommend == "true") {
                communityInstance.isRecommend = true
            } else {
                communityInstance.isRecommend = false
            }
            if (!communityInstance.hasErrors() && communityInstance.save(flush: true)) {
                flash.message = "学习社区推荐成功"
            }
        } else {
            flash.message = "学习社区未找到"
        }
        redirect(action: "listManager", params: params)
    }

    def uploadShare = {
        def result = [:];
        //serialId,fileEntity
        try {
            int communityId = params.communityId as int;
            int userId = params.userId as int;
            CommonsMultipartFile fileEntity = params.fileEntity;

            def UploadRootPath = SysConfig.findByConfigName('UploadRootPath');        //上传路径设置
            def rootFile = new File(UploadRootPath.configValue, "community${communityId}/${userId}");

            if (!rootFile.exists()) {
                rootFile.mkdirs();
            }

            File dest = new File(rootFile, fileEntity.originalFilename);
            if (dest.exists()) {
                dest.delete();
            }
            dest.createNewFile();
            FileUtils.copyInputStreamToFile(fileEntity.inputStream, dest);
            result.success = true;
            result.filePath = dest.getAbsolutePath();

        } catch (Exception e) {
            result.success = false;
            result.msg = e.message;
        }
        response.setContentType("text/json");
        return render(result as JSON);
    }

    def replayArticle() {
        def result = [:];
        ForumReplyArticle replyArticle;
        if (params.id) {
            replyArticle = ForumReplyArticle.get(params.id as Long);
            if (replyArticle) {
                ForumReplySubjectArticle subReply = new ForumReplySubjectArticle();
                subReply.name = session.consumer.name;
                subReply.description = params.description;
                subReply.dateCreated = new Date();
                subReply.consumer = session.consumer;
                subReply.forumReplyArticle = replyArticle;
                subReply.save(flush: true);
                def sub = replyArticle.addToForumReplySubjectArticle(subReply);
                if (sub) {
                    def id = replyArticle?.forumMainArticle?.id;
                    result.success = true;
                } else {
                    result.success = false;
                    result.message = "回复失败！";
                }
            }
        }
        return render(result as JSON)
    }

    def firstReplyArticle() {
        def result = [:];
        ForumMainArticle article;
        if (params.id) {
            article = ForumMainArticle.get(params.id as Long);
            if (article) {
                ForumReplyArticle replyArticle = new ForumReplyArticle();
                replyArticle.name = session.consumer.name;
                def description = CTools.htmlToBlank(params.description);
                replyArticle.description = description;
                replyArticle.dateCreated = new Date();
                replyArticle.forumMainArticle = article;
                replyArticle.replyConsumer = session.consumer;
                article.addToForumReplyArticle(replyArticle);
                if (replyArticle.save(flush: true) && (!replyArticle.hasErrors())) {
                    result.success = true;
                } else {
                    result.success = false;
                    result.message = "回复失败！";
                }
            }
        }
        return render(result as JSON)
    }
    def communityGroupIndex = {
        if (!params.max) params.max = 10;
        if (!params.offset) params.offset = 0;
        ForumBoard board;
        List<ForumSharing> sharingList = [];
        int articleTotal = 0;
        int replyTotal = 0;
        int sharingTotal = 0;
        if (params.id) {
            board = ForumBoard.get(params.id as Long);
            if (session.consumer) {
                Consumer consumer = Consumer.get(session.consumer.id);
                if (consumer) {
                    articleTotal = board?.forumMainArticle?.size();
                    replyTotal = board?.forumMainArticle?.forumReplyArticle?.size();

                }
            }
            List<ForumSharing> sharings = [];
            sharings = ForumSharing.createCriteria().list(max: params.max, offset: params.offset) {
                eq('forumBoard', board)
                eq('state', 1)
            }
            sharings?.each {
                if (it.special) {
                    if (it.special.files.size() > 0) {
                        sharingList.add(it);
                    }
                }
                if (it.userFile) {
                    sharingList.add(it);
                }
            }
            sharingTotal = sharings.totalCount;
        }
        if (params.max == null) {
            params.max = 10;
        }
        List<ForumMainArticle> articleList = ForumMainArticle.createCriteria().list(max: params.max, sort: 'dateCreated', order: 'desc') {
            eq("forumBoard", board)
            order("isTop", "desc")
        };
        List<ForumBoard> boards = ForumBoard.list([order: 'desc', sort: 'dateCreated', max: 3]);

        def joinBoards = ForumMember.withCriteria {
            projections {
                distinct('forumBoard')
            }
            eq("state", 0)
            if (session.consumer) {
                eq("consumer", session.consumer)
            }
        }

        return render(view: 'communityGroupIndex', model: [sharingTotal: sharingTotal, sharingList: sharingList, articleTotal: articleTotal, replyTotal: replyTotal, boards: boards, board: board, articleList: articleList, joinBoards: joinBoards])
    }

    def saveArticle() {
        def name = params.name;
        def description = params.description;
        StudyCommunity studyCommunity;
        if (params.forumBoardId) {
            ForumBoard board = ForumBoard.get(params.forumBoardId as Long);
            studyCommunity = board.studyCommunity;
            if (studyCommunity && session.consumer && board) {
                ForumMainArticle article = new ForumMainArticle();
                article.createConsumer = session.consumer;
                article.forumBoard = board;
                article.name = params.name;
                article.description = params.description;
                article.dateCreated = new Date();
                if (article.save(flush: true) && (!article.hasErrors())) {
                    return redirect(action: 'communityGroupIndex', params: [id: params.forumBoardId, communityId: studyCommunity.id])
                } else {
                    flash.message = "话题发布失败";
                    return redirect(action: 'communityGroupIndex', params: [id: params.forumBoardId, communityId: studyCommunity.id])
                }
            } else {
                return render(view: 'communityIndex', params: [studyCommunity: studyCommunity])
            }
        } else {
            return redirect(action: 'communityGroupIndex', params: [id: params.forumBoardId, communityId: studyCommunity.id])
        }
    }

    def communityArticle() {
        ForumMainArticle article;
        int articleTotal;
        int replyTotal;
        int forumReplyTotal;

        if (!params.offset) params.offset = 0;
        if (!params.max) params.max = 10;
        List<ForumReplyArticle> forumReplyArticle = new ArrayList<ForumReplyArticle>();
        if (params.id) {
            article = ForumMainArticle.get(params.id as Long);
        }
        if (session.consumer) {
            Consumer consumer = Consumer.get(session.consumer.id);
            if (consumer) {
                articleTotal = ForumMainArticle.findAllByCreateConsumer(consumer).size();
                replyTotal = ForumMainArticle.findAllByCreateConsumer(consumer).forumReplyArticle.size();
                forumReplyArticle = ForumReplyArticle.createCriteria().list(order: 'desc', sort: 'dateCreated', offset: params.offset, max: params.max) {
                    eq('forumMainArticle', article)
                }
                forumReplyTotal = forumReplyArticle.totalCount;
            }
        }
        List<ForumBoard> boards = ForumBoard.list(order: 'desc', sort: 'dateCreated', max: 3)
        StudyCommunity studyCommunity = article.forumBoard.studyCommunity;
        return render(view: 'communityArticle', model: [studyCommunity: studyCommunity, boards: boards, article: article, articleTotal: articleTotal, forumReplyTotal: forumReplyTotal, forumReplyArticle: forumReplyArticle, replyTotal: replyTotal])
    }

    def communityGroupList() {
        List<ForumBoard> boards = [];
        def isFlag = "false";
        def isCheck = params.isCheck;
        StudyCommunity studyCommunity = StudyCommunity.get(params.communityId as Long);
        if (params.id) {
            if (params.isFlag == 'join') {
                List<ForumMember> forumMemberList = ForumMember.findAllByConsumer(Consumer.get(params.id));
                forumMemberList.each { ForumMember forumMember ->
                    boards.add(forumMember.forumBoard);
                }
            } else {
                boards = ForumBoard.createCriteria().list() {
                    eq("createConsumer", Consumer.get(params.id));
                }
            }

        } else {
            def idList = ForumBoard.withCriteria {
                maxResults(6)
                order("dateCreated")
                projections {
                    distinct("id")
                }
                //当前社区下的所有小组
                if (isCheck == "true") {
                    if (params.communityId) {
                        eq("studyCommunity", studyCommunity)
                    }
                }

                if (params.id) {
                    eq("id", params.id as Long)
                }
                /*if (isCheck == "true") {
                    eq("createConsumer", session.consumer)
                } else if (isCheck == false) {
                    //notEqual("createConsumer", session.consumer)
                }*/

            }
            idList.each {
                boards.add(ForumBoard.get(it));
            }
        }


        return render(view: 'communityGroupList', model: [boards: boards, isCheck: isCheck, studyCommunity: studyCommunity])
    }

    def communityShareList() {
        if (!params.max) params.max = 10;
        if (!params.offset) params.offset = 0;
        List<Sharing> sharings;
        def studyCommunity = StudyCommunity.get(params.communityId as Long);
        if (studyCommunity) {
            def forumMembers = ForumMember.findAllByConsumerAndStudyCommunity(session.consumer, studyCommunity);
            if ((forumMembers && forumMembers.size() > 0) || studyCommunity.create_comsumer_id == session.consumer.id) {
                def total;
                sharings = Sharing.createCriteria().list(max: params.max, offset: params.offset) {
                    if (studyCommunity) {
                        eq("studyCommunity", studyCommunity)
                    }
                };
                total = sharings.totalCount;
                return render(view: 'communityShareList', model: [sharings: sharings, total: total, studyCommunity: studyCommunity])
            } else {
                flash.message = "您不暂时不是该社区成员，请先加入一个小组！！！";
                return redirect(action: "communityGroupList", params: [isCheck: true, communityId: params.communityId])
            }
        } else {
            return redirect(action: "index")
        }

    }

    def communitySharingShow() {
        ForumSharing sharing = null;
        StudyCommunity studyCommunity = null;
        UserFile userFile = null;
        SpecialFile specialFile = null;
        if (params.sharingId) {
            sharing = ForumSharing.get(params.sharingId as Long);
            userFile = UserFile.get(params.id as Long);
            userFile.viewNum++;
            userFile.save(flush: true);
            if (params.isFlag != "1") specialFile = SpecialFile.findByUserFile(userFile);
            studyCommunity = sharing?.forumBoard?.studyCommunity;
            String filePath = userFile.filePath;

            //找出热门的10条分享
            List<ForumSharing> hotSharings = ForumSharing.list(max: 10, sort: 'createdDate', order: 'asc')


            return render(view: 'communitySharingVideoShow', model: [hotSharings: hotSharings, specialFile: specialFile, userFile: userFile, sharing: sharing, studyCommunity: studyCommunity])
        }
    }

    def createSharing() {
        def studyCommunity = StudyCommunity.get(params.communityId as Long);
        def webUtils = WebUtils.retrieveGrailsWebRequest();
        session.classLibId = CTools.nullToOne(params.classLib?.id)
        def response = webUtils.getCurrentResponse();
        String uploadPath = servletContext.uploadRootPath + '/' + session.consumer.name + '/community' + session.classLibId + '/';
        Cookie cookie = new Cookie("uploadPath3", uploadPath);
        response.addCookie(cookie);
        return render(view: 'createSharing', model: [studyCommunity: studyCommunity])
    }

    def saveSharing() {
        def communityId = params.communityId;
        def studyCommunity = StudyCommunity.get(communityId)

        params.id = communityId

        def description = CTools.htmlToBlank(params.description);
        Sharing sharing = new Sharing(
                name: params.name,
                description: description,
                url: params.url,
                fileHash: params.fileHash,
                fileType: params.fileType,
                download: 0,
                dateCreated: new Date(),
                shareConsumer: session.consumer,
                studyCommunity: studyCommunity
        )
        studyCommunity.addToSharings(sharing)
        if (!sharing.hasErrors() && sharing.save()) {
            flash.message = "主贴 ${sharing.name} 发布成功"
            String photo = session.consumer?.photo == null || session.consumer?.photo == "" ? "${resource(dir: 'images/skin', file: 'default.gif')}" : session.consumer?.photo
            def logsDescription = "<li><div class='qc01l'><img src='" + photo + "' class='qimg' /><a href='javascript:void(0)' onclick='sendMessage(" + session.consumer.id + ")' class='g3f'>发送消息</a></div><div class='qc01r'>" + session.consumer.name + "&nbsp;&nbsp;上传了共享<a href='/sharing/show?id=" + sharing.id + "' class='gblue qck qh2'>查看</a><p>" + params.name + "</p></div></li>"
            def logsPublic = new LogsPublic(
                    studyCommunity_id: communityId,
                    description: logsDescription,
                    dateCreated: new Date(),
                    type: LogsPublic.type_sharing,
                    typeId: sharing.id
            )
            if (!logsPublic.hasErrors() && logsPublic.save()) {
                flash.message = "上传共享创建成功"
            }
            //redirect(action: 'communityShareList', params: params)
            redirect(action: "communityIndexShare", params: params)
        } else {
            flash.message = "公告创建失败"
            //redirect(action: "communityShareList", params: params)
            redirect(action: "communityIndexShare", params: params)
        }
    }

    def saveActivity() {
        def communityId = params.communityId
        def studyCommunity = StudyCommunity.get(communityId);
        if (studyCommunity) {
            def forumMembers = ForumMember.findAllByConsumerAndStudyCommunity(session.consumer, studyCommunity);
            if ((forumMembers && forumMembers.size() > 0) || studyCommunity.create_comsumer_id == session.consumer.id) {
                params.activityImgPath = "activity";
                def image = uploadImg('save');
                if (image == null || image == "" || image == "null") {
                    image = "default.jpg"
                }
                def description = CTools.htmlToBlank(params.description);
                Activity activity = new Activity(
                        name: params.name,
                        description: description,
                        isOpen: true,
                        startTime: params.startTime,
                        endTime: params.endTime,
                        dateCreated: new Date(),
                        photo: image,
                        createConsumer: session.consumer,
                        studyCommunity: studyCommunity
                )

                if (!activity.hasErrors() && activity.save()) {
                    flash.message = "活动 ${activity.name} 发布成功"
                    String photo = session.consumer?.photo == null || session.consumer?.photo == "" ? "/images/default.gif" : session.consumer?.photo
                    def logsDescription = "<li><div class='qc01l'><img src='" + photo + "' class='qimg' onerror='this.src='/skin/blue/pc/front/images/boful_default_img.png''/><a href='javascript:void(0)' onclick='sendMessage(" + session.consumer.id + ")' class='g3f'>发送消息</a></div><div class='qc01r'>" + session.consumer.name + "&nbsp;&nbsp;发起了活动<a href='/activity/show?id=" + activity.id + "' class='gblue qck qh2'>查看</a><p>" + params.name + "</p></div></li>";
                    /*def logsDescription = "<li><div class='qc01l'><img src='"+photo+"' class='qimg' /><a href='javascript:void(0)' onclick='sendMessage("+session.consumer.id+")' class='g3f'>发送消息</a></div><div class='qc01r'>"+session.consumer.name+"&nbsp;&nbsp;发起了活动<a href='/activity/show?id="+activity.id+"' class='gblue qck qh2'>查看</a><p>"+params.name+"</p></div></li>"*/
                    def logsPublic = new LogsPublic(
                            studyCommunity_id: communityId,
                            description: logsDescription,
                            dateCreated: new Date(),
                            type: LogsPublic.type_activity,
                            typeId: activity.id
                    )
                    if (!logsPublic.hasErrors() && logsPublic.save()) {
                        flash.message = "活动创建成功"
                    }
                    return redirect(action: "communityActivityIndex", params: [studyCommunityId: communityId])
                } else {
                    activity.errors.each {
                        println it
                    }
                    flash.message = "活动创建失败"
                    return redirect(action: "communityActivityIndex", params: [studyCommunityId: communityId])
                }
                return render(view: 'communityActivityCreat', model: [communityId: params.communityId]);
            } else {
                flash.message = "您不暂时不是该社区成员，请先加入一个小组！！！";
                return redirect(action: "communityGroupList", params: [isCheck: true, communityId: params.communityId])
            }
        }

    }

    def communityActivityIndex() {
        def isFlag = params.isFlag;//isFlag =0,代表全部    1代表进行   -1 代表结束
        if (!params.max) params.max = 15;
        if (!params.offset) params.offset = 0;
        def studyCommunity = StudyCommunity.get(params.studyCommunityId as Long);
        def activityList = Activity.createCriteria().list(max: params.max, offset: params.offset, order: 'desc', sort: 'dateCreated') {
            if (isFlag == '1') {
                gt("endTime", new SimpleDateFormat('yyyy-MM-dd').format(new Date()))
            } else if (isFlag == '-1') {
                lt("endTime", new SimpleDateFormat('yyyy-MM-dd').format(new Date()))
            }
            eq("studyCommunity", studyCommunity);
            eq("isOpen", true)
        };
        return render(view: 'communityActivityIndex', model: [activityList: activityList, total: activityList.totalCount, studyCommunity: studyCommunity])
    }

    def communityActivityCreat() {
        def studyCommunity = params.communityId ? StudyCommunity.get(params.communityId as Long) : null;
        if (studyCommunity) {
            def forumMembers = ForumMember.findAllByConsumerAndStudyCommunity(session.consumer, studyCommunity);
            if ((forumMembers && forumMembers.size() > 0) || studyCommunity.create_comsumer_id == session.consumer.id) {
                return render(view: 'communityActivityCreat', model: [communityId: params.communityId]);
            } else {
                flash.message = "请先加入一个小组！！！";
                return redirect(action: "communityGroupList", params: [isCheck: true, communityId: params.communityId])
            }
        } else {
            return redirect(action: "index");
        }
    }

    def saveActivitySubject() {
        Activity activity = Activity.get(params.id as Long);
        Consumer consumer = Consumer.get(session.consumer.id);
        if (activity && consumer) {
            def forumMembers = ForumMember.findAllByConsumerAndStudyCommunityAndState(session.consumer, activity.studyCommunity, 0);
            if ((forumMembers && forumMembers.size() > 0) || activity.studyCommunity.create_comsumer_id == session.consumer.id) {
                ActivitySubject subject = new ActivitySubject();
//                def description = CTools.htmlToBlank(params.description);
                def description = params.description;
                subject.createConsumer = consumer;
                subject.activity = activity;
                subject.description = description;
                if (subject.save(flush: true) && (!subject.hasErrors())) {
                    return redirect(action: 'communityActivityShow', params: [id: activity?.id])
                } else {
                    flash.message = "活动建议回复失败!";
                    return redirect(action: 'communityActivityShow', params: [id: activity?.id])
                }
            } else {
                flash.message = "您暂时不是该社区成员，请先加入一个小组！！！";
                return redirect(action: "communityActivityShow", params: [id: params.id])
            }

        }
    }

    //验证登录人是否是社区小组成员
    def checkCommunityMember = {
        def result = [:]
        Activity activity = Activity.get(params.id as Long);
        Consumer consumer = Consumer.get(session.consumer.id);
        if (activity && consumer) {
            def forumMembers = ForumMember.findAllByConsumerAndStudyCommunityAndState(session.consumer, activity.studyCommunity, 0);
            if ((forumMembers && forumMembers.size() > 0) || activity.studyCommunity.create_comsumer_id == session.consumer.id) {
                result.flag = true
            } else {
                result.flag = false
                result.msg = '您不暂时不是该社区成员，请先加入一个小组！！！'
            }
        } else {
            result.flag = false
            result.msg = '参数错误！！！'
        }
        render(result as JSON)
    }

    def communityActivityShow() {
        Activity activity = Activity.get(params.id as Long);
        StudyCommunity studyCommunity = activity?.studyCommunity;
        if (new SimpleDateFormat("yyyy-MM-dd").parse(activity.endTime) > new Date() || activity.createConsumer.id == session.consumer.id) {
            List<Activity> recommendActivity = Activity.createCriteria().list(max: 3, order: 'desc', sort: 'dateCreated') {
                //notEqual("createConsumer", session.consumer)
                gt("endTime", new SimpleDateFormat('yyyy-MM-dd').format(new Date()))
                eq("isOpen", true)
                eq("studyCommunity", studyCommunity)
            }
            List<ActivitySubject> activitySubjectList = ActivitySubject.createCriteria().list(order: 'desc', sort: 'dateCreated') {
                eq("activity", activity)
            };
            return render(view: 'communityActivityShow', model: [activitySubjectList: activitySubjectList, studyCommunity: studyCommunity, activity: activity, recommendActivity: recommendActivity])
        } else {
            flash.message = "活动已经过期!";
            return render(text: flash.message);
            //return redirect(action: 'communityActivityIndex', params: [studyCommunityId: params.communityId])
        }

    }
    /**
     * 社区共享下载
     * @return
     */
    def downloadSharing() {
        //consumer的downlaodnum增加1
        def studyCommunity = params.communityId ? StudyCommunity.get(params.communityId as Long) : null;
        if (studyCommunity) {
            def forumMembers = ForumMember.findAllByConsumerAndStudyCommunity(session.consumer, studyCommunity);
            if ((forumMembers && forumMembers.size() > 0) || studyCommunity.create_comsumer_id == session.consumer.id) {
                if (session.consumer) {
                    def consumer = Consumer.get(session.consumer.id)
                    consumer.downloadNum += 1
                    consumer.save()
                }

                String videoSevr = servletContext.getAttribute("videoSevr");
                String videoPort = servletContext.getAttribute("videoPort");    //视频服务器端口
                String url = "http://" + videoSevr + ":" + videoPort + "/bmc/upload/downloadFile?fileHash=" + params.fileHash;
                def fileName = params.fileHash + "." + params.fileType;
                HttpClient client = HttpClientBuilder.create().build();
                HttpGet getMethod = new HttpGet(url);
                getMethod.setHeader("Referer", "http://192.168.1.0")
                HttpResponse httpResponse = client.execute(getMethod);
                HttpEntity httpEntity = httpResponse.getEntity()
                InputStream inputStream = httpResponse.getEntity().getContent()
                response.setContentType("application/octet-stream")
                response.setHeader("Content-disposition", "attachment;filename=" + fileName)

                Sharing sharing = Sharing.get(params.id as Long);
                if (sharing) {
                    sharing.download++;
                    sharing.save(flush: true);
                }

                //以指定的文件名作为附件返回到前台，供下载，
                //前台发起的请求形式为：window.location.href = "actionName" 或 <a href ="actionName"></a> 点击
                response.outputStream << inputStream
            } else {
                flash.message = "您不暂时不是该社区成员，请先加入一个小组！！！";
                return redirect(action: "communityGroupList", params: [isCheck: true, communityId: params.communityId])
            }
        } else {
            return redirect(action: "index");
        }
    }
    def communityAllIndex = {
        if (!params.max) params.max = 5;
        if (!params.offset) params.offset = 0;
        List<StudyCommunity> communityList = [];
        if (params.id) {
            communityList = StudyCommunity.createCriteria().list(max: params.max, offset: params.offset) {
                eq("create_comsumer_id", Integer.parseInt(params.id.toString()))
                eq("state", 1)
            };
        } else {
            communityList = StudyCommunity.createCriteria().list(max: params.max, offset: params.offset) {
                eq("state", 1)
            };
        }

        int total = communityList.totalCount;
        List<StudyCommunity> hotCommunities = StudyCommunity.createCriteria().list(max: 10, sort: 'visit', order: 'desc') {
            eq("state", 1)
        };
        return render(view: 'communityAllIndex', model: [total: total, communityList: communityList, hotCommunities: hotCommunities]);
    }

    //验证成员权限
    def checkAuthority = {
        def result = communityService.checkAuthority(params)
        render(result)
    }

    //验证活动是否已结束
    def checkTimeout = {
        def result = communityService.checkTimeout(params)
        render(result)
    }

    def forumBoardCreate = {
        def studyCommunity = StudyCommunity.get(params.id as Long)
        return render(view: 'forumBoardCreate', model: [studyCommunity: studyCommunity]);
    }

    def forumBoardSave() {
        def communityId = params.communityId
        def studyCommunity = StudyCommunity.get(communityId);
        if (studyCommunity) {
            params.forumBoardImgPath = "forumBoard";
            def image = uploadImg('save');
            if (image == null || image == "" || image == "null") {
                image = "default.jpg"
            }
            def description = CTools.htmlToBlank(params.description);
            ForumBoard forumBoard = new ForumBoard(
                    name: params.name,
                    description: description,
                    type: 2,
                    dateCreated: new Date(),
                    photo: image,
                    createConsumer: session.consumer,
                    studyCommunity: studyCommunity
            )
            def boardList = ForumBoard.createCriteria().list() {
                eq('studyCommunity', studyCommunity)
            }
            if (!forumBoard.hasErrors() && forumBoard.save()) {
                flash.message = "小组 ${forumBoard.name} 创建成功"
                return redirect(action: "communityIndex", params: [id: communityId])
            } else {
                forumBoard.errors.each {
                    println it
                }
                flash.message = "小组创建失败"
                return redirect(action: "forumBoardCreate", params: [id: communityId])
            }
            return redirect(action: "communityIndex", params: [id: communityId, boardList: boardList])

        } else {
            return redirect(action: "communityIndex", params: [id: communityId])
        }
    }
    def communityIndexGroup = {
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0
        StudyCommunity studyCommunity;
        List<ForumBoard> forumBoardList = [];
        def myActivityList = [];
        def myBoradList = [];
        def boardList = [];
        Notice noticeNew = null; //最新公告
        def total = 0;
        if (params.id) {
            studyCommunity = StudyCommunity.get(params.id as Long);
            if (studyCommunity) {
                forumBoardList = ForumBoard.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                    eq("studyCommunity", studyCommunity)
                    eq("state", 1)
                }//.findAllByStudyCommunity(studyCommunity);
                total = forumBoardList.totalCount
                // 取得最新公告
                if (studyCommunity.notices.size() > 0) {
                    noticeNew = Notice.createCriteria().list() {
                        eq("studyCommunity", studyCommunity)
                        order("dateCreated", "desc")
                    }.get(0);
                }
                if (judeLoginConsumer()) {
                    if (studyCommunity.activitys.size() > 0) {
                        List<ActivitySubject> subjectList = ActivitySubject.withCriteria {
                            eq("createConsumer", session.consumer)
                            "in"("activity", studyCommunity.activitys)
                        }
                        def activityList = subjectList*.activity
                        if (activityList.size() > 5) {
                            activityList = activityList.subList(0, 4);
                        }
                        activityList.each {
                            if (!myActivityList.contains(it)) {
                                myActivityList.add(it)
                            }
                        }
                    }
                    if (studyCommunity.forumBoards.size() > 0) {
                        myBoradList = ForumMember.findAllByConsumerAndState(session.consumer, 0, [max: 5])
                    }
                    boardList = ForumBoard.createCriteria().list() {
                        eq('studyCommunity', studyCommunity)
                        eq("state", 1)
                    }
                }

                def hotMembers = ForumMember.withCriteria {
                    projections {
                        distinct("consumer")
                    }
                    eq("state", 0)
                    eq("studyCommunity", studyCommunity)
                    maxResults(9)
                    order("joinDate", "desc")
                }

                return render(view: "communityIndexGroup", model: [hotMembers: hotMembers, total: total, params: params, boardList: boardList, myBoradList: myBoradList, myActivityList: myActivityList, studyCommunity: studyCommunity, forumBoardList: forumBoardList, noticeNew: noticeNew]);
            }

        }

    }
    def communityIndexShare = {
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0
        StudyCommunity studyCommunity;
        List<ForumSharing> sharingList = [];
        def myActivityList = [];
        def myBoradList = [];
        def boardList = [];
        Notice noticeNew = null; //最新公告
        def total = 0;
        if (params.id) {
            studyCommunity = StudyCommunity.get(params.id as Long);
            if (studyCommunity) {
                /*sharingList = Sharing.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                      eq('studyCommunity', studyCommunity)
                  }
                  total = sharingList.totalCount*/

                boardList = ForumBoard.createCriteria().list() {
                    eq('studyCommunity', studyCommunity)
                }
                if (boardList.size() > 0) {
                    sharingList = ForumSharing.createCriteria().list(max: params.max, offset: params.offset, sort: 'createdDate', order: params.order) {
                        eq("state", ForumSharing.STATE_SHARING_ALREADY)
                        or {
                            eq("shareRange", ForumSharing.SHARE_RANGE_COMMUNITY)
                            eq("shareRange", ForumSharing.SHARE_RANGE_ALL)
                        }
                        inList('forumBoard', boardList)
                    }
                }
                total = sharingList.totalCount
                // 取得最新公告
                if (studyCommunity.notices.size() > 0) {
                    noticeNew = Notice.createCriteria().list() {
                        eq("studyCommunity", studyCommunity)
                        order("dateCreated", "desc")
                    }.get(0);
                }
                if (judeLoginConsumer()) {
                    if (studyCommunity.activitys.size() > 0) {
                        List<ActivitySubject> subjectList = ActivitySubject.withCriteria {
                            eq("createConsumer", session.consumer)
                            "in"("activity", studyCommunity.activitys)
                        }
                        def activityList = subjectList*.activity
                        if (activityList.size() > 5) {
                            activityList = activityList.subList(0, 4);
                        }
                        activityList.each {
                            if (!myActivityList.contains(it)) {
                                myActivityList.add(it)
                            }
                        }
                    }
                    if (studyCommunity.forumBoards.size() > 0) {
                        myBoradList = ForumMember.findAllByConsumerAndState(session.consumer, 0, [max: 5])
                    }
                }
            } else {
                return redirect(action: 'index', controller: 'index')
            }

        }
        def hotMembers = ForumMember.withCriteria {
            projections {
                distinct("consumer")
            }
            eq("state", 0)
            if (studyCommunity) eq("studyCommunity", studyCommunity)
            maxResults(9)
            order("joinDate", "desc")
        }
        return render(view: "communityIndexShare", model: [hotMembers: hotMembers, total: total, params: params, boardList: boardList, studyCommunity: studyCommunity, sharingList: sharingList, myBoradList: myBoradList, myActivityList: myActivityList, noticeNew: noticeNew]);
    }
    def communityIndexActivity = {
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        def isFlag = params.isFlag;//isFlag =0,代表全部    1代表进行   -1 代表结束
        StudyCommunity studyCommunity;
        List<Activity> activityList = [];
        def myActivityList = [];
        def myBoradList = [];
        def boardList = [];
        Notice noticeNew = null; //最新公告
        def total = 0;
        if (params.id) {
            studyCommunity = StudyCommunity.get(params.id as Long);
            if (studyCommunity) {
                activityList = Activity.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                    if (isFlag == '1') {
                        gt("endTime", new SimpleDateFormat('yyyy-MM-dd').format(new Date()))
                        eq('isOpen', true)
                    } else if (isFlag == '-1') {
                        lt("endTime", new SimpleDateFormat('yyyy-MM-dd').format(new Date()))
                        eq('isOpen', true)
                    } else {
                        eq('isOpen', true)
                    }
                    eq('studyCommunity', studyCommunity)
                }
                total = activityList.totalCount

                // 取得最新公告
                if (studyCommunity.notices.size() > 0) {
                    noticeNew = Notice.createCriteria().list() {
                        eq("studyCommunity", studyCommunity)
                        order("dateCreated", "desc")
                    }.get(0);
                }

                if (judeLoginConsumer()) {
                    if (studyCommunity.activitys.size() > 0) {
                        List<ActivitySubject> subjectList = ActivitySubject.withCriteria {
                            eq("createConsumer", session.consumer)
                            "in"("activity", studyCommunity.activitys)
                        }
                        def activitysList = subjectList*.activity
                        if (activitysList.size() > 5) {
                            activitysList = activitysList.subList(0, 4);
                        }
                        activitysList.each {
                            if (!myActivityList.contains(it)) {
                                myActivityList.add(it)
                            }
                        }
                    }
                    if (studyCommunity.forumBoards.size() > 0) {
                        myBoradList = ForumMember.findAllByConsumerAndState(session.consumer, 0, [max: 5])
                    }
                    boardList = ForumBoard.createCriteria().list() {
                        eq('studyCommunity', studyCommunity)
                    }
                }

                def hotMembers = ForumMember.withCriteria {
                    projections {
                        distinct("consumer")
                    }
                    eq("state", 0)
                    eq("studyCommunity", studyCommunity)
                    maxResults(9)
                    order("joinDate", "desc")
                }

                return render(view: "communityIndexActivity", model: [hotMembers: hotMembers, total: total, params: params, boardList: boardList, myBoradList: myBoradList, myActivityList: myActivityList, studyCommunity: studyCommunity, activityList: activityList, noticeNew: noticeNew]);
            }
        }

    }

    def querySpecialSharing() {
        def res = communityMgrService.querySpecialSharing(params);
        return render(res as JSON)
    }

    def specialRemarkSave() {
        params.consumer = session.consumer;
        def res = communityMgrService.specialRemarkSave(params);
        return render(res as JSON)
    }

    def specialReplySave() {
        params.consumer = session.consumer;
        def res = communityMgrService.specialReplySave(params);
        return render(res as JSON)
    }

    def changeForumMemberAttr = {
        def result = communityMgrService.changeForumMemberAttr(params);
        return render(result as JSON);
    }

    //学习社区公告公告显示转跳
    def showNotice() {
        StudyCommunity studyCommunity = StudyCommunity.get(params.studyCommunityId as Long);
        def noticeId = params.noticeId;
        Notice notice = Notice.findById(Long.parseLong(noticeId));
        return render(view: 'showNotice', model: [notice: notice, studyCommunity: studyCommunity]);
    }

    /**
     * 校验小组所在社区是否被禁用
     * @return
     */
    def checkCommunityState() {
        def result = [:];
        if (params.studyCommunityId) {
            def res = communityService.checkCommunityState(params.studyCommunityId as long);
            if (!res.state) {
                result.success = false;
                result.msg = res.msg;
            } else {
                result.success = true;
            }
        } else {
            result.success = false;
            result.msg = "参数不全";
        }
        return render(result as JSON)
    }

    /**
     * 社区名称重复校验
     * @return
     */
    def checkExistCommunityName() {
        def result = [:];
        result = communityService.checkExistCommunityName(params);
        return render(result as JSON)
    }
}