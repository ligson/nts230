package nts.admin.file.controllers

import com.boful.common.file.utils.FileType
import com.boful.common.file.utils.FileUtils
import com.sun.xml.internal.messaging.saaj.packaging.mime.internet.MimeUtility
import grails.converters.JSON
import nts.commity.domain.ForumSharing
import nts.user.domain.Consumer
import nts.user.file.domain.UserCategory
import nts.user.file.domain.UserFile
import nts.user.file.domain.UserFileTag
import nts.user.special.domain.SpecialFile
import nts.utils.CTools
import org.apache.commons.lang.StringUtils
import org.apache.http.HttpEntity
import org.apache.http.HttpResponse
import org.apache.http.HttpStatus
import org.apache.http.NameValuePair
import org.apache.http.client.HttpClient
import org.apache.http.client.entity.UrlEncodedFormEntity
import org.apache.http.client.methods.CloseableHttpResponse
import org.apache.http.client.methods.HttpGet
import org.apache.http.client.methods.HttpPost
import org.apache.http.impl.client.HttpClientBuilder
import org.apache.http.impl.client.HttpClients
import org.apache.http.message.BasicNameValuePair
import org.apache.http.params.CoreProtocolPNames
import org.apache.http.params.HttpParams

class UserFileController {
    def userFileService

    def index() {}

    /**
     * 上传完成后保存文件
     * @return
     */
    def saveUserFile() {
        def result = [:];
        String fileHash = params.fileHash;
        String filePath = params.filePath;
        String fileSize = params.fileSize;
        String parentId = params.parentId;
        UserFile userFile = new UserFile();
        userFile.name = params.name;
        userFile.fileType = FileUtils.getFileSufix(filePath);
        if (fileSize) userFile.fileSize = params.fileSize as Long;
        userFile.fileHash = fileHash;
        userFile.filePath = filePath;
        userFile.consumer = session.consumer;
        if (userFile.save(flush: true) && (!userFile.hasErrors())) {
            // 更新非超级管理员用户的已用空间
            if(session.consumer.role != Consumer.SUPER_ROLE) {
                def consumer = Consumer.get(session.consumer.id)
                consumer.useSpaceSize = consumer.useSpaceSize + (fileSize as Long);
                consumer.save();
            }
            if (parentId) {
                UserCategory userCategory = UserCategory.get(parentId as Long);
                userCategory.addToUserFiles(userFile);
            }
            result.success = true;
            result.msg = "上传完成";
            result.userFile = userFile;
        } else {
            result.success = false;
            result.msg = "上传失败";
        }
        return render(result as JSON)
    }

    /**
     * 保存文件夹
     */
    def saveUserCategory() {
        def result = [:];
        String fileName = params.fileName;
        fileName = CTools.htmlToBlank(fileName);
        String parentId = params.parentId;
        UserCategory userCategory = new UserCategory();
        userCategory.name = fileName;
        userCategory.consumer = session.consumer;
        if (parentId) {
            userCategory.fatherCategory = UserCategory.findById(parentId as Long);
        }
        if (userCategory.save(flush: true) && (!userCategory.hasErrors())) {
            result.success = true;
            result.msg = "文件夹创建完成";
            result.userCategory = userCategory;
        } else {
            result.success = true;
            result.msg = "文件夹创建失败";
        }
        return render(result as JSON)
    }
    /**
     * 单击文件夹进入下级目录
     */
    def checkCategory() {
        def result = [:];
        String id = params.id;
        List<UserCategory> categoryList = new ArrayList<UserCategory>();
        if (id) {
            UserCategory userCategory = UserCategory.get(id as Long);
            def childCategorys = UserCategory.findAllByFatherCategoryAndConsumerAndState(userCategory, session.consumer, 0);
            result.userCategory = userCategory;
            if (childCategorys) {
                childCategorys.each { UserCategory userCategory1 ->
                    categoryList.add(userCategory1);
                }
            }
            List<UserFile> userFiles = UserFile.createCriteria().list(max: 10, offset: 0) {
                if (userCategory) eq('userCategory', userCategory)
                eq('state', 0)
            }
            def total = userFiles.totalCount;
            result.childCategorys = categoryList;
            result.parentId = userCategory.id;
            result.fileList = userFiles;
            result.total = total;
        }
        return render(result as JSON)
    }

