package nts.activity.services

import com.boful.nts.service.model.RMSNode
import grails.converters.JSON
import grails.transaction.Transactional
import nts.activity.domain.UserActivity
import nts.activity.domain.UserVote
import nts.activity.domain.UserWork
import nts.commity.domain.StudyCommunity
import nts.program.domain.Program
import nts.program.domain.Serial
import nts.system.domain.RMSCategory
import nts.system.services.UtilService
import nts.user.domain.Consumer
import nts.utils.CTools
import org.apache.http.NameValuePair
import org.apache.http.client.HttpClient
import org.apache.http.client.entity.UrlEncodedFormEntity
import org.apache.http.client.methods.CloseableHttpResponse
import org.apache.http.client.methods.HttpPost
import org.apache.http.impl.client.HttpClients
import org.apache.http.message.BasicNameValuePair
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONElement
import org.springframework.web.multipart.commons.CommonsMultipartFile

/**
 * 活动
 */
@Transactional
class UserActivityService {
    def utilService;
    def appService
    def serverNodeService

    /**
     * 系统活动管理显示
     * @param params
     *      sord:排序（非必须，默认升续）
     *      page:显示第几页(非必须，默认1)
     *      sidx:排序依据（非必须，默认id）
     *      name：标题，用于搜索（非必须，默认搜索全部）
     *      approval：审批状态，用于搜索（非必须，默认全部）
     * @return
     * result集合参数
     *        page：页面
     *        records：查询总数，用于分页
     *        userActivityList：查询返回结果集
     */
    public Map userActivityList(Map params) {
        def result = [:];
        def max = 10;           //查询数量
        if (params.max) {
            max = params.max = 10;
        }
        def page = 1;           //页面数
        def offset = 0;         //偏移量
        if (params.page) {
            page = params.page as int;
            offset = (page - 1) * max;
        }
        def sort = 'id';        //排序依据
        if (params.sidx) {
            sort = params.sidx;
        }
        def order = 'asc';      //排序方法
        if (params.sord) {
            order = params.sord;
        }
        def name = null;        //标题，用于搜索
        if (params.name) {
            name = params.name.toString().decodeURL();
        }
        def approval = null;    //审批状态，用于搜索
        if (params.approval) {
            approval = params.approval as int;
        }
        //查询userActivity集合
        def userActivityList = UserActivity.createCriteria().list(max: max, offset: offset, sort: sort, order: order) {
            if (name) {
                like("name", "%" + name + "%")
            }
            if (approval) {
                eq("approval", approval)
            }
        };
        result.page = params.page;      //返回页面数
        def total = userActivityList.totalCount;    //查询总数，用于分页，相当于没有max查询
        result.records = total;                     //返回页面数，用于分页
        result.total = Math.ceil(total * 1.00 / max);//总共分页显示页面数计算
        result.userActivityList = userActivityList;
        return result;
    }
    /**
     * userActivity删除
     * @param params
     *      userActivityId：userActivity的ID，可以是依据“，”分割的字符串，用于批量删除
     * @return
     * result，参数
     *          message：删除删除信息
     *          success:删除是否成功
     *          errorId:删除失败的Id值
     */
    public Map userActivityDelete(Map params) {
        def result = [:];
        result.message = null;
        result.success = false;
        result.errorId = null;
        try {
            def userActivityId = params.userActivityId;
            List<String> ids = new ArrayList<String>();
            //判断是否批量删除
            if (userActivityId.contains(',')) {
                String[] str = userActivityId.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(userActivityId)
            }
            //删除数据
            for (String id : ids) {
                result.errorId = id;
                UserActivity userActivity = UserActivity.get(Integer.parseInt(id));
                userActivity.delete();
            }
            result.success = true;
            result.message = "删除成功！！";
            result.errorId = null;
        } catch (Exception e) {
            //对于数据查询，删除异常catch
            log.error(e.message, e);
            result.success = false;
            if (result.errorId) {
                result.success = true;
                result.message = "ID " + result.errorId + "删除失败！！";
            } else {
                result.message = "数据提交错误！！";
            }
        }
        return result;
    }
    /**
     * 修改活动状态
     * @param params
     *      userActivityId:userActivity的id
     *      changeOpen：是否开启活动，true开启，false反之
     * @return
     * result参数
     *          success：是否修改成功
     *          userActivityOpen：修改后，活动状态
     */
    public Map userActivityOpenChange(Map params) {
        def result = [:];
        result.success = false;
        def userActivityId = params.userActivityId;
        List<String> ids = new ArrayList<String>();
        try {
            if (userActivityId.contains(',')) {
                String[] str = userActivityId.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(userActivityId)
            }
            for (String id : ids) {
                UserActivity userActivity = UserActivity.get(Integer.parseInt(id));
                if (params.changeOpen == "true") {
                    userActivity.isOpen = true;
                } else {
                    userActivity.isOpen = false;
                }
                userActivity.save();
            }
            result.success = true;
            if (params.changeOpen == "true") {
                result.userActivityOpen = true;
            } else {
                result.userActivityOpen = false;
            }

        } catch (Exception e) {
            //对于数据查询，修改异常catch
            log.error(e.message, e);
            result.success = false;
            result.message = "对不起数据提交错误！！！";
        }
        return result;
    }
    /**
     * 修改活动审批状态
     * @param params
     *      userActivityId：userActivity的id，可以是以“,”分割的字符串，用于批量删除
     *      approval：是否审批通过，true通过审批，false反之
     * @return
     * result参数
     *          success：修改是否成功
     *          message：修改出错报异常时，反馈信息
     */
    public Map userActivityApproval(Map params) {
        def result = [:];
        result.success = false;
        def userActivityId = params.userActivityId;
        List<String> ids = new ArrayList<String>();
        try {
            //判断是否批量删除，分割字符串
            if (userActivityId.contains(',')) {
                String[] str = userActivityId.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(userActivityId)
            }
            for (String id : ids) {
                UserActivity userActivity = UserActivity.get(Integer.parseInt(id));
                //判断要修改的UserActivity 状态，只修改未审批UserActivity，修改后不可逆
                if (userActivity.approval == 2) {
                    //判断审批，修改状态
                    if (params.approval == 'true') {
                        userActivity.approval = 3;
                    } else {
                        userActivity.approval = 1;
                    }
                }
                userActivity.save();
            }
            result.success = true;
        } catch (Exception e) {
            //对于数据查询，修改异常catch
            log.error(e.message, e);
            result.success = false;
            result.message = "对不起数据提交错误！！！";
        }
        return result;
    }
    /**
     * 查询打开系统活动创建页面时，查询活动一二级分类
     * @return
     * rmsCategoryList1：一级查询
     *      rmsCategoryList2：一级查询下的二级分类查询
     */
    public Map userActivityCreate() {
        def result = [:];
        //查询一级分类，属于公共和活动，状态为使用中
        def rmsCategoryList1 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {
            'in'("type", [0, 3])
            eq("parentid", 0)
            eq("state", true)
        }
        def rmsCategoryList2 = null;
        //查询一级查询下的二级分类查询，属于公共和活动，状态为使用中
        if (rmsCategoryList1) {
            rmsCategoryList2 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {
                'in'("type", [0, 3])
                eq("parentid", rmsCategoryList1[0].id.toInteger())
                eq("state", true)
            }
        }

        result.rmsCategoryList1 = rmsCategoryList1;
        result.rmsCategoryList2 = rmsCategoryList2;
        return result;
    }
    /**
     * 依据前台一级分类 查询RMSCategory二级菜单
     * @param params
     *      category1   ：一级分类id
     *      category_type：分类类别
     * @return
     * result参数
     *          categoryList：查询的分类结果
     */
    public Map rmsCategoryList2(Map params) {
        def result = [:];
        def category1 = params.category1            //一级分类id
        if (category1 != null) {
            category1 = category1.toInteger();
        }
        //用于活动创建时显示分类 为了别人的前台不用做修改，只有在创建活动时才传category_type=3
        def category_type = Integer.parseInt(params.category_type ? params.category_type as String : "3")
        //查询二级分类，状态是使用中，类别为公共，和活动类别，parentid为传入一级分类id
        def categoryList = RMSCategory.createCriteria().list() {
            eq("state", true)
            or {
                eq("type", 0)
                eq("type", 3)
            }
            eq("parentid", category1)
        }
        result.categoryList = categoryList;
        return result;
    }
    /**
     * userActivity保存
     * @param params
     *      rmsCategoryId：userActivity所属分类（必须）
     *      description：userActivity描述（必须）
     *      userActivityId：UserActivity的id，隐藏域，用于判断save还是update（非必须，存在update，不存在save）
     *      name:活动标题(必须)
     *      shortName：简称（必须）
     *      photo：缩略图（必须）
     *      startTime：活动开始时间（必须，且不能小于当天）
     *      endTime：活动结束时间（必须，且不能小于开始时间）
     * @return
     * result参数
     *          success：save或者update 是否成功
     *          userActivity：save或者update失败后返回要操作的对象
     */
    public Map userActivitySave(Map params) {
        def result = [:];
        def rmsCategory = RMSCategory.get(params.categoryId)     //活动分类
        def session = utilService.getSession();
        result.success = false;
        result.saveOrUpdate = null;
        if (!params.description) {
            params.description = "未填写";
        }
        UserActivity userActivity = null;
        try {
            //判断save还是update，userActivityId为前台隐藏标签，save时没值
            if (params.userActivityId) {
                userActivity = UserActivity.get(params.userActivityId);//update时，查询对象
//                userActivity.approval = 2;                  //如果是修改活动，审批状态变为默认待审批
//                userActivity.isOpen = false;                //如果是修改，开启状态为  默认不开启
                result.saveOrUpdate = "update";
            } else {
                result.saveOrUpdate = "save";
                userActivity = new UserActivity();          //save是，创建新对象
                userActivity.approval = 3;
                userActivity.isOpen = true;
            }
            def uploadResult = [:];
            uploadResult = uploadImg(result.saveOrUpdate, userActivity.photo);
            def imgPath = uploadResult.imgPath;
            if (!imgPath) {
                imgPath = "default.jpg";
            }
            if (uploadResult.success) {
                result.message = uploadResult.message;
            }
            def name = CTools.htmlToBlank(params.name);
            def shortName = CTools.htmlToBlank(params.shortName);
            def description = CTools.htmlToBlank(params.description);
            userActivity.name = name;                //活动标题
            userActivity.shortName = shortName;      //简称
            userActivity.photo = imgPath;              //缩略图
            userActivity.description = description;  //userActivity描述
            userActivity.startTime = params.startTime;      //活动开始时间
            userActivity.endTime = params.endTime;          //活动结束时间
            userActivity.activityCategory = rmsCategory;    //userActivity所属分类
            userActivity.consumer = session.consumer;       //活动发起者
            userActivity.save(flush: true);
            result.success = true;
        } catch (Exception e) {
            //对于数据查询，修改异常catch
            log.error(e.message, e);
            result.success = false;
            result.userActivity = userActivity;
        }
        return result;
    }
    /**
     * 修改系统过的页面时给页面返回数据
     * @param params
     *      userActivityId：要修改的活动id
     * @return
     * result参数
     *          success：是否修改成功
     *          rmsCategoryList1：查询一级分类结果
     *          rmsCategoryList2：查询一级分类所属二级分类结果
     *          userActivity：要修改的用户
     *          massage：查询失败返回信息
     */
    public Map userActivityEdit(Map params) {
        def result = [:];
        def userActivityId = params.userActivityId;
        result.success = false;
        try {
            UserActivity userActivity = UserActivity.get(userActivityId);
            def rmsCategoryList1 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {            //查询一级类别
                'in'("type", [0, 3])
                eq("parentid", 0)
                eq("state", true)
            }
            def rmsCategoryList2 = null
            if (rmsCategoryList1 != null && rmsCategoryList1 != []) {
                rmsCategoryList2 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {
                    //查询与userActivity同一父类的节点
                    'in'("type", [0, 3])
                    eq("parentid", userActivity.activityCategory.parentid.toInteger())
                    eq("state", true)
                }
            }

            result.rmsCategoryList1 = rmsCategoryList1;
            result.rmsCategoryList2 = rmsCategoryList2;
            result.userActivity = userActivity;
            result.success = true;
        } catch (Exception e) {
            //对于数据查询，修改异常catch
            log.error(e.message, e);
            result.success = false;
            result.massage = "参数错误！！！";
        }
        return result;

    }
    /**
     * 活动分类节点数据
     * @param params
     *      parentid：父节点id（非必须，默认0，一级分类）
     *      max：最大查询条数（非必须，默认10）
     *      page：第几页（非必须，默认0）
     *      sidx：排序依据（非必须，默认id排序）
     *      name：节点名称，用户搜索（非必须，默认全部查询）
     *      sord：排序方法（非必须，默认升序）
     * @return
     * result参数
     *          success：查询是否成功
     *          rmsCategoryList：查询分类集合
     *          page:第几页，用于分页
     *          records：总共数量
     *          total：查询数据总共页数
     */
    public Map userActivityCategoryList(Map params) {
        def result = [:];
        def parentid = 0;       //父节点id
        result.success = false;
        if (params.parentid) {
            parentid = params.parentid;
        }
        def max = 10;       //查询最大值
        if (params.max) {
            max = params.max = 10;
        }
        def page = 1;       //访问页面数，用户查询数据，查询偏移
        def offset = 0;     //查询时，偏移量
        if (params.page) {
            page = params.page as int;
            offset = (page - 1) * max;      //计算偏移量
        }
        def sort = 'id';        //排序依据
        if (params.sidx) {
            sort = params.sidx;
        }
        def name = null;        //查询name
        if (params.name) {
            name = params.name.toString().decodeURL();
        }
        def order = 'asc';      //排序方式
        if (params.sord) {
            order = params.sord;
        }
        try {
            //查询分类，默认属于公开，和活动，状态为正常使用
            def rmsCategoryList = RMSCategory.createCriteria().list(max: max, offset: offset, sort: sort, order: order) {
                'in'("type", [3])
                //暂时只有两级分类，如果传递parentid为0,则为一级分类，为1为一级分类，暂时为只有二级分类，其他值未查询一级
                if (parentid == "0") {
                    eq("parentid", 0)
                }
                if (parentid == 0) {
                    eq("parentid", 0)
                }
                if (parentid == "1") {
                    notEqual("parentid", 0)
                }
                //eq("state", true)
                //搜索
                if (name) {
                    like("name", "%" + name + "%")
                }
            }
            result.rmsCategoryList = rmsCategoryList;
            result.page = params.page;
            def total = rmsCategoryList.totalCount;
            result.records = total;
            result.total = Math.ceil(total * 1.00 / max);
            result.success = true;
        } catch (Exception e) {
            //对于数据查询，修改异常catch
            result.success = false;
            log.error(e.message, e);
        }
        return result;
    }
    /**
     *  删除活动分类
     * @param params
     *      rmsCategoryId：活动分类id，可以是已“，”分隔的字符串
     * @return
     * result参数
     *        message：删除返回消息
     *        success：删除成功与否
     *        errorId：删除失败Id值
     */
    public Map rmsCategoryDelete(Map params) {
        def result = [:];
        result.message = null;
        result.success = false;
        result.errorId = null;
        try {
            def rmsCategoryId = params.rmsCategoryId;
            List<String> ids = new ArrayList<String>();
            //判断是否批量删除，分隔字符串
            if (rmsCategoryId.contains(',')) {
                String[] str = rmsCategoryId.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(rmsCategoryId)
            }
            //循环删除分类
            for (String id : ids) {
                result.errorId = id;
                RMSCategory rmsCategory = RMSCategory.get(Integer.parseInt(id));
                if (!rmsCategory) {
                    result.message = "ID " + id + "删除失败，提交id不存在";
                    break;              //循环结束
                }
                //不能删除一级节点,只能删除类别为公共和活动的节点
                if (rmsCategory && rmsCategory.parentid != 0 && (rmsCategory.type == 0 || rmsCategory.type == 3)) {
                    //查询分类下所有系统活动id
                    def userActivityIds = UserActivity.executeQuery("select id from UserActivity where activityCategory.id = ?", rmsCategory.id);
                    //查询活动下所有作品id
                    if (userActivityIds) {
                        def userWorkIds = UserWork.executeQuery("select id from UserWork where userActivity.id in (:userActivityIds)", [userActivityIds: userActivityIds]);
                        //依据作品id，删除所有投票
                        if (userWorkIds) {
                            UserVote.executeUpdate("delete UserVote where userWork.id in (:userWorkIds)", [userWorkIds: userWorkIds])
                            //删除所有作品
                            UserWork.executeUpdate("delete UserWork where id in (:userWorkIds)", [userWorkIds: userWorkIds]);
                        }
                        //删除所有活动
                        UserActivity.executeUpdate("delete UserActivity  where id in (:userActivityIds)", [userActivityIds: userActivityIds])
                    }
                    //删除该分类
                    rmsCategory.delete();
                    result.success = true;
                    result.message = "删除成功！！";
                    result.errorId = null
                }
                //一级节点删除
                if (rmsCategory && rmsCategory.parentid == 0 && (rmsCategory.type == 0 || rmsCategory.type == 3)) {
                    //查询一级节点下是否有二级节点
                    def rmsCategoryChildIds = RMSCategory.executeQuery("select id from RMSCategory where parentid=?", rmsCategory.id.intValue());
                    if (rmsCategoryChildIds) {
                        result.message = "ID " + id + "节点下存在子节点，请先删除其子节点！！";
                        break;          //跳出循环
                    } else {
                        rmsCategory.delete();
                        result.success = true;
                        result.message = "删除成功！！";
                        result.errorId = null
                    }
                }
            }
        } catch (Exception e) {
            log.error(e.message, e);
            result.success = false;
            if (result.errorId) {
                result.success = true;
                result.message = "ID " + result.errorId + "删除失败！！";
            } else {
                result.message = "数据提交错误！！";
            }

        }
        return result;
    }
    /**
     * 创建节点时显示父节点
     * @return
     * result参数:
     *          rmsCategoryParentList：创建分类的时候返回的一级分类
     */
    public Map rmsCategoryCreate() {
        def result = [:];
        def rmsCategoryParentList = RMSCategory.createCriteria().list(order: 'dateCreated', sort: 'id') {
            'in'("type", [3])
            eq("state", true)
            eq("parentid", 0)
        }
        result.rmsCategoryParentList = rmsCategoryParentList;
        return result;
    }
    /**
     * 分类saveOrUpdate，如果是update的一级几点，会修改起子节点的parentName
     * @param params
     *      rmsCategoryId:分类Id，如果存在则为修改，不存在就是新建
     *      parentid：判断分类是一级还是二级节点
     *      name：节点名称
     * @return
     * result参数
     *          success判断是否修改成功
     *          rmsCategory：修改出错后，返回出错的对象
     *          saveOrUpdate:保存是save还是update，用于出错后转跳页面
     */
    public Map rmsCategorySave(Map params) {
        def result = [:];
        RMSCategory rmsCategory = null;
        result.success = false;
        result.saveOrUpdate = null;
        try {
            if (params.rmsCategoryId) {
                rmsCategory = RMSCategory.get(params.rmsCategoryId);
                result.saveOrUpdate = "update";
            } else {
                result.saveOrUpdate = "save";
                rmsCategory = new RMSCategory();
                //如果是子节点需要查询出父节点，并且赋值
                if (params.parentid != "0") {
                    RMSCategory parentRMSCategory = RMSCategory.get(params.parentid);
                    rmsCategory.parentName = parentRMSCategory.name;
                    rmsCategory.parentid = parentRMSCategory.id as int;
                }
            }
            rmsCategory.name = params.name;
            rmsCategory.type = 3;
            //判断是修改，如果是save，则不需要更新子节点中parentName
            if (rmsCategory.id) {
                RMSCategory.executeUpdate("update RMSCategory set parentName = :parentName where parentid = :parentid", [parentName: rmsCategory.name, parentid: rmsCategory.id.intValue()]);
            }
            rmsCategory.save(flush: true);
            result.success = true;
        } catch (Exception e) {
            log.error(e.message, e);
            result.success = false;
            result.rmsCategory = rmsCategory;
        }
        return result;
    }
    /**
     * 分类修改页面转跳
     * @param params
     * @return
     */
    public Map rmsCategoryEdit(Map params) {
        def result = [:];
        def rmsCategoryParentList = RMSCategory.createCriteria().list(order: 'dateCreated', sort: 'id') {
            eq("state", true)
            'in'("type", [3])
            eq("parentid", 0)
        }
        result.rmsCategoryParentList = rmsCategoryParentList;
        RMSCategory rmsCategory = null;
        try {
            rmsCategory = RMSCategory.get(params.rmsCategoryId as int);
            result.rmsCategory = rmsCategory;
            result.success = true;
        } catch (Exception e) {
            log.error(e.message, e);
            result.success = false;
            result.rmsCategory = rmsCategory;
        }
        return result;
    }
    /**
     * 作品管理
     * @param params
     * @return
     */
    public Map userWorkList(Map params) {
        def result = [:];
        result.message = null;
        def max = 10;
        if (params.max) {
            max = params.max = 10;
        }
        def page = 1;
        def offset = 0;
        if (params.page) {
            page = params.page as int;
            offset = (page - 1) * max;
        }
        def sort = 'id';
        if (params.sidx) {
            sort = params.sidx;
        }

        def order = 'desc';
        if (params.sord) {
            order = params.sord;
        }
        def name = null;
        if (params.name) {
            name = params.name.toString().decodeURL();
        }
        def approval = null;
        if (params.approval) {
            approval = params.approval as int;
        }
        def userWorkList = UserWork.createCriteria().list(max: max, offset: offset, sort: sort, order: order) {
            if (name) {
                like("name", "%" + name + "%")
            }
            if (approval) {
                eq("approval", approval)
            }
        };

        result.page = params.page;
        def total = userWorkList.totalCount;
        result.records = total;
        result.total = Math.ceil(total * 1.00 / max);
        result.userWorkList = userWorkList;
        return result;
    }
    /**
     * 作品审批
     * @param params
     * @return
     */
    public Map userWorkApproval(Map params) {
        def result = [:];
        result.success = false;
        def userWorkId = params.userWorkId;
        List<String> ids = new ArrayList<String>();
        try {
            if (userWorkId.contains(',')) {
                String[] str = userWorkId.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(userWorkId)
            }
            for (String id : ids) {
                UserWork userWork = UserWork.get(Integer.parseInt(id));
                if (params.approval == 'true') {
                    if(userWork.transcodeState==Serial.CODED_STATE || userWork.transcodeState == Serial.NO_NEED_STATE) {
                        userWork.approval = 3;
                    } else {
                        result.success = false;
                        result.message = "活动作品" + userWork.name + "还未转码成功, 不能审批!";
                        break;
                    }

                } else {
                    userWork.approval = 1;
                }
                userWork.save();
                result.success = true;
            }
        } catch (Exception e) {
            log.error(e.message, e);
            result.success = false;
            result.message = "对不起数据提交错误！！！";
        }
        return result;
    }
    /**
     * 作品删除
     * @param params
     * @return
     */
    public Map userWorkDelete(Map params) {
        def result = [:];
        result.message = null;
        result.success = false;
        result.errorId = null;
        try {
            def userWorkId = params.userWorkId;
            List<String> ids = new ArrayList<String>();
            if (userWorkId.contains(',')) {
                String[] str = userWorkId.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(userWorkId)
            }
            for (String id : ids) {
                result.errorId = id;
                UserWork userWork = UserWork.get(Integer.parseInt(id));
                def userActivity = userWork.userActivity;
                userActivity.workNum--;
                userWork.delete();
                userActivity.save();
            }
            result.success = true;
            result.message = "删除成功！！";
            result.errorId = null;
        } catch (Exception e) {
            log.error(e.message, e);
            result.success = false;
            if (result.errorId) {
                result.success = true;
                result.message = "ID " + result.errorId + "删除失败！！";
            } else {
                result.message = "数据提交错误！！";
            }

        }
        return result;
    }
    /**
     * 上传图片
     * @param opt
     *      opt：值为save表示添加图片
     *      imgPath:传入的文件路径，update的时候使用
     * @return
     */
    public Map uploadImg(def opt, def imgPath) {
        def result = [:];
        result.success = true;
        def request = utilService.getRequest();
        def servletContext = utilService.getServletContext();
        CommonsMultipartFile imgFile = request.getFile("saveImg");
        if (imgFile) {
            def imgName = imgFile.getOriginalFilename();
            def imgType = imgFile.getContentType();

            def path = servletContext.getRealPath("/upload");

            if (imgFile && !imgFile.isEmpty()) {
                if (imgType == "image/pjpeg" || imgType == "image/jpeg" || imgType == "image/png" || imgType == "image/x-png" || imgType == "image/gif") {
                    if (opt == "save" || imgPath == "default.jpg" || !imgPath) {
                        /*def sc = StudyCommunity.createCriteria()
                        def id = sc.get {
                            projections {
                                max "id"
                            }
                        }*/
                        def id = System.currentTimeMillis();
                        /*id = id == null ? 1 : id + 1*/
                        imgPath = "i_" + id + ".jpg";
                    }
                    File rootFile = new File("${path}/userActivityImg/");
                    if (!rootFile.exists()) {
                        rootFile.mkdirs();
                    }
                    imgFile.transferTo(new java.io.File(rootFile.getAbsolutePath(), imgPath));
                } else {
                    result.success = false;
                    result.message = "上传图片格式不对...";
                }
            }
        }
        result.imgPath = imgPath;
        return result;
    }


