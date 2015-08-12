package nts.program.services

import grails.transaction.Transactional
import groovy.xml.MarkupBuilder
import nts.meta.domain.MetaContent
import nts.meta.domain.MetaDefine
import nts.meta.domain.MetaEnum
import nts.program.domain.Program
import nts.program.domain.Serial
import nts.system.domain.Directory
import nts.user.domain.Consumer
import nts.utils.BfConfig
import nts.utils.CTools
import org.apache.poi.hssf.usermodel.HSSFCell
import org.apache.poi.hssf.usermodel.HSSFCellStyle
import org.apache.poi.hssf.usermodel.HSSFDateUtil
import org.apache.poi.hssf.usermodel.HSSFFont
import org.apache.poi.hssf.usermodel.HSSFRichTextString
import org.apache.poi.hssf.usermodel.HSSFRow
import org.apache.poi.hssf.usermodel.HSSFSheet
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.multipart.commons.CommonsMultipartFile

import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession
import java.text.SimpleDateFormat

@Transactional
class ProgramExportService {

    public boolean excelToDataBase(Map params) {
        //说明：因为excel中可能有不规范数据，可能产生异常，故先将资源先放在list中，确保数据都正确才保存，保存中产生异常，则回滚
        List<Program> batch = []
        def today = new Date()
        def programName = ''
        def programActor = ''
        def filename = ''
        Program program = null
        def directory = null
        HSSFCell cell

        def metaTitleId = params.servletContext.metaTitleId
        def metaCreatorId = params.servletContext.metaCreatorId
        def directoryId = CTools.nullToZero(params.directoryId)

        MultipartHttpServletRequest mpr = (MultipartHttpServletRequest) (params.request)
        CommonsMultipartFile file = (CommonsMultipartFile) mpr.getFile("file1") //获取上传的file
        filename = file.getOriginalFilename()
        println(filename + "---------------")
        //fs = new POIFSFileSystem(new FileInputStream("d:\\1.xls"));

        //创建对Excel工作簿文件的引用
        HSSFWorkbook workbook = new HSSFWorkbook(file.inputStream)
        //创建对工作表的引用
        HSSFSheet sheet = workbook.getSheetAt(0)

        //总行数
        int rowNum = sheet.getLastRowNum()

        //////////////////////////////////////////处理标题行开始
        //读取第一行(标题行)
        HSSFRow row = sheet.getRow(0)
        //标题总列数
        int colNum = row.getLastCellNum()

        //列对应的元数据ID数组
        int[] arrMetaId = new int[colNum];
        //第1列是资源文件路径，2简介,3标识列,4海报,特殊列
        arrMetaId[0] = 0
        arrMetaId[1] = 0
        arrMetaId[2] = 0
        arrMetaId[3] = 0
        for (int i = 4; i < colNum; i++) {
            cell = row.getCell(i)
            if (cell) arrMetaId[i] = queryMetaId(cell.getStringCellValue())
        }
        //////////////////////////////////////////处理program domain结束

        int curRow = 0
        int curCell = 0

        try {
            for (int i = 1; i <= rowNum; i++) {
                row = sheet.getRow(i)
                curRow = i;

                /////////////标识ID列(fromId)处理,处理多集开始
                def fromId = 0
                boolean bProgramExist = false
                cell = row.getCell(2)
                if (cell) {
                    if (cell.getCellType() == cell.CELL_TYPE_NUMERIC)
                        fromId = cell.getNumericCellValue()
                    else if (cell.getCellType() == cell.CELL_TYPE_STRING)
                        fromId = CTools.nullToZero(cell.getStringCellValue())
                }

                if (fromId && batch && fromId > 0) {
                    program = queryProgramFromList(batch, fromId)
                    //如果资源已存在，如中南财大本库一个资源有多个流媒体物理文件
                    if (program) {
                        println "lll:" + program.name
                        bProgramExist = true
                    } else
                        program = new Program()
                } else
                    program = new Program()

                //if(!bProgramExist) program = new nts.program.domain.Program()
                /////////////标识ID列(fromId)处理,处理多集结束

                ///////////////////////////////////////处理Serial domain开始
                //////////////处理视音频开始
                def serial = null
                def filePath = ''
                def serialNo = 1
                def timeLength = 0
                def svrAddress = CTools.nullToBlank(params.servletContext.videoSevr) == '' ? params.request.serverName : params.servletContext.videoSevr

                cell = row.getCell(0)
                if (cell) filePath = cell.getStringCellValue().trim()
                filePath = filePath.replaceAll("\\\\", "/")


                if (filePath) {
                    String[] arrFilePath = filePath.split("\\|")

                    for (int j = 0; j < arrFilePath.length; j++) {
                        filePath = arrFilePath[j].trim()
                        if (filePath == "") continue

                        //获得serialNo
                        //if(program.serials) serialNo = program.serials.size()+1
                        if (program.serials) {
                            program.serials.each {
                                if (it.urlType == Serial.URL_TYPE_VIDEO || (params.urlType.toInteger() == Serial.URL_TYPE_IMAGE && it.urlType == Serial.URL_TYPE_IMAGE)) serialNo++
                            }

                        }

                        serial = new Serial(
                                urlType: params.urlType,
                                serialNo: serialNo,
                                name: CTools.readFileName(filePath, false),
                                filePath: filePath,
                                progType: 0,
                                timeLength: timeLength,
                                bandWidth: 0,
                                svrAddress: svrAddress,
                                startTime: '00:00:00',
                                endTime: '00:00:00',
                                webPath: '',
                                description: '',
                                dateModified: today
                        )

                        program.addToSerials(serial)
                    }
                }
                //////////////处理视音频结束

                //如果资源存在，只插入Serial即可,返回
                if (bProgramExist) continue

                //////////////处理海报开始
                cell = row.getCell(3)
                if (cell) {
                    filePath = cell.getStringCellValue().trim()

                    if (filePath && filePath != "") {
                        filePath = filePath.replaceAll("\\\\", "/")
                        serial = new Serial(
                                urlType: Serial.URL_TYPE_IMAGE,
                                serialNo: 1,
                                name: CTools.readFileName(filePath, false),
                                filePath: filePath,
                                progType: 0,
                                timeLength: timeLength,
                                bandWidth: 0,
                                svrAddress: svrAddress,
                                startTime: '00:00:00',
                                endTime: '00:00:00',
                                webPath: '',
                                description: '',
                                transcodeState: Serial.OPT_IMG_POSTER,
                                dateModified: today
                        )

                        program.addToSerials(serial)
                    }
                }
                //////////////处理海报结束
                ///////////////////////////////////////处理Serial domain结束

                //防止资源名称累加
                programName = ''
                programActor = ''

                ///////////////////////////////////////处理Program domain开始
                directory = Directory.get((long) directoryId)

                program.consumer = params.consumer
                program.classLib = directory
                program.directory = program?.classLib
                //program.name = ''		//在后面赋值
                //program.actor = ''	//在后面赋值

                program.state = Program.PUBLIC_STATE
                program.fromId = fromId

                //约定第2列是简介列
                cell = row.getCell(1)
                if (cell) {
                    program.description = cell.getStringCellValue()
                    //program.description = program.description.replaceAll("<([\\s\\S]*?)>","")	//新东方内容中有html标签 正常情况下注释此行
                }

                program.datePassed = today
                program.dateCreated = today
                program.dateModified = today
                ///////////////////////////////////////处理Program domain结束

                ///////////////////////////////////////处理MetaContent domain开始
                def sCellValue = ''

                def metaDefine
                def metaContent
                def numContent
                def strContent
                def metaEnum

                //j = 4，因为前4列是特殊列
                for (int j = 4; j < colNum; j++) {
                    cell = row.getCell(j)
                    curCell = j;
                    if (cell) {
                        metaDefine = MetaDefine.get(arrMetaId[j])
                        if (metaDefine) {
                            if (cell.getCellType() == cell.CELL_TYPE_NUMERIC) {
                                sCellValue = ((int) cell.getNumericCellValue()) + ''
                            } else if (cell.getCellType() == cell.CELL_TYPE_STRING) {
                                sCellValue = CTools.nullToBlank(cell.getStringCellValue()).trim()
                            } else {
                                sCellValue = ''
                            }

                            if (sCellValue == null || sCellValue == '') continue

                            //如果是复合元素，通过其值分解转换成具体修饰词及值
                            if (metaDefine.dataType == 'decorate') {
                                //如学科,化学->无机化学：arr[0]=化学,arr[1]=无机化学
                                List arrCnName = queryArrCnName(sCellValue)
                                metaDefine = MetaDefine.findByCnNameAndParentId(arrCnName[0], metaDefine.id)
                                sCellValue = arrCnName[1];

                                if (!metaDefine) {
                                    throw new RuntimeException(" ${filename} decorate cnName:${arrCnName[0]} not exist.")
                                }
                            }


                            if (MetaContent.numDataTypes.contains(metaDefine.dataType)) {
                                if (metaDefine.dataType == 'enumeration') {
                                    metaEnum = MetaEnum.findByNameAndMetaDefine(sCellValue, metaDefine)

                                    if (metaEnum) {
                                        numContent = metaEnum.enumId
                                    } else {
                                        numContent = 0;//对于学科，只有一级分类的，如化学，不在细分了。
                                        //throw new RuntimeException ("${filename} ${metaDefine.cnName}:${sCellValue} not exist.")
                                    }
                                } else {
                                    //比如：12.0直接转整形会报错
                                    numContent = (int) sCellValue.toDouble()
                                }
                                strContent = ''
                            } else {
                                numContent = null
                                //元数据中定义中不是数字类型的，但在cell中当作数字的，都作为日期类型
                                if (metaDefine.dataType == "date") {
                                    strContent = new java.text.SimpleDateFormat("yyyy-MM-dd").format(HSSFDateUtil.getJavaDate(sCellValue.toDouble()))
                                } else if (metaDefine.dataType == "datetime") {
                                    strContent = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(HSSFDateUtil.getJavaDate(sCellValue.toDouble()))
                                } else {
                                    strContent = sCellValue
                                }

                            }

                            if (numContent == null && sCellValue == '') continue

                            metaContent = new MetaContent(
                                    numContent: numContent,
                                    strContent: strContent,
                                    metaDefine: metaDefine,
                                    parentId: metaDefine.parentId
                            )
                            program.addToMetaContents(metaContent)

                            //取得标题
                            if (metaDefine.parentId == metaTitleId && (metaDefine.showType & MetaDefine.ABSTRACT_SHOW) == MetaDefine.ABSTRACT_SHOW && strContent != '') {
                                programName += strContent + ";"
                            }

                            //取得主要责任者
                            if (metaDefine.parentId == metaCreatorId && (metaDefine.showType & MetaDefine.ABSTRACT_SHOW) == MetaDefine.ABSTRACT_SHOW && strContent != '') {
                                programActor += strContent + ";"
                            }
                        }
                        //元数据不存在
                        else {
                            throw new RuntimeException("${filename} id=${arrMetaId[j]} not exist.")
                        }
                    }
                }
                ///////////////////////////////////////处理MetaContent domain结束

                ///////////////////////////////////////给program题名，创建者赋值 结束
                if (programName.endsWith(";")) programName = programName.substring(0, programName.length() - 1)
                if (programActor.endsWith(";")) programActor = programActor.substring(0, programActor.length() - 1)
                program.name = programName
                program.actor = programActor
                ///////////////////////////////////////给program题名，创建者赋值 结束

                ///处理完毕，保存资源
                batch.add(program)
                //program.save()

            }//for

            //捕获异常会导致不回滚(网上有人这样说),有时间时可验证一下
            //program.errors.allErrors.each { println it }
            Program.withTransaction {
                for (Program p in batch) {
                    p.save()
                }
            }
            //batch.clear()
            return true;
        }
        catch (Exception e) {
            return false;

        }
    }
    def exportExcel(String name, List<Consumer> data, List<String> fieldName, List<String> fieldValue, String sheetName, HttpServletResponse response) {
        def os = null;
        HSSFWorkbook workbook = null;
        try {
            response.reset(); // 清空输出流
            os = response.getOutputStream(); // 取得输出流
            response.setContentType("application/msexcel; charset=UTF-8");
            response.setHeader("Content-disposition", "inline; filename=" + name + ".xls"); // 设定输出文件头
            // 定义输出类型

            //在内存中生成工作薄
            // HSSFWorkbook workbook = makeWorkBook(sheetName,fieldName,data);
            // 产生工作薄对象
            workbook = new HSSFWorkbook();
            // 产生工作表对象
            HSSFSheet sheet = workbook.createSheet();
            // 为了工作表能支持中文,设置字符集为UTF_16
            workbook.setSheetName(0, sheetName);
            // 产生一行
            HSSFRow row = sheet.createRow(0);
            // 产生单元格
            HSSFCell cell;
            // 写入各个字段的名称
            for (int i = 0; i < fieldName.size(); i++) {
                //println("in0"+fieldName[i])
                // 创建第一行各个字段名称的单元格
                cell = row.createCell((short) i);
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

                    cell.setCellValue(new HSSFRichTextString((tmp.(fieldValue[j]) == null) ? "" : tmp.(fieldValue[j]).toString()));

                }
            }
            os.flush();
            workbook.write(os)
        } catch (IOException e) {
            e.printStackTrace();
            println("Output is closed");
        }
    }
    public Map export(Map params, HttpServletRequest request, HttpSession session) {
        def result = [:];
        def directoryId = params.directoryId
        def exportType = params.exportType.toInteger()
        def exportFormat = params.exportFormat.toInteger()
        def isDescription = params.isDescription
        def rootPath1 = params.rootPath
        def fileName = Directory.get(directoryId).name + "库" + new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date()) + (exportFormat == 1 ? ".xls" : ".xml")
        def file = Directory.get(directoryId).name + "库" + new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date())
        def rootPath = rootPath1 + fileName
        def beginDate = params.beginDate
        def endDate = params.endDate
        def vEnum = MetaEnum.executeQuery("select enumId,name,metaDefine.id from MetaEnum")
        def nExcelColNum = 0
        def arrDataType = []
        def WhereDate = ''
        def sAddSql = ''
        def metaContentList = null
        if (!beginDate.equals("")) WhereDate += " and dateCreated >= '" + beginDate + "'";
        if (!endDate.equals("")) WhereDate += " and dateCreated <= '" + endDate + " 23:59:59'";
        if (!WhereDate.equals("")) sAddSql += " and a.program.id in (select id from nts.program.domain.Program where 1=1 " + WhereDate + ") ";

        if (exportFormat == 0) {
            def strSql = "select p.id,a.strContent,b.name,b.cnName,c.name from nts.program.domain.Program p,nts.meta.domain.MetaContent a,nts.meta.domain.MetaDefine b,nts.system.domain.Directory c where a.metaDefine.id=b.id and p.directory.id=c.id and p.id=a.program.id and c.id=${directoryId}" + sAddSql + "  order by p.id asc ";
            def list = Program.executeQuery(strSql)
            rootPath = rootPath.replace('//', '/')//单个字符可全替换
            def writer = new FileWriter(new File(rootPath))
            writer.write("<?xml version=\"1.0\" encoding=\"GBK\"?>\n");
            def xml = new groovy.xml.MarkupBuilder(writer)

            def shu = 0
            def nPreProgId = 0
            def attsql = null
            def attlist = null
            def enumName = null
            xml.list() {
                list.each {
                    if (nPreProgId != it[0]) {
                        program(id: it[0], library: it[4]) { ->
                            it
                            attsql = "select strContent ,metaDefine.name,metaDefine.cnName ,metaDefine.dataType,numContent ,metaDefine.id,metaDefine.showType from nts.meta.domain.MetaContent where program.id = " + it[0]
                            attlist = MetaContent.executeQuery(attsql)
                            attlist.each {
                                if ((exportType == 1 && ((it[6] & 16) == 16)) || (exportType == 0)) {

                                    if (it[3].equals("enumeration")) {

                                        enumName = getEnumName(it[5], it[4], vEnum)

                                        attribute(name: it[1], cnName: it[2], enumName != "0" ? enumName : it[2])
                                    } else if (it[3].equals("number")) {
                                        attribute(name: it[1], cnName: it[2], it[4])
                                    } else {
                                        attribute(name: it[1], cnName: it[2], it[0])
                                    }
                                }
                            }

                            attribute(name: "description", cnName: "简介", isDescription ? CTools.htmlToBlank(Program.get(it[0]).description) : "")
                        }
                        nPreProgId = it[0]
                        shu++
                    }
                }
            }
            def sFileExt = CTools.readExtensionName(rootPath)
            def port = BfConfig.getVideoPort()
            if (port == null || port == '') port = '1680'
            def videoHost = request.getServerName() + ":" + port
            def url = "${BfConfig.getPlayProtocol()}://ADDR=${videoHost};UID=${session.consumer.name};PWD=${session.consumer.password};FILE=${rootPath};PN=${file};EXT=${sFileExt};PFG=2;"
            def playUrl = "bfp://" + request.getServerName() + ":" + request.getServerPort() + "/pfg=d&enc=b&url=" + url.getBytes("GBK").encodeAsBase64().toString()

            //flash.message = "成功备份到：${rootPath}。" + "<a href=\"${playUrl}\"><font color=\"blue\">下载到本地</font></a>"
            //render(view: "exportExcelorXml", model: [directoryList: Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"]), directoryId: directoryId, endDate: endDate, beginDate: beginDate, isDescription: isDescription, exportFormat: exportFormat, exportType: exportType, rootPath: params.rootPath])
            result.message = "成功备份到：${rootPath}。" + "<a href=\"${playUrl}\"><font color=\"blue\">下载到本地</font></a>";
            result.putAll([directoryList: Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"]), directoryId: directoryId, endDate: endDate, beginDate: beginDate, isDescription: isDescription, exportFormat: exportFormat, exportType: exportType, rootPath: params.rootPath]);
        } else if (exportFormat == 1) {

            HSSFWorkbook workbook = new HSSFWorkbook();
            // 生成一个表格
            HSSFSheet sheet = workbook.createSheet("Excel");
            // 设置表格默认列宽度为15个字节
            sheet.setDefaultColumnWidth((short) 30);
            // 生成一个样式
            HSSFCellStyle style = workbook.createCellStyle();
            HSSFCell cell = null
            // 设置这些样式
            //style.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
            //style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
            style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
            style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
            style.setBorderRight(HSSFCellStyle.BORDER_THIN);
            style.setBorderTop(HSSFCellStyle.BORDER_THIN);
            style.setAlignment(HSSFCellStyle.ALIGN_CENTER);

            // 生成一个字体
            HSSFFont font = workbook.createFont();
            // font.setColor(HSSFColor.VIOLET.index);
            font.setFontHeightInPoints((short) 12);
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

            // 把字体应用到当前的样式
            style.setFont(font);

            //产生表格标题行
            HSSFRow row = sheet.createRow(0);
            //int nParentid=0,is_export=0,classid=0;

            HSSFRichTextString text = null;
            def nPreProgId = 0
            def curColNo = -1
            //第一列资源ID列设置：
            cell = row.createCell(0);

            cell.setCellStyle(style);
            text = new HSSFRichTextString("资源ID号");
            cell.setCellValue(text);
            nExcelColNum++;
            //其它列设置
            def criteria = MetaDefine.createCriteria()
            def excelList = criteria.list {
                or {
                    sizeEq("directorys", 0)
                    directorys {
                        eq('id', directoryId.toLong())
                    }
                }
                order("parentId", "asc")
            }

            for (int i = 0; i < excelList.size(); i++) {
                if (!excelList[i].dataType.equals("decorate")) {
                    arrDataType << excelList[i].id
                    cell = row.createCell((short) nExcelColNum);
                    cell.setCellStyle(style);
                    text = new HSSFRichTextString(excelList[i].cnName);
                    cell.setCellValue(text);
                    nExcelColNum++;
                }
            }
            cell = row.createCell((short) nExcelColNum);

            cell.setCellStyle(style);
            text = new HSSFRichTextString("资源简介");
            cell.setCellValue(text);

            def strSql = "select a.strContent,a.program.id ,a.metaDefine.id from nts.meta.domain.MetaContent a where a.program.directory.id=${directoryId} " + sAddSql + "  order by a.program.id asc ";
            def valuelist = MetaContent.executeQuery(strSql)
            def rowIndex = 1
            def attsql = null
            def attlist = null
            def enumName = null
            def program = null

            HSSFCellStyle style1 = workbook.createCellStyle();
            valuelist.each {
                if (nPreProgId != it[1]) {
                    row = sheet.createRow(rowIndex);
                    for (int j = 0; j <= arrDataType.size(); j++) row.createCell(j);
                    cell = row.getCell(0);
                    style1.setAlignment(HSSFCellStyle.ALIGN_CENTER);
                    cell.setCellStyle(style1);
                    cell.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell.setCellValue(new HSSFRichTextString(it[1] + ""))
                    nPreProgId = it[1];
                    rowIndex++;
                }
                attsql = "select strContent ,metaDefine.dataType,numContent ,metaDefine.id ,metaDefine.cnName ,metaDefine.showType from nts.meta.domain.MetaContent where program.id = " + it[1]
                attlist = MetaContent.executeQuery(attsql)
                attlist.each {
                    if ((exportType == 1 && ((it[5] & 16) == 16)) || (exportType == 0)) {
                        curColNo = getExcelColNo(it[3], arrDataType);
                        if (curColNo != -1) {
                            cell = row.getCell(curColNo);
                            cell.setCellType(HSSFCell.CELL_TYPE_STRING);
                            if (it[1].equals("enumeration")) {
                                enumName = getEnumName(it[3], it[2], vEnum)
                                cell.setCellValue(new HSSFRichTextString(enumName != "0" ? enumName : it[4] + ""))
                            } else if (it[1].equals("number")) {
                                cell.setCellValue(new HSSFRichTextString(it[2] + ""))
                            } else {
                                cell.setCellValue(new HSSFRichTextString(it[0] + ""))
                            }
                        }

                    }
                }

                program = Program.get(it[1])
                cell = row.createCell((short) nExcelColNum);
                text = new HSSFRichTextString(isDescription ? CTools.htmlToBlank(program.description) : '');
                cell.setCellValue(text);
            }

            FileOutputStream fileOutputStream = new FileOutputStream(rootPath);
            workbook.write(fileOutputStream);
            fileOutputStream.close();
            def sFileExt = CTools.readExtensionName(rootPath)
            def port = BfConfig.getVideoPort()
            if (port == null || port == '') port = '1680'
            def videoHost = request.getServerName() + ":" + port
            def url = "${BfConfig.getPlayProtocol()}://ADDR=${videoHost};UID=${session.consumer.name};PWD=${session.consumer.password};FILE=${rootPath};PN=${file};EXT=${sFileExt};PFG=2;"
            def playUrl = "bfp://" + request.getServerName() + ":" + request.getServerPort() + "/pfg=d&enc=b&url=" + url.getBytes("GBK").encodeAsBase64().toString()

            //flash.message = "成功备份到：${rootPath}。" + "<a href=\"${playUrl}\"><font color=\"blue\">下载到本地</font></a>"
            //render(view: "exportExcelorXml", model: [directoryList: Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"]), directoryId: directoryId, endDate: endDate, beginDate: beginDate, isDescription: isDescription, exportFormat: exportFormat, exportType: exportType, rootPath: params.rootPath])
            result.message = "成功备份到：${rootPath}。" + "<a href=\"${playUrl}\"><font color=\"blue\">下载到本地</font></a>";
            result.putAll([directoryList: Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"]), directoryId: directoryId, endDate: endDate, beginDate: beginDate, isDescription: isDescription, exportFormat: exportFormat, exportType: exportType, rootPath: params.rootPath])
        } else if (exportFormat == 2) {
            //oai-phm export code by jlf

            def directory = Directory.get(directoryId)

            ////////导入日期范围 start
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
            def startTime = "1900-01-01 23:59:59"
            def endTime = "2051-01-01 23:59:59"
            if (beginDate != "") startTime = beginDate + ' 00:00:01'
            if (endDate != "") endTime = endDate + ' 23:59:59'
            startTime = sdf.parse(startTime)
            endTime = sdf.parse(endTime)
            ////////导入日期范围 end

            ////////request host start
            def host = request.getServerName()
            if (request.getServerPort() != 80) host += ":" + request.getServerPort()
            ////////request host end

            ////////要导出的元数据 start
            def metaDefineList = MetaDefine.createCriteria().list {
                //eq("description", "Fred%")
                ne("description", "")
                or {
                    sizeLt("directorys", 1)
                    directorys {
                        eq("id", directory.id)
                    }
                }

                order("showOrder", "asc")
            }

            ////////要导出的元数据 end

            ////////要导出的资源 start
            def programList = Program.createCriteria().list {
                eq("directory", directory)
                between("dateCreated", startTime, endTime)
                order("id", "asc")
            }
            ////////要导出的资源 end

            rootPath = rootPath.replace('//', '/')//单个字符可全替换

            def writer = new FileWriter(new File(rootPath))
            writer.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
            def mB = new groovy.xml.MarkupBuilder(writer)

            mB.ListRecords() {
                for (p in programList) {

                    ////////要导出的metaContent start
                    metaContentList = MetaContent.createCriteria().list {
                        eq("program", p)
                        'in'("metaDefine", metaDefineList)
                    }
                    ////////要导出的metaContent end
                    mB.record() {
                        mB.header() {
                            identifier(p.id)
                            datestamp(p.dateCreated)
                            setSpec("共享工程")
                        }

                        mB.metadata() {
                            metaDefineList.each { metaDefine ->
                                metaContentList.each { metaContent ->
                                    if (metaContent.metaDefine == metaDefine) {
                                        def strData = ""
                                        if (MetaContent.numDataTypes.contains(metaDefine.dataType)) {
                                            if (metaDefine.dataType == "enumeration")
                                                strData = getEnumName(metaDefine.id, metaContent.numContent, vEnum)
                                            else
                                                strData = metaContent.numContent
                                        } else {
                                            strData = metaContent.strContent
                                        }
                                        "${metaDefine.description}"(strData)
                                    }
                                }
                            }

                            if (isDescription == "0") description(p.description)
                        }

                        mB.about() {
                            url("http://${host}/program/showProgram?id=${p.id}")
                        }

                    }
                }

            }

            def sFileExt = CTools.readExtensionName(rootPath)
            def port = BfConfig.getVideoPort()
            if (port == null || port == '') port = '1680'
            def videoHost = request.getServerName() + ":" + port
            def url = "${BfConfig.getPlayProtocol()}://ADDR=${videoHost};UID=${session.consumer.name};PWD=${session.consumer.password};FILE=${rootPath};PN=${file};EXT=${sFileExt};PFG=2;"
            def playUrl = "bfp://" + host + "/pfg=d&enc=b&url=" + url.getBytes("GBK").encodeAsBase64().toString()

            result.message = "成功备份到：${rootPath}。" + "<a href=\"${playUrl}\"><font color=\"blue\">下载到本地</font></a>"
            result.putAll([directoryList: Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"]), directoryId: directoryId, endDate: endDate, beginDate: beginDate, isDescription: isDescription, exportFormat: exportFormat, exportType: exportType, rootPath: params.rootPath])

        }
        return result;

    }
    public Map exportProgram(Map params, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        def result = [:];
        def directoryId = params.directoryId
        def exportType = params.exportType.toInteger()
        def exportFormat = params.exportFormat.toInteger()
        def isDescription = params.isDescription
        def rootPath1 = params.rootPath
        def fileName = Directory.get(directoryId).name + "库" + new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + (exportFormat == 1 ? ".xls" : ".xml")
        def file = Directory.get(directoryId).name + "库" + new SimpleDateFormat("yyyy-MM-dd").format(new Date())
        def rootPath = rootPath1 + fileName
        def beginDate = params.beginDate
        def endDate = params.endDate
        def vEnum = MetaEnum.executeQuery("select enumId,name,metaDefine.id from MetaEnum")
        def nExcelColNum = 0
        def arrDataType = []
        def WhereDate = ''
        def sAddSql = ''
        def metaContentList = null
        if (!beginDate.equals("")) WhereDate += " and dateCreated >= '" + beginDate + "'";
        if (!endDate.equals("")) WhereDate += " and dateCreated <= '" + endDate + " 23:59:59'";
        if (!WhereDate.equals("")) sAddSql += " and a.program.id in (select id from nts.program.domain.Program where 1=1 " + WhereDate + ") ";

        if (exportFormat == 0) {
            def strSql = "select p.id,a.strContent,b.name,b.cnName,c.name from nts.program.domain.Program p,nts.meta.domain.MetaContent a,nts.meta.domain.MetaDefine b,nts.system.domain.Directory c where a.metaDefine.id=b.id and p.directory.id=c.id and p.id=a.program.id and c.id=${directoryId}" + sAddSql + "  order by p.id asc ";
            def list = Program.executeQuery(strSql)
            rootPath = rootPath.replace('//', '/')//单个字符可全替换
            File file1 = File.createTempFile(new Date().getTime().toString(), "xml");
            def writer = new FileWriter(file1)

            writer.write("<?xml version=\"1.0\" encoding=\"GBK\"?>\n");
            def xml = new MarkupBuilder(writer)

            def shu = 0
            def nPreProgId = 0
            def attsql = null
            def attlist = null
            def enumName = null
            xml.list() {
                list.each {
                    if (nPreProgId != it[0]) {
                        program(id: it[0], library: it[4]) { ->
                            it
                            attsql = "select strContent ,metaDefine.name,metaDefine.cnName ,metaDefine.dataType,numContent ,metaDefine.id,metaDefine.showType from nts.meta.domain.MetaContent where program.id = " + it[0]
                            attlist = MetaContent.executeQuery(attsql)
                            attlist.each {
                                if ((exportType == 1 && ((it[6] & 16) == 16)) || (exportType == 0)) {

                                    if (it[3].equals("enumeration")) {

                                        enumName = getEnumName(it[5], it[4], vEnum)

                                        attribute(name: it[1], cnName: it[2], enumName != "0" ? enumName : it[2])
                                    } else if (it[3].equals("number")) {
                                        attribute(name: it[1], cnName: it[2], it[4])
                                    } else {
                                        attribute(name: it[1], cnName: it[2], it[0])
                                    }
                                }
                            }

                            attribute(name: "description", cnName: "简介", isDescription ? CTools.htmlToBlank(Program.get(it[0]).description) : "")
                        }
                        nPreProgId = it[0]
                        shu++
                    }
                }
            }
            InputStream inputStream = new FileInputStream(file1);
            response.setContentType("application/octet-stream");
            response.setContentLength(inputStream.available())
            response.setHeader("Content-disposition", "attachment;filename=" + fileName);
            response.outputStream << inputStream
            result.message = "导出完成";
            //def sFileExt = CTools.getExtensionName(rootPath)
            //def port = BfConfig.getVideoPort()
            //if (port == null || port == '') port = '1680'
            //def videoHost = request.getServerName() + ":" + port
            //def url = "${BfConfig.getPlayProtocol()}://ADDR=${videoHost};UID=${session.consumer.name};PWD=${session.consumer.password};FILE=${rootPath};PN=${file};EXT=${sFileExt};PFG=2;"
            //def playUrl = "bfp://" + request.getServerName() + ":" + request.getServerPort() + "/pfg=d&enc=b&url=" + url.getBytes("GBK").encodeAsBase64().toString()

            //flash.message = "成功备份到：${rootPath}。" + "<a href=\"${playUrl}\"><font color=\"blue\">下载到本地</font></a>"
            //render(view: "exportExcelorXml", model: [directoryList: Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"]), directoryId: directoryId, endDate: endDate, beginDate: beginDate, isDescription: isDescription, exportFormat: exportFormat, exportType: exportType, rootPath: params.rootPath])
            //result.message = "成功备份到：${rootPath}。" + "<a href=\"${playUrl}\"><font color=\"blue\">下载到本地</font></a>";
            //result.putAll([directoryList: Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"]), directoryId: directoryId, endDate: endDate, beginDate: beginDate, isDescription: isDescription, exportFormat: exportFormat, exportType: exportType, rootPath: params.rootPath]);
        } else if (exportFormat == 1) {

            HSSFWorkbook workbook = new HSSFWorkbook();
            // 生成一个表格
            HSSFSheet sheet = workbook.createSheet("Excel");
            // 设置表格默认列宽度为15个字节
            sheet.setDefaultColumnWidth((short) 30);
            // 生成一个样式
            HSSFCellStyle style = workbook.createCellStyle();
            HSSFCell cell = null
            // 设置这些样式
            //style.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
            //style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
            style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
            style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
            style.setBorderRight(HSSFCellStyle.BORDER_THIN);
            style.setBorderTop(HSSFCellStyle.BORDER_THIN);
            style.setAlignment(HSSFCellStyle.ALIGN_CENTER);

            // 生成一个字体
            HSSFFont font = workbook.createFont();
            // font.setColor(HSSFColor.VIOLET.index);
            font.setFontHeightInPoints((short) 12);
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

            // 把字体应用到当前的样式
            style.setFont(font);

            //产生表格标题行
            HSSFRow row = sheet.createRow(0);
            //int nParentid=0,is_export=0,classid=0;

            HSSFRichTextString text = null;
            def nPreProgId = 0
            def curColNo = -1
            //第一列资源ID列设置：
            cell = row.createCell(0);

            cell.setCellStyle(style);
            text = new HSSFRichTextString("资源ID号");
            cell.setCellValue(text);
            nExcelColNum++;
            //其它列设置
            def criteria = MetaDefine.createCriteria()
            def excelList = criteria.list {
                or {
                    sizeEq("directorys", 0)
                    directorys {
                        eq('id', directoryId.toLong())
                    }
                }
                order("parentId", "asc")
            }

            for (int i = 0; i < excelList.size(); i++) {
                if (!excelList[i].dataType.equals("decorate")) {
                    arrDataType << excelList[i].id
                    cell = row.createCell((short) nExcelColNum);
                    cell.setCellStyle(style);
                    text = new HSSFRichTextString(excelList[i].cnName);
                    cell.setCellValue(text);
                    nExcelColNum++;
                }
            }
            cell = row.createCell((short) nExcelColNum);

            cell.setCellStyle(style);
            text = new HSSFRichTextString("资源简介");
            cell.setCellValue(text);

            def strSql = "select a.strContent,a.program.id ,a.metaDefine.id from nts.meta.domain.MetaContent a where a.program.directory.id=${directoryId} " + sAddSql + "  order by a.program.id asc ";
            def valuelist = MetaContent.executeQuery(strSql)
            def rowIndex = 1
            def attsql = null
            def attlist = null
            def enumName = null
            def program = null

            HSSFCellStyle style1 = workbook.createCellStyle();
            valuelist.each {
                if (nPreProgId != it[1]) {
                    row = sheet.createRow(rowIndex);
                    for (int j = 0; j <= arrDataType.size(); j++) row.createCell(j);
                    cell = row.getCell(0);
                    style1.setAlignment(HSSFCellStyle.ALIGN_CENTER);
                    cell.setCellStyle(style1);
                    cell.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell.setCellValue(new HSSFRichTextString(it[1] + ""))
                    nPreProgId = it[1];
                    rowIndex++;
                }
                attsql = "select strContent ,metaDefine.dataType,numContent ,metaDefine.id ,metaDefine.cnName ,metaDefine.showType from nts.meta.domain.MetaContent where program.id = " + it[1]
                attlist = MetaContent.executeQuery(attsql)
                attlist.each {
                    if ((exportType == 1 && ((it[5] & 16) == 16)) || (exportType == 0)) {
                        curColNo = getExcelColNo(it[3], arrDataType);
                        if (curColNo != -1) {
                            cell = row.getCell(curColNo);
                            cell.setCellType(HSSFCell.CELL_TYPE_STRING);
                            if (it[1].equals("enumeration")) {
                                enumName = getEnumName(it[3], it[2], vEnum)
                                cell.setCellValue(new HSSFRichTextString(enumName != "0" ? enumName : it[4] + ""))
                            } else if (it[1].equals("number")) {
                                cell.setCellValue(new HSSFRichTextString(it[2] + ""))
                            } else {
                                cell.setCellValue(new HSSFRichTextString(it[0] + ""))
                            }
                        }

                    }
                }

                program = Program.get(it[1])
                cell = row.createCell((short) nExcelColNum);
                text = new HSSFRichTextString(isDescription ? CTools.htmlToBlank(program.description) : '');
                cell.setCellValue(text);
            }
            File file1 = File.createTempFile(new Date().getTime().toString(), "xlsx");
            FileOutputStream fileOutputStream = new FileOutputStream(file1);
            workbook.write(fileOutputStream);
            InputStream inputStream = new FileInputStream(file1);
            response.setContentType("application/octet-stream");
            response.setContentLength(inputStream.available())
            response.setHeader("Content-disposition", "attachment;filename=" + fileName);
            response.outputStream << inputStream
            result.message = "导出完成";
            //FileOutputStream fileOutputStream = new FileOutputStream(rootPath);
            //workbook.write(fileOutputStream);
            //fileOutputStream.close();
            //def sFileExt = CTools.getExtensionName(rootPath)
            //def port = BfConfig.getVideoPort()
            //if (port == null || port == '') port = '1680'
            //def videoHost = request.getServerName() + ":" + port
            //def url = "${BfConfig.getPlayProtocol()}://ADDR=${videoHost};UID=${session.consumer.name};PWD=${session.consumer.password};FILE=${rootPath};PN=${file};EXT=${sFileExt};PFG=2;"
            //def playUrl = "bfp://" + request.getServerName() + ":" + request.getServerPort() + "/pfg=d&enc=b&url=" + url.getBytes("GBK").encodeAsBase64().toString()

            //flash.message = "成功备份到：${rootPath}。" + "<a href=\"${playUrl}\"><font color=\"blue\">下载到本地</font></a>"
            //render(view: "exportExcelorXml", model: [directoryList: Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"]), directoryId: directoryId, endDate: endDate, beginDate: beginDate, isDescription: isDescription, exportFormat: exportFormat, exportType: exportType, rootPath: params.rootPath])
            //result.message = "成功备份到：${rootPath}。" + "<a href=\"${playUrl}\"><font color=\"blue\">下载到本地</font></a>";
            //result.putAll([directoryList: Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"]), directoryId: directoryId, endDate: endDate, beginDate: beginDate, isDescription: isDescription, exportFormat: exportFormat, exportType: exportType, rootPath: params.rootPath])
        } else if (exportFormat == 2) {
            //oai-phm export code by jlf

            def directory = Directory.get(directoryId)

            ////////导入日期范围 start
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
            def startTime = "1900-01-01 23:59:59"
            def endTime = "2051-01-01 23:59:59"
            if (beginDate != "") startTime = beginDate + ' 00:00:01'
            if (endDate != "") endTime = endDate + ' 23:59:59'
            startTime = sdf.parse(startTime)
            endTime = sdf.parse(endTime)
            ////////导入日期范围 end

            ////////request host start
            def host = request.getServerName()
            if (request.getServerPort() != 80) host += ":" + request.getServerPort()
            ////////request host end

            ////////要导出的元数据 start
            def metaDefineList = MetaDefine.createCriteria().list {
                //eq("description", "Fred%")
                ne("description", "")
                or {
                    sizeLt("directorys", 1)
                    directorys {
                        eq("id", directory.id)
                    }
                }

                order("showOrder", "asc")
            }

            ////////要导出的元数据 end

            ////////要导出的资源 start
            def programList = Program.createCriteria().list {
                eq("directory", directory)
                between("dateCreated", startTime, endTime)
                order("id", "asc")
            }
            ////////要导出的资源 end

            rootPath = rootPath.replace('//', '/')//单个字符可全替换

            def writer = new FileWriter(new File(rootPath))
            writer.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
            def mB = new groovy.xml.MarkupBuilder(writer)

            mB.ListRecords() {
                for (p in programList) {

                    ////////要导出的metaContent start
                    metaContentList = MetaContent.createCriteria().list {
                        eq("program", p)
                        'in'("metaDefine", metaDefineList)
                    }
                    ////////要导出的metaContent end
                    mB.record() {
                        mB.header() {
                            identifier(p.id)
                            datestamp(p.dateCreated)
                            setSpec("共享工程")
                        }

                        mB.metadata() {
                            metaDefineList.each { metaDefine ->
                                metaContentList.each { metaContent ->
                                    if (metaContent.metaDefine == metaDefine) {
                                        def strData = ""
                                        if (MetaContent.numDataTypes.contains(metaDefine.dataType)) {
                                            if (metaDefine.dataType == "enumeration")
                                                strData = getEnumName(metaDefine.id, metaContent.numContent, vEnum)
                                            else
                                                strData = metaContent.numContent
                                        } else {
                                            strData = metaContent.strContent
                                        }
                                        "${metaDefine.description}"(strData)
                                    }
                                }
                            }

                            if (isDescription == "0") description(p.description)
                        }

                        mB.about() {
                            url("http://${host}/program/showProgram?id=${p.id}")
                        }

                    }
                }

            }

            def sFileExt = CTools.readExtensionName(rootPath)
            def port = BfConfig.getVideoPort()
            if (port == null || port == '') port = '1680'
            def videoHost = request.getServerName() + ":" + port
            def url = "${BfConfig.getPlayProtocol()}://ADDR=${videoHost};UID=${session.consumer.name};PWD=${session.consumer.password};FILE=${rootPath};PN=${file};EXT=${sFileExt};PFG=2;"
            def playUrl = "bfp://" + host + "/pfg=d&enc=b&url=" + url.getBytes("GBK").encodeAsBase64().toString()

            result.message = "成功备份到：${rootPath}。" + "<a href=\"${playUrl}\"><font color=\"blue\">下载到本地</font></a>"
            result.putAll([directoryList: Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"]), directoryId: directoryId, endDate: endDate, beginDate: beginDate, isDescription: isDescription, exportFormat: exportFormat, exportType: exportType, rootPath: params.rootPath])

        }
        return result;

    }
    //获得batch中program对象,用于处理多集
    def queryProgramFromList(programList, fromId) {
        if (programList == null) return null

        Program program = null

        for (int i = 0; i < programList.size(); i++) {
            if (programList[i].fromId == fromId) return programList[i]
        }

        return program
    }

    //获得元数据中文名称数组，如学科值：化学->无机化学:a[0]=化学 a[1]=无机化学
    def queryArrCnName(String title) {
        //{化学,无机化学)
        List arr = ["", ""];
        int nPos = 0;

        //防止用用户输入全角括号
        title = title.replace("－", "-");
        title = title.replaceAll("＞", ">");

        nPos = title.lastIndexOf("->");
        if (nPos > 0) {
            arr[0] = title.substring(0, nPos);
            arr[1] = title.substring(nPos + 2);
        }
        //有的没有二级学科，如：化学
        else {
            arr[0] = title;
            arr[1] = "0";
        }

        return arr;
    }


    //通过元数据ID,枚举ID获取枚举名称
    public String getEnumName(sMId, sEId, vEnum) {
        def MId = "0"
        def EId = "0"
        def name = "0"
        if (sEId == null || sEId == "")
            return ""
        vEnum.each {
            MId = it[2]
            EId = it[0]
            if (MId == sMId && EId == sEId) {
                name = it[1]
                return name
            }
        }
        return name;
    }

    //获得excel列序号
    public int getExcelColNo(sId, arr) {
        def meta_id = "";
        for (int i = 0; i < arr.size(); i++) {
            meta_id = arr[i];
            if (meta_id.equals(sId))
                return i + 1;//第一列是节目ID，没放在数组里。
        }

        return -1;
    }


    //获得 标题列中元数据ID，标题列形如：资源原名(8)
    public int queryMetaId(String title) {
        def id = 0;
        def nPos = 0;

        //防止用用户输入全角括号
        title = title.replace('（', '(');
        title = title.replaceAll('）', ')');

        nPos = title.lastIndexOf('(');
        if (nPos > 0) {
            id = title.substring(nPos + 1, (title.length() - 1)).toInteger();
        }

        return id
    }



}
