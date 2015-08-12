package nts.admin.userActivityMgr.controllers

import grails.converters.JSON
import nts.activity.domain.UserActivity
import nts.activity.domain.UserVote
import nts.activity.domain.UserWork
import nts.system.domain.RMSCategory
import nts.user.services.ActionNameAnnotation
import nts.user.services.ControllerNameAnnotation
import nts.user.services.PatternNameAnnotation
import nts.utils.CTools

@ControllerNameAnnotation(name = "活动管理")
class UserActivityMgrController {
    def userActivityService;
    /**
     * 活动列表展示
     * @return
     */
    @PatternNameAnnotation(name = "活动列表")
    @ActionNameAnnotation(name = "活动列表")
    def index() {
        return render(view: 'userActivityList', model: [editPage: params.editPage]);
    }
    /**
     * 系统活动管理,JSON参数返回
     * @return
     */
    @PatternNameAnnotation(name = "活动列表")
    @ActionNameAnnotation(name = "活动列表展示JSON")
    def userActivityListAsJson() {
        def result = [:];
        result = userActivityService.userActivityList(params);

        result.rows = [];
        for (UserActivity userActivity : result.userActivityList) {
            def tmp = [:];
            tmp.id = userActivity.id;
            tmp.name = userActivity.name;
            tmp.createName = userActivity.consumer.name;
            tmp.startTime = userActivity.startTime;
            tmp.endTime = userActivity.endTime;
            tmp.approval = userActivity.approval;
            tmp.workNum = userActivity.workNum;
            tmp.voteNum = userActivity.voteNum;
            tmp.isOpen = userActivity.isOpen;
            tmp.dateCreated = userActivity.dateCreated.format("yyyy-MM-dd");
            result.rows.add(tmp);
        }
        return render(result as JSON);
    }
    /**
     * 系统活动删除
     * @return
     */
    @PatternNameAnnotation(name = "活动列表")
    @ActionNameAnnotation(name = "系统活动删除")
    def userActivityDelete() {
        def result = [:];
        result = userActivityService.userActivityDelete(params);
        return render(result as JSON);
    }
    /**
     * 修改活动状态
     * @return
     */
    @PatternNameAnnotation(name = "活动列表")
    @ActionNameAnnotation(name = "修改活动状态")
    def userActivityOpenChange() {
        def result = [:];
        result = userActivityService.userActivityOpenChange(params);
        return render(result as JSON)
    }
    /**
     * 修改活动审批状态
     * @return
     */
    @PatternNameAnnotation(name = "活动列表")
    @ActionNameAnnotation(name = "修改活动审批状态")
    def userActivityApproval() {
        def result = [:];
        result = userActivityService.userActivityApproval(params);
        return render(result as JSON);
    }
    /**
     * 系统活动创建
     * @return
     */
    @PatternNameAnnotation(name = "活动列表")
    @ActionNameAnnotation(name = "创建系统活动")
    def userActivityCreate() {
        def result = [:];
        result = userActivityService.userActivityCreate();
        return ["rmsCategoryList1": result.rmsCategoryList1, "rmsCategoryList2": result.rmsCategoryList2];
    }
    /**
     * 查询RMSCategory二级菜单
     * @return
     */
    @ActionNameAnnotation(name = "查询RMSCategory二级菜单")
    def rmsCategoryList2() {
        def result = [:];
        result = userActivityService.rmsCategoryList2(params);

        def str = "";
        result.categoryList?.each { category ->
            str += "<option value='" + category?.id + "'>" + category?.name + "</option>";
        }
        return render(text: str, contentType: "text/plain");
    }
    /**
     * 活动保存
     * @return
     */
    @PatternNameAnnotation(name = "活动列表")
    @ActionNameAnnotation(name = "活动保存")
    def userActivitySave() {
        def result = [:];
        result = userActivityService.userActivitySave(params);

        if (result.success) {
            flash.message = result.message;
            return redirect(action: 'index', params: [editPage: params.editPage]);
        } else {
            flash.message = "保存失败,参数错误！！！";
            if ("save".equals(result.saveOrUpdate)) {
                return redirect(action: 'userActivityCreate');
            } else if ("update".equals(result.saveOrUpdate)) {
                return redirect(action: 'userActivityEdit', params: params);
            } else {
                return redirect(action: 'userActivityCreate');
            }
        }
    }
    /**
     * 活动修改
     * @return
     */
    @PatternNameAnnotation(name = "活动列表")
    @ActionNameAnnotation(name = "活动修改")
    def userActivityEdit() {
        def result = [:];
        result = userActivityService.userActivityEdit(params);
        if (result.success) {
            return render(view: "userActivityCreate", model: ["userActivity": result.userActivity, "rmsCategoryList1": result.rmsCategoryList1, "rmsCategoryList2": result.rmsCategoryList2, editPage: params.editPage]);
        } else {
            flash.message = result.message;
            return redirect(action: 'index');
        }

    }
    /**
     * 活动分类管理
     */
    @PatternNameAnnotation(name = "活动分类列表")
    @ActionNameAnnotation(name = "活动分类列表")
    def userActivityCategoryList() {
        return render(view: 'userActivityCategoryList', model: [editPage: params.editPage, searchName: params.searchName, parentID: params.parentID]);
    }
    /**
     * 活动分类管理返回JSON数据
     */
    @PatternNameAnnotation(name = "活动分类列表")
    @ActionNameAnnotation(name = "活动分类管理JSON")
    def userActivityCategoryListAsJson() {
        def result = [:];
        result = userActivityService.userActivityCategoryList(params);
        result.rows = [];
        for (RMSCategory rmsCategory : result.rmsCategoryList) {
            def tmp = [:];
            tmp.id = rmsCategory.id;
            tmp.name = rmsCategory.name;
            tmp.parentName = rmsCategory.parentName;
            tmp.dateCreated = rmsCategory.dateCreated.format("yyyy-MM-dd");
            tmp.type = rmsCategory.type;
            tmp.state = rmsCategory.state;
            result.rows.add(tmp);
        }
        return render(result as JSON);
    }
    /**
     * 节点删除
     * @return
     */
    @PatternNameAnnotation(name = "活动分类列表")
    @ActionNameAnnotation(name = "节点删除")
    def rmsCategoryDelete() {
        def result = [:];
        result = userActivityService.rmsCategoryDelete(params);
        return render(result as JSON);
    }
    /**
     * 返回创建节点页面
     * @return
     */
    @PatternNameAnnotation(name = "活动分类列表")
    @ActionNameAnnotation(name = "创建节点")
    def rmsCategoryCreate() {
        def result = [:];
        result = userActivityService.rmsCategoryCreate();
        return render(view: 'userActivityRMSCategoryCreate', model: [rmsCategoryParentList: result.rmsCategoryParentList])
    }
    /**
     * 节点保存
     * @return
     */
    @PatternNameAnnotation(name = "活动分类列表")
    @ActionNameAnnotation(name = "节点保存")
    def rmsCategorySave() {
        def result = [:];
        result = userActivityService.rmsCategorySave(params);

        if (result.success) {
            return redirect(action: 'userActivityCategoryList', params: [editPage: params.editPage, searchName: params.searchName, parentID: params.parentID]);
        } else {
            flash.message = "保存失败,参数错误！！！";
            if ("save".equals(result.saveOrUpdate)) {
                return redirect(action: 'rmsCategoryCreate');
            } else if ("update".equals(result.saveOrUpdate)) {
                return redirect(action: 'rmsCategoryEdit', params: params);
            } else {
                return redirect(action: 'rmsCategoryCreate');
            }
        }
    }
    /**
     * 节点修改页面
     * @return
     */
    @PatternNameAnnotation(name = "活动分类列表")
    @ActionNameAnnotation(name = "节点修改")
    def rmsCategoryEdit() {
        def result = [:];
        result = userActivityService.rmsCategoryEdit(params);
        if (result.success) {
            return render(view: 'userActivityRMSCategoryCreate', model: [rmsCategory: result.rmsCategory, rmsCategoryParentList: result.rmsCategoryParentList, editPage: params.editPage, searchName: params.name, parentID: params.parentid]);
        } else {
            flash.message = "参数错误！！！";
            return redirect(action: 'rmsCategoryCreate', params: params);
        }
    }
    /**
     * 作品管理
     */
    @PatternNameAnnotation(name = "作品管理")
    @ActionNameAnnotation(name = "作品管理")
    def userWorkList() {
        return render(view: 'userWorkList');
    }
    /**
     * 作品管理返回JSON数据
     */
    @PatternNameAnnotation(name = "作品管理")
    @ActionNameAnnotation(name = "作品管理JSON")
    def userWorkListAsJson() {
        def result = [:];
        result = userActivityService.userWorkList(params);
        result.rows = [];
        for (UserWork userWork : result.userWorkList) {
            def tmp = [:];
            tmp.id = userWork.id;
            tmp.name = userWork.name;
            tmp.userActivity = ['name': userWork.userActivity.name];
            tmp.voteNum = userWork.voteNum;
            tmp.approval = userWork.approval;
            tmp.dateCreated = userWork.dateCreated.format("yyyy-MM-dd");
            tmp.state = userWork.state;
            tmp.transCodeState = userWork.transcodeState;
            result.rows.add(tmp);
        }
        return render(result as JSON);
    }
    /**
     * 作品审批
     * @return
     */
    @PatternNameAnnotation(name = "作品管理")
    @ActionNameAnnotation(name = "作品审批")
    def userWorkApproval() {
        def result = [:];
        result = userActivityService.userWorkApproval(params);
        return render(result as JSON);
    }
    /**
     * 作品删除
     * @return
     */
    @PatternNameAnnotation(name = "作品管理")
    @ActionNameAnnotation(name = "作品删除")
    def userWorkDelete() {
        def result = [:];
        result = userActivityService.userWorkDelete(params);
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "作品管理")
    @ActionNameAnnotation(name = "查看作品")
    def showUserWork(){
        def userWorkInstance = UserWork.get(params.id)
        if (!userWorkInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'userWorkInstance.label', default: 'nts.activity.domain.UserWork'), params.id])}"
            redirect(action: "list")
        } else {
            def userVoteList = UserVote.createCriteria().list() {
                userWork {
                    eq('id', CTools.nullToZero(params.id).longValue())
                }
                consumer {
                    eq('id', CTools.nullToZero(session?.consumer?.id).longValue())
                }
            }
            if (userVoteList != null && userVoteList != []) {
                flash.voteState = 1
            } else {
                flash.voteState = 0
            }

            def newsUserWorkList = UserWork.list(max: 10, sort: "id", order: "desc")            //最新产品
            def hotUserWorkList = UserWork.list(max: 10, sort: "voteNum", order: "desc")            //热门产品
            return render(view: 'showUserWork',model:[userWork: userWorkInstance, newsUserWorkList: newsUserWorkList, hotUserWorkList: hotUserWorkList] )
        }
    }

    /**
     * 上传图片
     * @param opt
     *      opt：值为save表示添加图片
     *      imgPath:传入的文件路径，update的时候使用
     * @return
     */
    /*def uploadImg(def opt, def imgPath) {
        CommonsMultipartFile imgFile = request.getFile("saveImg");
        if (imgFile) {
            def imgName = imgFile.getOriginalFilename();
            def imgType = imgFile.getContentType();

            def path = servletContext.getRealPath("/upload");

            if (imgFile && !imgFile.isEmpty()) {
                if (imgType == "image/pjpeg" || imgType == "image/jpeg" || imgType == "image/png" || imgType == "image/x-png" || imgType == "image/gif") {
                    if (opt == "save" || imgPath == "default.jpg" || !imgPath) {
                        *//*def sc = StudyCommunity.createCriteria()
                        def id = sc.get {
                            projections {
                                max "id"
                            }
                        }*//*
                        def id = System.currentTimeMillis();
                        *//*id = id == null ? 1 : id + 1*//*
                        imgPath = "i_" + id + ".jpg";
                    }
                    imgFile.transferTo(new java.io.File("${path}/userActivityImg/" + imgPath));
                } else {
                    flash.message = "上传图片格式不对...";
                }
            }
        }
        return imgPath;
    }*/

    //检查活动分类是否重名
    def checkCategoryName = {
        def msg = false;
        def categoryId = params.categoryId;
        def categoryName = params.categoryName;
        def parentId = params.parentId;
        def checkType = params.checkType;
        def category = RMSCategory.createCriteria().list(){
            eq('name', categoryName)
            eq('parentid', parentId as int)
            eq('type', 3)
            if("updateCheck".equals(checkType)){
                notEqual('id', categoryId as long)
            }
        }
        if(category){
            msg = true;
        }
        return render(msg)
    }
}
