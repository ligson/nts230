package nts.admin.communitymgr.controllers

import grails.converters.JSON
import nts.commity.domain.ForumBoard
import nts.commity.domain.StudyCommunity
import nts.system.domain.RMSCategory
import nts.user.services.ActionNameAnnotation
import nts.user.services.ControllerNameAnnotation
import nts.user.services.PatternNameAnnotation

@ControllerNameAnnotation(name = "社区管理")
class CommunityManagerController {
    def communityManagerService
    @PatternNameAnnotation(name = "社区列表")
    @ActionNameAnnotation(name = "社区列表")
    def index() {

    }

    @PatternNameAnnotation(name = "社区列表")
    @ActionNameAnnotation(name = "社区管理")
    def communityList(){
        def result=communityManagerService.communityList(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "社区列表")
    @ActionNameAnnotation(name = "社区删除")
    def communityDelete(){
        def result=communityManagerService.deleteCommunity(params);
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "社区列表")
    @ActionNameAnnotation(name = "社区状态")
    def communityState(){
        def result=communityManagerService.communityState(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "社区列表")
    @ActionNameAnnotation(name = "社区推荐")
    def communityRecommend(){
        def result=communityManagerService.communityRecommend(params);
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "小组管理")
    @ActionNameAnnotation(name = "小组管理")
    def forumBoardManager(){

    }

    @PatternNameAnnotation(name = "小组管理")
    @ActionNameAnnotation(name = "板块显示")
    def forumBoardList(){
        def result=communityManagerService.forumBoardList(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "小组管理")
    @ActionNameAnnotation(name = "板块删除")
    def forumBoardDelete(){
        def result=communityManagerService.deleteForumBoard(params);
        return render(result as JSON);
    }
    @PatternNameAnnotation(name = "帖子管理")
    @ActionNameAnnotation(name = "帖子管理")
    def forumMainArticleManager(){

    }

    @PatternNameAnnotation(name = "帖子管理")
    @ActionNameAnnotation(name = "帖子显示")
    def articleList(){
        def result=communityManagerService.articleList(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "帖子管理")
    @ActionNameAnnotation(name = "帖子置顶")
    def topArticle(){
        def result=communityManagerService.topArticle(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "帖子管理")
    @ActionNameAnnotation(name = "精华帖子")
    def eliteArticle(){
        def result=communityManagerService.eliteArticle(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "帖子管理")
    @ActionNameAnnotation(name = "帖子删除")
    def articleDelete(){
        def result=communityManagerService.deleteArticle(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "共享管理")
    @ActionNameAnnotation(name = "共享管理")
    def sharingManager(){

    }

    @PatternNameAnnotation(name = "共享管理")
    @ActionNameAnnotation(name = "共享显示")
    def sharingList(){
        def result=communityManagerService.sharingList(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "共享管理")
    @ActionNameAnnotation(name = "共享删除")
    def sharingDelete(){
        def result=communityManagerService.deleteSharing(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "共享管理")
    @ActionNameAnnotation(name = "共享操作")
    def operateSharing(){
        def result=communityManagerService.operateSharing(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "公告管理")
    @ActionNameAnnotation(name = "公告管理")
    def noticeManager(){

    }

    @PatternNameAnnotation(name = "公告管理")
    @ActionNameAnnotation(name = "公告显示")
    def noticeList(){
        def result=communityManagerService.noticeList(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "公告管理")
    @ActionNameAnnotation(name = "公告删除")
    def noticeDelete(){
        def result=communityManagerService.deleteNotice(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "社区活动管理")
    @ActionNameAnnotation(name = "社区活动管理")
    def activityManager(){

    }

    @PatternNameAnnotation(name = "社区活动管理")
    @ActionNameAnnotation(name = "社区活动显示")
    def activityList(){
        def result=communityManagerService.activityList(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "社区活动管理")
    @ActionNameAnnotation(name = "社区活动删除")
    def activityDelete(){
        def result=communityManagerService.deleteActivity(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "社区活动管理")
    @ActionNameAnnotation(name = "社区活动状态")
    def operaActivityState(){
        def result=communityManagerService.operaActivityState(params);
        return render(result as JSON)
    }
    @PatternNameAnnotation(name = "社区分类列表")
    @ActionNameAnnotation(name = "社区分类列表")
    def RMSCategoryManager(){

    }

    @PatternNameAnnotation(name = "社区分类列表")
    @ActionNameAnnotation(name = "社区分类显示")
    def RMSCategoryList(){
        def result=communityManagerService.RMSCategoryList(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "社区分类列表")
    @ActionNameAnnotation(name = "社区分类删除")
    def rmsCategoryDelete(){
        def result=communityManagerService.deleteRMSCategory(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "社区分类列表")
    @ActionNameAnnotation(name = "社区分类创建")
    def categoryCreate(){
        RMSCategory category=new RMSCategory();//修改时用
        if(params?.id){
            category=RMSCategory.get(params.id);
        }
        List<RMSCategory> categoryList=RMSCategory.createCriteria().list(){
            eq("parentid",0)
            eq("type",2)
        }
        return render(view: 'categoryCreate',model: [categoryList:categoryList,categoryA:category])
    }

    @PatternNameAnnotation(name = "社区分类列表")
    @ActionNameAnnotation(name = "社区分类保存")
    def categorySave(){
        def name=params.name;
        def parentid=params.parentid;
        def parId;
        def parentName;
        if(parentid instanceof String){
            parId=Integer.parseInt(parentid);
        }else{
            parId=parentid;
        }
        RMSCategory category;
        if(params.id){
            category=RMSCategory.get(params.id)
        }else
        {
            category=new RMSCategory();
        }

        category.name=name;
        if(parId==0){
            parentName="无";
        }else{
            RMSCategory parent=RMSCategory.get(parId);
            parentName=parent.name;
        }

        if(params.id) {
            //20140717添加 查询是否有子节点,如果有字节点修改字节点的父节点名称
            List<RMSCategory> childCategoryList=RMSCategory.createCriteria().list(){
                eq("parentid",Integer.parseInt(params.id))
            }

            if(childCategoryList.size() > 0){
                childCategoryList.each{
                    it.parentName = name;
                    it.save(flush:true);
                }
            }
        }

        category.parentid=parId;
        category.parentName=parentName;
        category.type=2;
        if(category.save(flush: true)&&(!category.hasErrors())){
            return redirect(action: 'RMSCategoryManager',controller: 'communityManager')
        }
    }

    @PatternNameAnnotation(name = "社区管理员")
    @ActionNameAnnotation(name = "社区管理员")
    def communityAdmin(){
        List<StudyCommunity> communityList = StudyCommunity.list();
        return render(view: 'communityAdmin',model: [communityList:communityList])
    }

    @PatternNameAnnotation(name = "社区管理员")
    @ActionNameAnnotation(name = "社区管理员显示")
    def communityAdminList(){
        def result=communityManagerService.communityConsumer(params,"admin");
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "社区管理员")
    @ActionNameAnnotation(name = "社区管理员操作")
    def operaCommunityConsumer(){
        def result=communityManagerService.operaCommunityConsumer(params);
        return render(result as JSON)

    }

    @PatternNameAnnotation(name = "社区管理员")
    @ActionNameAnnotation(name = "社区管理员删除")
    def consumerDelete(){
        def result=communityManagerService.deleteConsumer(params);
        return render(result as JSON)

    }

    @PatternNameAnnotation(name = "小组管理员")
    @ActionNameAnnotation(name = "小组管理员")
    def forumBoardAdmin(){
        List<ForumBoard> boardList = ForumBoard.list();
        return render(view: 'forumBoardAdmin',model: [boardList:boardList])
    }

    @PatternNameAnnotation(name = "小组管理员")
    @ActionNameAnnotation(name = "小组管理员显示")
    def forumBoardAdminList(){
        def result=communityManagerService.communityConsumer(params,"board");
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "小组管理员")
    @ActionNameAnnotation(name = "小组管理员操作")
    def operaCommunityConsumerForForumBoard(){
        def result=communityManagerService.operaCommunityConsumer(params);
        return render(result as JSON)

    }

    @PatternNameAnnotation(name = "小组管理员")
    @ActionNameAnnotation(name = "小组管理员删除")
    def consumerDeleteForForumBoard() {
        def result = communityManagerService.deleteConsumer(params);
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "社区用户")
    @ActionNameAnnotation(name = "社区用户")
    def communityConsumer(){
        List<StudyCommunity> communityList = StudyCommunity.list();
        return render(view: 'communityConsumer',model: [communityList:communityList])
    }

    @PatternNameAnnotation(name = "社区用户")
    @ActionNameAnnotation(name = "社区用户显示")
    def communityConsumerList(){
        def result=communityManagerService.communityConsumer(params,"consumer");
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "社区用户")
    @ActionNameAnnotation(name = "社区用户操作")
    def operaCommunityConsumerForCommunity(){
        def result=communityManagerService.operaCommunityConsumer(params);
        return render(result as JSON)

    }

    @PatternNameAnnotation(name = "社区用户")
    @ActionNameAnnotation(name = "社区用户删除")
    def consumerDeleteForCommunity() {
        def result = communityManagerService.deleteConsumer(params);
        return render(result as JSON);
    }

    //检查社区分类是否重名
    def checkCategoryName = {
        def msg = false;
        def categoryId = params.categoryId;
        def categoryName = params.categoryName;
        def parentId = params.parentId;
        def checkType = params.checkType;
        def category = RMSCategory.createCriteria().list(){
            eq('name', categoryName)
            eq('parentid', parentId as int)
            eq('type', 2)
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