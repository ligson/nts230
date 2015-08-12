package nts.system.services

import grails.transaction.Transactional
import nts.system.domain.Errors
import nts.system.domain.News
import nts.system.domain.OperationEnum
import nts.system.domain.OperationLog

import java.text.SimpleDateFormat

/**
 * 新闻资讯服务
 */
@Transactional
class NewsService {

    List<News> newsSearch(Map params) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        Date begin_date = null;
        Date end_date = null;
        def searchTitle = params.searchTitle
        def searchPublisher = params.searchPublisher
        def searchm = params.searchm
        def errorState = params.searchState
        def dateBegin                                    //创建开始时间
        def dateEnd                                    //创建结束时间

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'submitTime'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        if (searchm)                            //用户判断用使用的是哪一种时间段查询方式
        {
            dateBegin = params.searchm + ' 00:00:01'
            dateEnd = params.searchm + ' 23:59:59'

            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        }

        def searchList = News.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {

            if (searchTitle) {
                searchTitle = searchTitle.trim()
                like('title', "%${searchTitle}%")
            }
            if (searchPublisher) {
                publisher
                        {
                            searchPublisher = searchPublisher.trim()
                            like('nickname', "%${searchPublisher}%")
                        }
            }
            if (searchm) {
                between("submitTime", begin_date, end_date)
            }

        }
        return searchList
    }

    List<Errors> errorsSearch(Map params) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        java.util.Date begin_date = null;
        java.util.Date end_date = null;
        def searchTitle = params.searchTitle
        def searchContent = params.searchContent
        def searchPublisher = params.searchPublisher
        def searchm = params.searchm
        def dateBegin                                    //创建开始时间
        def dateEnd                                    //创建结束时间
        def errorState = params.searchState                //错误状态

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'submitTime'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        if (searchm)                            //用户判断用使用的是哪一种时间段查询方式
        {
            dateBegin = params.searchm + ' 00:00:01'
            dateEnd = params.searchm + ' 23:59:59'

            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        }
        def searchList = Errors.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {

            if (searchTitle) {
                searchTitle = searchTitle.trim()
                like('errorTitle', "%${searchTitle}%")
            }
            if (searchContent) {
                searchContent = searchContent.trim()
                like('errorContent', "%${searchContent}%")
            }
            if (searchPublisher) {
                publisher
                        {
                            searchPublisher = searchPublisher.trim()
                            like('publisher', "%${searchPublisher}%");
                        }
            }
            if (searchm) {
                between("submitTime", begin_date, end_date)
            }
            if (errorState) {
                eq('errorState', errorState.toInteger())
            }
        }
        return searchList
    }

    List<OperationLog> logSearch(Map params) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        java.util.Date begin_date = null;
        java.util.Date end_date = null;

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        def searchConsumer = params.searchConsumer
        def searchOperation = params.searchOperation
        def beginDate = params.beginDate
        def endDate = params.endDate

        def dateBegin                            //创建开始时间
        def dateEnd                            //创建结束时间

        if (beginDate && !endDate)                            //用户判断用使用的是哪一种时间段查询方式
        {
            dateBegin = params.beginDate + ' 00:00:01'
            dateEnd = params.beginDate + ' 23:59:59'

            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        } else if (beginDate && endDate) {
            dateBegin = params.beginDate + ' 00:00:01'
            dateEnd = params.endDate + ' 23:59:59'
            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        }


        def logList = OperationLog.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            //根据用户名称查询
            if (searchConsumer) {
                searchConsumer = searchConsumer.trim()
                like('operator', "%${searchConsumer}%");
                //eq('operator' , searchConsumer)
            }

            //根据操作类型查询
            if (searchOperation) {
                eq('operation', OperationEnum."${searchOperation}")
            }

            //根据操作日期查询
            if (beginDate) {
                between("dateCreated", begin_date, end_date)
            }

        }

        return logList
    }
    /**
     * 日志删除
     * @param params
     */
    public void deleteOperationLog(params) {
        def deleteIdList = params.idList
        def log
        if (deleteIdList instanceof String) deleteIdList = [params.idList]
        deleteIdList?.each { id ->
            log = OperationLog.get(id)
            if (log) log.delete()
        }
    }
}