    def updateFileCategory() {
        def result = [:];
        def categoryId = params.categoryId;
        def fids = (params.fId).toString().split(",");
        UserCategory userCategory;
        if (categoryId == '0') {
            userCategory = null;
        } else {
            userCategory = UserCategory.get(categoryId as Long);
        }
        for (int i = 0; i < fids.length; i++) {
            def fId = fids[i];
            UserFile userFile = UserFile.get(fId as Long);
            result.oldCate = userFile.userCategory;
            if (userFile) {
                userFile.userCategory = userCategory;
                userFile.save(flush: true);
                if (userCategory) userCategory.addToUserFiles(userFile);
                result.newCate = userFile.userCategory;
                result.success = true;
                result.msg = "移动完成";
            } else {
                result.success = false;
                result.msg = "参数不全";
            }
        }

        return render(result as JSON)
    }

    /**
     * 回收站
     */
    def recycleBin() {
        def result = [:];
        Consumer consumer = session.consumer;
        List<UserFile> fileList = UserFile.createCriteria().list(order: 'desc', sort: 'createdDate') {
            eq("consumer", consumer);
            eq("state", 1)
        }
        //查询出所有回收站中的文件，然后判断该文件的父类是否被删除，如果被删除则在集合中移除该文件
        if (fileList) {
            Iterator<UserFile> fileIterator = fileList.iterator();
            while (fileIterator.hasNext()) {
                UserFile userFile = fileIterator.next();
                if (userFile.userCategory && userFile.userCategory.state == 1) {
                    fileIterator.remove();
                }
            }
        }
        List<UserCategory> categoryList = UserCategory.createCriteria().list(order: 'desc', sort: 'createdDate') {
            eq("consumer", consumer);
            eq("state", 1)
        }
        if (categoryList) {
            Iterator<UserCategory> categoryIterator = categoryList.iterator();
            while (categoryIterator.hasNext()) {
                UserCategory userCategory = categoryIterator.next();
                if (userCategory.fatherCategory && userCategory.fatherCategory.state == 1) {
                    categoryIterator.remove();
                }
            }
        }
        result.total = fileList.totalCount;
        result.fileList = fileList;
        result.childCategorys = categoryList;
        return render(result as JSON)
    }

