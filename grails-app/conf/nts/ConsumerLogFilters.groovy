package nts

import nts.system.domain.ConsumerLog
import nts.user.domain.Consumer
import nts.utils.CTools

class ConsumerLogFilters {

    def filters = {
        //用户日志记录
        all(controller: '*', action: '*') {
            def uncheckController = [:];        //key为controllerName,value为该controller中不拦截的action
            before = {

                if (!session.consumer) {
                    def name = servletContext.anonymityUserName
                    def password = servletContext.anonymityPassword
                    session.consumer = Consumer.findByNameAndPassword(name, password.toString().encodeAsPassword())
                    /*checkLogin.call(params)*/
                }
                //指定某些日志不记录
                def uncheckAction = uncheckController.get(controllerName);
                if (!(uncheckAction && uncheckAction.contains(actionName))) {
                    def userAgent = request.getHeader("User-Agent");
                    if(userAgent.length() <= 255 || requestRefer.length()<255) {
                        ConsumerLog consumerLog = new ConsumerLog();
                        Consumer consumer = session.consumer;
                        if (consumer) {
                            consumerLog.consumerId = consumer.id;
                            consumerLog.consumerName = consumer.nickname ? consumer.nickname : consumer.name;
                        }
                        consumerLog.ip = CTools.readIpAddr(request);
                        consumerLog.controllerName = controllerName;
                        consumerLog.actionName = actionName;
                        consumerLog.requestMethod = request.getMethod();
                        consumerLog.requestReferer = request.getHeader("Referer");
                        consumerLog.requestContentType = request.getContentType();
                        consumerLog.requestUrl = request.getRequestURL();
                        consumerLog.ajaxRequest = "XMLHttpRequest".equals(request.getHeader("X-Requested-With")) ? true : false;
                        consumerLog.userAgent = request.getHeader("User-Agent");
                        request.setAttribute("consumerLog", consumerLog);
                    }
                }
                return true;
            }
            after = { Map model ->
                ConsumerLog consumerLog = request.getAttribute("consumerLog");
                if (consumerLog) {
                    consumerLog.responseData = model ? model.keySet().toString() : null;
                }
                return true;
            }
            afterView = { Exception e ->
                ConsumerLog consumerLog = request.getAttribute("consumerLog");
                if (consumerLog) {
                    consumerLog.statusCode = response.getStatus();
                    consumerLog.responseContentType = response.getContentType();
                    consumerLog.responseTime = new Date().getTime() - consumerLog.dateCreated.getTime();
                    consumerLog.responseView = null;
                }
                //防止出现异常时不保存日志，所以写在afterView，flush:true
                if (consumerLog.validate()) {
                    try {
                        consumerLog.save(flush: true);
                    } catch (Exception e1) {
                        log.error(e1.getMessage());
                    }

                }
                return true;
            }
        }
    }
}
