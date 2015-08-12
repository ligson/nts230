package nts.system.controllers

import groovy.xml.MarkupBuilder
import nts.meta.domain.MetaContent
import nts.meta.domain.MetaDefine
import nts.meta.domain.MetaEnum
import nts.program.domain.DistributeProgram
import nts.program.domain.Program
import nts.program.domain.Serial
import nts.program.services.ProgramService
import nts.user.domain.Consumer
import nts.utils.CTools
import org.apache.http.NameValuePair
import org.apache.http.client.HttpClient
import org.apache.http.client.entity.UrlEncodedFormEntity
import org.apache.http.client.methods.CloseableHttpResponse
import org.apache.http.client.methods.HttpPost
import org.apache.http.impl.client.HttpClients
import org.apache.http.message.BasicNameValuePair

import java.text.SimpleDateFormat

class WebMethodController {
    ProgramService programService

    def showSerials = {
        //println "dddddddddddmmmm"
        String xmlStr = ""
        int nProgramId = CTools.strToInt(params.programId)
        def subIdList = '0'
        def serialList = null
        def svrAddress = ""

        if (nProgramId > 0) {
            if (subIdList == null || subIdList == '0' || subIdList == '')
                serialList = Serial.executeQuery("select a from nts.program.domain.Serial a where a.urlType=" + Serial.URL_TYPE_VIDEO + " and program.id=" + nProgramId)
            else
                serialList = Serial.executeQuery("select a from nts.program.domain.Serial a where a.urlType=" + Serial.URL_TYPE_VIDEO + " and id in(" + subIdList + ") order by a.serialNo")

            render(contentType: "text/xml", encoding: "UTF-8") {
                serials(programId: nProgramId, size: serialList.size()) {
                    for (s in serialList) {
                        svrAddress = s.svrAddress + ":" + BfConfig.getVideoPort()
                        serial(id: s.id, name: s.name, svrAddress: svrAddress, timeLength: s.timeLength, filePath: s.filePath, startTime: s.startTime, endTime: s.endTime)
                    }
                }
            }
        }

        ////http://192.168.1.12:8080/nts/web/getPlayList?UID=username&PWD=password&programId=7893&subIdList=22111,22112,22113
    }

    /**
     * 为了实现ajax跨域请求，代理action
     * 调用：ajaxUrl = '/nts/webMethod/proxy?method=get&encoding=UTF-8&contentType=xml&url=' + encodeURIComponent('http://www.google.com/search?q=Prototype');
     * 注意：url参数必传，其它参数可不传，默认值：method=get，encoding=UTF-8，contentType=xml
     */
    def proxy = {
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);

        def responseText = ""
        def url = ""
        def method = "GET"
        def encoding = "UTF-8"
        def contentType = "xml"    //常用的有：html xml json

        url = params.url
        if (params.method && params.method != "") method = params.method
        if (params.encoding && params.encoding != "") encoding = params.encoding
        if (params.contentType && params.contentType != "") contentType = params.contentType

        method = method.toUpperCase()
        encoding = encoding.toUpperCase()

        if (url && url != "" && method != "" && encoding != "") {
            url = url.replaceAll("&amp;","&");
            responseText = CTools.readInputStreamContent1(url, method, encoding)
        }