    def queryAllFileAndCategorys() {
        def result = [:];
        List<UserCategory> categoryList = new ArrayList<UserCategory>();
        List<UserFile> fileList = new ArrayList<UserFile>();
        def total;
        String parentId = params.parentId;
        String name = params.name;
        String search = params.search;
        String recycle = params.recycle;
        if (parentId) {
            UserCategory childCategory;
            UserCategory fatherCategory;
            /**search字段是为了区分方法（不存在时使用的是返回上一级功能，存在时使用的是查询功能）**/
            if (search) {
                fatherCategory = UserCategory.get(parentId as Long);
            } else {
                childCategory = UserCategory.get(parentId as Long);
                fatherCategory = childCategory.fatherCategory;
            }

            if (fatherCategory) {
                List<UserCategory> categories = UserCategory.createCriteria().list() {
                    eq("fatherCategory", fatherCategory)
                    eq("consumer", session.consumer)
                    if (name) {
                        like("name", "%" + name + "%")
                    }
                    if (recycle) {
                        eq("state", 1)
                    } else {
                        eq("state", 0)
                    }

                }
                categories.each { UserCategory category ->
                    categoryList.add(category);
                }

                fileList = UserFile.createCriteria().list(max: 10, order: 'desc', sort: 'createdDate') {
                    eq('userCategory', fatherCategory)
                    if (name) {
                        like("name", "%" + name + "%")
                    }
                    eq("consumer", session.consumer)
                }
                result.total = fileList.totalCount;
                result.userCategory = fatherCategory;
                result.childCategorys = categoryList;
                result.fileList = fileList;
            } else {
                List<UserFile> fileList1 = UserFile.createCriteria().list(max: 10, order: 'desc', sort: 'createdDate') {
                    eq("consumer", session.consumer);
                    isNull("userCategory")
                    if (name) {
                        like("name", "%" + name + "%")
                    }
                    if (recycle) {
                        eq("state", 1)
                    } else {
                        eq("state", 0)
                    }
                }
                List<UserCategory> categoryList1 = UserCategory.createCriteria().list(order: 'desc', sort: 'createdDate') {
                    eq("consumer", session.consumer);
                    isNull("fatherCategory")
                    if (name) {
                        like("name", "%" + name + "%")
                    }
                    if (recycle) {
                        eq("state", 1)
                    } else {
                        eq("state", 0)
                    }
                }
                result.total = fileList1.totalCount;
                result.userCategory = null;
                result.childCategorys = categoryList1;
                result.fileList = fileList1;
            }

        } else {
            List<UserFile> fileList1 = UserFile.createCriteria().list(max: 10, order: 'desc', sort: 'createdDate') {
                eq("consumer", session.consumer);
                if (!search)
                    isNull("userCategory")
                if (name) {
                    like("name", "%" + name + "%")
                }
                if (recycle) {
                    eq("state", 1)
                } else {
                    eq("state", 0)
                }
            }
            List<UserCategory> categoryList1 = UserCategory.createCriteria().list(order: 'desc', sort: 'createdDate') {
                eq("consumer", session.consumer);
                if (!search)
                    isNull("fatherCategory")
                if (name) {
                    like("name", "%" + name + "%")
                }
                if (recycle) {
                    eq("state", 1)
                } else {
                    eq("state", 0)
                }
            }
            result.total = fileList1.totalCount;
            result.userCategory = null;
            result.childCategorys = categoryList1;
            result.fileList = fileList1;
        }
        return render(result as JSON)
    }

    /**
     * 删除文件
     */
    def deleteUserFile() {
        def result = [:];
        result.useSize = -1;
        def idList = params.idList;
        def reset = params.reset;
        List<Integer> ids = new ArrayList<Integer>();
        if (idList.indexOf(",")) {
            String[] strings = idList.split(",");
            strings.each {
                ids.add(it as int);
            }
        } else {
            ids.add(idList as int);
        }

        if (ids.size() > 0) {
            long fileSize = 0;
            ids.each {
                UserFile userFile = UserFile.get(it);
                if (userFile) {
                    if (reset) {
                        userFile.state = 0;
                        userFile.save(flush: true);
                    } else {
                        if (userFile.state == 0) {
                            userFile.state = 1;
                            userFile.save(flush: true);
                        } else if (userFile.state == 1) {
                            //如果文件共享过,删除板块公共享
                            List<ForumSharing> forumSharing = ForumSharing.findAllByUserFile(userFile);
                            forumSharing?.each {
                                it.delete(flush: true);
                            }
                            SpecialFile specialFile = SpecialFile.findByUserFile(userFile);
                            if (specialFile) {
                                if (specialFile.userSpecial) {
                                    specialFile.userSpecial.removeFromFiles(specialFile);
                                    forumSharing = ForumSharing.findAllBySpecial(specialFile.userSpecial);
                                    forumSharing?.each {
                                        if (it.special) {
                                            if (SpecialFile.findAllByUserSpecial(it.special)?.size() == 1) it.delete(flush: true);
                                            if (it.special.files.toList().contains(userFile)) {
                                                it.special.removeFromFiles(specialFile);
                                                userFile.delete(flush: true);
                                            }
                                        }

                                    }


                                }
                                specialFile.delete(flush: true);
                            }

                            if (userFile.userCategory) {
                                userFile.userCategory.removeFromUserFiles(userFile);
                            }
                            fileSize += userFile.fileSize;
                            userFile.delete();
                        }
                    }

                    result.success = true;
                }
            }

            if(fileSize > 0) {
                // 更新非超级管理员用户的已用空间
                if(session.consumer.role != Consumer.SUPER_ROLE) {
                    def consumer = Consumer.get(session.consumer.id)
                    consumer.useSpaceSize = consumer.useSpaceSize - fileSize;
                    result.useSize = consumer.useSpaceSize;
                    consumer.save();
                }
            }
        }
        result.ids = ids;
        return render(result as JSON)
    }

