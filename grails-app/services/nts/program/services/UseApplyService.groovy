package nts.program.services

import nts.program.domain.Program
import nts.program.domain.Remark
import nts.system.domain.Qnaire
import nts.system.domain.QnaireOption
import nts.system.domain.QnaireQuestion
import nts.system.domain.Question
import nts.system.domain.Survey
import nts.user.domain.Consumer
import nts.utils.CTools
import org.apache.poi.hssf.usermodel.HSSFCell
import org.apache.poi.hssf.usermodel.HSSFCellStyle
import org.apache.poi.hssf.usermodel.HSSFFont
import org.apache.poi.hssf.usermodel.HSSFRichTextString
import org.apache.poi.hssf.usermodel.HSSFRow
import org.apache.poi.hssf.usermodel.HSSFSheet
import org.apache.poi.hssf.usermodel.HSSFWorkbook

import javax.servlet.http.HttpServletResponse
import java.text.SimpleDateFormat

class UseApplyService {
    public Map statisticsList(Map params){
        def result=[:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        params.max = Math.min(params.max ? params.int('max') : 10, 200);
        def qnaireList=Qnaire.findAllByStateGreaterThan(Qnaire.NO_PUBLIC_STATE, params);
        def qnaireTotal=Qnaire.countByStateGreaterThan(Qnaire.NO_PUBLIC_STATE);
        result.qnaireList=qnaireList;
        result.qnaireTotal=qnaireTotal;
        return result;
    }
    public Map surveyDelete(Map params){
        def result=[:];
        def delIdList = params.idList
        if (delIdList) {
            if (delIdList instanceof String) delIdList = [params.idList]
        } else {
            delIdList = [params.id]
        }
        delIdList?.each {String id ->
            def survey = Survey.findById(Long.parseLong(id));
            survey.delete();
            result.success=true;
        }
        return result;
    }
    public Map surveylist(Map params){
        def result=[:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        params.max = Math.min(params.max ? params.int('max') : 10, 200)
        def survey = Survey.list(params);
        result.survey=survey;
        return result;
    }
    public Map saveQnaire(Map params,Qnaire qnaire){
        def result=[:];
        def maxQuestionIndex = 0
        def maxOptionIndex = 0
        def question = 0
        def type = 0
        def optionText = 0
        def qShowOrder = 0    //问题排序号
        def oShowOrder = 0    //选项排序号

        if (qnaire) {
            maxQuestionIndex = params.maxQuestionIndex.toInteger()
            for (int i = 0; i < maxQuestionIndex; i++) {
                question = CTools.nullToBlank(params."questionText_${i}").trim()
                type = params."type_${i}"

                if (question != "") {
                    def qnaireQuestion = new QnaireQuestion(question: question, type: type, showOrder: qShowOrder)
                    qnaire.addToQnaireQuestions(qnaireQuestion)
                    qShowOrder++

                    maxOptionIndex = params.maxOptionIndex.toInteger()
                    oShowOrder = 0
                    for (int j = 0; j < maxOptionIndex; j++) {
                        optionText = CTools.nullToBlank(params."optionText_${i}_${j}").trim()
                        if (optionText != "") {
                            def qnaireOption = new QnaireOption(optionText: optionText, count: 0, showOrder: oShowOrder)
                            qnaireQuestion.addToQnaireOptions(qnaireOption)
                            oShowOrder++
                        }
                    }
                }
            }

            if (!qnaire.save(flush: true)) {
                println qnaire.errors
            } else
                println "ok"

            result.message = "创建成功"


        }

        return result;
    }

    public Map questionSearchList(Map params){
        def result=[:];
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        Date begin_date = null;
        Date end_date = null;

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        def searchName = params.searchName
        def searchType = params.searchType
        def searchDate = params.searchDate
        def dateBegin                                    //创建开始时间
        def dateEnd                                    //创建结束时间

        if (searchDate)                            //用户判断用使用的是哪一种时间段查询方式
        {
            dateBegin = params.searchDate + ' 00:00:01'
            dateEnd = params.searchDate + ' 23:59:59'

            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        }


        def searchList = Question.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (searchName) {
                searchName = searchName.trim()
                like('name', "%${searchName}%")
            }

            if (searchType) {
                if (searchType == '1') {
                    eq("questionState", true)
                } else {
                    eq("questionState", false)
                }

            }
            if (searchDate) {
                between("dateCreated", begin_date, end_date)
            }
        }
        result.searchList=searchList;
        return result;
    }

    public Map searchRemark(Map params){
        def result=[:];
        def searchTitle = params.searchTitle
        def searchContent = params.searchContent
        def searchConsumer = params.searchConsumer
        def searchProgram = params.searchProgram

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        def searchList = Remark.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {

            if (searchTitle) {
                searchTitle = searchTitle.trim()
                like('topic', "%${searchTitle}%")
            }
            if (searchContent) {
                searchContent = searchContent.trim()
                like('content', "%${searchContent}%")
            }
            if (searchConsumer) {
                consumer
                        {
                            searchConsumer = searchConsumer.trim()
                            like('nickname', "%${searchConsumer}%");
                        }
            }
            if (searchProgram) {
                program
                        {
                            searchProgram = searchProgram.trim()
                            like('name', "%${searchProgram}%");
                        }
            }
        }
        result.searchList=searchList;
        return result
    }

    public Map searchTopicProgram(Map params){
        def result=[:];
        if (!params.max) params.max = 20
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'

        def state = CTools.nullToZero(params.schState)//状态为0 所有未入库资源
        def directoryId = CTools.nullToZero(params.directoryId)//类库
        def schType = CTools.nullToBlank(params.schType)//
        def schWord = CTools.nullToBlank(params.schWord)


        def programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {

            //检索 标签 呢称用完全匹配查询
            if (schWord != '') {
                if (schType == 'name') {
                    like("name", "%${schWord}%")
                } else if (schType == 'actor') {
                    like("actor", "%${schWord}%")
                } else if (isFromMgr && schType == 'consumer') {
                    eq("consumer", Consumer.findByNickname(schWord))
                } else if (schType == 'programTags') {
                    programTags {
                        eq('name', schWord)
                    }
                }
            }

            //已入库
            ge("state", Program.PUBLIC_STATE)

        }
        result.programList=programList;
        return result;
    }

    def exportExcel1(String name, List<Program> data, List<String> fieldName, List<String> fieldValue, String sheetName,HttpServletResponse response) {
        def os = null;
        HSSFWorkbook workbook = null;
        try {
            response.reset(); // 清空输出流
            os = response.getOutputStream(); // 取得输出流
            response.setContentType("application/msexcel; charset=UTF-8");
            response.setHeader("Content-disposition", "inline; filename=" + new String(name.getBytes("gb2312"), "ISO8859-1") + ".xls");
            // 设定输出文件头
            // 定义输出类型

            //在内存中生成工作薄
            // HSSFWorkbook workbook = makeWorkBook(sheetName,fieldName,data);
            // 产生工作薄对象
            workbook = new HSSFWorkbook();
            HSSFCellStyle style = workbook.createCellStyle();
            style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
            style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
            style.setBorderRight(HSSFCellStyle.BORDER_THIN);
            style.setBorderTop(HSSFCellStyle.BORDER_THIN);
            style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
            // 生成一个字体
            HSSFFont font = workbook.createFont();
            font.setFontHeightInPoints((short) 8);
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
            // 把字体应用到当前的样式
            style.setFont(font);
            // 产生工作表对象
            HSSFSheet sheet = workbook.createSheet();
            // 为了工作表能支持中文,设置字符集为UTF_16
            workbook.setSheetName(0, sheetName);
            // 产生一行
            HSSFRow row = sheet.createRow(0);
            sheet.setDefaultColumnWidth((short) 50);
            // 产生单元格
            HSSFCell cell;
            // 写入各个字段的名称
            for (int i = 0; i < fieldName.size(); i++) {
                //println("in0"+fieldName[i])
                // 创建第一行各个字段名称的单元格
                cell = row.createCell((short) i);
                cell.setCellStyle(style);
                // 设置单元格内容为字符串型
                cell.setCellType(HSSFCell.CELL_TYPE_STRING);
                // 为了能在单元格中输入中文,设置字符集为UTF_16
                // cell.setEncoding(HSSFCell.ENCODING_UTF_16);
                // 给单元格内容赋值
                cell.setCellValue(new HSSFRichTextString(fieldName[i]));
            }
            // 写入各条记录,每条记录对应excel表中的一行
            def tmp = null

            for (int i = 0; i < data.size(); i++) {
                tmp = data[i];
                // println(tmp.(fieldValue[j]))
                row = sheet.createRow(i + 1);
                for (int j = 0; j < fieldValue.size(); j++) {
                    cell = row.createCell((short) j);
                    //设置单元格字符类型为String
                    cell.setCellType(HSSFCell.CELL_TYPE_STRING);
                    if (j == 1) {

                        cell.setCellValue(new HSSFRichTextString(tmp?.directory?.name));
                    } else {

                        cell.setCellValue(new HSSFRichTextString((tmp.(fieldValue[j]) == null) ? "" : tmp.(fieldValue[j]).toString()));
                    }
                }
            }
            os.flush();
            workbook.write(os)
        } catch (IOException e) {
            e.printStackTrace();
            println("Output is closed");
        }

    }

}