        render(text: responseText, contentType: "text/${contentType}", encoding: encoding)
    }

    def proxy2 = {
        String url = params.url;
        String data = params.data;
        HttpPost httpPost = new HttpPost(url);

        ArrayList<NameValuePair> arrayList = new ArrayList<NameValuePair>();
        if (data.contains("&")) {
            String[] param = data.split("&");
            for (String p : param) {
                String key = p.split("=")[0];
                String value = p.split("=")[1];
                arrayList.add(new BasicNameValuePair(key, value));
            }
        } else {
            String key = data.split("=")[0];
            String value = data.split("=")[1];
            arrayList.add(new BasicNameValuePair(key, value));
        }
        httpPost.setEntity(new UrlEncodedFormEntity(arrayList, "UTF-8"));

        HttpClient httpClient = HttpClients.createDefault();

        CloseableHttpResponse httpResponse = httpClient.execute(httpPost);

        String text = httpResponse.getEntity().getContent().getText("UTF-8");
        println("${url}:" + text);
        return render(text);
    }

    /**
     * 由外部统发出请求，邦丰nts返回资源XML数据,因为是供外部调用，故规范xml中program改为resource
     * http://192.168.1.12:8080/nts/webMethod/resourceList?user=123456&verify=070262df2beb46d34908ad86ba8aca43&type=1&keyword=test&page=0&size=5&time=1312961333047
     * 说明：可参见经管学院接口
     */
    def resourceList = {
        def encoding = "UTF-8"
        def consumer = null
        def programList = null
        def xmlText = ""
        boolean isAuthPass = false

        if (!params.size) params.size = 10
        if (!params.page) params.page = 1
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'

        if (params.encoding && params.encoding != "") encoding = params.encoding

        params.offset = (CTools.nullToZero(params.page) - 1) * CTools.nullToZero(params.size)

        def userName = CTools.nullToBlank(params.user).trim()
        def type = CTools.nullToOne(params.type)    //搜索关键词对应的类别：名称 作者 创建者 标签
        def keyword = CTools.nullToBlank(params.keyword).trim()
        def verify = CTools.nullToBlank(params.verify)
        def time = (params.time) ? Long.parseLong(params.time) : 0L

        if (servletContext.clientName == "fujian")
            isAuthPass = true
        else
            isAuthPass = programService.isAuthPass(servletContext.authPrefix, servletContext.authPostfix, userName, verify, time, servletContext.authTimeout.toLong())
        //println ((servletContext.authPrefix+userName+time+servletContext.authPostfix).encodeAsMD5())
        //println servletContext.authPrefix
        if (isAuthPass) {

            def webHost = request.getServerName()
            if (request.getServerPort() != 80) webHost += ":" + request.getServerPort()
            Map args = null    //用于传到服务层的参数

            programList = Program.createCriteria().list(max: params.size, offset: params.offset, sort: params.sort, order: params.order) {
                //关键词条件
                if (keyword) {
                    //资源id列表keyword:12,13,15
                    if (type == 0) {
                        def idList = (keyword.tokenize(',')).collect { it.toLong() }
                        'in'("id", idList)
                    }
                    //资源名称
                    else if (type == 1) {
                        like("name", "%${keyword}%")
                    }
                    //作者
                    else if (type == 2) {
                        like("actor", "%${keyword}%")
                    }
                    //创建者
                    else if (type == 3) {
                        eq("consumer", Consumer.findByNickname(keyword))
                    }
                    //标签
                    else if (type == 4) {
                        programTags {
                            eq("name", keyword)
                        }
                    }
                    //描述
                    else if (type == 5) {
                        like("description", "%${keyword}%")
                    }
                    //日期 keyword:20080101-20110101
                    else if (type == 6) {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd HH:mm:ss")
                        def endTime = "20510101 23:59:59"
                        def arrTime = keyword.split('\\-')
                        def startTime = arrTime[0] + ' 00:00:01'
                        if (arrTime.length == 2) endTime = arrTime[1] + ' 23:59:59'

                        startTime = sdf.parse(startTime)
                        endTime = sdf.parse(endTime)

                        between("dateCreated", startTime, endTime)
                    }
                }
            }

            def writer = new StringWriter()
            def mB = new MarkupBuilder(writer)

            mB.resources(count: programList.totalCount, page: params.page, size: params.size) {
                for (p in programList) {
                    //svrAddress = s.svrAddress + ":" + nts.nts.utils.BfConfig.getVideoPort()
                    mB.resource(id: p.id) {
                        name(p.name)
                        contributor(p.actor)
                        playNum(p.frequency)
                        downloadNum(p.downloadNum)
                        dateCreated(p.dateCreated)
                        description(p.description)
                        urls() {
                            p.serials.each { serial ->

                                //////////////////////////////////////////////获得播放地址开始
                                def videoHost = ""
                                def svrAddress = ""
                                def sVideoPort = servletContext.videoPort    //视频服务器端口
                                def pwd = ""
                                def playUrl = ""
                                int playType = Serial.PLAY_TYPE_PC //0是普通pc机播放，1是移动手机播放，2是移动平板播放

                                //接口不进行操作系统或浏览器检测，只根据urlType返回url
                                if (serial.urlType == Serial.URL_TYPE_MOBILE) playType = Serial.PLAY_TYPE_MOBILE
                                else if (serial.urlType == Serial.URL_TYPE_TABLET) playType = Serial.PLAY_TYPE_TABLET

                                if (serial) svrAddress = serial.svrAddress
                                if (servletContext.videoSevr == '' || svrAddress.startsWith("127.0.0.1") || svrAddress.startsWith("localhost")) svrAddress = request.getServerName()
                                videoHost = svrAddress + ":" + sVideoPort

                                pwd = (servletContext.authPrefix + userName + servletContext.authPostfix).encodeAsMD5()

                                args = [serial: serial, consumer: consumer, webHost: webHost, videoHost: videoHost, pwd: pwd, isPlay: true, playType: playType]
                                playUrl = programService.generalSerialUrl(args)
                                //////////////////////////////////////////////获得播放地址结束

                                url(serialNo: serial.serialNo, type: serial.urlType, typeName: Serial.urlTypeName[serial.urlType], playUrl)
                            }
                        }
                    }
                }

            }

            xmlText = writer.toString()
        } else {
            xmlText = '<resources count="-1" page="0" size="5">Authentication failure</resources>'
        }

        render(text: xmlText, contentType: "text/xml", encoding: encoding)
    }

    /**
     * 由外部统发出请求，邦丰nts返回资源XML数据,因为是供外部调用，故规范xml中program改为resource
     * http://192.168.1.12:8080/nts/webMethod/resourceShow?user=123456&verify=070262df2beb46d34908ad86ba8aca43&time=1312961333047&id=1
     * 说明：可参见经管学院接口
     */
    def resourceShow = {
        def encoding = "UTF-8"
        def consumer = null
        def program = null
        def metaDefineList = null
        def metaEnumList = null
        def metaContentList = null
        def xmlText = ""
        boolean isAuthPass = false

        if (params.encoding && params.encoding != "") encoding = params.encoding

        def userName = CTools.nullToBlank(params.user).trim()
        def type = CTools.nullToOne(params.type)    //搜索关键词对应的类别：名称 作者 创建者 标签
        def verify = CTools.nullToBlank(params.verify)
        def time = (params.time) ? Long.parseLong(params.time) : 0L

        program = Program.get(params.id)

        //keyword =new String(keyword.getBytes("ISO8859_1"), "GBK")
        if (servletContext.clientName == "fujian")
            isAuthPass = true
        else
            isAuthPass = programService.isAuthPass(servletContext.authPrefix, servletContext.authPostfix, userName, verify, time, servletContext.authTimeout.toLong())
        //println ((servletContext.authPrefix+userName+time+servletContext.authPostfix).encodeAsMD5())

        if (isAuthPass && program) {

            ///////////////////////////////////////////////////////////get metaDefineList start
            def c = MetaDefine.createCriteria()
            metaDefineList = c.list {
                //like("holderFirstName", "Fred%")
                or {
                    sizeLt("directorys", 1)
                    directorys {
                        eq("id", program?.directory?.id)
                    }
                }

                order("showOrder", "asc")
            }
            //////////////////////////////////////////////////////////get metaDefineList end

            /////////////////////////////////////////////////////////get metaEnumList start
            c = MetaEnum.createCriteria()
            metaEnumList = c.list {
                'in'("metaDefine", metaDefineList)

                //order("showOrder", "asc")
            }

            ////////////////////////////////////////////////////////get metaEnumList end

            /////////////////////////////////////////////////////////get metaContentList start
            metaContentList = program.metaContents
            ////////////////////////////////////////////////////////get metaContentList end

            //////////////////////////////////////////////////////////////////////////////////////set xml text start
            def writer = new StringWriter()
            def mB = new MarkupBuilder(writer)
            def data = ""

            mB.resource(id: program.id, library: program?.directory?.id) {
                /////////////////////////////////元数据信息开始
                metaData() {
                    for (metaDefine in metaDefineList) {
                        if (metaDefine.parentId == 0) {
                            if (metaDefine.dataType == "decorate") {
                                element(name: metaDefine.name, cnName: metaDefine.cnName, dataType: metaDefine.dataType) {
                                    for (metaDefine2 in metaDefineList) {
                                        if (metaDefine2.parentId == metaDefine.id) {
                                            data = getMetaData(metaDefine2, metaEnumList, metaContentList)
                                            if (data != "") decorate(name: metaDefine2.name, cnName: metaDefine2.cnName, dataType: metaDefine2.dataType, data)
                                        }
                                    }
                                }
                            } else {
                                data = getMetaData(metaDefine, metaEnumList, metaContentList)
                                if (data != "") element(name: metaDefine.name, cnName: metaDefine.cnName, dataType: metaDefine.dataType, data)
                            }
                        }

                    }
                }
                //////////////////////////////元数据信息结束

                /////////////////////////////// program and serial info start
                def tags = program?.programTags
                programData() {
                    name(cnName: Program.cnField.name, program.name)
                    contributor(cnName: Program.cnField.actor, program.actor)
                    dateCreated(cnName: Program.cnField.dateCreated, program.dateCreated)
                    description(cnName: Program.cnField.description, program.description)
                    playNum(cnName: Program.cnField.frequency, program.frequency)
                    downloadNum(cnName: Program.cnField.downloadNum, program.downloadNum)

                    /////////////////////////////// tags start
                    programTags(cnName: Program.cnField.programTags) {
                        for (programTag in tags) {
                            tag(programTag.name)
                        }
                    }
                    /////////////////////////////// tags end

                    /////////////////////////////// urls start
                    def webHost = request.getServerName()
                    if (request.getServerPort() != 80) webHost += ":" + request.getServerPort()
                    Map args = null    //用于传到服务层的参数
                    urls(cnName: "地址列表") {
                        program.serials.each { serial ->

                            //////////////////////////////////////////////获得播放地址开始
                            def videoHost = ""
                            def svrAddress = ""
                            def sVideoPort = servletContext.videoPort    //视频服务器端口
                            def pwd = ""
                            def playUrl = ""
                            int playType = Serial.PLAY_TYPE_PC //0是普通pc机播放，1是移动手机播放，2是移动平板播放

                            //接口不进行操作系统或浏览器检测，只根据urlType返回url
                            if (serial.urlType == Serial.URL_TYPE_MOBILE) playType = Serial.PLAY_TYPE_MOBILE
                            else if (serial.urlType == Serial.URL_TYPE_TABLET) playType = Serial.PLAY_TYPE_TABLET

                            if (serial) svrAddress = serial.svrAddress
                            if (servletContext.videoSevr == '' || svrAddress.startsWith("127.0.0.1") || svrAddress.startsWith("localhost")) svrAddress = request.getServerName()
                            videoHost = svrAddress + ":" + sVideoPort

                            pwd = (servletContext.authPrefix + userName + servletContext.authPostfix).encodeAsMD5()

                            args = [serial: serial, consumer: consumer, webHost: webHost, videoHost: videoHost, pwd: pwd, isPlay: true, playType: playType]
                            playUrl = programService.generalSerialUrl(args)
                            //////////////////////////////////////////////获得播放地址结束

                            url(serialNo: serial.serialNo, type: serial.urlType, typeName: Serial.urlTypeName[serial.urlType], playUrl)
                        }
                    }
                    /////////////////////////////// urls end
                }

                /////////////////////////////// program and serial info start
            }

            xmlText = writer.toString()
            /////////////////////////////////////////////////////////////////////////////////////set xml text end

        } else {
            if (!program)
                xmlText = '<resource id="' + params.id + '">resource not exist</resource>'
            else
                xmlText = '<resource id="' + params.id + '">Authentication failure</resource>'

        }

        render(text: xmlText, contentType: "text/xml", encoding: encoding)
    }

    /**
     * 由外部统发出请求，邦丰nts返回资源XML数据,因为是供外部调用，故规范xml中program改为resource
     * http://192.168.1.12:8080/nts/webMethod/resourceStat
     * 说明：可参见经管学院接口
     */
    def resourceStat = {
        String encoding = "UTF-8"
        String xmlText = ""
        StringBuffer buf = new StringBuffer("")

        ////////////////////////get data start

        //资源总数
        def programCount = Program.countByStateGreaterThan(Program.APPLY_STATE)

        //资源自建总数
        def programSelfCount = Program.countByStateGreaterThanAndFromState(Program.APPLY_STATE, Program.FROM_STATE_SELF)

        //资源分发总数
        def programDistributeCount = Program.countByStateGreaterThanAndFromState(Program.APPLY_STATE, Program.FROM_STATE_DISTRIBUTE)

        //资源收割总数
        def programHarvestCount = Program.countByStateGreaterThanAndFromState(Program.APPLY_STATE, Program.FROM_STATE_HARVEST)

        //资源分发(出去)总数
        def programDistributeOutCount = DistributeProgram.countByStateGreaterThanAndIsDistribute(DistributeProgram.STATE_NO_DISTRIBUTED, true)

        //资源被收割总数
        def programHarvestOutCount = DistributeProgram.countByStateGreaterThanAndIsDistribute(DistributeProgram.STATE_NO_DISTRIBUTED, false)

        //资源待分发总数
        def programDistributeWaitCount = DistributeProgram.countByStateAndIsDistribute(DistributeProgram.STATE_NO_DISTRIBUTED, true)

        //资源待收割总数
        def programHarvestWaitCount = DistributeProgram.countByStateAndIsDistribute(DistributeProgram.STATE_NO_DISTRIBUTED, false)

        //待审批总数
        def programApplyCount = Program.countByState(Program.APPLY_STATE)

        //点播数
        def programPlaySum = Program.createCriteria().get {
            projections {
                sum "frequency"
            }
        }

        ////浏览（访问）数
        def programViewSum = Program.createCriteria().get {
            projections {
                sum "viewNum"
            }
        }

        //用户总数
        def consumerCount = Consumer.count()

        ////////////////////////get data end


        buf.append("<stat>\n")
        buf.append("<resource total=\"${programCount}\">\n")
        buf.append("<distribute_in>${programDistributeCount}</distribute_in>\n")
        buf.append("<distribute_out>${programDistributeOutCount}</distribute_out>\n")
        buf.append("<distribute_wait>${programDistributeWaitCount}</distribute_wait>\n")
        buf.append("<harvest_in>${programHarvestCount}</harvest_in>\n")
        buf.append("<harvest_out>${programHarvestOutCount}</harvest_out>\n")
        buf.append("<harvest_wait>${programHarvestWaitCount}</harvest_wait>\n")
        buf.append("<self_create>${programSelfCount}</self_create>\n")
        buf.append("<un_verify>${programApplyCount}</un_verify>\n")
        buf.append("</resource>")
        buf.append("<demand_total>${programPlaySum}</demand_total>\n")
        buf.append("<access_total>${programViewSum}</access_total>\n")
        buf.append("<user_total>${consumerCount}</user_total>\n")
        buf.append("</stat>")

        xmlText = buf.toString()

        render(text: xmlText, contentType: "text/xml", encoding: encoding)
    }

    /**
     * 获取子目播放地址,调用:http://192.168.1.12:8080/nts/webMethod/getPlayUrl?&isSerial=1&id=2&startTime=0:1:0&endTime=0:2:0
     * 说明：
     */
    def getPlayUrl = {
        def serial = null //可能是serial的实例，也可能是movieClip的实例，名称不规范，是想沿用前代码
        def url = ""
        boolean isSerial = CTools.nullToOne(params.isSerial) == 1
        serial = Serial.get(params.id)//isSerial?nts.program.domain.Serial.get(params.id):MovieClip.get(params.id)
        //手机平板点播来不及测试
        int playType = programService.judePlayType(request.getHeader("User-Agent"))
        if (CTools.nullToZero(params.playType) > 0) playType = CTools.nullToZero(params.playType)

        if (serial) {
            //////////////////////////////////////////////获得播放地址开始
            Map args = null    //用于传到服务层的参数
            boolean isPlay = CTools.nullToOne(params.isPlay) == 1
            def videoHost = ""
            def svrAddress = ""
            def sVideoPort = servletContext.videoPort    //视频服务器端口
            def webHost = request.getServerName()
            def pwd = ""
            def startTime = CTools.nullToBlank(params.startTime)
            def endTime = CTools.nullToBlank(params.endTime)

            if (serial) svrAddress = serial.svrAddress
            if (request.getServerPort() != 80) webHost += ":" + request.getServerPort()
            if (servletContext.videoSevr == '' || svrAddress.startsWith("127.0.0.1") || svrAddress.startsWith("localhost")) svrAddress = request.getServerName()
            videoHost = svrAddress + ":" + sVideoPort

            pwd = (servletContext.authPrefix + session?.consumer?.name + servletContext.authPostfix).encodeAsMD5()

            args = [serial: serial, consumer: session.consumer, webHost: webHost, videoHost: videoHost, pwd: pwd, isPlay: isPlay, startTime: startTime, endTime: endTime, playType: playType]
            url = programService.generalSerialUrl(args)
            //////////////////////////////////////////////获得播放地址结束

            //如果是电影标签，点播次数加1
            if (!isSerial) serial.frequency++
        }
        render url
        ////
    }

    //获得元数据对应的文本值，如果还有后续模块用到此方法，则移入到ProgramService中
    def getMetaData(metaDefine, metaEnumList, metaContentList) {
        def strData = ""

        for (metaContent in metaContentList) {

            if (metaContent.metaDefine.id == metaDefine.id) {
                if (MetaContent.numDataTypes.contains(metaDefine.dataType)) {
                    if (metaDefine.dataType == "enumeration")
                        strData = getEnumName(metaContent.numContent, metaDefine, metaEnumList)
                    else
                        strData = metaContent.numContent
                } else {
                    strData = metaContent.strContent
                }

                break;
            }
        }

        return strData

    }

    //获得枚举对应的文本值，如果还有后续模块用到此方法，则移入到ProgramService中
    def getEnumName(enumId, metaDefine, metaEnumList) {
        def strData = ""

        for (metaEnum in metaEnumList) {
            if (metaEnum.metaDefine.id == metaDefine.id && metaEnum.enumId == enumId) {
                strData = metaEnum.name
                break;
            }
        }

        return strData
    }
}
