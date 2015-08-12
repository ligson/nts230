package nts.program.services

import nts.system.domain.RMSCategory
import nts.utils.CTools

class RMSCategoryService {
    public Map RMSCategoryList(Map params){
        def result=[:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'

        def categoryList = RMSCategory.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            eq("state", true)
            eq("type", 0)
            eq("parentid", 0)
        }
        result.categoryList=categoryList;
        return result;
    }

    public Map editRMSCategory(Map params,RMSCategory RMSCategoryInstance){
        def result=[:];
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        def type = CTools.nullToZero(params?.type) //类型 0-公共 1-学习圈 2-学习社区
        def categoryList = RMSCategory.createCriteria().list(sort: params.sort, order: params.order) {
            eq("state", true)
            eq("type", type)
            eq("parentid", 0)
            ne("name", RMSCategoryInstance.name)
        }
        result.categoryList=categoryList;
        return result;
    }

    public Map searchRMSCategory(Map params){
        def result=[:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'

        def type = CTools.nullToZero(params?.type) //类型 0-公共 1-学习圈 2-学习社区
        def level = CTools.nullToZero(params?.level) //分类级别 1-一级类别  2-二级类别
        def searchName = CTools.nullToBlank(params?.schName) //类别名称

        def categoryList = RMSCategory.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            eq("state", true)
            eq("type", type)
            if (level == 1) {
                eq("parentid", 0)
            } else if (level == 2) {
                ne("parentid", 0)
            }
            if (searchName != '') {
                like("name", "%${searchName}%")
            }
        }
        result.categoryList=categoryList;
        return result;
    }

}
