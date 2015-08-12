package nts.system.domain
/**
 * Created by xuzhuo on 14-5-24.
 * 用户操作日志
 */
class ConsumerLog {
    String id;
    Long consumerId;                                //操作用户id
    String consumerName;                            //操作用户名
    String ip;                                      //用户ip
    String controllerName;                          //用户访问contorller
    String actionName;                              //用户访问action
    Integer statusCode;                              //返回状态码
    Date dateCreated = new Date();                   //请求时间
    String requestMethod;                           //请求方式POST，GET
    String requestReferer;                          //请求链接来源
    String requestUrl;                              //请求url
    String requestContentType;                      //请求类型
    Boolean ajaxRequest;                            //是否ajax请求
    String userAgent;                                //用户浏览器，操作系统等信息
    String responseView;                            //响应页面
    String responseContentType;                      //响应类型
    Long responseTime;                              //响应时间
    String responseData;                            //响应返回数据

    static constraints = {
        consumerId(nullable: true);
        consumerName(nullable: true);
        ip(nullable: true);
        controllerName(nullable: true);
        actionName(nullable: true);
        statusCode(nullable: true);
        dateCreated(nullable: true);
        requestMethod(nullable: true);
        requestUrl(nullable: true);
        requestReferer(nullable: true);
        requestContentType(nullable: true);
        ajaxRequest(nullable: true);
        userAgent(nullable: true);
        responseView(nullable: true);
        responseContentType(nullable: true);
        responseTime(nullable: true);
        responseData(nullable: true, maxSize: 10000);
    }
    static mapping = {
        id(generator: "uuid")
    }
}
