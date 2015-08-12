package nts.listener.services

import grails.transaction.Transactional
import nts.user.domain.Consumer

import javax.servlet.http.HttpSessionBindingEvent
import javax.servlet.http.HttpSessionEvent

@Transactional
class ConsumerListenerService {
//    public static HashSet onlineSet = new HashSet();
    private static HashMap<String,Consumer> loginUserMap = new HashMap<String,Consumer>();
    public static HashSet loginUserSet = new HashSet();
    public static HashSet loginTeacherSet = new HashSet();
    public static HashSet loginStudentSet = new HashSet();

    void sessionCreated(HttpSessionEvent httpSessionEvent) {
//        def servletContext = httpSessionEvent.getSession().getServletContext();
//        onlineSet.add(httpSessionEvent.getSession().getId());
//        servletContext.setAttribute("onlineNum", onlineSet.size());
    }

    void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
        def servletContext = httpSessionEvent.getSession().getServletContext();
//        onlineSet.remove(httpSessionEvent.getSession().getId());
        Consumer consumer = loginUserMap.get(httpSessionEvent.getSession().getId());
        if(consumer){
            loginUserSet.remove(consumer);
            if(consumer.role == Consumer.TEACHER_ROLE) {
                loginTeacherSet.remove(consumer);
            } else if(consumer.role == Consumer.STUDENT_ROLE) {
                loginStudentSet.remove(consumer);
            }
        }
        HashSet onlineUserSet = (HashSet)servletContext.getAttribute("onlineUserSet");
        HashMap onlineUserMap = (HashMap)servletContext.getAttribute("onlineUserMap");
        if(onlineUserSet && onlineUserMap){
            String key = onlineUserMap.get(httpSessionEvent.getSession().getId());
            if(key){
                onlineUserSet.remove(key);
            }
            onlineUserMap.remove(httpSessionEvent.getSession().getId());
            servletContext.setAttribute("onlineNum", onlineUserSet.size());
        }

//        servletContext.setAttribute("onlineNum", onlineSet.size());
        servletContext.setAttribute("loginUserNum", loginUserSet.size());
        servletContext.setAttribute("onlineTeacherNum", loginTeacherSet.size());
        servletContext.setAttribute("onlineStudentNum", loginStudentSet.size());
    }

    void attributeAdded(HttpSessionBindingEvent httpSessionBindingEvent) {
        if("consumer".equals(httpSessionBindingEvent.getName())){
            if(httpSessionBindingEvent.getValue()!=null){
                def servletContext = httpSessionBindingEvent.getSession().getServletContext();
                if(httpSessionBindingEvent.getSession().getAttribute("consumer")){
                    Consumer consumer = (Consumer)httpSessionBindingEvent.getSession().getAttribute("consumer");
                    if(loginUserMap.containsKey(httpSessionBindingEvent.getSession().getId())){
                        Consumer consumerOld = loginUserMap.get(httpSessionBindingEvent.getSession().getId());
                        if(consumerOld){
                            loginUserSet.remove(consumerOld);
                            if(consumerOld.role == consumerOld.TEACHER_ROLE) {
                                loginTeacherSet.remove(consumerOld);
                            } else if(consumerOld.role == consumerOld.STUDENT_ROLE) {
                                loginStudentSet.remove(consumerOld);
                            }
                        }
                    }
                    loginUserMap.put(httpSessionBindingEvent.getSession().getId(),consumer);
                    loginUserSet.add(consumer);
                    if(consumer.role == Consumer.TEACHER_ROLE) {
                        loginTeacherSet.add(consumer);
                    } else if(consumer.role == Consumer.STUDENT_ROLE) {
                        loginStudentSet.add(consumer);
                    }
                }
                servletContext.setAttribute("loginUserNum", loginUserSet.size());
                servletContext.setAttribute("onlineTeacherNum", loginTeacherSet.size());
                servletContext.setAttribute("onlineStudentNum", loginStudentSet.size());
            }
        }
    }

    void attributeRemoved(HttpSessionBindingEvent httpSessionBindingEvent) {
        if("consumer".equals(httpSessionBindingEvent.getName())){
            sessionDestroyed(httpSessionBindingEvent);
        }
    }

    void attributeReplaced(HttpSessionBindingEvent httpSessionBindingEvent) {
        if("consumer".equals(httpSessionBindingEvent.getName())){
            attributeAdded(httpSessionBindingEvent);
        }
    }
}