    def queryUserFileById() {
        def result = [:];
        def id = params.id;
        UserFile userFile = UserFile.get(id as Long);
//        List<UserFileTag> tags = UserFileTag.findAllByUserFile(userFile);
        def criteria = UserFileTag.createCriteria();
        List<UserFileTag> tags = criteria.list{
            eq("userFile", userFile)
            order("id", "asc")
        }
        result.userFile = userFile;
        result.tags = tags;
        return render(result as JSON)
    }

    def fileStateSet() {
        def result = [:];
        def id = params.id;
        def isDownload = params.isDownload;
        def isRemark = params.isRemark;
        def isPublic = params.isPublic;
        if (id) {
            UserFile userFile = UserFile.get(id as Long);
            if (userFile) {
                if (isDownload == '0' || isDownload == 0) {
                    userFile.allowDownload = false;
                } else {
                    userFile.allowDownload = true;
                }
                if (isPublic == "0" || isPublic == 0) {
                    userFile.canPublic = false;
                } else {
                    userFile.canPublic = true;
                }
                if (isRemark == "0" || isRemark == 0) {
                    userFile.allowRemark = false;
                } else {
                    userFile.allowRemark = true;
                }
                if (userFile.save(flush: true) && (!userFile.hasErrors())) {
                    result.success = true;
                    result.msg = "设置完成";
                }
            }
        } else {
            result.success = false;
            result.msg = "参数不全";
        }
        return render(result as JSON)
    }
    /**
     * 修改文件描述和标签
     */
    def executeUpdate() {
        def result = [:];
        def id = params.id;
        def name = params.name;
        def desc = params.desc;
        def tags = params.tags;
        if (id) {
            UserFile userFile = UserFile.get(id as Long);
            List<UserFileTag> fileTags = UserFileTag.findAllByUserFile(userFile);
            if (userFile) {
                if (name) {
                    userFile.name = name;
                }
                if (desc) {
                    userFile.description = desc;
                }
                if (tags) {
                    fileTags.each { UserFileTag userFileTag ->
                        userFile.removeFromTags(userFileTag);
                        userFileTag.delete();
                    }
                    if (tags.indexOf(",") != -1) {
                        String[] strings = tags.split(",");
                        for (int i = 0; i < strings.size(); i++) {
                            def str = strings[i];
                            if (str) {
                                UserFileTag tag = UserFileTag.findByName(str);
                                if (!tag) {
                                    tag = new UserFileTag();
                                    tag.name = str;
                                    tag.userFile = userFile;
                                    tag.save(flush: true);
                                    userFile.addToTags(tag);
                                } else {
                                    tag.userFile = userFile;
                                    tag.save(flush: true);
                                    userFile.addToTags(tag);
                                }
                            }
                        }
                    } else {
                        UserFileTag tag = UserFileTag.findByName(tags);
                        if (!tag) {
                            tag = new UserFileTag();
                            tag.name = tags;
                            tag.userFile = userFile;
                            tag.save(flush: true);
                            userFile.addToTags(tag);
                        }
                    }
                }
                if (userFile.save(flush: true) && (!userFile.hasErrors())) {
                    result.success = true;
                }
            } else {
                result.success = false;
                result.msg = "参数不全";
            }
        }
        return render(result as JSON)
    }
    /**
     * 删除文件夹以及子文件
     * @return
     */
    def deleteUserCategory() {
        def result = [:];
        result.useSize = -1;
        def idList = params.idList;
        def reset = params.reset;
        List<Integer> ids = new ArrayList<Integer>();
        if (idList.indexOf(",")) {
            String[] strings = idList.split(",");
            strings.each {
                ids.add(it as int);
            }
        } else {
            ids.add(idList as int);
        }
        if (ids.size() > 0) {
            // 取得非超级管理员用户
            Consumer consumer = null;
            if(session.consumer.role != Consumer.SUPER_ROLE) {
                consumer = Consumer.get(session.consumer.id)
            }
            ids.each {
                UserCategory category = UserCategory.get(it);
                if (category) {
                    deleteAllUserCategory(category, reset, consumer);
                    if (reset) {
                        category.state = 0;
                        category.save(flush: true);
                    } else {
                        if (category.state == 0) {
                            category.state = 1;
                            category.save(flush: true);
                        } else if (category.state == 1) {
                            if (category.userFiles) {
                                category.userFiles.each {
                                    // 更新非超级管理员用户的已用空间
                                    if(consumer) {
                                        consumer.useSpaceSize = consumer.useSpaceSize - it.fileSize;
                                    }
                                    it.delete();
                                }
                            }
                            category.delete();
                        }
                    }

                    result.success = true;
                }
            }
            if(consumer) {
                result.useSize = consumer.useSpaceSize;
                consumer.save();
            }
            result.ids = ids;
        }
        return render(result as JSON)
    }

