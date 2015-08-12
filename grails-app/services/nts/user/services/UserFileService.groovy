package nts.user.services

import nts.commity.domain.ForumBoard
import nts.commity.domain.ForumSharing
import nts.user.domain.Consumer
import nts.user.file.domain.UserCategory
import nts.user.file.domain.UserFile
import nts.user.special.domain.SpecialComment
import nts.user.special.domain.SpecialFile
import nts.user.special.domain.SpecialFileRemark
import nts.user.special.domain.SpecialPoster
import nts.user.special.domain.SpecialScore
import nts.user.special.domain.SpecialTag
import nts.user.special.domain.UserSpecial
import org.spockframework.compiler.model.Spec

class UserFileService {


    public Map saveUserSpecial(Map params){
        def result=[:];
        List<Long> ids =[];
        def idList = params.idList;
        def specialName = params.specialName;
        def specialDesc = params.specialDesc;
        def specialTag = params.specialTag;
        def specialId = params.specialId;
        if(idList){
            if(idList.indexOf(',')){
                def strs=idList.split(',');
                strs.each {
                    ids.add(it as Long)
                }
            }else{
                ids.add(idList as Long)
            }
        }
        //创建专辑
        UserSpecial userSpecial = null;
        if(specialId){
            userSpecial = UserSpecial.get(specialId as Long);
        }else{
            userSpecial = new UserSpecial();
            userSpecial.name = specialName;
            userSpecial.consumer = params.consumer;
            userSpecial.description = specialDesc;
            userSpecial.planSize=ids.size();
            userSpecial.save(flush: true)
        }

        //专辑标签保存
        if(specialTag){
            if(specialTag.indexOf(",")!=-1){
                String[] strings = specialTag.split(",");
                for(int i=0;i<strings.size();i++){
                    String str =strings[i];
                    if(str){
                        SpecialTag tag = new SpecialTag();
                        tag.name = str;
                        tag.special = userSpecial;
                        tag.save(flush: true);
                        userSpecial.addToTags(tag);
                        userSpecial.save(flush: true)
                    }
                }
            }else{
                SpecialTag tag = new SpecialTag();
                tag.name = specialTag;
                tag.special = userSpecial;
                tag.save(flush: true);
                userSpecial.addToTags(tag);
                userSpecial.save(flush: true)
            }
        }

        //保存专辑文件
        ids?.each {
            UserFile userFile = UserFile.get(it);
            if(userFile){
                SpecialFile specialFile = null;
                specialFile = SpecialFile.findByUserFileAndUserSpecial(userFile,userSpecial);
                if(!specialFile){
                    specialFile = new SpecialFile();
                    specialFile.userFile = userFile;
                    specialFile.name = userFile.name;
                    specialFile.description = userFile.description;
                    specialFile.userSpecial = userSpecial;
                    specialFile.save(flush: true);
                    userSpecial.addToFiles(specialFile);
                    userSpecial.save(flush: true)
                }
                result.success=true;
            }else{
                result.success=false;
                result.msg = "参数不全!";
            }
        }
        return result;
    }

    public void updateSpecial(Map params){
        def id = params.id;
        def specialTags = params.specialTags;
        UserSpecial userSpecial = UserSpecial.get(id as Long);
        userSpecial.properties = params;
        if(params.allowRemark=='true'){
            userSpecial.allowRemark=true;
        }else{
            userSpecial.allowRemark=false;
        }
        //删除原有标签
        deleteSpecialTag(userSpecial);

        if(specialTags.indexOf(",")!=-1){
            String[] strings = specialTags.split(",");
            for(int i=0;i<strings.size();i++){
                String str =strings[i].trim();
                if(str){
                    SpecialTag tag = new SpecialTag();
                    tag.name = str;
                    tag.special = userSpecial;
                    tag.save(flush: true);
                    userSpecial.addToTags(tag);
                }
            }
        }else{
            SpecialTag tag = new SpecialTag();
            tag.name = specialTags;
            tag.special = userSpecial;
            tag.save(flush: true);
            userSpecial.addToTags(tag);
        }

        //增加海报
        def fileHash = params.fileHash
        if(fileHash){
            SpecialPoster specialPoster = new SpecialPoster();
            specialPoster.properties = params;
            specialPoster.special = userSpecial;
            specialPoster.save(flush: true);
            userSpecial.addToPosters(specialPoster);
        }
        userSpecial.save(flush: true);
    }


    public Map queryCategoryAndFile(String parentId,Consumer consumer){
        def result = [:];
        List<UserCategory> categoryList=[];
        if(parentId){
            UserCategory father = UserCategory.get(parentId as Long);
            categoryList = UserCategory.findAllByFatherCategoryAndConsumerAndState(father,consumer,0);
        }else{
            categoryList = UserCategory.findAllByFatherCategoryAndConsumerAndState(null,consumer,0);
        }
        List categories =[];
        categoryList.each {
            List<UserFile> fileList = [];
            fileList = UserFile.findAllByUserCategoryAndConsumerAndState(it,consumer,0);
            def tmp=[:];
            tmp.id=it.id;
            tmp.name=it.name;
            tmp.isParent=UserCategory.countByFatherCategory(it);
            //文件夹下没有文件的清空下让复选框失效
            if(fileList.size()==0){
                tmp.chkDisabled = true;
            }
            if(categoryList){
                tmp.fatherCategory=it.fatherCategory;
            }
            //tmp.fileList = fileList;
            List child = [];
            //子节点集合
            fileList?.each {UserFile userFile->
                def tmp1=[:];
                tmp1.id=userFile.id;
                tmp1.name=userFile.name;
                tmp1.fileHash = userFile.fileHash;
                child.add(tmp1);
            }
            tmp.children =child;
            categories.add(tmp);
        }
        if(!parentId){
            List<UserFile> files = UserFile.createCriteria().list(){
                isNull('userCategory')
                eq('consumer',consumer)
                eq('state',0)
            };
            files?.each {
                def tmp=[:];
                tmp.id=it.id;
                tmp.name=it.name;
                tmp.fileHash = it.fileHash;
                categories.add(tmp);
            }
        }

        result.categories = categories
        return result
    }
    public void deleteSpecialById(String id){
        UserSpecial userSpecial = UserSpecial.get(id as Long);
        deleteSpecialScore(userSpecial);
        deleteForumSharing(userSpecial);
        deleteSpecialFile(userSpecial);
        deleteSpecialTag(userSpecial);
        deleteSpecialPoster(userSpecial);
        userSpecial.delete();
    }

