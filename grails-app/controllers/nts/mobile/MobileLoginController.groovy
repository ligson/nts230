package nts.mobile

import grails.converters.JSON
import nts.program.category.domain.ProgramCategory
import nts.program.domain.PlayedProgram
import nts.program.domain.Program
import nts.system.domain.OperationEnum
import nts.system.domain.OperationLog
import nts.user.domain.Consumer

/**
 * Created by boful on 15-1-5.
 */
class MobileLoginController {
    def userService;
    def programService;
    def programCategoryService;

    // 登录验证
    def checkLogin = {
        // 返回结果
        def result = [:];

        // 登录验证
        result = userService.checkLogin(params);

        if(result.success) {
            // 根据登录帐号和密码获取客户信息
            def consumer = Consumer.findByName(params.loginName);

            if (consumer.name != 'anonymity') {
                consumer.loginNum = consumer.loginNum + 1
                consumer.dateLastLogin = new Date()
                //---将登陆信息写入日志 nts.system.domain.OperationLog
                new OperationLog(tableName: 'consumer', tableId: consumer.id, operator: consumer.name, modelName: '用户登陆', brief: '登陆操作', operatorId: consumer.id, operation: OperationEnum.LOGIN).save();
            }
            result.consumerId = consumer.id;
            result.consumerName = consumer.name;
        }

        return render(result as JSON)
    }

    def consumerPhoto={
        // 返回结果
        def result = [:];

        def consumerId = params.consumerId;
        if(consumerId){
            def consumer = Consumer.get(consumerId as int);
            if(consumer.photo) {
                result.src = "http://192.168.1.186:8080/upload/photo/${consumer.photo}";
            }
        }

        return render(result as JSON);
    }

    def register={
        def result = [:];

        if (params.name && params.password) {
            params.nickname = params.name;
            params.chkPassword = params.password
            params.request = request;
            // 有效时间，默认一年
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.YEAR, 1);
            params.dateValid = new java.text.SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());

            params.consumer = session.consumer;

            def registerResult = userService.register(params);
            if (registerResult.isOK) {
                result.consumerId=registerResult.id;
                result.consumerName=registerResult.name
            } else {
                result.msg = '注册失败'
            }
        } else {
            result.msg = "参数不全";
        }

        return render(result as JSON)
    }

    def acquireRecordPlay={
        def result = [:];

        //获得用户组
        def paramConsumerId = params.consumerId;
        def sessionConsumerId = session.consumer.id;

        if(paramConsumerId || sessionConsumerId) {
            Consumer consumer
            if(paramConsumerId){
                consumer = Consumer.get(paramConsumerId as long);
            } else{
                consumer = Consumer.get(sessionConsumerId  as long);
            }

            List playedPrograms = [];

            //找到该用户的所有PlayedProgram，对program分组，找到所有program
            List programIdList = PlayedProgram.executeQuery("select program.id from PlayedProgram where consumer.id=:consumerId group by program.id order by playDate desc", [consumerId: consumer.id]);
            programIdList.each{
                //在PlayedProgram，找到所有某个program的所有播放记录，按照播放时间，降序排序
                List playedProgramList = PlayedProgram.executeQuery("from PlayedProgram where program.id=:programId order by playDate desc", [programId: it]);

                PlayedProgram playedProgram = null;
                if (playedProgramList && playedProgramList.size() > 0) {
                    //因为是播放时间降序排序，所以第一个就是最后一次播放
                    playedProgram = playedProgramList[0];
                }

                //播放记录材质，且播放的program是公开的，  避免后期，后台更改资源状态后，前台还会显示
                if (playedProgram && playedProgram.program && playedProgram.serial && playedProgram.program.state == Program.PUBLIC_STATE) {
                    def program = [:];
                    program.id = playedProgram.program.id;
                    program.name = playedProgram.program.name;
                    program.frequency = playedProgram.program.frequency;
                    program.downloadNum = playedProgram.program.downloadNum;
                    program.programScore = playedProgram.program.programScore;
                    program.src = acquirePosterUrl(playedProgram.program, params.size, -1);
                    program.option = playedProgram.program.otherOption;
                    playedPrograms.add(program);
                }
            }

            result.playedPrograms = playedPrograms;
            result.errorFlag=false;
        } else {
            result.errorFlag=true;
            result.msg="";
        }

        return render(result as JSON)
    }

    def acquireCategory={
        def result = [:];

        // 取得一级分类
        List<ProgramCategory> categoryList = programCategoryService.querySubCategory(programCategoryService.querySuperCategory());

        List frist = [];

        categoryList.each{
            def firstCategory = [:];
            firstCategory.categoryId = it.id;
            firstCategory.categoryName = it.name;
            if(it.img){
                firstCategory.img = "http://192.168.1.186:8080/upload/programCategoryImg/${it.img}";;
            }

            // 取得二级分类
            List<ProgramCategory> secondList = programCategoryService.querySubCategory(it);
            List second = [];
            secondList.each { sc ->
                def secondCategory = [:];
                secondCategory.categoryId = sc.id;
                secondCategory.categoryName = sc.name;
                second.add(secondCategory);
            }
            firstCategory.secondCategoryList = second;
            frist.add(firstCategory);
        }
        result.firstCategoryList = frist;

        return render(result as JSON);
    }



    private String acquirePosterUrl(Program program, String size, int postion){
        try{
            if (program.posterPath && program.posterType && program.posterHash) {
                def url = programService.generalFilePoster(program.posterHash, size, postion);
                if(url){
                    return new URL(url).openConnection().getInputStream().getText("UTF-8");
                } else {
                    return  "../../img/images/boful_default_img.png";
                }
            } else{
                if (program.otherOption == Program.ONLY_FLASH_OPTION) {
                    return "../../img/images/flash-imgs.png";
                } else {
                    def url = programService.generalProgramPoster(program, size, postion);
                    if(url){
                        return new URL(url).openConnection().getInputStream().getText("UTF-8");
                    } else {
                        return  "../../img/images/boful_default_img.png";
                    }
                }
            }
        }catch(Exception e){
            if (program.otherOption == Program.ONLY_FLASH_OPTION) {
                return "../../img/images/flash-imgs.png";
            } else {
                return  "../../img/images/boful_default_img.png";
            }
        }
    }
}