    /**
     * 递归删除子分类以及文件
     * @param category
     */
    private void deleteAllUserCategory(UserCategory category, String reset, Consumer consumer) {
        List<UserCategory> categoryList = UserCategory.findAllByFatherCategoryAndConsumer(category, session.consumer);
        List<UserFile> fileList = UserFile.findAllByUserCategoryAndConsumer(category, session.consumer);
        fileList.each { UserFile userFile ->
            if (reset) {
                userFile.state = 0;
                userFile.save(flush: true);
            } else {
                if (userFile.state == 0) {
                    userFile.state = 1;
                    userFile.save(flush: true);
                } else if (userFile.state == 1) {
                    if (userFile.userCategory) userFile.userCategory.removeFromUserFiles(userFile);
                    // 更新非超级管理员用户的已用空间
                    if(consumer) {
                        consumer.useSpaceSize = consumer.useSpaceSize - userFile.fileSize;
                    }
                    userFile.delete();
                }
            }
        }
        categoryList.each { UserCategory userCategory ->
            List<UserCategory> categories = UserCategory.findAllByFatherCategoryAndConsumer(userCategory, session.consumer);
            //如果存在子文件夹，递归
            if (categories.size() > 0) {
                deleteAllUserCategory(userCategory, reset, consumer);
            }
            if (reset) {
                userCategory.state = 0;
                userCategory.save(flush: true);
            } else {
                if (userCategory.state == 0) {
                    userCategory.state = 1;
                    userCategory.save(flush: true);
                } else if (userCategory.state == 1) {
                    if (userCategory.userFiles) {
                        userCategory.userFiles.each {
                            // 更新非超级管理员用户的已用空间
                            if(consumer) {
                                consumer.useSpaceSize = consumer.useSpaceSize - it.fileSize;
                            }
                            it.delete();
                        }
                    }
                    userCategory.delete();
                }
            }
            /*if(categories.size()==0){
                if(reset){
                    userCategory.state=0;
                    userCategory.save(flush: true);
                }else{
                    if(userCategory.state==0){
                        userCategory.state=1;
                        userCategory.save(flush: true);
                    }else if(userCategory.state==1){
                        if(userCategory.userFiles){
                            userCategory.userFiles.each {
                                userCategory.removeFromUserFiles(it);
                            }
                        }
                        userCategory.delete();
                    }
                }

            }
 */
        }
    }