    //delete forumSharing
    public void deleteForumSharing(UserSpecial userSpecial){
        ForumSharing forumSharing = ForumSharing.findBySpecial(userSpecial);
        if(forumSharing)forumSharing.delete();
    }

    //delete specialScore
    public void deleteSpecialScore(UserSpecial userSpecial){
        List<SpecialScore> scoreList = userSpecial.getScores().toList();
        scoreList?.each {SpecialScore score->
            userSpecial.getScores().remove(score);
            score.delete();
        }

    }

    //delete SpecialFile
    public void deleteSpecialFile(UserSpecial userSpecial){
        List<SpecialFile> specialFileList = SpecialFile.findAllByUserSpecial(userSpecial);
        specialFileList?.each {
            if(userSpecial?.files.toList().contains(it)){
                userSpecial?.files.remove(it)
                userSpecial.save();
            }
            deleteSpecialFileRemark(it);
            it.delete();
        }
    }
    //delete SpecialFileRemark
    public void deleteSpecialFileRemark(SpecialFile specialFile){
        specialFile?.remarks?.toList().each {
            specialFile.remarks.remove(it);
            specialFile.save()
            deleteSpecialComment(it);
            it.delete();
        }
    }
    //delete SpecialComment
    public void deleteSpecialComment(SpecialFileRemark specialFileRemark){
        specialFileRemark?.comments?.toList()?.each {
            specialFileRemark.comments.remove(it);
            specialFileRemark.save()
            it.delete();
        }
    }
    //delete SpecialTag
    public void deleteSpecialTag(UserSpecial userSpecial){
        userSpecial?.tags.toList()?.each {
            userSpecial.tags.remove(it);
            userSpecial.save()
            it.delete();
        }
    }
    //delete SpecialPoster
    public void deleteSpecialPoster(UserSpecial userSpecial){
        userSpecial?.posters.toList()?.each {
            userSpecial.posters.remove(it);
            userSpecial.save()
            it.delete();
        }
    }


    public Map specialSharing(Map params){
        def result = [:];
        UserSpecial userSpecial = null;
        ForumBoard forumBoard = null;
        if(params.specialId){
          userSpecial =  UserSpecial.get(params.specialId as Long);
          forumBoard = ForumBoard.get(params.boardId as Long);

           ForumSharing sharing = new ForumSharing();
           sharing.special = userSpecial;
           sharing.forumBoard =forumBoard;
           sharing.consumer = params.consumer;
           sharing.description = userSpecial.description;
           if(params.canDownload=="true"){
               sharing.canDownload = true;
           } else if(params.canDownload == "false"){
               sharing.canDownload = false;
           }
           if(params.shareRange == "0"){
               sharing.shareRange = 0;
           } else if(params.shareRange == "1"){
               sharing.shareRange = 1;
           }else if(params.shareRange == "2"){
               sharing.shareRange = 2;
           }
           if(sharing.save(flush: true)&&(!sharing.hasErrors())){
               result.success = true;
               result.msg = "共享完成";
           }else{
               result.success = false;
               result.msg = "共享失败";
           }
        }else{
            result.success = false;
            result.msg = "用户专辑不存在";
        }
        return result;
    }
    public Map userFileSharing(Map params){
        def result = [:];
        ForumBoard forumBoard = null;
        List<Long> fileIds = [];
        if(params.fileIdList){
            if(params.fileIdList.indexOf(',')!=-1){
                def strs = params.fileIdList.split(',');
                strs?.each {
                    fileIds.add(it as Long);
                }
            }else{
                fileIds.add(params.fileIdList as Long);
            }
        }
        forumBoard = ForumBoard.get(params.boardId as Long);
        fileIds?.each {
            UserFile userFile = UserFile.get(it);
            ForumSharing sharing = new ForumSharing();
            sharing.userFile = userFile;
            sharing.forumBoard =forumBoard;
            sharing.consumer = params.consumer;
            sharing.description = userFile.description;
            if(params.canDownload=="true"){
                sharing.canDownload = true;
            } else if(params.canDownload == "false"){
                sharing.canDownload = false;
            }
            if(params.shareRange == "0"){
                sharing.shareRange = 0;
            } else if(params.shareRange == "1"){
                sharing.shareRange = 1;
            }else if(params.shareRange == "2"){
                sharing.shareRange = 2;
            }
            if(sharing.save(flush: true)&&(!sharing.hasErrors())){
                result.success = true;
                result.msg = "共享完成";
            }else{
                result.success = false;
                result.msg = "共享失败";
            }
        }
        return result;
    }


}