    private static int syncUserWorkOffset = 0;

    public void syncUserWorkTranscodeStateJob() {
        if (appService) {
            RMSNode rmsNode = appService.queryNodeInfo();

            try {
                String url = "http://${rmsNode.getBmcIPAddress()}:${rmsNode.bmcWebPort}/bmc/query/queryFileInfo";
                HttpPost httpPost = new HttpPost(url);
                ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
                def userWorkList = UserWork.createCriteria().list(max: 100, offset: syncUserWorkOffset) {
                    notEqual('transcodeState', Serial.CODED_STATE)
                    notEqual('transcodeState', Serial.NO_NEED_STATE)
                    order('id', 'desc')
                };
                syncUserWorkOffset += 100;
                if (syncUserWorkOffset > userWorkList.totalCount) {
                    syncUserWorkOffset = 0;
                }

                def fileHashes = [];
                httpPost = new HttpPost(url);
                params = new ArrayList<NameValuePair>();
                if(userWorkList && userWorkList.size()>0) {
                    for(UserWork userWork : userWorkList){
                        fileHashes.add(userWork.fileHash);
                        params.add(new BasicNameValuePair("hashes", userWork.fileHash));
                    }

                    if (fileHashes.size() > 0) {
                        httpPost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
                        HttpClient httpClient = HttpClients.createDefault();
                        log.debug("访问URL:${url},hashes:${fileHashes}")
                        try {
                            CloseableHttpResponse httpResponse = httpClient.execute(httpPost);
                            String text = httpResponse.getEntity().getContent().getText("UTF-8");
                            JSONElement result = JSON.parse(text);
                            if (result.success) {
                                JSONArray bofulFiles = result.bofuleFiles;
                                if (bofulFiles) {
                                    for (int i = 0; i < bofulFiles.length(); i++) {
                                        def bofulFile = bofulFiles[i];
                                        def fileHash = bofulFile.fileHash;
                                        def state = bofulFile.transcodeState;
                                        userWorkList.each { UserWork work ->
                                            if (work.fileHash == fileHash) {
                                                if (state == Program.STATE_SUCCESS) {
                                                    work.state = Serial.CODED_STATE;
                                                    work.transcodeState = Serial.CODED_STATE;
                                                } else if (state == Program.STATE_FAIL) {
                                                    work.state = Serial.CODED_FAILED_STATE;
                                                    work.transcodeState = Serial.CODED_FAILED_STATE;
                                                } else if (state == Program.STATE_NONE) {
                                                    work.state = Serial.NO_NEED_STATE;
                                                    work.transcodeState = Serial.NO_NEED_STATE;
                                                }
                                                work.save(flush: true);
                                            }
                                        }
                                    }
                                }
                            } else {
                                log.error("查询失败");
                            }
                        } catch (Exception e) {
                            log.error(e.message, e);
                        }
                    }
                }
            } catch (Exception e) {
                log.error(e.message, e);
            }
        }
    }

