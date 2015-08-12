package nts.front.index.controllers

import com.boful.common.file.utils.FileType
import com.boful.nts.utils.SystemConfig
import com.sun.xml.internal.messaging.saaj.packaging.mime.internet.MimeUtility
import grails.converters.JSON
import nts.note.domain.ProgramNote
import nts.program.category.domain.CategoryFacted
import nts.program.category.domain.FactedValue
import nts.program.category.domain.ProgramCategory
import nts.program.domain.*
import nts.system.domain.*
import nts.user.domain.Consumer
import nts.user.services.ActionNameAnnotation
import nts.user.services.ControllerNameAnnotation
import nts.utils.CTools
import org.apache.http.HttpEntity
import org.apache.http.HttpResponse
import org.apache.http.client.HttpClient
import org.apache.http.client.methods.HttpGet
import org.apache.http.impl.client.HttpClientBuilder

import java.text.DecimalFormat

//规范：文件名，闭包名：单词尽量不用缩写，动词＋名词 形容词＋名词 名词＋名词
@ControllerNameAnnotation(name = "普通资源")
class ProgramController {
    def programService;
    def userService;
    def searchService;
    def programCategoryService;
    ////////////////////////资源制作开始
    // the delete, save and update actions only accept POST requests
    def static allowedMethods = [save: 'POST', update: 'POST']

    //验证点播或下载权限
    def checkAuthority() {
        def program = Program.get(params.programId as Long)
        def result = '';
        if (params.type) {
            result = programService.canPlay(session.consumer, program)
        } else {
            result = programService.canDownload(session.consumer, program)
        }
        return render(result);
    }


    @ActionNameAnnotation(name = "资源首页")
    def programIndex() {
        //资源排行
        def zyphList = programService.search([state: Program.PUBLIC_STATE, canPublic: true, max: 8, order: "desc", orderBy: "dateCreated"], false);
        //热门资源
        def remenList = programService.search([state: Program.PUBLIC_STATE, canPublic: true, max: 8, order: "desc", orderBy: "frequency"], false);
        //推荐熟
        def tuijianList = programService.search([otherOption: Program.ONLY_VIDEO_OPTION, state: Program.PUBLIC_STATE, canPublic: true, max: 12, order: "desc", orderBy: "recommendNum"], false);
        //文档排行
        def wendangList = programService.search([otherOption: Program.ONLY_TXT_OPTION, state: Program.PUBLIC_STATE, canPublic: true, max: 6, offset: 0, order: "desc", orderBy: "recommendNum"], false);
        // 二级分类目录获取
        List<ProgramCategory> categoryList = programCategoryService.querySubCategory(programCategoryService.querySuperCategory());
        def programList = [];
        def tmpMap = [:];

        List<Program> list = new ArrayList<Program>();
        def programTotal = 0;
        List<ProgramCategory> categoryList2 = new ArrayList<ProgramCategory>();
        categoryList?.each { ProgramCategory category ->
            tmpMap = [:];
            list = new ArrayList<Program>();
            if (category.isDisplay == 0 && category.mediaType != 0) { //资源分类为显示状态
                tmpMap.categoryId = category.id;
                tmpMap.categoryName = category.name;
                tmpMap.categoryType = category.mediaType;
                categoryList2 = programCategoryService.querySubCategory(category);
                def categoryList3 = programCategoryService.querySubAllCategory(category);
                if (categoryList3) {
                    categoryList3.add(category);
                } else {
                    categoryList3 = [];
                    categoryList3.add(category);
                }

                def rsMap = programService.queryProgramByCategory(categoryList3, category);
                tmpMap.programList = rsMap.programList;
                tmpMap.programTotal = rsMap.programTotal;
                tmpMap.categoryList = categoryList2;
                programList.add(tmpMap);
            }
        }

/*

        //视频
        List<Program> videoList2 = programService.search([otherOption: Program.ONLY_VIDEO_OPTION, state: Program.PUBLIC_STATE, canPublic: true, max: 7, order: "desc", sort: "dateCreated"], false);
        //图片集合
        List<Program> photoList2 = programService.search([otherOption: Program.ONLY_IMG_OPTION, state: Program.PUBLIC_STATE, canPublic: true, max: 7, order: "desc", orderBy: "dateCreated"], false);
        //文档排行
        List<Program> docList2 = programService.search([otherOption: Program.ONLY_TXT_OPTION, state: Program.PUBLIC_STATE, canPublic: true, max: 10, order: "desc", orderBy: "dateCreated"], false);
        //共享课程排行
        List<Program> publicList = programService.search([otherOption: Program.ONLY_LESSION_OPTION, state: Program.PUBLIC_STATE, canPublic: true, max: 7, order: "desc", orderBy: "dateCreated"], false);
        //图片集合数量
        def photoTotal = Program.createCriteria().list() {
            eq("state", Program.PUBLIC_STATE)
            eq("transcodeState", Program.STATE_SUCCESS)
            and {
                eq("otherOption", Program.ONLY_IMG_OPTION)
                notEqual("otherOption", Program.ONLY_LESSION_OPTION);
            }
        }.size();
        //Program.countByOtherOptionNotEqualAndStateAndTranscodeStateAnd(Program.ONLY_LESSION_OPTION,Program.PUBLIC_STATE,Program.STATE_SUCCESS);
        //视频集合数量
        def videoTotal = Program.createCriteria().list() {
            eq("state", Program.PUBLIC_STATE)
            eq("transcodeState", Program.STATE_SUCCESS)
            and {
                eq("otherOption", Program.ONLY_VIDEO_OPTION)
                notEqual("otherOption", Program.ONLY_LESSION_OPTION);
            }
        }.size();
        //Program.countByOtherOptionAndStateAndTranscodeState(Program.ONLY_VIDEO_OPTION,Program.PUBLIC_STATE,Program.STATE_SUCCESS);
        //文档集合数量
        def docTotal = Program.createCriteria().list() {
            eq("state", Program.PUBLIC_STATE)
            eq("transcodeState", Program.STATE_SUCCESS)
            and {
                eq("otherOption", Program.ONLY_TXT_OPTION)
                notEqual("otherOption", Program.ONLY_LESSION_OPTION);
            }
        }.size();
        //Program.countByOtherOptionAndStateAndTranscodeState(Program.ONLY_TXT_OPTION,Program.PUBLIC_STATE,Program.STATE_SUCCESS);
        //音频素材数量
        def audioSum = Program.createCriteria().list() {
            eq("state", Program.PUBLIC_STATE)
            eq("transcodeState", Program.STATE_SUCCESS)
            and {
                eq("otherOption", Program.ONLY_AUDIO_OPTION)
                notEqual("otherOption", Program.ONLY_LESSION_OPTION);
            }
        }.size();
        //Program.countByOtherOptionAndStateAndTranscodeState(Program.ONLY_AUDIO_OPTION,Program.PUBLIC_STATE,Program.STATE_SUCCESS);
        //programService.audioSum();
        //公开课程数量
        def publicTotal = Program.countByOtherOptionAndStateAndTranscodeState(Program.ONLY_LESSION_OPTION, Program.PUBLIC_STATE, Program.STATE_SUCCESS)
        //音频热门分类
        def audioTypeOne = programService.audioTypeListTop10();
        //音频最新10条资源
        def newTop10 = programService.newTop10();
        def publicName = programCategoryService.queryCourseCategoryName();
        def publicList2 = programCategoryService.querySubCategory(programCategoryService.queryCourseCategory());
        //获取视频名称
        def videoName = programCategoryService.queryVideoCategoryName();
        // 获取视频2级目录
        def videoCategory2List = programCategoryService.querySubCategory(programCategoryService.queryVideoCategory())
        // 获取音频名称
        def audioName = programCategoryService.queryAudioCategoryName();
        // 获取文档名称
        def docName = programCategoryService.queryDocCategoryName();
        // 获取文档2级目录
        def docCategory2List = programCategoryService.querySubCategory(programCategoryService.queryDocCategory())
        // 获取图片名称
        def photoName = programCategoryService.queryPhotoCategoryName();
        // 获取图片2级目录
        def photoCategory2List = programCategoryService.querySubCategory(programCategoryService.queryImageCategory())*/
        return render(view: "programIndex", model: [/*studyTotal: studyTotal, */ remenList: remenList, zyphList: zyphList, tuijianList: tuijianList, wendangList: wendangList, programList: programList/*,
                                                    publicName : publicName, publicList2: publicList2, publicList: publicList, publicTotal: publicTotal, photoTotal: photoTotal, videoTotal: videoTotal, docTotal: docTotal,
                                                    docList    : docList2, photoList: photoList2, videoList: videoList2, *//*publicLession: publicLession,*//*
                                                    audioSum   : audioSum, audioTypeOne: audioTypeOne, newTop10: newTop10, videoName: videoName, audioName: audioName, docName: docName, photoName: photoName, videoCategory2List: videoCategory2List, docCategory2List: docCategory2List, photoCategory2List: photoCategory2List*/])
    }

