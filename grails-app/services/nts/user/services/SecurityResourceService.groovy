package nts.user.services

import nts.user.domain.Consumer
import nts.user.domain.Role
import nts.user.domain.SecurityResource
import nts.user.domain.UserGroup
import org.codehaus.groovy.grails.commons.GrailsClass

import java.lang.annotation.Annotation
import java.lang.reflect.Method

class SecurityResourceService {
    def grailsApplication

    public static final Map<String,String> controllerNameMap = [:];
    public static final Map<String,String> actionNameMap = [:];
    public static final Map<String,String> patternNameMap = [:];

    public static String getControllerName(String controllerName){
        return controllerNameMap.get(controllerName)
    }
    public static String getActionName(String controllerName, String actionName) {
        return actionNameMap.get(controllerName + "-" + actionName);
    }

    public static String getPatternName(String controllerName,String patternName){
        return patternNameMap.get(controllerName + "-" + patternName);
    }

    public void initResource(){
        GrailsClass[] grailsClasses = grailsApplication.controllerClasses;
        grailsClasses.each {GrailsClass grailsClass ->
            Class controllerClass = grailsClass.getClazz();
            Annotation[] annotations = controllerClass.getDeclaredAnnotations();
            annotations.each {Annotation annotation ->
                if(annotation instanceof ControllerNameAnnotation){
                    ControllerNameAnnotation nameAnnotation=annotation;
                    controllerNameMap.put(grailsClass.getLogicalPropertyName(),nameAnnotation.name());
                }
            }
            Method[] methods = controllerClass.getDeclaredMethods();
            methods.each {Method method ->
               Annotation[] annotations1= method.getDeclaredAnnotations();
                annotations1.each {Annotation annotation ->
                    if( annotation instanceof ActionNameAnnotation){
                        ActionNameAnnotation nameAnnotation = annotation;
                        actionNameMap.put(grailsClass.getLogicalPropertyName()+"-"+method.getName(),nameAnnotation.name());
                    }
                    if(annotation instanceof PatternNameAnnotation){
                        PatternNameAnnotation patternNameAnnotation = annotation;
                        patternNameMap.put(grailsClass.getLogicalPropertyName()+"-"+method.getName(),patternNameAnnotation.name());
                    }
                }
            }
        }
        initSecurityResource();
    }

    //初始化数据库资源
    private static void initSecurityResource(){
        actionNameMap.each {String key,String value ->
            String[] names=key.split("-");
            String controllerName=names[0];
            String actionName=names[1];
            SecurityResource securityResource = SecurityResource.findByControllerEnNameAndActionEnName(controllerName,actionName);

            if(!securityResource){
                securityResource=new SecurityResource();
            }
            if(patternNameMap.containsKey(key)){
                String patterName = (key.split('-'))[1];
                SecurityResource resource = SecurityResource.findByControllerEnNameAndPatternEnName(controllerName,patterName);
                if(!resource){
                    securityResource.patternEnName =patterName;
                    securityResource.patternName = getPatternName(controllerName,patterName);
                }
            }
            securityResource.controllerEnName=controllerName;
            securityResource.actionEnName=actionName;
            securityResource.controllerName = getControllerName(controllerName);
            securityResource.actionName = getActionName(controllerName,actionName);
            securityResource.save(flush: true);
        }

    }

    //根据用户角色，查找对应的功能权限
    public Map getUserSecurityResources(Consumer consumer){
        def userSecurityResources = [:]
        def List<Role> roles = []
        def userRole = consumer.userRole //当前登陆用户的角色
        if(userRole){
            roles.add(userRole)
            //如果角色下有子角色
            def childrenRole = Role.findAllByParentRole(userRole)
            if(childrenRole.size() > 0){
                roles.addAll(childrenRole)
            }
        }

        //查当前登录用户所在的用户组的角色
        def userGroups = consumer.userGroups
        userGroups?.each {
            if(it.role){
                roles.add(it.role)
                //如果角色下有子角色
                def childrenRole = Role.findAllByParentRole(it.role)
                if(childrenRole.size() > 0){
                    roles.addAll(childrenRole)
                }
            }
        }

        roles.unique()

        //合并用户角色和用户所在用户组角色的所有功能权限
        def securityResources = []
        roles.each {
            securityResources.addAll(it.resources)
        }

        securityResources.unique()

        if(securityResources.size() > 0){
            securityResources.each {
                userSecurityResources.put((it.actionEnName+'-'+it.controllerEnName), it.controllerEnName)
            }
        }
        return userSecurityResources
    }
}
