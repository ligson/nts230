package nts.community.services

import nts.activity.domain.UserActivity
import nts.activity.domain.UserWork
import nts.commity.domain.Activity
import nts.commity.domain.ForumBoard
import nts.commity.domain.ForumMainArticle
import nts.commity.domain.ForumMember
import nts.commity.domain.ForumReplyArticle
import nts.commity.domain.Sharing
import nts.commity.domain.StudyCommunity
import nts.program.domain.ProgramTag
import nts.system.domain.RMSCategory
import nts.tags.ProgramTagLib
import nts.user.domain.Consumer
import nts.utils.CTools

import javax.servlet.http.HttpSession
import java.text.SimpleDateFormat

class CommunityService {

    def utilService

    List<StudyCommunity> searchCommunity(Map params) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        java.util.Date begin_date = null;
        java.util.Date end_date = null;

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

    public Map addConsumerAjax(Map params) {
        def result = [:];
        if (params.id && params.consumerId) {
            def board = ForumBoard.get(params.id as Long);
            if (board) {
                StudyCommunity studyCommunity = board.studyCommunity;
                if (studyCommunity) {
                    if (studyCommunity.state == StudyCommunity.STUDYCOMMUNITY_STATE_PASS) {
                        Consumer consumer = Consumer.get(params.consumerId as Long);
                        if (consumer) {
                            if (board.createConsumer.id == consumer.id || board.studyCommunity.create_comsumer_id == consumer.id) {
                                result.success = false;
                                result.msg = "你是该小组管理员，不需要加入!"
                            } else {
                                def forumMember = ForumMember.findByConsumerAndForumBoard(consumer, board);
                                if (forumMember && forumMember.state == ForumMember.STATE_NORMAIL) {
                                    result.success = false;
                                    result.msg = "已经加入该小组!"
                                } else if (!forumMember) {
                                    forumMember = new ForumMember();
                                    forumMember.consumer = consumer;
                                    forumMember.forumBoard = board;
                                    forumMember.studyCommunity = board.studyCommunity;
                                    forumMember.canDownload = true;
                                    forumMember.canCreateArticle = true;
                                    forumMember.canReply = true;
                                    forumMember.canComment = true;
                                    forumMember.canPlay = true;

                                } else if (forumMember.state != ForumMember.STATE_NORMAIL) {
                                    forumMember.state = ForumMember.STATE_APPLY;
                                }
                                if (!forumMember.hasErrors() && forumMember.save(flush: true)) {
                                    result.success = true;
                                    result.msg = "加入小组成功，等待审核！！"
                                } else {
                                    result.success = true;
                                    result.msg = "加入小组失败!"
                                }
                            }
                        }
                    } else {
                        result.success = false;
                        if (studyCommunity.state == StudyCommunity.STUDYCOMMUNITY_STATE_FORBIDDEN) {
                            result.msg = "小组所在社区已被禁用,不能加入该小组"
                        } else {
                            result.msg = "小组所在社区正在审核,不能加入该小组"
                        }
                    }
                } else {
                    result.success = false;
                    result.msg = "目前小组不存在"
                }
            } else {
                result.success = false;
                result.msg = "板块不存在"
            }
        } else {
            result.success = false;
            result.msg = "参数不全"
        }
        return result
    }

    public Map autoLoadLing(Map params) {

    }