    /**
     * 判断社区是否禁用
     * @param activityId
     * @return
     */
    public Map checkActivityState(long activityId) {
        def result = [:];
        UserActivity activity = UserActivity.findById(activityId);
        if (activity) {
            if (!activity.isOpen) {
                result.state = false;
                result.msg = "活动 " + activity.name + " 已关闭";
            } else {
                result.state = true;
            }
        } else {
            result.state = false;
            result.msg = "没有对应的活动";
        }
        return result
    }

    /**
     * 我参与的活动列表查询
     * @param params
     * @param id
     * @return
     */
    List<UserActivity> searchMyUserActivity(Map params, Long id) {
        if (!params.max) params.max = '10'
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = '0'
        if (!params.year) params.year = '0'

        def state = params.state
        def name = params.name
        def nowDate = new Date().format("yyyy-MM-dd")
        List<UserActivity> userActivityList = UserWork.createCriteria().list() {
            projections {
                distinct('userActivity')
            }
            eq("consumer", Consumer.get(id))
        }

        def searchList = [];
        if (userActivityList && userActivityList.size() > 0) {
            def userActivityIds = userActivityList.id;
            searchList = UserActivity.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                'in'('id', userActivityIds.toArray())
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
                if (name) {
                    name = name.trim()
                    like('name', "%${name}%")
                }
            }
        }

        if (searchList == null) searchList = []
        return searchList
    }

    /**
     * 我的活动作品列表查询
     * @param params
     * @param id
     * @return
     */
    List<UserActivity> searchMyUserWork(Map params) {
        def consumerId = utilService.getSession().consumer.id;
//        def userActivityId = params.userActivityId;
        if (!params.max) params.max = '10'
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = '0'

        def approval = params.approval
        def name = params.name

        def searchList = UserWork.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            eq("consumer", Consumer.get(consumerId))
            /*userActivity {
                eq('id', userActivityId as long)
            }*/
            if (approval && !"".equals(approval)) {
                eq("approval", approval as int)
            }

            if (name) {
                name = name.trim()
                like('name', "%${name}%")
            }
        }
        if (searchList == null) searchList = []
        return searchList
    }
}
