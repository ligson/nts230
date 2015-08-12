package nts.mobile

import grails.converters.JSON
import nts.program.category.domain.ProgramCategory
import nts.program.domain.Program
import nts.program.domain.Serial

/**
 * Created by boful on 15-1-6.
 */
class MobileProgramController {

    def programService;
    def programCategoryService;

    def carousel={
        def result=[:];

        List<Program> programList = programService.search(params, false);
        def list = [];
        programList?.each {
            def program = [:];
            program.id = it.id;
            program.name = it.name;
            program.src = acquirePosterUrl(it, params.size, -1);
            program.option = it.otherOption;
            list.add(program);
        }
        result.list=list;
        return render(result as JSON);
    }

    def programSearch={
        def result=[:];

        List<ProgramCategory> categoryList = programCategoryService.querySubCategory(programCategoryService.querySuperCategory());

        def clist = [];
        categoryList?.each { ProgramCategory category ->
            def tmpMap = [:];
            tmpMap.mediaType = category.mediaType;
            tmpMap.categoryId = category.id;
            tmpMap.categoryName = category.name;
            def programList = programService.search([programCategoryId: category.id, order: "desc", orderBy: "id", max: 6, offset: 0], false);
            def plist = [];
            programList.each{
                def program = [:];
                program.id = it.id;
                program.name = it.name;
                program.src = acquirePosterUrl(it, params.size, -1);
                program.option = it.otherOption;
                plist.add(program);
            }
            tmpMap.programList = plist;
            clist.add(tmpMap);
        }

        result.categoryList=clist;
        return render(result as JSON);
    }

    def programSearchByCategoryId={
        def result=[:];

            def programs = programService.search([programCategoryId: params.categoryId, order: "desc", orderBy: "id"], false);
            def programList = [];
            programs.each{
                def program = [:];
                program.id = it.id;
                program.name = it.name;
                program.src = acquirePosterUrl(it, params.size, -1);
                program.option = it.otherOption;
                program.frequency = it.frequency;
                program.downloadNum = it.downloadNum;
                program.programScore = it.programScore;
                programList.add(program);
            }

        result.programList=programList;
        return render(result as JSON);
    }

    def checkProgram = {
        def result=[:];

        Program program = null;

        if (params.programId) {
            program = Program.get(params.programId as Long);
            if (program?.serials?.size() == 0) {
                result.msg = program?.name + "下没有子资源";
                return render(result as JSON);
            }
            if (!program) {
                result.msg ="对不起,你所要查找的数据不存在!";
                return render(result as JSON);
            }
        } else {
            result.msg ="对不起,你所要查找的数据不存在!";
            return render(result as JSON);
        }

        if (!program) {
            result.msg ="点播的资源不存在!";
            return render(result as JSON);
        }

        def canPlay = programService.canPlay(session.consumer, Program.get(params.programId as Long));
        if (!canPlay) {
            if ((program.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                result.msg = "对不起，您没有权限学习该课程！"
                return render(result as JSON);
            } else {
                result.msg = "对不起，您没有权限点播该资源！"
                return render(result as JSON);
            }
        }

        return render(result as JSON);
    }

    def playProgram={

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

    def acquirePdf={
        println ("acquirePdf");
        URL url = new URL("http://192.168.1.220:8080/plus.pdf");
        URLConnection con = url.openConnection();
        response.setContentType("application/octet-stream");
        // response.setHeader("Content-disposition", "attachment;filename=1.pdf")
        response.outputStream << con.getInputStream();
        return;
//        InputStream is = con.getInputStream();
//        byte[] b = new byte[con.getContentLength()];
//        is.read(b);
//
//        def result=[:];
//        return render(result as JSON);
    }
}
