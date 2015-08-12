package mooc.course.services

import com.boful.mooc.app.course.ICourseQuery
import com.boful.nts.utils.SystemConfig
import org.springframework.remoting.rmi.RmiProxyFactoryBean

class CourseAppService {
    public static ICourseQuery courseQuery = null;
    public initRMIFactory(){
        def mooc = SystemConfig.getMoocAddressAndPort();
        String moocAddress = mooc.ip;
        String moocPort = "9001";
        RmiProxyFactoryBean factoryBean = new RmiProxyFactoryBean();
        try{
            String rmiURL = "rmi://"+moocAddress+":"+moocPort+"/courseQuery";
            factoryBean.setServiceInterface(ICourseQuery.class);
            factoryBean.setServiceUrl(rmiURL);
            factoryBean.afterPropertiesSet();
            courseQuery =  (ICourseQuery)factoryBean.getObject();
            log.info("rmi 启动完成........")
        }catch (e){
            log.error("mooc rmi 未连接！");
        }
    }

    public Map queryCourseList(Map params){
        Map<String,String> courseMap = new HashMap<String,String>();
        if(courseQuery){
            String categoryId = params.categoryId;
            int offset = params.offset as int;
            int max = params.max as int;
            String sort = params.sort;
            String order = params.order;
            try{
                courseMap = courseQuery.queryCourseListByCondition(categoryId,offset,max,sort,order);
            }catch(Exception e){
                log.error(e.message);
            }

        }
        return courseMap;
    }

    public Map queryCategoryList(){
        Map<String,String> categoryMap = new HashMap<String,String>();
        if(courseQuery){
           categoryMap = courseQuery.queryFatherCategoryList();
        }
        return categoryMap;
    }

    public Map queryCategoryById(String id){
        Map<String,String> categoryMap = new HashMap<String,String>();
        if(courseQuery){
            categoryMap = courseQuery.queryCategoryById(id);
        }
        return categoryMap;
    }

}