    List<UserActivity> searchUserActivity(Map params, Long id) {
        if (!params.max) params.max = '10'
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = '0'
        if (!params.year) params.year = '0'

        def state = params.state
        def name = params.name
        def nowDate = new Date().format("yyyy-MM-dd")
        def searchList = UserActivity.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (!params.isAll) {
                eq("consumer", Consumer.get(id))
            }
            if (state == "1")        //活动尚未开始
            {
                gt("startTime", nowDate)
            } else if (state == "2")    //活动正在进行
            {
                le("startTime", nowDate)
                ge("endTime", nowDate)
            } else if (state == "3")    //活动已结束
            {
                lt("endTime", nowDate)
            }
            if (Integer.parseInt(params.year) > 1000) {
                like('startTime', "%${params.year}%")
            } else if (Integer.parseInt(params.year) < 0) {
                le("startTime", -Integer.parseInt(params.year) + "")
            }
            if (name) {
                name = name.trim()
                like('name', "%${name}%")
            }
            if (CTools.nullToZero(params?.categoryId).longValue() != 0) {
                activityCategory {
                    eq('id', CTools.nullToZero(params?.categoryId).longValue())
                }
            }
            if (params.approval) {
                eq('approval', params.approval.toInteger())
            }
            if (params.isOpen) {
                eq('isOpen', params.isOpen)
            }
        }
        if (searchList == null) searchList = []
        return searchList
    }

    List<UserWork> searchUserWork(Map params, Long id) {
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        def name = params.name

        def searchList = UserWork.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (params.isMy == "yes") {
                consumer {
                    eq('id', id)
                }
            }
            if (name) {
                name = name.trim()
                like('name', "%${name}%")
            }
            if (params.approval) {
                eq('approval', params.approval.toInteger())
            }
        }
        if (searchList == null) searchList = []
        return searchList
    }
    /**
     * 社区update
     * @param params
     * @return
     */
    public Map communityUpdate(Map params) {
        def result = [:];
        result.success = false;
        def session = utilService.getSession();
        //获取修改社区
        StudyCommunity studyCommunity = StudyCommunity.get(params.id);
        //修改社区存在，且创建者为当前用户
        if (studyCommunity && studyCommunity.create_comsumer_id == params.consumerId) {
            if (params.photo) {
                studyCommunity.photo = params.photo;
            }
            if (params.bgPhoto) {
                studyCommunity.bgPhoto = params.bgPhoto;
            }
            if (params.name) {
                studyCommunity.name = params.name;
            }
            if (params.categoryId) {
                RMSCategory category = RMSCategory.get(params.categoryId);
                if (category) {
                    studyCommunity.communityCategory = category;
                }
            }
            if (params.description) {
                def description = CTools.htmlToBlank(params.description);
                studyCommunity.description = description;
            }
            //update
            if (!studyCommunity.hasErrors() && studyCommunity.save()) {
                result.success = true;
                result.message = "社区 " + studyCommunity.name + " 修改成功";
            } else {
                result.success = false;
                result.message = "社区 " + studyCommunity.name + " 修改失败" + studyCommunity.errors;
            }
        }
        return result;
    }

    //验证上传、下载权限
    public boolean checkAuthority(params) {
        def result = false
        def session = utilService.getSession();
        def type = params.type
        def communityId = params.communityId
        def community = StudyCommunity.get(communityId as Long)
        if (community) {
            def forumMember = ForumMember.findByStudyCommunityAndConsumer(community, session.consumer)
            if (type == '1') {
                if ((forumMember && forumMember.state == 0 && forumMember.canUpload) || (community.create_comsumer_id == session.consumer.id)) {
                    result = true
                }
            } else if (type == '2') {
                if ((forumMember && forumMember.state == 0 && forumMember.canDownload) || (community.create_comsumer_id == session.consumer.id)) {
                    result = true
                }
            }

        }
        return result
    }

    public boolean checkTimeout(params) {
        def result = true
        def session = utilService.getSession();
        def type = params.type
        def activityId = params.id
        def activity = Activity.get(activityId as Long)
        if (activity) {
            if (new SimpleDateFormat("yyyy-MM-dd").parse(activity.endTime) > new Date() || activity.createConsumer.id == session.consumer.id) {
                result = true;
            } else {
                result = false;
            }
        }
        return result
    }

    /**
     * 判断社区是否禁用
     * @param studyCommunityId
     * @return
     */
    public Map checkCommunityState(long studyCommunityId) {
        def result = [:];
        StudyCommunity studyCommunity = StudyCommunity.findById(studyCommunityId);
        if (studyCommunity) {
            if (studyCommunity.state == 0) {
                result.state = false;
                result.msg = "社区 " + studyCommunity.name + " 已禁用";
//            } else if (studyCommunity.state == 2) {
//                result.state = false;
//                result.msg = "社区 " + studyCommunity.name + " 审核中";
            } else {
                result.state = true;
            }
        } else {
            result.state = false;
            result.msg = "没有对应的社区";
        }
        return result
    }

    /**
     * 社区名称重复校验
     * @param params
     * @return
     */
    public Map checkExistCommunityName(Map params) {
        def result = [:];
        def categoryId = params.categoryId;
        def communityName = params.communityName;
        if (categoryId && communityName) {
            def community = null;
            RMSCategory category = RMSCategory.findById(categoryId as long);
            if (params.communityId) { //修改
                def communityId = params.communityId;
                community = StudyCommunity.createCriteria().list() {
                    notEqual('id', communityId as long)
                    eq('name', communityName)
                    communityCategory {
                        eq('id', categoryId as long)
                    }
                }
            } else { //创建
                community = StudyCommunity.findByNameAndCommunityCategory(communityName, category);
            }
            if (community) {
                result.success = false;
                result.msg = "社区名称重复!";
            } else {
                result.success = true;
            }
        }
        return result;
    }
}