    def downloadFile() {
        def id = params.id;
        UserFile userFile = UserFile.get(id as Long);
        //下载数量++
        userFile.downloadNum++;
        userFile.save(flush: true);

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

    def sharingFile() {
        def result = [:];
        def idList = params.idList;
        def canPublic = params.canPublic;
        List<Integer> ids = new ArrayList<Integer>();
        if (idList.indexOf(",")) {
            String[] strings = idList.split(",");
            strings.each {
                ids.add(it as int);
            }
        } else {
            ids.add(idList as int);
        }
        if (ids.size() > 0) {
            ids.each {
                UserFile userFile = UserFile.get(it);
                if (canPublic == "true") {
                    userFile.canPublic = true;
                    result.msg = "共享成功!";
                } else if (canPublic == "false") {
                    userFile.canPublic = false;
                    result.msg = "已取消共享!";
                }
                userFile.save(flush: true);
            }
            result.success = true;
        }
        return render(result as JSON)
    }

    def updateUserFile() {
        def result = [:];
        def id = params.id;
        def name = params.name;
        if (id && name) {
            UserFile userFile = UserFile.get(id as Long);
            if (userFile) {
                userFile.name = name;
                userFile.save(flush: true);
                result.success = true;
                result.userFile = userFile;
            }
        }
        return render(result as JSON)
    }

    def updateCategory() {
        def result = [:];
        def id = params.id;
        def name = params.name;
        if (id && name) {
            UserCategory userCategory = UserCategory.get(id as Long);
            if (userCategory) {
                userCategory.name = name;
                userCategory.save(flush: true);
                result.success = true;
                result.userCategory = userCategory;
            }
        }
        return render(result as JSON)
    }

    def userCategoryList() {
        List<UserCategory> categoryList = [];
        if (params.parentId) {
            UserCategory father = UserCategory.get(params.parentId as Long);
            categoryList = UserCategory.findAllByFatherCategoryAndConsumerAndState(father, session.consumer, 0);
        } else {
            categoryList = UserCategory.findAllByFatherCategoryAndConsumerAndState(null, session.consumer, 0);
        }
        List<UserCategory> categories = [];
        categoryList.each {
            def tmp = [:];
            tmp.id = it.id;
            tmp.name = it.name;
            tmp.isParent = UserCategory.countByFatherCategory(it);
            if (categoryList) {
                tmp.fatherCategory = it.fatherCategory;
            }
            categories.add(tmp);
        }
        return render(categories as JSON)
    }

    def queryAllUserFile() {
        def result = [];
        def parentId = params.parentId;
        def fileId = params.fileId;
        Consumer consumer = session.consumer;
        if(consumer && consumer.name != 'anonymity') {
            UserFile userFile1 = null;
            if (fileId) userFile1 = UserFile.get(fileId as Long);
            UserCategory fatherCategory;
            if (parentId) fatherCategory = UserCategory.get(parentId as Long);
            List<UserFile> userFileList = UserFile.createCriteria().list(order: 'desc', sort: 'createdDate') {
                eq('state', 0)
                eq('consumer', consumer)
                if (fatherCategory) {
                    eq("userCategory", fatherCategory)
                } else {
                    isNull('userCategory')
                }
            }
            List<UserFile> fileList = [];
            if (userFile1) {
                def tmp = [:];
                tmp.filePath = "${playUserFileLink(fileHash: userFile1.fileHash)}";
                tmp.desc = userFile1.description
                tmp.name = userFile1.name;
                result.add(tmp)
            }
            userFileList?.each { UserFile userFile ->
                def tmp = [:];
                if (FileType.isImage(userFile.filePath)) {
                    if (userFile.id != userFile1?.id) {
                        tmp.filePath = "${playUserFileLink(fileHash: userFile.fileHash)}";
                        tmp.desc = userFile.description
                        tmp.name = userFile.name;
                        result.add(tmp)
                    }
                }
            }
        }
        return render(result as JSON)
    }
}