    def downloadSharing() {

        //consumer的downlaodnum增加1
        if (session.consumer) {
            def consumer = Consumer.get(session.consumer.id)
            consumer.downloadNum += 1
            consumer.save()
        }

        if(params.serialId) {
            def serialId = params.serialId;
            if(CTools.isNumber(serialId)) {
                Serial serial = Serial.get(serialId as Long);

                if (serial) {
                    def program = Program.get(serial.program.id)
                    if (program) {
                        program.downloadNum += 1
                        program.save()
                        new OperationLog(tableName: 'program', tableId: program.id, operator: session.consumer.name, operatorIP: request.getRemoteAddr(),
                                modelName: '下载资源', brief: program.name, operatorId: session.consumer.id, operation: OperationEnum.DOWNLOAD_PROGRAM).save(flush: true)
                    }
                }

                String videoSevr = servletContext.getAttribute("videoSevr");
                String videoPort = servletContext.getAttribute("videoPort");    //视频服务器端口
                String url = "http://" + videoSevr + ":" + videoPort + "/bmc2/api/download?fileHash=" + serial.fileHash;

                def fileName = serial.name;
                def userAgent = request.getHeader("User-Agent");
                def newFileName = URLEncoder.encode(fileName, "UTF-8");
                def rtn = "filename=\"" + newFileName + "\"";
                if (userAgent != null) {
                    userAgent = userAgent.toLowerCase();
                    // IE浏览器，只能采用URLEncoder编码
                    if (userAgent.indexOf("msie") != -1) {
                        rtn = "filename=\"" + newFileName + "\"";
                    } // Opera浏览器只能采用filename*
                    else if (userAgent.indexOf("opera") != -1) {
                        rtn = "filename*=UTF-8''" + newFileName;
                    }
                    // Safari浏览器，只能采用ISO编码的中文输出
                    else if (userAgent.indexOf("safari") != -1) {
                        rtn = "filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO8859-1") + "\"";
                    }
                    // Chrome浏览器，只能采用MimeUtility编码或ISO编码的中文输出
                    else if (userAgent.indexOf("applewebkit") != -1) {
                        newFileName = MimeUtility.encodeText(fileName, "UTF8", "B");
                        rtn = "filename=\"" + newFileName + "\"";
                    }
                    // FireFox浏览器，可以使用MimeUtility或filename*或ISO编码的中文输出
                    else if (userAgent.indexOf("mozilla") != -1) {
                        rtn = "filename*=UTF-8''" + newFileName;
                    }

                }

                HttpClient client = HttpClientBuilder.create().build();
                HttpGet getMethod = new HttpGet(url);
                getMethod.setHeader("Referer", "http://192.168.1.0")
                HttpResponse httpResponse = client.execute(getMethod);
                HttpEntity httpEntity = httpResponse.getEntity()
                InputStream inputStream = httpResponse.getEntity().getContent()
                response.setContentType("application/octet-stream")
                response.setHeader("Content-disposition", "attachment;" + rtn);

                //以指定的文件名作为附件返回到前台，供下载，
                //前台发起的请求形式为：window.location.href = "actionName" 或 <a href ="actionName"></a> 点击
                response.outputStream << inputStream
            } else {
                return render(view: '/error500');
            }
        } else {
            return render(view: '/error500');
        }

    }

    @ActionNameAnnotation(name = "课程点播")
    //开放课程点播
    def lessionProgram() {
        def otherSerialTotal = 0;
        if (!params.offset) params.offset = '0';
        if (!params.max) params.max = '5';
        def serialId = params.serialId;
        int ids;
        if (serialId instanceof String) {
            ids = params.serialId as Long;
        } else {
            ids = params.serialId;
        }
        Serial serial = Serial.get(ids);
        List<Serial> otherSerial = null;
        otherSerial = Serial.createCriteria().list(offset: params.offset, max: params.max) {
            eq("program", serial.program)
            notEqual("urlType", Serial.URL_TYPE_VIDEO)
            order("serialNo", "asc")
        }
        otherSerialTotal = otherSerial.totalCount;
        if (FileType.isDocument(serial.filePath) || serial.filePath.endsWith(".pdf") || serial.filePath.endsWith(".PDF")) {
            params.playType = "document";
        } else if (FileType.isImage(serial.filePath)) {
            params.playType = "image";
        } else if (FileType.isAudio(serial.filePath)) {
            params.playType = "audio";
        } else if (serial.filePath.endsWith("swf") || serial.filePath.endsWith("SWF")) {
            params.playType = "flash";
        }
        params.id = serial.id;
        params.fileHash = serial.fileHash;

        return render(view: 'lessionDocument', model: [serial: serial, program: serial.program, otherSerial: otherSerial, params: params, otherSerialTotal: otherSerialTotal]);
    }


    @ActionNameAnnotation(name = "普通资源点播")
    //资源详细页面
    def showProgram() {
        try {
            long t1 = System.currentTimeMillis()
            if(params.id) {
                if(CTools.isNumber(params.id)) {
                    def program = Program.get(params.id as Long)

                    if (program?.serials?.size() == 0) {
                        return render(program?.name + "下没有子资源")
                    } else {
                        if (session.consumer && params.id) {
                            def result = programService.canPlay(session.consumer, Program.get(params.id as Long))
                            if (!result) {
                                def errorMsg = ''
                                if ((program.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                                    errorMsg = '对不起，您没有权限学习该课程！'
                                } else {
                                    errorMsg = '对不起，您没有权限点播该资源！'
                                }
                                return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
                            } else {
                                //修改时长
                                if (program) {
                                    if (servletContext.isCon != "false") {
//                                programService.fixTimeLength(program, servletContext);
                                        program.frequency += 1;
                                    }
                                    program.viewNum += 1
                                    program.save(flush: true)
                                }
                                def programList = null
                                def consumerList = null
                                def otherProgramList = null
                                def remarkList = null
                                def bAuthOK = true    //是否认证通过
                                def fromNodeName = ""
                                def fromNode = null    //来源节点
                                def isOutPlay = false    //是否来自外部播放，此专指用省图下级节点播放
                                def arrOutPlay = null    //福建省图采集外部(子节点):0海报 1播放列表 2批量播放列表
                                def topProgramList = null    //当前类库排行

                                if ((program.otherOption & Program.ONLY_IMG_OPTION) == Program.ONLY_IMG_OPTION) {
                                    return redirect(action: 'playPhoto', params: [programId: program.id])
                                } else if ((program.otherOption & Program.ONLY_TXT_OPTION) == Program.ONLY_TXT_OPTION) {
                                    return redirect(action: 'playDocument', params: [programId: program.id])
                                } else if ((program.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                                    return redirect(controller: 'program', action: 'courseDetail', params: [programId: program.id])
                                } else if ((program.otherOption & Program.ONLY_AUDIO_OPTION) == Program.ONLY_AUDIO_OPTION) {
                                    return redirect(action: 'playAudio', params: [programId: program.id])
                                } else if ((program.otherOption & Program.ONLY_FLASH_OPTION) == Program.ONLY_FLASH_OPTION) {
                                    return redirect(action: 'playFlash', params: [programId: program.id])
                                } else if ((program.otherOption & 0) == 0) {
                                    return redirect(action: 'playVideo', params: [programId: program.id])
                                }
                                if (program.serials.size() > 0) {
                                    Serial serial = programService.serialFirst(program);
                                    if (serial.urlType == Serial.URL_TYPE_LINK) {
                                        return redirect(url: serial.filePath);
                                    }
                                }

                                ////////////////////////没有登录的作为匿名用户 开始
                                if (!session.consumer) {
                                    def consumer = Consumer.findByName(servletContext.anonymityUserName)
                                    //判断用户是否是锁定状态
                                    if (consumer) {
                                        if (!consumer.userState) {
                                            redirect(controller: 'index', action: 'loginError', params: [loginFlg: 4])
                                            return
                                        }
                                        session.consumer = consumer
                                    } else {
                                        redirect(controller: 'index', action: 'loginError', params: [loginFlg: 1])
                                        return
                                    }
                                }
                                ////////////////////////没有登录的作为匿名用户 结束


                                if (program) {

                                    if (bAuthOK) {
                                        //点播了此资源的用户 ViewedProgram记得改为PlayedProgram
                                        //consumerList = nts.program.domain.ViewedProgram.findAllByProgram(program,[max:24])?.consumer.unique()
                                        //consumerList = nts.program.domain.PlayedProgram.executeQuery( "select distinct a.consumer from nts.program.domain.PlayedProgram a where a.program = :program", [program:program], [max:24] )

                                        //点播了此资源的用户还点播了 为了效率只查询5个用户的点播记录 ViewedProgram记得改为PlayedProgram
                                        //nts.system.domain.Message: 不能以 DISTINCT 方式选择 text、ntext 或 image 数据类型。
                                        //if(consumerList) otherProgramList = nts.program.domain.PlayedProgram.executeQuery( "select distinct a.program from nts.program.domain.PlayedProgram a where a.program.state >= :state and a.program != :program and a.consumer in (:consumers)", [state:nts.program.domain.Program.PUBLIC_STATE,program:program,consumers:consumerList.size()<6?consumerList:consumerList.getAt(1..5)], [max:24] )
                                        if (false && consumerList) {
                                            def otherProgramIdList = PlayedProgram.executeQuery("select distinct a.program.id from nts.program.domain.PlayedProgram a where a.program.state >= :state and a.program != :program and a.consumer in (:consumers)", [state: Program.PUBLIC_STATE, program: program, consumers: consumerList.size() < 6 ? consumerList : consumerList.getAt(1..5)], [max: 24])
                                            //println otherProgramIdList
                                            if (otherProgramIdList && otherProgramIdList.size() > 0) otherProgramList = Program.getAll(otherProgramIdList)

                                            //otherProgramList
                                        }

                                        //考虑到评论可能很多并可能要分页，故没用program.remarks
                                        remarkList = Remark.findAllByProgramAndIsPass(program, true, [max: 20, sort: 'id', order: 'desc'])

                                        //插入到浏览历史表并设置浏览次数if(session.consumer && session.consumer.name != 'anonymity')
                                        if (session.consumer && servletContext.viewLogOpt == 1) {
                                            new ViewedProgram(consumer: session.consumer, program: program).save()
                                            def consumerTemp = Consumer.get(session.consumer.id)
                                            consumerTemp.viewNum++
                                            consumerTemp.save(flush: true)
                                        }
                                        //program.viewNum++
                                        //program.save(flush: true)

                                        //来源下级节点
                                        fromNodeName = CTools.nullToBlank(program.fromNodeName).trim()
                                        if (fromNodeName != "") {
                                            //fromNode = nts.system.domain.ServerNode.findByNameAndGrade(fromNodeName,nts.system.domain.ServerNode.GRADE_CHILD);
                                            //原来是下级节点，后采集播放热门的自动进入分发表，改为不分上下级
                                            fromNode = ServerNode.findByName(fromNodeName);
                                            if (fromNode && program.fromId > 0 && program?.serials.size() < 1) isOutPlay = true

                                            if (isOutPlay) {
                                                def outUrl = "http://${fromNode.ip}:${fromNode.webPort}/nts/program/showProgram?id=${program.fromId}"
                                                arrOutPlay = getArrOutPlay(outUrl)
                                            }
                                        }

                                        topProgramList = Program.findAllByStateAndDirectory(Program.PUBLIC_STATE, program.directory, [max: 10, sort: 'frequency', order: 'desc']);
                                        //视频排行
                                        //视频
                                        def videoList = Program.createCriteria().list(max: 5, order: "desc") {
                                            serials {
                                                eq("urlType", Serial.URL_TYPE_VIDEO)
                                            }

                                        }
                                        List<Serial> serialList = program.serials.toList();
                                        serialList.sort {
                                            serial1, serial2 ->
                                                serial1.serialNo <=> serial2.serialNo
                                        }
                                        return render(view: 'videoShow', model: [serialList: serialList, videoList: videoList, program: program, consumerList: consumerList, otherProgramList: otherProgramList, remarkList: remarkList, fromNode: fromNode, isOutPlay: isOutPlay, arrOutPlay: arrOutPlay, topProgramList: topProgramList, t1: t1])
                                    }
                                } else {
                                    flash.message = "program not found with id ${params.id}"
                                    render "program not found with id ${params.id}"
                                }
                            }
                        } else {
                            def errorMsg = "对不起，您还没有登陆！"
                            return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
                        }

                    }
                } else {
                    return render("${params.id} 参数类型不正确");
                }
            } else {
                return render("参数不全");
            }
        } catch (Exception e) {
            log.error(e.message, e);
            return redirect(uri: '/index/error')
        }
    }

    def videoShow = {
        Program program = Program.get(params.programId)
        if (program) {
            //视频
            def videoList = Program.findAllByState(Program.PUBLIC_STATE, [max: 5, sort: 'recommendNum', order: 'desc'])

            List<Serial> serialList = program.serials.toList();
            serialList.sort {
                serial1, serial2 ->
                    serial1.serialNo <=> serial2.serialNo
            }
            return render(view: 'videoShow', model: [program: program, videoList: videoList, serialList: serialList]);
        }

    }

    //插入到点播历史表
    def addPlayedProgram = {
        def program = Program.get(params.programId)
        if (session.consumer && servletContext.playLogOpt == 1) {
            new PlayedProgram(consumer: session.consumer, program: program).save()
            Consumer.get(session.consumer.id).playNum++
        }
        program.frequency++
        render ""
    }

    //Flash播放
    def playFlash() {
        Serial serial = null;
        Program program = null;
        try {
            if (params.programId) {
                program = Program.get(params.programId as Long);
                if (program?.serials?.size() == 0) {
                    return render(program?.name + "下没有子资源")
                }
                if (program) {
                    if (program.serials.size() > 0) {
                        serial = programService.serialFirst(program);
                    }
                } else {
                    return render("对不起,你所要查找的数据不存在!");
                }
            } else if (params.id) {
                serial = Serial.get(params.id as Long);
                if (serial) {
                    program = serial.program;
                }
            } else {
                return render("对不起,你所要查找的数据不存在!");
            }


            if (!program) {
                def errorMsg = '点播的资源不存在！'
                return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
            }
            def result;
            if (params.programId) {
                result = programService.canPlay(session.consumer, Program.get(params.programId as Long))
            } else if (params.id) {
                if (program) {
                    result = programService.canPlay(session.consumer, program)
                }
            }

            if (!result) {
                def errorMsg = ''
                if ((program.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                    errorMsg = '对不起，您没有权限学习该课程！'
                } else {
                    errorMsg = '对不起，您没有权限点播该资源！'
                }
                return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
            }
            List states = new ArrayList();
            states.add(Serial.NO_NEED_STATE);
            states.add(Serial.CODED_STATE);
            List<Serial> serialList2 = Serial.createCriteria().list(order: 'asc', sort: 'serialNo') {
                eq('program', program)
                'in'("state", states.toArray())
            }
            def lastTime = -1;
            PlayedProgram playedProgram = null;
            if (session.consumer && session.consumer.name != 'anonymity') {
                Consumer consumer = Consumer.findById(session.consumer.id);
                consumer.playNum++;
                consumer.save();
                playedProgram = PlayedProgram.findByProgramAndSerialAndConsumer(program, serial, consumer);
                if (playedProgram) {
                    lastTime = playedProgram.timeLength;
                }
            }

            //确认用户是否有下载权限
            boolean isCanDownload = programService.canDownload(session.consumer, program);

            return render(view: 'playFlash', model: [isCanDownload: isCanDownload, serialList: serialList2, serial: serial, program: serial.program, lastTime: lastTime]);
        } catch (Exception e) {
            log.error(e.message, e);
            return redirect(uri: '/index/error')
        }
    }

    def playVideo() {
        Serial serial = null;
        Program program = null;
        try {
            if (params.programId) {
                program = Program.get(params.programId as Long);
                if (program?.serials?.size() == 0) {
                    return render(program?.name + "下没有子资源")
                }
                if (program) {
                    if (program.serials.size() > 0) {
                        serial = programService.serialFirst(program);
                    }
                } else {
                    return render("对不起,你所要查找的数据不存在!");
                }
            } else if (params.id) {
                serial = Serial.get(params.id as Long);
                if (serial) {
                    program = serial.program;
                }
            } else {
                return render("对不起,你所要查找的数据不存在!");
            }


            if (!program) {
                def errorMsg = '点播的资源不存在！'
                return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
            }
            def result;
            if (params.programId) {
                result = programService.canPlay(session.consumer, Program.get(params.programId as Long))
            } else if (params.id) {
                if (program) {
                    result = programService.canPlay(session.consumer, program)
                }
            }

            if (!result) {
                def errorMsg = ''
                if ((program.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                    errorMsg = '对不起，您没有权限学习该课程！'
                } else {
                    errorMsg = '对不起，您没有权限点播该资源！'
                }
                return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
            }

            List states = new ArrayList();
            states.add(Serial.NO_NEED_STATE);
            states.add(Serial.CODED_STATE);
            List<Serial> serialList2 = Serial.createCriteria().list(order: 'asc', sort: 'serialNo') {
                eq('program', program)
                'in'("state", states.toArray())
            }
            def lastTime = -1;
            PlayedProgram playedProgram = null;
            if (session.consumer && session.consumer.name != 'anonymity') {
                Consumer consumer = Consumer.findById(session.consumer.id);
                consumer.playNum++;
                consumer.save();
                playedProgram = PlayedProgram.findByProgramAndSerialAndConsumer(program, serial, consumer);
                if (playedProgram) {
                    lastTime = playedProgram.timeLength;
                }
            }
            def videoList = []; //视频排行
            def relationProgram = []; //相关资源
            states = new ArrayList();
            states.add(Program.STATE_SUCCESS_PART);
            states.add(Program.STATE_SUCCESS);
            def idList = Program.createCriteria().list(max: 5, sort: 'recommendNum', order: 'desc') {
                //if (userService.judeAnonymity()) {
                eq('canPublic', true);
                //}
                eq("state", Program.PUBLIC_STATE)
                'in'('transcodeState', states.toArray())
                serials {
                    eq("urlType", Serial.URL_TYPE_VIDEO)
                }
                distinct('id')
            }
            idList.each {
                videoList.add(Program.get(it));
            }

            //相关资源取得
            if (servletContext.searchEnable) {
                int max = 5;
                int offset = 0;
                def rs = searchService.searchRelationProgram(offset, max, program?.name, "id", "desc");
                if (rs && rs.size() > 0) {
                    relationProgram = rs.modelList;
                }
            } else {
                relationProgram = Program.createCriteria().list(max: 5, sort: 'id', order: 'desc') {
                    notEqual('id', program.id)
                    like('name', "%" + program.name + "%")
                    like('description', "%" + program.name + "%")
                    eq('canPublic', true);
                    eq("state", Program.PUBLIC_STATE)
                    'in'('transcodeState', states.toArray())
                };
            }

            //确认用户是否有下载权限
            boolean isCanDownload = programService.canDownload(session.consumer, program);

            return render(view: 'videoShow', model: [isCanDownload: isCanDownload, serialList2: serialList2, serialList: serialList2, serial: serial, program: serial.program, videoList: videoList, relationProgram: relationProgram, lastTime: lastTime]);
        } catch (Exception e) {
            log.error(e.message, e);
            return redirect(uri: '/index/error')
        }
    }

    def playPhoto() {
        def program = Program.get(params.programId);

        def result = programService.canPlay(session.consumer, Program.get(params.programId as Long))
        if (!result) {
            def errorMsg = ''
            if ((program.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                errorMsg = '对不起，您没有权限学习该课程！'
            } else {
                errorMsg = '对不起，您没有权限点播该资源！'
            }
            return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
        }

        Serial serial = programService.serialFirst(program);
        if (!serial) {
            return render(text: '文件列表为空！请联系管理员！');
        }
        if (session.consumer && session.consumer.name != 'anonymity') {
            Consumer consumer = Consumer.findById(session.consumer.id);
            PlayedProgram playedProgram = PlayedProgram.findByProgramAndSerialAndConsumer(program, serial, consumer);
            if (!playedProgram) {
                playedProgram = new PlayedProgram();
                playedProgram.consumer = consumer;
                playedProgram.serial = serial;
                playedProgram.program = program;
                playedProgram.timeLength = 0;
                consumer.playedPrograms.add(playedProgram);
                consumer.playNum++;
                consumer.save(flush: true);
            }
        }
        program.save(flush: true);
        List<Remark> remarkList = Remark.createCriteria().list(sort: 'dateCreated', order: 'desc') {
            eq('program', program)
        }
        List states = new ArrayList();
        states.add(Serial.NO_NEED_STATE);
        states.add(Serial.CODED_STATE);
        List<Serial> serialList = Serial.createCriteria().list(order: 'asc', sort: 'serialNo') {
            eq('program', program)
            'in'("state", states.toArray())
        }
//        if (serial.fileType) {
//            if (FileType.VIDEO_TYPES.contains(serial.fileType.toLowerCase())) {
//                return render(view: 'videoShow', model: [serial: serial, program: serial.program, serialList: serialList]);
//            } else if (FileType.AUDIO_TYPES.contains(serial.fileType.toLowerCase())) {
//                return render(view: 'videoShow', model: [serial: serial, program: serial.program, serialList: serialList]);
//            } else if (FileType.DOCUMENT_TYPE.contains(serial.fileType.toLowerCase())) {
//                return render(view: 'playDocument', model: [serial: serial, program: serial.program, serialList: serialList]);
//            } else if (FileType.IMAGE_TYPES.contains(serial.fileType.toLowerCase())) {
//                return render(view: 'playPhoto', model: [serial: serial, program: program, remarkList: remarkList, serialList: serialList]);
//            }
//        }
        return render(view: 'playPhoto', model: [serial: serial, serials: program.serials, program: program, remarkList: remarkList, serialList: serialList]);
    }

    def playDocument() {
        PlayedProgram playedProgram = null;
        Program program = null;
        def result = null;
        def remarks = null;
        def hotPrograms = null;
        Serial serial = null;

        if (params.programId) {
            def prom = Program.get(params.programId as Long);
            result = programService.canPlay(session.consumer, prom);
            if (!result) {
                def errorMsg = ''
                if ((prom.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                    errorMsg = '对不起，您没有权限学习该课程！'
                } else {
                    errorMsg = '对不起，您没有权限点播该资源！'
                }
                return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
            }

            serial = programService.serialFirst(prom);

        } else if (params.id) {
            serial = Serial.findById(params.id);
            program = Program.get(serial.program.id);
            result = programService.canPlay(session.consumer, program);
            if (!result) {
                def errorMsg = ''
                if ((prom.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                    errorMsg = '对不起，您没有权限学习该课程！'
                } else {
                    errorMsg = '对不起，您没有权限点播该资源！'
                }
                return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
            }
        }

        if (!serial) {
            return render(text: '文件列表为空！请联系管理员！');
        }
        program = Program.get(serial.program.id);
        if (session.consumer && session.consumer.name != 'anonymity') {
            Consumer consumer = Consumer.findById(session.consumer.id);
            consumer.playNum++;
            consumer.save();
            playedProgram = PlayedProgram.findByProgramAndSerialAndConsumer(program, serial, consumer);
        }

        //评论
        remarks = Remark.createCriteria().list {
            eq("program", program)
            order("dateCreated", "desc")
        }
        List states = new ArrayList();
        states.add(Program.STATE_SUCCESS);
        states.add(Program.STATE_SUCCESS_PART);
        //热门文档
        hotPrograms = Program.createCriteria().list {
            if (userService.judeAnonymity()) {
                eq('canPublic', true);
            }
            serials {
                eq("urlType", Serial.URL_TYPE_DOCUMENT)
            }
            notEqual("otherOption", Program.ONLY_LESSION_OPTION)
            eq("state", Program.PUBLIC_STATE)
            'in'('transcodeState', states.toArray())
            order("viewNum", "desc")
            setMaxResults(10)
        }

        states = new ArrayList();
        states.add(Serial.NO_NEED_STATE);
        states.add(Serial.CODED_STATE);
        List<Serial> serialList = Serial.createCriteria().list(order: 'asc', sort: 'serialNo') {
            eq('program', program)
            'in'("state", states.toArray())
        }
//        if (serial.fileType) {
//            if (FileType.VIDEO_TYPES.contains(serial.fileType.toLowerCase())) {
//                return render(view: 'videoShow', model: [serialList: serialList, playedProgram: playedProgram, serial: serial, program: serial.program]);
//            } else if (FileType.AUDIO_TYPES.contains(serial.fileType.toLowerCase())) {
//                return render(view: 'videoShow', model: [serialList: serialList, playedProgram: playedProgram, serial: serial, program: serial.program]);
//            } else if (FileType.DOCUMENT_TYPE.contains(serial.fileType.toLowerCase())) {
//                return render(view: 'playDocument', model: [serialList: serialList, playedProgram: playedProgram, serial: serial, program: serial.program, remarks: remarks, hotPrograms: hotPrograms]);
//            } else if (FileType.IMAGE_TYPES.contains(serial.fileType.toLowerCase())) {
//                return render(view: 'playPhoto', model: [serialList: serialList, playedProgram: playedProgram, serial: serial, program: program]);
//            }
//        }
        return render(view: 'playDocument', model: [serialList: serialList, playedProgram: playedProgram, serial: serial, program: serial.program, remarks: remarks, hotPrograms: hotPrograms]);
    }

    //功能:批量播放和点播日志记录
    def playProgram = {
        def program = null
        def isPlay = true
        def isBatchPlay = true
        def urlType = 0
        def sPlayCode = ""
        def result = ""
        def webHost = request.getServerName() + ":" + request.getServerPort()
        boolean isOutHost = false    //是否是外部节点采集本节点数据播放

        program = Program.get(params.programId)
        isPlay = CTools.nullToOne(params.isPlay) == 1
        isBatchPlay = CTools.nullToOne(params.urlType) == -1
        isOutHost = CTools.nullToOne(params.isOutHost) == 1

        if (program) {

            def pwd = (servletContext.authPrefix + session?.consumer?.name + servletContext.authPostfix).encodeAsMD5()
            //sPlayCode = "LoginDirect('${session?.consumer?.name?.encodeAsJavaScript()}','${pwd.encodeAsJavaScript()}');"

            if (isBatchPlay) {
                //可以获得播放列表的webservice地址
                def serialIdList = CTools.nullToBlank(params.serialIdList)
                def url = "http://${webHost}/nts/serial/showSerials?UID=${session?.consumer?.name}&PWD=${pwd}&programId=${program.id}&subIdList=${serialIdList}"
                def playUrl = "bfp://" + webHost + "/pfg=l&enc=b&url=" + url.encodeAsBase64();

                if (isPlay) {
                    sPlayCode += "OpenPlayUrl('${playUrl}')"
                } else {
                    sPlayCode += "window.clipboardData.setData('Text','${playUrl}');"
                    sPlayCode += "alert('成功复制链接,现在可以粘贴了!');"
                }
            }

            //是下载
            if (!isPlay) {
                //插入到下载历史表
                if (session.consumer) {
                    new DownloadedProgram(consumer: session.consumer, program: program).save()
                    Consumer.get(session.consumer.id).downloadNum++
                }
                program.downloadNum++

                //生成操作日志
                new OperationLog(operation: OperationEnum.DOWNLOAD_PROGRAM, tableName: 'program', tableId: program?.id, brief: program?.name, operator: session.consumer?.name, operatorId: session.consumer?.id).save()
            } else {
                //插入到点播历史表
                if (session.consumer && servletContext.playLogOpt == 1) {
                    new PlayedProgram(consumer: session.consumer, program: program).save()
                    Consumer.get(session.consumer.id).playNum++
                }
                program.frequency++
            }

            //采集播放日志(时间仓促，可能会有问题)
            if (isOutHost) {
                def outPlayLog = OutPlayLog.findByProgramId(params.programId)
                def serverNode = ServerNode.get(program.fromNodeId)
                def selfNode = null    //本节点

                if (serverNode) {
                    if (outPlayLog) {

                        //插入到分发表中
                        def startDate = new Date(outPlayLog.dateCreated.getTime())
                        def endDate = new Date()
                        int dateDiff = CTools.dateDiff(startDate, endDate) + 1
                        int frequency = (outPlayLog.frequency / dateDiff)
                        //println dateDiff + "-" + frequency
                        int outPlayFrequency = 20    //设定要分发的频率
                        result = CTools.getInputStreamContent("http://${serverNode.ip}:${serverNode.webPort}/nts/webProgram/getOutPlayFrequency", "GET", "UTF-8")
                        if (result) outPlayFrequency = result.toInteger()
                        //println outPlayFrequency

                        //如果资源远程点播数大于来源结点设置的最大值
                        if (frequency > outPlayFrequency && outPlayLog.state == OutPlayLog.NO_DIST_STATE) {
                            //远程访问URL进入收割列表，返回json串
                            if (serverNode.grade == ServerNode.GRADE_CHILD) {
                                result = CTools.getInputStreamContent("http://${serverNode.ip}:${serverNode.webPort}/nts/webProgram/saveReapProgram?idLists=${program.fromId}", "POST", "UTF-8")
                            }
                            //远程访问URL进入分发列表
                            else {
                                //参数idLists是上级节点的program id,serverNodeIds是本节点在上级节点对应的serverNode id
                                selfNode = ServerNode.findByGrade(ServerNode.GRADE_SELF)
                                if (selfNode) {

                                    def outNodeId = CTools.getInputStreamContent("http://${serverNode.ip}:${serverNode.webPort}/nts/webProgram/getNodeIdByName?nodeName=${selfNode.name}", "POST", "UTF-8")
                                    if (outNodeId > 0) {
                                        //result = CTools.getInputStreamContent("http://${serverNode.ip}:${serverNode.webPort}/nts/distributeProgram/save?idLists=${outNodeId}&serverNodeIds=${program.fromId}&isSendObject=1", "POST", "UTF-8")
                                        result = CTools.getInputStreamContent("http://${serverNode.ip}:${serverNode.webPort}/nts/distributeProgram/save?idLists=${program.fromId}&serverNodeIds=${outNodeId}&isSendObject=1", "POST", "UTF-8")
                                        println "http://${serverNode.ip}:${serverNode.webPort}/nts/distributeProgram/save?idLists=${program.fromId}&serverNodeIds=${outNodeId}&isSendObject=1"
                                    } else
                                        println "getNodeIdByName failed,please check the node name in both server"
                                } else {
                                    println "self node no exist"
                                }
                            }

                            //前面result没有作异常捕获，网络不畅时可能有问题
                            outPlayLog.state = OutPlayLog.IN_DIST_STATE
                        } else {
                            outPlayLog.frequency++
                        }
                    } else {
                        //if(serverNode.grade == nts.system.domain.ServerNode.GRADE_CHILD){
                        new OutPlayLog(programId: program.id, playIP: request.getRemoteAddr()).save()
                        //else{

                        //result = CTools.getInputStreamContent("http://${webHost}/nts/distributeProgram/save?idLists=${program.id}&serverNodeIds=${serverNode.id}&isSendObject=1", "POST", "UTF-8")
                        //}
                    }
                }

                //println "http://${serverNode.ip}:${serverNode.webPort}/nts/distributeProgram/save?idLists=2&serverNodeIds=${serverNode.id}&isSendObject=1"
            }
            program.save(flush: true)
        }

        render(text: sPlayCode, contentType: "text/javascript", encoding: "UTF-8")
    }

    //收藏资源
    @ActionNameAnnotation(name = "资源推荐")
    def collectProgram() {
        def program = Program.get(params.id);
        def result = [:];
        result.success = false;
        if ((!session.consumer) || (session.consumer.name == "anonymity")) {
            result.msg = '未登陆，请先登陆！';
        } else {
            if (program) {
                //收藏本人还没有收藏的
                def collectedProgram = CollectedProgram.findByConsumerAndProgram(session.consumer, program);
                if (!collectedProgram) {
                    if (!params.tag) {
                        params.tag = "标签";
                    }
                    collectedProgram = new CollectedProgram(consumer: session.consumer, program: program, tag: params.tag);
                    if (collectedProgram.save()) {
                        program.collectNum++;
                        Consumer.get(session.consumer.id).collectNum++;
                        result.msg = '收藏成功！';
                        result.success = true; ;
                    } else {
                        result.msg = '收藏失败！';
                    }
                } else {
                    result.msg = '该资源已收藏，不能重复收藏！';
                }
            }
        }
        return render(result as JSON);
    }

    //推荐资源
    @ActionNameAnnotation(name = "资源推荐")
    def recommendProgram() {
        def program = Program.get(params.id);
        def result = [:];
        result.success = false;
        if ((!session.consumer) || (session.consumer.name == "anonymity")) {
            result.msg = '未登陆，请先登陆！';
        } else {
            if (program) {
                //推荐本人还没有推荐的
                def recommendedProgram = RecommendedProgram.findByConsumerAndProgram(session.consumer, program);
                if (!recommendedProgram) {
                    recommendedProgram = new RecommendedProgram(consumer: session.consumer, program: program);
                    if (recommendedProgram.save()) {
                        program.recommendNum++;
                        result.msg = '推荐成功！';
                        result.success = true;
                    } else {
                        result.msg = '推荐失败！';
                    }
                } else {
                    result.msg = '该资源您已推荐，不能重复推荐！';
                }
            }
        }
        return render(result as JSON);
    }


    @ActionNameAnnotation(name = "添加评论")
    //设置影评
    def saveRemark() {//content
        def programId = params.programId;
        params.content = CTools.codeToHtml(params.content)
        int id;
        if (programId instanceof String) {
            id = params.programId as int;
        } else {
            id = params.programId;
        }
        def serial = null;
        if (params.serialId) {
            serial = Serial.get(params.serialId as long);
        }

        def program = Program.get(id)
        def result = [:];
        if (program && session.consumer && session.consumer.canComment) {
            if (serial) {
                params.topic = serial.name;
            }
            def remark = new Remark();
            remark.content = params.content;
            remark.topic = params.topic;
            remark.dateModified = new Date();
            remark.consumer = session.consumer
            remark.program = program
            remark.isPass = servletContext.remarkAuthOpt == 0 ? true : false;
            program.addToRemarks(remark)
            if (remark.save(flush: true)) {
                if (params.rank) {
                    List<Remark> remarkList = Remark.findAllByConsumerAndProgram(session.consumer, program);
                    List<Integer> scoreList = [];
                    remarkList?.each {
                        if (it.rank > 0) {
                            scoreList.add(it.rank);
                        }
                    }
                    if (scoreList.size() == 0) {
                        remark.rank = Integer.parseInt(params.rank);
                        remark.save(flash: true);

                        //资源评分保存
                        programService.saveProgramScore(program.id);
                        result.isFlag = true;
                    } else {
                        List<Remark> remarkList2 = Remark.findAllByProgram(program);
                        program.remarkNum = remarkList2.size();
                        program.save(flash: true);
                        result.isFlag = false;
                    }
                }
                result.success = true;
                result.content = params.content
                result.remark = remark;
                result.consumer = remark.consumer;
                if (!remark.isPass) {
                    result.msg = "提交成功，谢谢您的评论，但须管理员审核后方能显示。"
                }
            } else {
                result.success = false;
                result.msg = "Error!!!"
            }
        } else {
            result.success = false;
            result.msg = "对不起，你没有评论的权限或页面已过期，页面过期可重新登录试试。"
        }

        //def remarkList = nts.program.domain.Remark.findAllByProgramAndIsPass(program, 1, [max: 20, sort: 'id', order: 'desc'])
        // render(template: 'remarkList', model: [remarkList: remarkList])
        return render(result as JSON);
    }


    @ActionNameAnnotation(name = "回复")
    def saveRemarkReply() {
        params.content = CTools.codeToHtml(params.content)
        Remark remark = Remark.findById(params.id);
        def replyNum = params.replyNum;
        if (replyNum != null) {
            replyNum = replyNum as int;
            replyNum += 1;
        }
        remark.replyNum = replyNum;
        RemarkReply remarkReply = new RemarkReply();
        remarkReply.content = params.content;
        remarkReply.dateCreated = new Date();
        remarkReply.consumer = session.consumer;
        remark.addToRemarkReplys(remarkReply);
        remark.save(flush: true);
        def result = [:];
        result.success = true;
        result.user = remarkReply.consumer.name;
        result.consumerId = remarkReply.consumer.id;
        result.date = remarkReply.dateCreated.format("yyyy-MM-dd HH:mm:ss");
        return render(result as JSON);
    }

    ////////////////////////浏览点播结束

    //图片资源详细显示页面
    def photoShow = {
        if (!params.index || params.index == "") params.index = 0
        if (!params.currentStep || params.currentStep == "") params.currentStep = 1

        def programInstance = Program.get(params.programId);
        def serialList = Serial.createCriteria().list(sort: "serialNo", order: "asc") {
            if (params.programId) {
                program {
                    eq("id", CTools.nullToZero(params.programId).longValue())
                }
            }
            eq("urlType", 2)
        }
        def total = !serialList || serialList == [] ? 0 : serialList.totalCount
        params.index = (params.currentStep.toInteger() - 1) * 28 + params.index.toInteger()

        ['serialList': serialList, 'total': total, 'params': params, 'index': params.index, 'programInstance': programInstance]
    }

    //add by jlf
    def embedPlay = {

    }

    //记录播放位置
    def recoderPosition() {
        def result = [:];
        if (session.consumer && (!session.consumer?.name?.equals(servletContext.anonymityUserName))) {
            if (params.serialId && params.time) {
                Serial serial = Serial.findById(params.serialId);
                if (serial) {
                    Program program = serial.program;
                    Consumer consumer = Consumer.findById(session.consumer.id);
                    if (program && consumer) {
                        PlayedProgram playedProgram = PlayedProgram.findByConsumerAndSerial(consumer, serial);
                        if (playedProgram) {
                            playedProgram.timeLength = (params.time as int);
                            playedProgram.playDate = new Date();

                        } else {
                            playedProgram = new PlayedProgram();
                            program.frequency++;
                            playedProgram.serial = serial;
                            playedProgram.program = program;
                            playedProgram.consumer = consumer;
                            playedProgram.timeLength = (params.time as int);
                            consumer.viewNum++;
                            consumer.save();
                        }
                        try {
                            params.playedProgram = playedProgram;
                            params.program = program;
                            programService.recoderPosition(params);

                        } catch (Exception e) {
                        }
                        result.success = true;
                        return render(result as JSON);
                    }
                }
            }
        }
        result.success = false;
        return render(result as JSON);
    }


    def resourceDownload = {
        return render(view: 'resourceDownload');
    }

    def errorAuthority() {
        [errorMsg: params.errorMsg]
    }
    /**
     * 音频播放
     */
    def playAudio() {
        Program program = null;
        def specialProgramList = [];//专辑资源
        def evaluateList = [];
        def hotAudio4 = [];//前四热门资源
        Serial serial = null;
        boolean isCanDownload = false;
        try {
            def prom = Program.get(params.programId as Long)
            def result = programService.canPlay(session.consumer, Program.get(params.programId as Long))
            if (!result) {
                def errorMsg = ''
                if ((prom.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                    errorMsg = '对不起，您没有权限学习该课程！'
                } else {
                    errorMsg = '对不起，您没有权限点播该资源！'
                }
                return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
            }
            isCanDownload = programService.canDownload(session.consumer, prom);
            if (params.programId) {
                program = Program.get(params.programId);
                if (program) {
                    //Program.get(params.programId).serials
                    List states = new ArrayList();
                    states.add(Serial.NO_NEED_STATE);
                    states.add(Serial.CODED_STATE);
                    specialProgramList = Serial.createCriteria().list(order: 'asc', sort: 'serialNo') {
                        eq('program', program)
                        'in'("state", states.toArray())
                    }
/*                    specialProgramList = programService.programIn(params.programId).toList();
                    specialProgramList.sort { serial1, serial2 ->
                        serial1?.serialNo <=> serial2?.serialNo
                    }*/
                    evaluateList = programService.evaluateList(params.programId);
                    hotAudio4 = programService.audioHot4();
                    serial = specialProgramList[0];
                }
            }
        }
        catch (Exception e) {

        }
        return render(view: 'audioIndexPlay', model: [serial: serial, isCanDownload: isCanDownload, specialProgramList: specialProgramList, program: program, evaluateList: evaluateList, hotAudio4: hotAudio4]);
    }
    //增加评论
    def evaluate() {
        params.text = CTools.codeToHtml(params.text)
        Remark remark = programService.addEvaluate(params.programId, session.consumer, params.text, params.rank as int);

        return render([remark as JSON, remark.consumer as JSON])
    }
    //增加回复
    def reply() {
        params.text = CTools.codeToHtml(params.text)
        def reply = programService.addReply(params.remarkId, params.text, session.consumer);
        return render([reply as JSON, reply.consumer as JSON])
    }

    //删除资源的评论
    def remarkDelete() {
        def result = [:]
        result = programService.remarkDelete(params)
        return render(result as JSON)
    }

    List<ProgramCategory> searchCategoryNavList = [];  //存放搜索页面导航栏

    //精确搜索
    def superSearch() {
        def facetFieldParams = ""; //搜索分面参数
        def facetValueParams = ""; // 搜索分面值参数
        if (servletContext.searchEnable) {
            params.searchEnable = 'enable';
           /* searchCategoryNavList.clear();*/
            def programCategoryId;
            def facetField = []; //搜索分面
            def facetValue = [:]; //搜索分面值
            def facetList = []; //存放分面和分面值
            Set paramsSet = params.keySet();
            paramsSet.each { String param ->
                if (param.contains("_facet")) {
                    facetField.add(param);
                    facetValue.put(param, params.get(param));
                    facetFieldParams = facetFieldParams + param + ",";
                    facetValueParams = facetValueParams + params.get(param) + ",";
                }
            }

            if (facetFieldParams.length() > 0) {
                facetFieldParams.substring(0, facetFieldParams.length() - 1);
                facetValueParams.substring(0, facetValueParams.length() - 1);
            }

            if (params.otherOption) {
                facetField.add("otherOption");
                facetValue.put("otherOption", params.otherOption);
            }

            if (params.programCategoryId) {
                try{
                    programCategoryId = Long.parseLong(params.programCategoryId);
                }catch(Exception e){
                    programCategoryId = null;
                }
            }
            ProgramCategory programCategory;

            //查询出来顶级分类下边的一级分类
            if (params.programCategoryId) {
                programCategory = ProgramCategory.findById(programCategoryId as Long);

                // 获取此分类以及所有子分类的ID
                List<String> categoryIdList = programCategoryIdQuery(programCategory);
                facetField.add("categoryId");
                facetValue.put("categoryId", categoryIdList);

                //分面获取
                Set<CategoryFacted> facetSet = programCategory?.facteds;
                if (facetSet && facetSet.size() > 0) {
                    List<CategoryFacted> factedList = facetSet.toList();
                    factedList.sort { facet1, facet2 ->
                        facet1.enName <=> facet2.enName
                    }
                    //分面值获取
                    for (CategoryFacted facet : factedList) {
                        def value = [:];
                        List<String> valueList = FactedValue.createCriteria().list {
                            projections {
                                distinct('contentValue')
                            }
                            categoryFacted {
                                eq('id', facet.id)
                            }
                            order('orderIndex', 'asc')
                        }
                        if (valueList && valueList.size() > 0) {
                            value.put("enName", facet.enName);
                            value.put("values", valueList);
                            value.put("cnName", facet.name);
                            facetList.add(value);
                        }
                    }
                    facetList.sort();
                }
            } else {
                def parentCategory = ProgramCategory.findByParentCategory(null);
                programCategory = parentCategory;
            }

//            List<ProgramCategory> childCategoryList = ProgramCategory.findAllByParentCategory(programCategory);

            //导航栏获取
            /*categoryList(programCategory)
            Collections.reverse(searchCategoryNavList);*/

            if (params.key || facetField.size() > 0) {
                //是否登录
                if (userService.judeAnonymity()) {
                    facetField.add("canPublic");
                    facetValue.put("canPublic", true);
                }
                int max = 20;
                if(params.max) {
                    try{
                        max =  params.max as int;
                    }catch(Exception e){
                        // do nothing
                    }
                }
                int offset = params.offset ? params.offset as int : 0;
                def result = searchService.superSearch(offset, max, params.key, params.orderBy, params.order, facetField, facetValue);
                if (result && result.size() > 0) {
                    def programs = result.modelList;
                    return render(view: 'superSearch', model: [facetList       : facetList, /*categoryNavList: searchCategoryNavList,*/
//                                                               childCategoryList: childCategoryList,
                                                               total           : result.total, programs: programs, useTime: result.useTime, params: params,
                                                               facetFieldParams: facetFieldParams, facetValueParams: facetValueParams]);
                } else {
                    return render(view: 'superSearch', model: [facetList       : facetList, /*categoryNavList: searchCategoryNavList,*/
//                                                               childCategoryList: childCategoryList,
                                                               total           : 0, programs: [], hightLightModels: [], useTime: 0, params: params,
                                                               facetFieldParams: facetFieldParams, facetValueParams: facetValueParams]);
                }
            } else {
                return render(view: 'superSearch', model: [facetList       : facetList, /*categoryNavList: searchCategoryNavList,*/
//                                                           childCategoryList: childCategoryList,
                                                           total           : 0, programs: [], hightLightModels: [], useTime: 0, params: params,
                                                           facetFieldParams: facetFieldParams, facetValueParams: facetValueParams]);
            }
        } else {
            params.searchEnable = 'disable';
            return render(view: 'superSearch', model: [total           : 0, programs: [], hightLightModels: [], useTime: 0, params: params,
                                                       facetFieldParams: facetFieldParams, facetValueParams: facetValueParams]);
        }
    }

    /**
     * 获取搜索页面当前导航栏
     * @param currentCategory
     */
    private void categoryList(ProgramCategory currentCategory) {
        if (currentCategory) {
            searchCategoryNavList.add(currentCategory);
            if (currentCategory.parentCategory) {
                categoryList(currentCategory.parentCategory)
            }
        }
    }

    /**
     * 获取分类及所有子分类的id
     * @param category
     * @return idList
     */
    private List<String> programCategoryIdQuery(ProgramCategory category) {
        List<String> categoryIdList = [];
        categoryIdList.add(category.id as String);
        List<ProgramCategory> categoryList = programCategoryService.querySubAllCategory(category);
        if (categoryList && categoryList.size() > 0) {
            categoryList.each {
                categoryIdList.add(it.id as String);
            }
        }
        return categoryIdList;
    }

    def suggest() {
        String[] suggests = searchService.suggestProgram(params.key, 10);
        def result = [:];
        result.list = suggests;
        return render(result as JSON);
    }

    def docSuggest() {
        String[] suggests = searchService.suggestSerial(params.key, 10);
        def result = [:];
        result.list = suggests;
        return render(result as JSON);
    }

    def docSearch() {
        if (servletContext.searchEnable) {
            params.searchEnable = 'enable';

            if (params.key) {
                int max = params.max ? params.max as int : 20;
                int offset = params.offset ? params.offset as int : 0;
                def result = searchService.docSearch(offset, max, params.key);
                def serialModels = result.modelList;
                return render(view: 'docSearch', model: [total: result.total, serialModels: serialModels, useTime: result.useTime, params: params]);
            } else {
                return render(view: 'docSearch', model: [total: 0, serialModels: [], hightLightModels: [], useTime: 0, params: params]);
            }

        } else {
            params.searchEnable = 'disable';

            return render(view: 'docSearch', model: [total: 0, serialModels: [], hightLightModels: [], useTime: 0, params: params]);
        }

    }

    def courseDetail() {
        def programId = params.programId;
        def courseQuestionTotal = 0;
        def programNoteTotal = 0;
        Program program = null;

        def result = programService.canPlay(session.consumer, Program.get(programId as Long))
        if (!result) {
            def errorMsg = '对不起，您没有权限学习该课程！'
            return redirect(controller: 'program', action: 'errorAuthority', params: [errorMsg: errorMsg])
        }

        if (programId) {
            program = Program.get(Long.parseLong(programId as String));
//            if (servletContext.isCon != "false") {
//                programService.fixTimeLength(program, servletContext);
//            }
            //查询问题数量
            def courseQuestionList = CourseQuestion.findAllByCourse(program);
            if (courseQuestionList) {
                courseQuestionTotal = courseQuestionList.size();
            }
            //查询笔记总数
            def programNoteList = ProgramNote.findAllByProgram(program)
            if (programNoteList) {
                programNoteTotal = programNoteList.size();
            }
        }

        //找出前四条评论

        def remarkList = Remark.createCriteria().list(max: 4, order: 'desc', sort: 'dateCreated') {
            if (program) {
                eq("program", program)
            }
        }
        if (!params.offset) params.offset = 0;
        params.max = 20;
        def transCondeState = [Serial.CODED_STATE, Serial.NO_NEED_STATE]; //转码状态
        List<Serial> videoSerial = Serial.createCriteria().list(max: params.max, offset: params.offset) {
            eq("program", program)
            eq("urlType", Serial.URL_TYPE_VIDEO)
            'in'('state', transCondeState.toArray())
            order("serialNo", "asc")
        }
        List<Serial> otherSerial = Serial.createCriteria().list() {
            eq("program", program)
            notEqual("urlType", Serial.URL_TYPE_VIDEO)
            'in'('state', transCondeState.toArray())
            order("serialNo", "asc")
        }
        //课程下面的目录显示目录显示
        return render(view: 'courseDetail', model: [videoSerial: videoSerial, otherSerial: otherSerial, remarkList: remarkList, program: program, courseQuestionTotal: courseQuestionTotal, programNoteTotal: programNoteTotal, serialTotal: videoSerial.totalCount, offset: params.offset.toString()])
    }


    def courseList() {
        def isNew = params.isNew;
        def categoryId = params.categoryId;
        int id;
        if (categoryId) {
            id = Integer.parseInt(categoryId);
        }

        //找出父类不是开放课程的mediatype为5的分类
        def programCategoryList = ProgramCategory.createCriteria().list() {
            notEqual("name", "开放课程")
            eq("mediaType", 5)
            eq("level", 2)
        }

        //获得子资源类别
        def childCategoryList = [:];
        programCategoryList.each {
            childCategoryList.put(it.id, ProgramCategory.findAllByParentCategory(it, [max: 8]))
        }

        //获得父类资源类别
        def parentCategory = ProgramCategory.get(id);

        //获得他的所有子类别
        def childrenCategory = [];
        def cateNum1 = params.cateNum ? params.cateNum : 8;
        int cateNum;
        if (cateNum1 instanceof String)
            cateNum = Integer.parseInt(cateNum1);
        else
            cateNum = cateNum1;
        childrenCategory = ProgramCategory.withCriteria {
            if (parentCategory) {
                eq("parentCategory", parentCategory)
            }
            eq("mediaType", 5)
            maxResults(cateNum)
        }
        def childrenTotal = ProgramCategory.withCriteria {
            if (parentCategory) {
                eq("parentCategory", parentCategory)
            }
            eq("mediaType", 5)
        }.size()

        //获得所有子分类相对应的资源
        def programList = [];
        if (!params.max) params.max = 20;
        if (!params.order) params.order = 'desc';
        if (!params.offset) params.offset = 0;
        //if (!params.sort){
        //    params.sort = "dateCreated";
        //}
        params.sort = "id";
        programList = programService.search([max: params.max, offset: params.offset, orderBy: params.sort, order: params.order, programCategoryId: parentCategory.id], false);
        def total = programService.searchTotalCount([max: params.max, offset: params.offset, orderBy: params.sort, order: params.order, programCategoryId: parentCategory.id]);
        //return render(view: 'courseList',model: [isNew:isNew,programCategoryList:programCategoryList,parentCategory:parentCategory,childrenCategory:childrenCategory,programList:programList,total: total,cateNum:cateNum,childrenTotal:childrenTotal])
        return render(view: 'courseList', model: [isNew: isNew, categoryId: categoryId, parentCategory: parentCategory, childrenCategory: childrenCategory, programCategoryList: programCategoryList, programList: programList, total: total, childCategoryList: childCategoryList])
    }

    def courseView() {
        def serialId = params.serialId;
        def problemFlg = false;
        if (params.problemFlg) {
            problemFlg = true;
        }
        Serial serial;
        Program program;
        def total;
        def courseTotal;
        def courseQuestionList = [];
        def remarkList = [];
        PlayedProgram playedProgram = null;
        ProgramNote note = null;
        /*if (!params.max) params.max = 10;
        if (!params.offset) params.offset = 0;*/
        if (serialId) {
            serial = Serial.get(serialId);
            //得到播放记录，记录播放是在ProgramController>recoderPosition方法里面
            playedProgram = PlayedProgram.findByConsumerAndSerial(session.consumer, serial);
            if (!playedProgram) {
                PlayedProgram pd = new PlayedProgram();
                pd.serial = serial;
                pd.program = serial.program;
                pd.consumer = session.consumer;
                serial.program.addToPlayedPrograms(pd);
                pd.save(flush: true);
            }
            //得到serial的Program
            program = serial.program;
            //查询所的问题
            courseQuestionList = CourseQuestion.createCriteria().list(order: 'desc', sort: 'id') {
                if (program) {
                    eq("course", program)
                }
            };
            remarkList = Remark.createCriteria().list(order: 'desc', sort: 'id') {
                eq("isPass", true)
                if (program) {
                    eq("program", program)
                }
            };
            total = remarkList.totalCount;
            courseTotal = courseQuestionList.totalCount;

            //如果是从笔记转跳过来，视频播放位置定位到笔记位置

            if (params.programNoteId) {
                note = ProgramNote.get(params.programNoteId);
            }
        }

        boolean isCanDownload = programService.canDownload(session.consumer, serial.program);

        def transCondeState = [Serial.CODED_STATE, Serial.NO_NEED_STATE]; //转码状态
        List<Serial> videoSerial = Serial.findAllByProgramAndUrlTypeAndStateInList(serial.program, Serial.URL_TYPE_VIDEO, transCondeState);
        videoSerial.sort {
            serial1, serial2 ->
                serial1.serialNo <=> serial2.serialNo
        }

        List<Serial> otherSerial = Serial.findAllByProgramAndUrlTypeNotEqualAndStateInList(serial.program, Serial.URL_TYPE_VIDEO, transCondeState);
        otherSerial.sort {
            serial1, serial2 ->
                serial1.serialNo <=> serial2.serialNo
        }
        return render(view: 'courseView', model: [isCanDownload: isCanDownload, note: note, playedProgram: playedProgram, total: total, courseTotal: courseTotal, serial: serial, otherSerial: otherSerial, videoSerial: videoSerial, courseQuestionList: courseQuestionList, remarkList: remarkList, problemFlg: problemFlg])
    }

    def singlePlay() {
        def serial = null;
        if (params.id) {
            serial = Serial.get(params.id as Long);
        } else {
            return render("对不起,你所要查找的数据不存在!");
        }
        return render(view: 'singlePlay', model: [serial: serial, program: serial.program, params: params]);
    }
}