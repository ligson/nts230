import grails.converters.JSON
import nts.commity.domain.ForumBoard
import nts.commity.domain.ForumMember
import nts.commity.domain.StudyCommunity
import nts.utils.CTools

import javax.servlet.http.Cookie

class SecurityFilters {
    def communityMgrService
    def communityService
    def userActivityService

    def filters = {

        leakDefense(controller: '*', action: '*'){
            before = {
                if (!(controllerName == 'coreMgr' && actionName == 'seniorSearchConfigSet')) {
                    // 迭代所有参数
                    Iterator<Map.Entry> iterator = params.entrySet().iterator();
                    while (iterator.hasNext()) {
                        // 取得一个参数
                        def param = iterator.next();
                        // 判断参数值的类型是否为String
                        def value = param.getValue();
                        if (value instanceof String) {
                            // 去除参数内的html标签
                            value = CTools.htmlToBlank(value);
                            value = CTools.codeToHtml(value);
                            param.setValue(value);
                        }
                    }

                    // 设置cookie的Secure属性
                    Cookie[] cookies = request.getCookies();
                    for (Cookie cookie : cookies) {
                        cookie.setSecure(true);
                    }
                }
            }
        }

        loginCheck(controller: 'program', action: '*') {
            before = {
                def uncheckAction = ['login', 'showProgram', 'playProgram', 'playHTML5', 'embedPlay', 'directoryView', 'uploadSerial', 'uploadSerialPhoto', 'uploadSerialSubtitle', 'textLibrary', 'photoShow', 'playDocument', 'playPhoto', 'playVideo', 'videoShow', 'collectProgram', 'recommendProgram', 'courseDetail'];
                if (!session.consumer && (!uncheckAction.contains(actionName))) {
                    redirect(controller: "index", action: "login")
                    return false
                }
                if (actionName == "courseView") {
                    if (!session.consumer || session.consumer.name == 'anonymity') {
                        redirect(controller: "index", action: "login")
                        return false
                    }
                }
            }
        }



        loginCheck(controller: 'index', action: '*') {
            before = {
                if (actionName == "courseView") {
                    if (!session.consumer || session.consumer.name == 'anonymity') {
                        redirect(controller: "index", action: "login")
                        return false
                    }
                }

            }
        }

        //个人空间
        loginCheck(controller: 'my', action: '*') {
            before = {
                if (actionName != "userSpace") {
                    if (!session.consumer || session.consumer.name == 'anonymity') {
                        redirect(controller: "index", action: "login")
                        return false
                    }
                }
            }
        }
        //板块管理
        loginCheck(controller: 'communityMgr', action: '*') {
            before = {
                if (!session.consumer || session.consumer.name == 'anonymity') {
                    redirect(controller: "index", action: "login")
                    return false
                } else {
                    def studyCommunityId = params.studyCommunityId;
                    //判断管理的社区是否存在
                    if (studyCommunityId) {
                        def result = communityMgrService.checkManagerLimit(session.consumer.id as long, studyCommunityId as long);
                        if (!result.msg) {
                            params.type = result.type;
                            params.msg = result.msg;
                            return false;
                        } else {
                            params.studyCommunity = StudyCommunity.findById(studyCommunityId as Long)
                            params.type = result.type;
                            params.msg = result.msg;
                        }
                    } else {
                        redirect(controller: "my", action: "myCreatedCommunity")
                    }
                }
            }
        }
        //---2009-9-3 �û���֤���˿ռ�session �Ƿ���ڣ�������ת
        loginCheck(controller: 'my', action: '*')
                {
                    before =
                            {
                                if (!session.consumer && actionName != "login") {
                                    redirect(controller: "index", action: "login")
                                    return false
                                }
                            }
                }

        //�ﳤ����Դ����	2012/7/30
        loginCheck(controller: 'community', action: '*') {
            before = {
                if (actionName != "communityIndex" && actionName != "uploadShare" && actionName != "index" && actionName != 'communityArticle' && actionName != 'communityIndexGroup' && actionName != 'communityGroupIndex.js' && actionName != 'communityIndexShare' && actionName != 'communityIndexActivity' && actionName != 'communityActivityShow') {
                    if (!session.consumer || session.consumer.name == 'anonymity') {
                        redirect(controller: "index", action: "login")
                        return false
                    }
                    def forumBoardCheckAction = ["saveArticle", "replayArticle", "firstReplyArticle"];
                    if (forumBoardCheckAction.contains(actionName)) {
                        def result = [:];
                        ForumBoard forumBoard = ForumBoard.get(params.forumBoardId as Long);
                        ForumMember forumMember = ForumMember.findByConsumerAndForumBoard(session.consumer, forumBoard);
                        //因为社区管理员不需要加入小组，有所有权限，所以直接进入
                        if (forumBoard.studyCommunity.create_comsumer_id == session.consumer.id) {
                            return true;
                        }
                        //saveArticle是form表单，有点特殊，所以单独提出
                        if ("saveArticle".equals(actionName)) {
                            if (forumMember) {
                                if (forumMember.state == ForumMember.STATE_LOCKED) {
                                    flash.message = "您的账户被锁定！请联系管理员！！";
                                    redirect(controller: "community", action: "communityGroupIndex", params: [id: params.forumBoardId, communityId: params.studyId])
                                    return false;
                                }
                                if (forumMember.state == ForumMember.STATE_QUIT) {
                                    flash.message = "您已经退出该社区,请重新申请加入！！";
                                    redirect(controller: "community", action: "communityGroupIndex", params: [id: params.forumBoardId, communityId: params.studyId])
                                    return false;
                                }
                                if (forumMember.state == ForumMember.STATE_APPLY) {
                                    flash.message = "您的申请正在审核中，请等待审核！！";
                                    redirect(controller: "community", action: "communityGroupIndex", params: [id: params.forumBoardId, communityId: params.studyId])
                                    return false;
                                }
                                if (forumMember.canCreateArticle) {
                                    return true;
                                } else {
                                    flash.message = "权限不足！请联系管理员！！";
                                    redirect(controller: "community", action: "communityGroupIndex", params: [id: params.forumBoardId, communityId: params.studyId])
                                    return false;
                                }
                            } else {
                                flash.message = "您还未加入该小组！";
                                redirect(controller: "community", action: "communityGroupIndex", params: [id: params.forumBoardId, communityId: params.studyId])
                                return false;
                            }
                        }
                        //用户是否加入该小组，用户是否锁定
                        if (forumMember) {
                            if (forumMember.state == ForumMember.STATE_LOCKED) {
                                result.success = false;
                                result.message = "您的账户被锁定！请联系管理员！！";
                                response.contentType = "application/json;charset=UTF-8";
                                response.writer.println(result as JSON)
                                return false;
                            }
                            if (forumMember.state == ForumMember.STATE_QUIT) {
                                result.success = false;
                                result.message = "您已经退出该社区,请重新申请加入！！";
                                response.contentType = "application/json;charset=UTF-8";
                                response.writer.println(result as JSON)
                                return false;
                            }
                            if (forumMember.state == ForumMember.STATE_APPLY) {
                                result.success = false;
                                result.message = "您的申请正在审核中，请等待审核！！";
                                response.contentType = "application/json;charset=UTF-8";
                                response.writer.println(result as JSON)
                                return false;
                            }
                            if ("saveArticle".equals(actionName) && forumMember.canCreateArticle) {       //发帖权限验证
                                return true;
                            } else if ("replayArticle".equals(actionName) && forumMember.canComment) {      //评论权限验证
                                return true;
                            } else if ("firstReplyArticle".equals(actionName) && forumMember.canReply) {   //回贴权限验证
                                return true;
                            } else {
                                result.success = false;
                                result.message = "权限不足！请联系管理员";
                                response.contentType = "application/json;charset=UTF-8";
                                response.writer.println(result as JSON)
                                return false;
                            }
                        } else {
                            result.success = false;
                            result.message = "您还未加入该小组！";
                            response.contentType = "application/json;charset=UTF-8";
                            response.writer.println(result as JSON)
                            return false;
                        }
                    } else {
                        return true;
                    }
                } else {
                    return true;
                }
            }
        }


        forbiddenCommunityCheck(controller: 'community', action: '*')
                {
                    before =
                            {
                                def studyCommunityId = null;
                                if (actionName == "communityIndex" || actionName == "communityIndexGroup" || actionName == "communityIndexShare" || actionName == "communityIndexActivity") {
                                    if (params.id) {
                                        studyCommunityId = params.id;
                                    }
                                } else {
                                    if (params.communityId) {
                                        studyCommunityId = params.communityId;
                                    }
                                }
                                //判断社区是否被禁用
                                if (studyCommunityId) {
                                    def result = communityService.checkCommunityState(studyCommunityId as long);
                                    if (!result.state) {
                                        render(view: '/error404');
                                        return false;
                                    } else {
                                        return true;
                                    }
                                } else {
                                    return true;
                                }
                            }
                }
        forbiddenCommunityMgrCheck(controller: 'communityMgr', action: '*')
                {
                    before =
                            {
                                def studyCommunityId = null;
                                if (actionName == "forumBoradList" || actionName == "forumBoradCreate" || actionName=="forumMainArticleList"
                                        || actionName=="noticeList" || actionName=="noticeCreate" || actionName=="membersList"
                                        || actionName=="sharingList"  || actionName=="activityList"  || actionName=="activityCreate") {
                                    if (params.studyCommunityId) {
                                        studyCommunityId = params.studyCommunityId;
                                    }
                                } else {
                                    if (params.communityId) {
                                        studyCommunityId = params.communityId;
                                    }
                                }
                                //判断社区是否被禁用
                                if (studyCommunityId) {
                                    def result = communityService.checkCommunityState(studyCommunityId as long);
                                    if (!result.state) {
                                        render(view: '/error404');
                                        return false;
                                    } else {
                                        return true;
                                    }
                                } else {
                                    return true;
                                }
                            }
                }

        forbiddenActivityCheck(controller: 'userActivity', action: '*')
                {
                    before =
                            {
                                def activityId = null;
                                if (actionName == "show") {
                                    if (params.id) {
                                        activityId = params.id;
                                    }
                                }
                                //判断社区是否被禁用
                                if (activityId) {
                                    def result = userActivityService.checkActivityState(activityId as long);
                                    if (!result.state) {
                                        render(view: '/error404');
                                        return false;
                                    } else {
                                        return true;
                                    }
                                } else {
                                    return true;
                                }
                            }
                }
    }
}
