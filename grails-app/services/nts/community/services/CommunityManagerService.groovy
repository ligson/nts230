package nts.community.services

import nts.commity.domain.Activity
import nts.commity.domain.ForumBoard
import nts.commity.domain.ForumMainArticle
import nts.commity.domain.ForumMember
import nts.commity.domain.ForumSharing
import nts.commity.domain.Notice
import nts.commity.domain.Sharing
import nts.commity.domain.StudyCommunity
import nts.system.domain.RMSCategory
import nts.user.domain.Consumer
import nts.user.file.domain.UserFile
import nts.user.special.domain.UserSpecial

import java.lang.reflect.Member

class CommunityManagerService {

    public Map communityList(Map params) {
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "dateCreated";
        List<StudyCommunity> communityList = StudyCommunity.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
            if (params.name) {
                like("name", "%" + params.name.toString().decodeURL() + "%")
            }
            if (params.state) {
                eq("state", params.state as int)
            } else {
                ge("state", 0)
            }
        }
        def total = communityList.totalCount;
        result.page = page;
        //总记录数
        result.records = total;
        //总页数
        result.total = Math.ceil(total * 1.00 / params.max);
        result.rows = [];
        communityList.each {
            def tmp = [:];
            tmp.id = it.id;
            tmp.name = it.name;
            tmp.communityCategory = it.communityCategory.name;
            tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
            Consumer cu = Consumer.get(it.create_comsumer_id);
            String name = "";
            if (cu) {
                name = cu.name;
            }
            tmp.create_comsumer_id = name;
            tmp.members = it.members.size();
            tmp.state = it.state;
            tmp.isRecommend = it.isRecommend;
            result.rows.add(tmp);
        }
        return result
    }

    public Map deleteCommunity(Map params) {
        def result = [:];
        def idList = params.idList;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            StudyCommunity studyCommunity = StudyCommunity.get(it as Long);
            if (studyCommunity) {
                try {
                    if (studyCommunity.members || studyCommunity.notices || studyCommunity.sharings || studyCommunity.activitys || studyCommunity.forumBoards) {
                        //result.success = false;
                        //result.msg = "请清空社区后再做删除处理!";

                        def members = ForumMember.findAllByStudyCommunity(studyCommunity)
                        members.each {
                            it.delete()
                        }

                        def forumBoards = ForumBoard.findAllByStudyCommunity(studyCommunity)
                        forumBoards.each {
                            it.delete()
                        }

                        studyCommunity.delete();
                        result.success = true;
                        result.msg = "删除成功";
                    } else {
                        studyCommunity.delete();
                        result.success = true;
                        result.msg = "删除成功";
                    }
                } catch (Exception e) {
                    result.success = false;
                    result.msg = e.getMessage();
                }
            }
        }
        return result
    }

    public Map communityState(Map params) {
        def result = [:];
        def idList = params.idList;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            def communityInstance = StudyCommunity.get(it as Long)
            if (communityInstance != null) {
                communityInstance.state = params.state.toInteger();
                if (!communityInstance.hasErrors() && communityInstance.save(flush: true)) {
                    result.success = true;
                    if (communityInstance.state == 0) {
                        result.msg = "学习社区已禁用"
                    } else {
                        result.msg = "学习社区审核成功"
                    }

                }
            } else {
                result.success = false;
                result.msg = "学习社区未找到"
            }
        }
        return result
    }

    public Map communityRecommend(Map params) {
        def result = [:];
        def idList = params.idList;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            def communityInstance = StudyCommunity.get(it as Long);
            if (communityInstance != null) {
                if (params.recommend == "true") {
                    communityInstance.isRecommend = true
                } else {
                    communityInstance.isRecommend = false
                }
                if (!communityInstance.hasErrors() && communityInstance.save(flush: true)) {
                    result.success = true;
                    if (communityInstance.isRecommend == true) {
                        result.msg = "学习社区推荐成功"
                    } else if (communityInstance.isRecommend == false) {
                        result.msg = "学习社区取消推荐成功"
                    }

                }
            } else {
                result.success = false;
                result.msg = "学习社区未找到"
            }
        }
        return result
    }

    public Map forumBoardList(Map params) {
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "dateCreated";
        List<ForumBoard> boardList = ForumBoard.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
            if (params.name) {
                like("name", "%" + params.name + "%")
            }
        }
        def total = boardList.totalCount;
        result.page = page;
        //总记录数
        result.records = total;
        //总页数
        result.total = Math.ceil(total * 1.00 / params.max);
        result.rows = [];
        boardList.each {
            def tmp = [:];
            tmp.id = it.id;
            tmp.name = it.name;
            tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
            tmp.createConsumer = it.createConsumer.name;
            tmp.community = it.studyCommunity.name;
            tmp.studyCommunity = it.studyCommunity.members.size();
            result.rows.add(tmp);
        }
        return result
    }

    public Map deleteForumBoard(Map params) {
        def result = [:];
        def idList = params.idList;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            ForumBoard board = ForumBoard.get(it as Long);
            if (board) {
                if (board.forumMainArticle) {
                    result.success = false;
                    result.msg = "小组里面目前还有帖子,请先清空帖子再做删除处理";
                } else {
                    List<ForumMember> forumMemberList = ForumMember.findAllByForumBoard(board);
                    forumMemberList?.each {ForumMember forumMember->
                        forumMember.delete(flush: true);
                    }
                    deleteForumSharing(board);
                    board.delete()
                    result.success = true;
                    result.msg = "删除小组成功";
                }
            } else {
                result.success = false;
                result.msg = "小组不存在";
            }
        }
        return result
    }
    public void deleteForumSharing(ForumBoard forumBoard){
        List<ForumSharing> forumSharingList = ForumSharing.findAllByForumBoard(forumBoard);
        forumSharingList?.each {ForumSharing forumSharing->
            UserFile userFile = forumSharing.userFile;
            forumSharing.delete(flush: true);
        }
    }

    public Map articleList(Map params) {
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "dateCreated";
        List<ForumMainArticle> articleList = ForumMainArticle.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
            if (params.name) {
                like("name", "%" + params.name + "%")
            }
        }
        def total = articleList.totalCount;
        result.page = page;
        //总记录数
        result.records = total;
        //总页数
        result.total = Math.ceil(total * 1.00 / params.max);
        result.rows = [];
        articleList.each {
            def tmp = [:];
            tmp.id = it.id;
            tmp.name = it.name;
            tmp.forumBoard = it.forumBoard.name;
            tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
            tmp.createConsumer = it.createConsumer.name;
            tmp.forumViewNum = it.forumViewNum;
            tmp.forumReplyArticle = it.forumReplyArticle.size();
            tmp.isTop = it.isTop;
            tmp.isElite = it.isElite;
            result.rows.add(tmp);
        }
        return result
    }

    public Map topArticle(Map params) {
        def result = [:];
        def id = params.id;
        ForumMainArticle article = ForumMainArticle.get(id as Long);
        if (article && params.isTop) {
            article.isTop = params.isTop as int;
            if (article.save(flush: true) && (!article.hasErrors())) {
                result.success = true;
                if (article.isTop == 1) {
                    result.msg = "置顶成功";
                } else if (article.isTop == 0) {
                    result.msg = "取消置顶成功";
                }

            }
        } else {
            result.success = false;
            result.msg = "参数不全";
        }
        return result
    }

    public Map eliteArticle(Map params) {
        def result = [:];
        def id = params.id;
        ForumMainArticle article = ForumMainArticle.get(id as Long);
        if (article && params.isElite) {
            article.isElite = params.isElite as int;
            if (article.save(flush: true) && (!article.hasErrors())) {
                result.success = true;
                if (article.isElite == 1) {
                    result.msg = "精华帖设置成功";
                } else if (article.isElite == 0) {
                    result.msg = "普通帖设置成功";
                }

            }
        } else {
            result.success = false;
            result.msg = "参数不全";
        }
        return result
    }

    public Map deleteArticle(Map params) {
        def result = [:];
        def idList = params.idList;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            ForumMainArticle article = ForumMainArticle.get(it as Long);
            if (article) {
                article.delete();
                result.success = true;
                result.msg = "删除成功";
            } else {
                result.success = false;
                result.msg = "参数不全";
            }
        }
        return result
    }

    public Map sharingList(Map params) {
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "createdDate";
        List<ForumSharing> sharingList = ForumSharing.list(max: params.max, offset: params.offset, sort: sort, order: order);
        def total = sharingList.totalCount;
        result.page = page;
        //总记录数
        result.records = total;
        //总页数
        result.total = Math.ceil(total * 1.00 / params.max);
        result.rows = [];
        sharingList.each {
            def tmp = [:];
            tmp.id = it.id;
            String name = "";
            if (it?.userFile) {
                name = it.userFile.name;
            }
            if (it?.special) {
                name = it.special.name;
            }
            tmp.name = name;
            tmp.studyCommunity = it.forumBoard.studyCommunity.name;
            tmp.createdDate = it.createdDate.format("yyyy-MM-dd");
            tmp.shareConsumer = it.consumer.name;
            tmp.canDownload = it.canDownload;
            tmp.shareRange = ForumSharing.rangeCnField.get(it.shareRange);
            result.rows.add(tmp);
        }
        return result
    }

    public Map deleteSharing(Map params) {
        def result = [:];
        def idList = params.idList;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            ForumSharing forumSharing = ForumSharing.get(it);
            if (forumSharing) {
                forumSharing.delete();
                result.success = true;
                result.msg = "删除成功";
            } else {
                result.success = false;
                result.msg = "参数不全";
            }
        }
        return result
    }

    public Map operateSharing(Map params) {
        def isList = params.idList;
        def isFlag = params.isFlag;
        def state = params.state;
        def result = [:];
        def idList = params.idList;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            ForumSharing sharing = ForumSharing.get(it as int);
            if (sharing) {
                def stateDiv = "";
                def flag;
                if (isFlag instanceof String) {
                    flag = Boolean.parseBoolean(isFlag);
                } else {
                    flag = isFlag;
                }
                if (state == "canDownload") {
                    sharing.canDownload = flag;
                    if (isFlag == true) {
                        stateDiv = "取消下载";
                    } else {
                        stateDiv = "下载";
                    }

                }
                if (sharing.save(flush: true) && (!sharing.hasErrors())) {
                    result.success = true;
                    result.msg = stateDiv + "设置成功"
                }
            }
        }
        return result
    }

    public Map noticeList(Map params) {
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "dateCreated";
        List<Notice> noticeList = Notice.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
            if (params.name) {
                like("name", "%" + params.name + "%")
            }
        }
        def total = noticeList.totalCount;
        def result = [:];
        result.page = page;
        //总记录数
        result.records = total;
        //总页数
        result.total = Math.ceil(total * 1.00 / params.max);
        result.rows = [];
        noticeList.each {
            def tmp = [:];
            tmp.id = it.id;
            tmp.name = it.name;
            tmp.studyCommunity = it.studyCommunity.name;
            tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
            result.rows.add(tmp);
        }
        return result
    }

    public Map deleteNotice(Map params) {
        def result = [:];
        def idList = params.idList;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            Notice notice = Notice.get(it as Long);
            if (notice) {
                notice.delete();
                result.success = true;
                result.msg = "删除成功";
            } else {
                result.success = false;
                result.msg = "参数不全";
            }
        }
        return result
    }

    public Map activityList(Map params) {
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "dateCreated";
        List<Activity> activityList = Activity.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
            if (params.name) {
                like("name", "%" + params.name + "%")
            }
        }
        def total = activityList.totalCount;
        result.page = page;
        //总记录数
        result.records = total;
        //总页数
        result.total = Math.ceil(total * 1.00 / params.max);
        result.rows = [];
        activityList.each {
            def tmp = [:];
            tmp.id = it.id;
            tmp.name = it.name;
            tmp.studyCommunity = it.studyCommunity.name;
            tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
            tmp.createConsumer = it.createConsumer.name;
            tmp.startTime = it.startTime;
            tmp.endTime = it.endTime;
            tmp.isOpen = it.isOpen;
            result.rows.add(tmp);
        }
        return result
    }

    public Map deleteActivity(Map params) {
        def result = [:];
        def idList = params.idList;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            Activity activity = Activity.get(it as Long);
            if (activity) {
                activity.delete();
                result.success = true;
                result.msg = "删除成功";
            } else {
                result.success = false;
                result.msg = "参数不全";
            }
        }
        return result
    }

    public Map operaActivityState(Map params) {
        def result = [:];
        def idList = params.idList;
        def isFlag = params.isOpen;
        def isOpen;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        if (isFlag instanceof String) {
            isOpen = Boolean.parseBoolean(isFlag);
        } else {
            isOpen = isFlag;
        }
        ids.each {
            Activity activity = Activity.get(it as Long);
            if (activity) {
                activity.isOpen = isOpen;
                if (activity.save(flush: true) && (!activity.hasErrors())) {
                    if (activity.isOpen == true) {
                        result.msg = "活动开启";
                    } else {
                        result.msg = "活动关闭";
                    }
                    result.success = true;
                }
            } else {
                result.success = false;
                result.msg = "参数不全";
            }
        }
        return result
    }

    public Map RMSCategoryList(Map params) {
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "dateCreated";
        List<RMSCategory> actegoryList = RMSCategory.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
            if (params.name) {
                like("name", "%" + params.name.toString().decodeURL() + "%")
            }
            or {
                eq("type", 2)
                //eq("type", 0)
            }
            if (params.parentid) {
                def parentId;
                if (params.parentid instanceof String) {
                    parentId = Integer.parseInt(params.parentid);
                } else {
                    parentId = params.parentid;
                }
                if (parentId == 0) {
                    eq("parentid", parentId)
                } else {
                    notEqual("parentid", 0);
                }

            }
        }
        def total = actegoryList.totalCount;
        result.page = page;
        //总记录数
        result.records = total;
        //总页数
        result.total = Math.ceil(total * 1.00 / params.max);
        result.rows = [];
        actegoryList.each {
            def tmp = [:];
            tmp.id = it.id;
            tmp.name = it.name;
            tmp.parentName = it.parentName;
            tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
            tmp.type = it.type;
            tmp.state = it.state;
            result.rows.add(tmp);
        }
        return result
    }

    public Map deleteRMSCategory(Map params) {
        def result = [:];
        def idList = params.idList;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            RMSCategory category = RMSCategory.get(it as Long);
            if (category) {
                def studyCommunity = StudyCommunity.findAllByCommunityCategory(category)
                List<RMSCategory> childCategory = RMSCategory.findAllByParentid(category.id);
                if (studyCommunity && studyCommunity.size() > 0) {
                    result.success = false;
                    result.msg = "该分类下有社区，不能删除。";
                } else if (childCategory.size() > 0) {
                    /*
                    childCategory.each {
                        it.parentid = 0;
                        it.parentName = "无";
                        it.save(flush: true);
                    }
                    */
                    result.success = false;
                    result.msg = "该分类下有子分类，不能删除。";
                } else {
                    category.delete();
                    result.success = true;
                    result.msg = "删除成功";
                }
            } else {
                result.success = false;
                result.msg = "参数不全";
            }
        }
        return result
    }

    public Map operaCommunityConsumer(Map params) {
        def result = [:];
        def idList = params.idList;
        def stateName = params.stateName;
        def isFlag = params.isFlag;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            Consumer consumer = Consumer.get(it as Long);
            if (consumer) {
                if (stateName == "userState") {
                    if (isFlag == 'true' || isFlag == (isFlag instanceof String ? "1" : 1)) {
                        consumer.userState = 1;
                    } else if (isFlag == 'false' || isFlag == (isFlag instanceof String ? "0" : 0)) {
                        consumer.userState = 0;
                    }
                } else if (stateName == "uploadState") {
                    if (isFlag == (isFlag instanceof String ? "1" : 1)) {
                        consumer.uploadState = 1;
                    } else if (isFlag == (isFlag instanceof String ? "0" : 0)) {
                        consumer.uploadState = 0;
                    }
                } else if (stateName == "canDownload") {
                    if (isFlag == 'true' || isFlag == 1) {
                        consumer.canDownload = true;
                    } else if (isFlag == 'false' || isFlag == 0) {
                        consumer.canDownload = false;
                    }
                } else if (stateName == "canComment") {
                    if (isFlag == 'true' || isFlag == 1) {
                        consumer.canComment = true;
                    } else if (isFlag == 'false' || isFlag == 0) {
                        consumer.canComment = false;
                    }
                } else if (stateName == "notExamine") {
                    if (isFlag == 'true' || isFlag == 1) {
                        consumer.notExamine = true;
                    } else if (isFlag == 'false' || isFlag == 0) {
                        consumer.notExamine = false;
                    }
                }
                if (consumer.save(flush: true) && (!consumer.hasErrors())) {
                    result.success = true;
                    result.msg = "设置成功";
                }
            } else {
                result.success = false;
                result.msg = "参数不全";
            }
        }
        return result
    }

    public Map deleteConsumer(Map params) {
        def result = [:];
        def idList = params.idList;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            Consumer consumer = Consumer.get(it as Long);
            if (consumer) {
                consumer.delete();
                result.success = true;
                result.msg = "删除成功";
            } else {
                result.success = false;
                result.msg = "参数不全";
            }
        }
        return result
    }

    public Map communityConsumer(Map params, String isRole) {
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "id";
        def name = params.name;
        def communityId = params.communityId ? params.communityId : "-1";
//        List<Consumer> consumerList = Consumer.createCriteria().list() {
//            //社区管理员
//            if (isRole == "admin") {
//                eq("role", Consumer.MANAGER_ROLE)
//                if (communityId != "-1") {
//                    memberCommunitys {
//                        eq("id", communityId as Long)
//                    }
//                } else {
//                    isNotNull("memberCommunitys")
//                }
//                //小组管理员
//            } else if (isRole == "board") {
//                eq("role", Consumer.MANAGER_ROLE)
//                if (communityId != "-1") {
//                    forumBoards {
//                        eq("id", communityId as Long)
//                    }
//                } else {
//                    isNotNull("forumBoards")
//                }
//                //普通用户
//            } else if (isRole == "consumer") {
//                gt("role", Consumer.MANAGER_ROLE)
//                if (communityId != "-1") {
//                    memberCommunitys {
//                        eq("id", communityId as Long)
//                    }
//                } else {
//                    isNotNull("memberCommunitys")
//                }
//            }
//
//
//            if (params.name) {
//                like("name", "%" + params.name.toString().decodeURL() + "%")
//            }
//        }
        List<Consumer> consumerList = new ArrayList<Consumer>();
        def list = [];
        def cIdList2 = [];
        if ("admin".equals(isRole)) {
            def cIdList = StudyCommunity.createCriteria().list {
                if (communityId != "-1") {
                    eq("id", communityId as Long)
                }
                projections {
                    distinct(['create_comsumer_id'])
                }
            }

            if (cIdList) {
                cIdList.each {
                    cIdList2.add(Long.parseLong(String.valueOf(it)));
                }
            }
            if (cIdList2.size() > 0) {
                consumerList = Consumer.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
                    'in'("id", cIdList2.toArray());
                    if (params.name) {
                        like("name", "%" + params.name.toString().decodeURL() + "%")
                    }
                }
            }

            //.findAllByRoleAndMemberCommunitysIsNotNull(Consumer.MANAGER_ROLE);
            if (consumerList.size() > 0) {
                def total = consumerList.totalCount;

                result.page = page;
                //总记录数
                result.records = total;
                //总页数
                result.total = Math.ceil(total * 1.00 / params.max);
                result.rows = [];
                consumerList.each {
                    def tmp = [:];
                    tmp.id = it.id;
                    tmp.name = it.name;
                    tmp.nickname = it.nickname;
                    tmp.trueName = it.trueName;
                    tmp.userState = it.userState;
                    tmp.uploadState = it.uploadState;
                    tmp.canDownload = it.canDownload;
                    tmp.canComment = it.canComment;
                    tmp.notExamine = it.notExamine;
                    result.rows.add(tmp);
                }
            }
        } else if ("board".equals(isRole)) { // 小组管理员
            List<ForumBoard> boardList = ForumBoard.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
                if (communityId != "-1") {
                    eq("id", communityId as Long)
                }
                if (params.name) {
                    createConsumer {
                        like("name", "%" + params.name.toString().decodeURL() + "%")
                    }
                }
            }
            if (boardList && boardList.size() > 0) {
                /*boardList?.each { ForumBoard board ->
                    if (!cIdList2.contains(board?.createConsumer?.id)) {
                        cIdList2.add(board?.createConsumer?.id);
                    }
                }*/
                def total = boardList.totalCount;

                result.page = page;
                //总记录数
                result.records = total;
                //总页数
                result.total = Math.ceil(total * 1.00 / params.max);
                result.rows = [];
                boardList.each {
                    def tmp = [:];
                    tmp.id = it.id;
                    tmp.boardName = it.name;
                    tmp.communityName = it.studyCommunity.name;
                    tmp.name = it?.createConsumer?.name;
                    tmp.nickname = it?.createConsumer?.nickname;
                    tmp.trueName = it?.createConsumer?.trueName;
                    tmp.userState = it?.createConsumer?.userState;
                    tmp.uploadState = it?.createConsumer?.uploadState;
                    tmp.canDownload = it?.createConsumer?.canDownload;
                    tmp.canComment = it?.createConsumer?.canComment;
                    tmp.notExamine = it?.createConsumer?.notExamine;
                    result.rows.add(tmp);
                }
            }
        } else if ("consumer".equals(isRole)) { // 社区用户
            List<ForumMember> members = ForumMember.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
                if (communityId != "-1") {
                    studyCommunity{
                        eq("id", communityId as Long)
                    }
                }

                if (params.name) {
                    consumer{
                        like("name", "%" + params.name.toString().decodeURL() + "%")
                    }
                }
            }

            if (members && members.size() > 0) {
                def total = members.totalCount;

                result.page = page;
                //总记录数
                result.records = total;
                //总页数
                result.total = Math.ceil(total * 1.00 / params.max);
                result.rows = [];
                members.each {
                    def tmp = [:];
                    tmp.id = it.consumer.id;
                    tmp.communityName = it.studyCommunity.name;
                    tmp.boardName = it.forumBoard.name;
                    tmp.name = it.consumer.name;
                    tmp.nickname = it.consumer.nickname;
                    tmp.trueName = it.consumer.trueName;
                    tmp.userState = it.consumer.userState;
                    tmp.uploadState = it.consumer.uploadState;
                    tmp.canDownload = it.consumer.canDownload;
                    tmp.canComment = it.consumer.canComment;
                    tmp.notExamine = it.consumer.notExamine;
                    result.rows.add(tmp);
                }
            }
        }
        return result
    }


}
