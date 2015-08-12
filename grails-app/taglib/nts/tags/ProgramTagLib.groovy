package nts.tags

import com.boful.common.date.utils.TimeLengthUtils
import com.boful.nts.utils.SystemConfig
import nts.activity.domain.UserWork
import nts.commity.domain.ActivitySubject
import nts.commity.domain.ForumBoard
import nts.commity.domain.ForumMember
import nts.commity.domain.ForumReplyArticle
import nts.commity.domain.StudyCommunity
import nts.program.domain.CollectedProgram
import nts.program.domain.PlayedProgram
import nts.program.domain.Program
import nts.program.domain.RecommendedProgram
import nts.program.domain.Remark
import nts.program.domain.Serial
import nts.program.domain.Subtitle
import nts.program.services.ProgramService
import nts.system.domain.SysConfig
import nts.user.domain.Consumer
import nts.utils.CTools
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import org.springframework.web.servlet.support.RequestContextUtils as RCU

import java.text.DateFormat
import java.text.DecimalFormat
import java.text.SimpleDateFormat

class ProgramTagLib {
    //static namespace = "program"
    def programService
    def securityResourceService
    def userService

    def showCnField = { attrs, body ->
        out << cnEnFieldMap[attrs.table][attrs.field]
    }

    //海报图片链接
    def posterLink = { attrs, body ->
        def serials = attrs.serials
        def isAbbrImg = attrs.isAbbrImg
        def size = CTools.nullToBlank(attrs.size)
        def has = false

        def position = servletContext.thumbnailPos
        int tnflag = 1

        if (size == "") size = servletContext.thumbnailSize
        if (isAbbrImg) tnflag = 3

        //each 不能 break
        for (serial in serials) {
            if (serial.urlType == Serial.URL_TYPE_IMAGE && (serial.transcodeState & serial.OPT_IMG_POSTER) == serial.OPT_IMG_POSTER) {
                has = true
                out << readImgAddr(serial, isAbbrImg, size, position, tnflag)
                break;
            }
        }

        if (!has) {
            for (serial in serials) {
                if (serial.urlType == Serial.URL_TYPE_VIDEO && CTools.nullToBlank(serial.photo) != "") {
                    has = true
                    out << readImgAddr(serial, isAbbrImg, size, position, tnflag)
                    break;
                }
            }
        }

        if (!has) {
            for (serial in serials) {
                if (serial.urlType == Serial.URL_TYPE_VIDEO) {
                    has = true
                    out << readImgAddr(serial, isAbbrImg, size, position, tnflag)
                    break;
                }
            }
        }
        //缺省图片
        if (!has) out << createLinkTo(dir: 'images', file: (isAbbrImg ? 'defaultAbbrPoster.jpg' : 'defaultPoster.jpg'))
        //标签库可用${posterLink(serials:program?.serials)}
    }

    //返回serial的海报-add by chenfan
    def posterSerialLink = { attrs, body ->
        def serial = attrs.serial
        def isAbbrImg = attrs.isAbbrImg

        def size = servletContext.thumbnailSize
        def position = servletContext.thumbnailPos
        int tnflag = 1

        if (isAbbrImg) tnflag = 3
        out << readImgAddr(serial, isAbbrImg, size, position, tnflag)

    }

    /**
     * 新的截图皆空
     */
    def posterLinkNew = { attrs, body ->
        Program program = attrs.program;
        Serial serial = attrs.serial;
        String size = attrs.size;
        def position = attrs.position;
        String fileHash = attrs.fileHash;

        String url = null;

        if (!position) {
            position = -1;
        }
        if (program) {
            if (program.posterPath && program.posterType && program.posterHash) {

                /*File file = new File(com.boful.nts.utils.SystemConfig.webRootDir, 'upload/posters/'+program.posterHash + "." + program.posterType);
                if (file.exists()) {
                    url = "${resource(dir: 'upload/posters', file: program.posterHash + "." + program.posterType)}";
                } else {
                    url = programService.generalProgramPoster(program, size, position);
                }*/
                url = programService.generalFilePoster(program.posterHash, size, position)

            } else {
                if (program.otherOption == Program.ONLY_FLASH_OPTION) {
                    url = "${resource(dir: 'images/flash', file: 'flash-imgs.png')}";
                } else {
                    url = programService.generalProgramPoster(program, size, position);
                }
            }
        }

        if (serial) {
            //def reg = /^[0-9A-F]{32}$/;
            if (serial.photo && serial.photo ==~ /^[0-9A-F]{32}$/) {
                url = programService.generalFilePoster(serial.photo, size, position);
            } else {
                if (serial?.filePath.endsWith('swf') || serial?.filePath.endsWith('SWF')) {
                    url = "${resource(dir: 'images/flash', file: 'flash-imgs.png')}";
                } else {
                    url = programService.generalSerialPoster(serial, size, position);
                }
            }

        }

        if (fileHash) {
            url = programService.generalFilePoster(fileHash, size, position);
        }


        if (!url) {
            url = "${resource(dir: '/skin/blue/pc/front/images', file: 'boful_default_img.png')}";
        }
        out << url
    }

    def verticalPosterLinkNew = { attrs, body ->
        Program program = attrs.program;
        Serial serial = attrs.serial;
        String size = attrs.size;
        def position = attrs.position;

        String url = null;

        if (!position) {
            position = -1;
        }
        if (program) {
            if (program.verticalPosterPath && program.verticalPosterType && program.verticalPosterHash) {
                url = programService.generalFilePoster(program.verticalPosterHash, size, position)

            } else {
                url = programService.generalProgramPoster(program, size, position);
            }
        }

        if (serial) {
            if (serial.photo && serial.photo ==~ /^[0-9A-F]{32}$/) {
                url = programService.generalFilePoster(serial.photo, size, position);
            } else {
                url = programService.generalSerialPoster(serial, size, position);
            }
        }

        if (!url) {
            url = "${resource(dir: '/skin/blue/pc/front/images', file: 'boful_default_img.png')}";
        }
        if (url.startsWith("http://")) {
            try {
                URL url1 = new URL(url);
                url = url1.openConnection().getInputStream().getText("UTF-8");
            } catch (Exception e) {
            }
        }
        out << url
    }

    //根据用户ID返回姓名name 2012-06-26 崔雅鑫
    def consumerName = { attrs, body ->
        def id = attrs.id
        def consumer = Consumer.get(id)
        if (consumer) {
            if (consumer.nickname) {
                out << consumer.nickname
            } else {
                out << consumer.name
            }
        } else {
            out << '--'
        }
    }

    //根据主题ID返回最后一次回帖的时间 2012-06-28 崔雅鑫
    def getLastReplyTime = { attrs, body ->
        def mainArticleId = CTools.nullToZero(attrs.artId).longValue()
        def lastDateTime = ForumReplyArticle.executeQuery("select max(fr.dateCreated) from ForumReplyArticle fr where fr.forumMainArticle.id = :artId", [artId: mainArticleId])[0]
        out << ((lastDateTime == null) ? '--' : CTools.readSpecifiedDateTime('yyyy-MM-dd HH:mm:ss', lastDateTime))
    }

    //分类浏览中目录列表链接
    def directoryLinks = { attrs, body ->
        def directoryList = attrs.directoryList
        if (directoryList) {
            def cols = 10 //每行显示的分类数
            def rows = (directoryList.size() + cols - 1) / cols

            out << '<div id="directoryList">'
            out << '<table width="100%" align=center border="0" align="center" cellpadding="0" cellspacing="0">'
            for (i in 1..rows) {
                out << '<tr>'
                for (j in 1..cols) {
                    def index = ((i - 1) * cols + j - 1).toInteger()
                    if (index < directoryList.size()) {
                        out << '<td><a href="' + createLink(action: 'directoryView', params: [directoryId: directoryList[index]?.id]) + '">' + directoryList[index]?.name + '</a></td>'
                    } else {
                        out << '<td>&nbsp;</td>'
                    }
                }
                out << '</tr>'

            }
            out << '</table>'
            out << '</div>'
        } else {
            out << "尚未设置类别"
        }
    }

    //播放链接,指在列表页面中的链接，单个文件直接播放，多文件打开详细页面
    def playPrgram = { attrs, body ->

        def authStateMap = [OK: 0, AUTH_FAIL: 1, NO_EXIST: 2]
        def program = attrs.program


        def serials = null
        boolean isPlay = CTools.nullToOne(attrs.isPlay) == 1
        def url = ""
        def urlType = 0
        def authState = authStateMap.OK    //0 能播放 1权限不够 2节目不存在
        def strPlay = ""
        def serialId = 0
        Map args = null    //用于传到服务层的参数
        boolean bAuthOK = false
        def playType = false;//programService.judePlayType(request.getHeader("User-Agent"))
        def serial = null

        if (program) {
            //playSerials包括视音频0，课件1，在线课件4,6 链接
            def playSerials = null

            serials = program.serials
            def webHost = request.getServerName()

            if (request.getServerPort() != 80) webHost += ":" + request.getServerPort()

            //如果是下载 0是下载 1是播放
            if (!isPlay)
                playSerials = serials.findAll {
                    it.urlType == Serial.URL_TYPE_VIDEO || it.urlType == Serial.URL_TYPE_COURSE || it.urlType == Serial.URL_TYPE_DOCUMENT
                }
            else
                playSerials = serials.findAll {
                    it.urlType == Serial.URL_TYPE_VIDEO || it.urlType == Serial.URL_TYPE_COURSE || it.urlType == Serial.URL_TYPE_DOCUMENT || it.urlType == Serial.URL_TYPE_ONLINE_COURSE || it.urlType == Serial.URL_TYPE_LINK || it.urlType == Serial.URL_TYPE_TRURAN_COURSE || it.urlType == Serial.URL_TYPE_MOBILE || it.urlType == Serial.URL_TYPE_TABLET
                }

            //如果是下载 0是下载 1是播放
            if (!isPlay) {
                //1是移动手机播放
                if (playType == Serial.PLAY_TYPE_MOBILE) {
                    playSerials = serials.findAll { it.urlType == Serial.URL_TYPE_MOBILE }
                }
                //2是移动平板播放
                else if (playType == Serial.PLAY_TYPE_TABLET) {
                    playSerials = serials.findAll { it.urlType == Serial.URL_TYPE_TABLET }
                } else {
                    playSerials = serials.findAll {
                        it.urlType == Serial.URL_TYPE_VIDEO || it.urlType == Serial.URL_TYPE_COURSE || it.urlType == Serial.URL_TYPE_DOCUMENT || it.urlType == Serial.URL_TYPE_MOBILE || it.urlType == Serial.URL_TYPE_TABLET
                    }
                }
            } else {
                //1是移动手机播放
                if (playType == 1) {
                    playSerials = serials.findAll { it.urlType == Serial.URL_TYPE_MOBILE }
                }
                //2是移动平板播放
                else if (playType == 2) {
                    playSerials = serials.findAll { it.urlType == Serial.URL_TYPE_TABLET }
                } else {
                    playSerials = serials.findAll {
                        it.urlType == Serial.URL_TYPE_VIDEO || it.urlType == Serial.URL_TYPE_COURSE || it.urlType == Serial.URL_TYPE_DOCUMENT || it.urlType == Serial.URL_TYPE_ONLINE_COURSE || it.urlType == Serial.URL_TYPE_LINK || it.urlType == Serial.URL_TYPE_TRURAN_COURSE || it.urlType == Serial.URL_TYPE_MOBILE || it.urlType == Serial.URL_TYPE_TABLET
                    }
                }
            }

            playSerials = playSerials.asList()

            if (playSerials.size() == 1) {
                def auth = programService.queryAuthority(session?.consumer, program, request.getRemoteAddr())
                bAuthOK = isPlay ? auth.canPlay : auth.canDownload

                if (bAuthOK) {
                    serial = playSerials[0];

                    //////////////////////////////////////////////获得播放地址开始
                    def videoHost = ""
                    def svrAddress = ""
                    def sVideoPort = servletContext.videoPort    //视频服务器端口
                    def pwd = ""

                    if (serial) svrAddress = serial.svrAddress
                    if (servletContext.videoSevr == '' || svrAddress.startsWith("127.0.0.1") || svrAddress.startsWith("localhost")) svrAddress = request.getServerName()
                    videoHost = svrAddress + ":" + sVideoPort

                    pwd = (servletContext.authPrefix + session?.consumer?.name + servletContext.authPostfix).encodeAsMD5()

                    args = [serial: serial, consumer: session.consumer, webHost: webHost, videoHost: videoHost, pwd: pwd, isPlay: isPlay, playType: playType]
                    url = programService.generalSerialUrl(args)
                    //////////////////////////////////////////////获得播放地址结束

                    urlType = serial.urlType
                    serialId = serial.id
                } else {
                    authState = authStateMap.AUTH_FAIL
                }
            } else {
                def contextPath = grailsApplication.metadata['app.context'];
                if ("/".equals(contextPath)) {
                    contextPath = '';
                }
                url = "http://${webHost}" + contextPath + "/program/showProgram?id=${program?.id}"
                //多文件都作为视音频
                urlType = Serial.URL_TYPE_VIDEO
            }
        } else {
            authState = authStateMap.NO_EXIST
        }

        strPlay = "playProgram('" + url + "'," + program?.id + "," + urlType + "," + (isPlay ? 1 : 0) + "," + authState + "," + playType + "," + serialId + "," + (serial ? serial.transcodeState : 0) + "," + (serial ? serial.state : 0) + ");"

        out << strPlay
    }

    //播放链接列表
    def playLinks = { attrs, body ->
        def program = null
        def authStateMap = [OK: 0, AUTH_FAIL: 1, NO_EXIST: 2]
        def authState = authStateMap.OK    //0 能播放 1权限不够 2节目不存在
        def serials = attrs.serials
        boolean isPlay = CTools.nullToOne(attrs.isPlay) == 1
        def programId = CTools.nullToZero(attrs.programId)
        def webHost = request.getServerName()
        def strLinks = ""
        def fileInfo = ""
        def batchPlay = ""
        def jsSerial = '<SCRIPT LANGUAGE="JavaScript">\n'    //javascript serial对象字符串
        def jsIndex = 0    ////javascript serial对象数组下标
        def index = 0
        def urlType = 0
        boolean bAuthOK = true
        Map args = null    //用于传到服务层的参数
        int playType = programService.judePlayType(request.getHeader("User-Agent")) //0是普通pc机播放，1是移动手机播放，2是移动平板播放
        boolean hasImg = false
        def size = CTools.nullToBlank(attrs.size)

        String[] arrStr = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
        int[] arrTotal = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] //各类资源的数目
        int[] arrIndex = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] //各类资源的索引,即在播放行显示的1,2,3,4...等链接

        if (request.getServerPort() != 80) webHost += ":" + request.getServerPort()
        if (size == "") size = servletContext.thumbnailSize
        jsSerial += 'var serialListAll = new Array();\n'    //所有视音频
        jsSerial += 'var serialList = new Array();\n'    //已转码的视音频
        jsSerial += 'var canPlay = true;\n'    //是否能播放
        jsSerial += 'var canDownload = true;\n'    //是否能下载

        if (serials) {
            //playSerials包括视音频0，课件1，在线课件4,6 链接
            def playSerials = null
            def copyLink = ""
            def url = ""
            def playShow = ""
            program = Program.get(attrs.programId)

            //如果是下载 0是下载 1是播放
            if (!isPlay) {
                //playSerials = serials.findAll{it.urlType == nts.program.domain.Serial.URL_TYPE_VIDEO || it.urlType == nts.program.domain.Serial.URL_TYPE_COURSE || it.urlType == nts.program.domain.Serial.URL_TYPE_DOCUMENT || it.urlType == nts.program.domain.Serial.URL_TYPE_MOBILE || it.urlType == nts.program.domain.Serial.URL_TYPE_TABLET}
                playSerials = serials.findAll {
                    it.urlType == Serial.URL_TYPE_VIDEO || it.urlType == Serial.URL_TYPE_COURSE || it.urlType == Serial.URL_TYPE_DOCUMENT
                }

            } else {
                hasImg = serials.any { elem -> elem.urlType == Serial.URL_TYPE_IMAGE && (elem.transcodeState & Serial.OPT_IMG_POSTER) != Serial.OPT_IMG_POSTER }
                playSerials = serials.findAll {
                    it.urlType == Serial.URL_TYPE_VIDEO || it.urlType == Serial.URL_TYPE_COURSE || it.urlType == Serial.URL_TYPE_DOCUMENT || it.urlType == Serial.URL_TYPE_ONLINE_COURSE || it.urlType == Serial.URL_TYPE_LINK || it.urlType == Serial.URL_TYPE_TRURAN_COURSE || it.urlType == Serial.URL_TYPE_TEXT_LIBRARY
                }
            }

            if (playSerials || hasImg) {
                playSerials.each { serial ->

                    arrTotal[serial.urlType]++
                }

                def auth = programService.queryAuthority(session?.consumer, program, request.getRemoteAddr())
                bAuthOK = isPlay ? auth.canPlay : auth.canDownload

                if (bAuthOK) {
                    playSerials.eachWithIndex { serial, i ->
                        fileInfo = readFileInfo(serial);
                        //if(true || fileInfo != '') fileInfo = '名称：' + serial.name + '<br>' + fileInfo + '<br>说明：鼠标右键可复制播放链接,粘贴到PPT或WORD文档等。'
                        //if(true || fileInfo != '') fileInfo = '名称：' + serial.name + '<br>' + fileInfo

                        //////////////////////////////////////////////获得播放地址开始
                        def videoHost = ""
                        def svrAddress = ""
                        def sVideoPort = servletContext.videoPort    //视频服务器端口
                        def pwd = ""

                        if (serial) svrAddress = serial.svrAddress
                        if (svrAddress == null || servletContext.videoSevr == '' || svrAddress.startsWith("127.0.0.1") || svrAddress.startsWith("localhost")) svrAddress = request.getServerName()
                        videoHost = svrAddress + ":" + sVideoPort

                        pwd = (servletContext.authPrefix + session?.consumer?.name + servletContext.authPostfix).encodeAsMD5()

                        args = [serial: serial, consumer: session.consumer, webHost: webHost, videoHost: videoHost, pwd: pwd, isPlay: isPlay, playType: playType]
                        url = serial.urlType == Serial.URL_TYPE_TEXT_LIBRARY ? "" : programService.generalSerialUrl(args)
                        //////////////////////////////////////////////获得播放地址结束

                        urlType = serial.urlType

                        if ((!isPlay && serial.urlType == Serial.URL_TYPE_VIDEO) || serial.urlType != Serial.URL_TYPE_VIDEO) {
                            if (arrTotal[serial.urlType] == 1) {
                                if (isPlay) {
                                    if (serial.urlType == Serial.URL_TYPE_DOCUMENT || serial.urlType == Serial.URL_TYPE_TEXT_LIBRARY)
                                        playShow = "打开"
                                    else
                                        playShow = "点击播放"
                                } else
                                    playShow = "点击下载"

                                if (serial.urlType == Serial.URL_TYPE_ONLINE_COURSE) {
                                    arrStr[serial.urlType] += '<dd><a href="' + url + '" onclick="javascript:playProgram(\'\',' + program.id + ',' + urlType + ',' + (isPlay ? 1 : 0) + ',0,' + playType + ',' + serial.id + ',' + serial.transcodeState + ',' + serial.state + ')" target="_blank">' + playShow + '</a></dd>'
                                } else {
                                    arrStr[serial.urlType] += '<dd><a href="javascript:playProgram(\'' + url + '\',' + program.id + ',' + urlType + ',' + (isPlay ? 1 : 0) + ',0,' + playType + ',' + serial.id + ',' + serial.transcodeState + ',' + serial.state + ')" >' + playShow + '</a></dd>'
                                }
                            } else {
                                //解决朱吉光课件播放第二个时很忙的问题。
                                if (serial.urlType == Serial.URL_TYPE_ONLINE_COURSE) {
                                    arrStr[serial.urlType] += '<dd><a href="' + url + '" onclick="playProgram(\'\',' + program.id + ',' + urlType + ',' + (isPlay ? 1 : 0) + ',0,' + playType + ',' + serial.id + ',' + serial.transcodeState + ',' + serial.state + ')" title="' + serial.name + '" target="_blank">' + arrIndex[serial.urlType] + '</a></dd>'
                                } else {
                                    arrStr[serial.urlType] += '<dd><a href="javascript:playProgram(\'' + url + '\',' + program.id + ',' + urlType + ',' + (isPlay ? 1 : 0) + ',0,' + playType + ',' + serial.id + ',' + serial.transcodeState + ',' + serial.state + ')" title="' + serial.name + '" >' + arrIndex[serial.urlType] + '</a></dd>'
                                }

                                arrIndex[serial.urlType]++
                            }
                        }
                        if (isPlay && serial.urlType == Serial.URL_TYPE_VIDEO) {
                            //args = args.push(isFlashPlay:true)
                            boolean isMp4 = false
                            isMp4 = CTools.readExtensionName(serial.filePath).toUpperCase() == 'MP4'
                            if (isPlay && (serial.state == Serial.CODED_STATE || (serial.state == Serial.NO_NEED_STATE && isMp4))) {
                                args = [serial: serial, consumer: session.consumer, webHost: webHost, videoHost: videoHost, pwd: pwd, isPlay: isPlay, playType: playType, isFlashPlay: true]
                                url = programService.generalSerialUrl(args)
                            }

                            jsSerial += 'serialListAll[' + jsIndex + '] = new CSerialObj(' + serial.id + ',' + program.id + ',' + serial.serialNo + ',\'' + serial.name.encodeAsJavaScript() + '\',\'' + url + '\',\'' + serial.startTime + '\',\'' + serial.endTime + '\',' + serial.transcodeState + ',\'' + readImgAddr(serial, true, size, servletContext.thumbnailPos, 1) + '\',' + serial.state + ',\'' + serial.fileHash + '\',\'' + serial.fileType + '\');\n'
                            serial.subtitles.eachWithIndex { subtitle, k ->
                                args = [subtitle: subtitle, videoHost: videoHost]
                                url = programService.generalSubtitleUrl(args)
                                jsSerial += 'serialListAll[' + jsIndex + '].subtitles[' + k + '] = {id:' + subtitle.id + ',type:' + subtitle.type + ',url:\'' + url + '\',lang:{shortName:\'' + subtitle?.lang?.shortName + '\',enName:\'' + subtitle?.lang?.enName + '\',zhName:\'' + subtitle?.lang?.zhName + '\'}};\n'
                            }

                            jsIndex++
                        }
                    }

                    //if(arrIndex[nts.program.domain.Serial.URL_TYPE_VIDEO] > 1) batchPlay = '<a href="#batch" id="batchLink" title="播放全部或选择部分播放" onclick="selectProgram(0,2,1);return false;">批量播放</a>'

                    strLinks = ''
                    for (int i = 0; i < arrStr.length; i++) {
                        if (arrStr[i] != "" && i != Serial.URL_TYPE_EMBED_PC && i != Serial.URL_TYPE_MOBILE && i != Serial.URL_TYPE_TABLET) {
                            strLinks += '<dl><dt>' + ((i == Serial.URL_TYPE_VIDEO || i == Serial.URL_TYPE_MOBILE || i == Serial.URL_TYPE_TABLET) ? '视音频' : Serial.urlTypeName[i]) + '：</dt>' + (isPlay && i == Serial.URL_TYPE_VIDEO ? batchPlay : '') + arrStr[i] + copyLink + '</dl>\n'
                        }
                    }

                    if (hasImg && isPlay) strLinks += '<dl><dt>查看图片：</dt><dd><a href="/program/photoList?programId=' + programId + '" target="_blank">查看图片</a></dd></dl>\n'
                }
                //没有权限
                else {
                    authState = authStateMap.AUTH_FAIL
                    //strLinks = '<dl><dt>点击播放：</dt><dd><a href="javascript:playProgram(\'AUTH_FAIL\',0,0,'+(isPlay?1:0)+','+authState+','+playType+',0)" >'+(isPlay?'点击播放':'点击下载')+'</a></dd></dl>\n'
                    jsSerial += (isPlay ? 'canPlay' : 'canDownload') + ' = false;\n'
                }
            }
        }


        jsSerial += '</SCRIPT>\n'

        if (isPlay) {
            //println jsSerial
            out << jsSerial
        }
        out << strLinks
    }

    //用于分享中给embedPlay.gsp提供数据
    def embedSerialData = { attrs, body ->
        def program = null
        def serial = null
        def authStateMap = [OK: 0, AUTH_FAIL: 1, NO_EXIST: 2]
        def authState = authStateMap.OK    //0 能播放 1权限不够 2节目不存在

        boolean isPlay = true
        def programId = CTools.nullToZero(attrs.programId)
        def webHost = request.getServerName()

        def jsSerial = ''    //javascript serial对象字符串
        def jsIndex = 0    ////javascript serial对象数组下标
        def index = 0
        def urlType = 0
        boolean bAuthOK = true
        Map args = null    //用于传到服务层的参数
        int playType = programService.judePlayType(request.getHeader("User-Agent")) //0是普通pc机播放，1是移动手机播放，2是移动平板播放


        if (request.getServerPort() != 80) webHost += ":" + request.getServerPort()
        jsSerial += 'var serialObj = null;\n'    //所有视音频

        program = Program.get(attrs.programId)
        if (program) {
            def url = ""

            serial = Serial.get(attrs.serialId)
            if (serial) {

                def auth = programService.queryAuthority(session?.consumer, program)
                bAuthOK = true    //auth.canPlay;

                if (bAuthOK) {

                    //////////////////////////////////////////////获得播放地址开始
                    def videoHost = ""
                    def svrAddress = ""
                    def sVideoPort = servletContext.videoPort    //视频服务器端口
                    def pwd = ""

                    svrAddress = serial.svrAddress
                    if (servletContext.videoSevr == '' || svrAddress.startsWith("127.0.0.1") || svrAddress.startsWith("localhost")) svrAddress = request.getServerName()
                    videoHost = svrAddress + ":" + sVideoPort

                    pwd = (servletContext.authPrefix + session?.consumer?.name + servletContext.authPostfix).encodeAsMD5()

                    args = [serial: serial, consumer: session.consumer, webHost: webHost, videoHost: videoHost, pwd: pwd, isPlay: isPlay, playType: playType]
                    url = serial.urlType == Serial.URL_TYPE_TEXT_LIBRARY ? "" : programService.generalSerialUrl(args)
                    //////////////////////////////////////////////获得播放地址结束

                    urlType = serial.urlType

                    if (serial.urlType == Serial.URL_TYPE_VIDEO) {
                        //args = args.push(isFlashPlay:true)
                        boolean isMp4 = false
                        isMp4 = CTools.readExtensionName(serial.filePath).toUpperCase() == 'MP4'
                        if (isPlay && (serial.state == Serial.CODED_STATE || (serial.state == Serial.NO_NEED_STATE && isMp4))) {
                            args = [serial: serial, consumer: session.consumer, webHost: webHost, videoHost: videoHost, pwd: pwd, isPlay: isPlay, playType: playType, isFlashPlay: true]
                            url = programService.generalSerialUrl(args)
                        }

                        jsSerial += 'serialObj = new CSerialObj(' + serial.id + ',' + program.id + ',' + serial.serialNo + ',\'' + serial.name.encodeAsJavaScript() + '\',\'' + url + '\',\'' + serial.startTime + '\',\'' + serial.endTime + '\',' + serial.transcodeState + ',\'' + readImgAddr(serial, true, servletContext.thumbnailSize, servletContext.thumbnailPos, 1) + '\',' + serial.state + ');\n'
                        serial.subtitles.eachWithIndex { subtitle, k ->
                            args = [subtitle: subtitle, videoHost: videoHost]
                            url = programService.generalSubtitleUrl(args)
                            jsSerial += 'serialObj.subtitles[' + k + '] = {id:' + subtitle.id + ',type:' + subtitle.type + ',url:\'' + url + '\',lang:{shortName:\'' + subtitle?.lang?.shortName + '\',enName:\'' + subtitle?.lang?.enName + '\',zhName:\'' + subtitle?.lang?.zhName + '\'}};\n'
                        }

                    }


                }
                //没有权限
                else {
                    authState = authStateMap.AUTH_FAIL
                }
            }
        }



        out << jsSerial
    }

    //图片链接列表
    def imgLinks = { attrs, body ->
        def serialList = attrs.serials.findAll { it.urlType == Serial.URL_TYPE_IMAGE }.toList()
        if (serialList) {
            def width = 0;
            def cols = CTools.nullToZero(attrs.cols) //每行显示的列数
            if (cols < 1) cols = 6
            //四舍五入
            width = ((100 / cols).setScale(1, BigDecimal.ROUND_HALF_UP))

            def rows = (serialList.size() + cols - 1) / cols
            def imgAddr = ""

            out << '<div id="imgList">'
            out << '<table width="100%" align=center border="0" align="center" cellpadding="0" cellspacing="0">'
            for (i in 1..rows) {
                out << '<tr>'
                for (j in 1..cols) {
                    def index = ((i - 1) * cols + j - 1).toInteger()
                    if (index < serialList.size()) {
                        imgAddr = readImgAddr(serialList[index], false)
                        out << '<td width="' + width + '%" align="center" valign="bottom"><img id="abbrImg_' + index + '" style="cursor:pointer;" src="' + readImgAddr(serialList[index], true) + '" onclick="openImg(' + index + ',\'' + imgAddr + '\');"><br><a href="javascript:openImg(' + index + ',\'' + imgAddr + '\');">' + serialList[index]?.name + '</a></td>'
                    } else {
                        out << '<td width="' + width + '%">&nbsp;</td>'
                    }
                }
                out << '</tr>'

            }
            out << '</table>'
            out << '<input name="abbrImgNum" id="abbrImgNum" type="hidden" value="' + serialList.size() + '" />'
            out << '</div>'
        } else {
            out << ""
        }

    }

    //点播了此节目的用户链接列表
    def consumerLinks = { attrs, body ->
        def consumerList = attrs.consumerList
        if (consumerList) {
            def cols = 6 //每行显示的列数
            def rows = (consumerList.size() + cols - 1) / cols

            out << '<div id="consumerList">'
            out << '<table width="100%" align=center border="0" align="center" cellpadding="0" cellspacing="0">'
            for (i in 1..rows) {
                out << '<tr>'
                for (j in 1..cols) {
                    def index = ((i - 1) * cols + j - 1).toInteger()
                    if (index < consumerList.size()) {
                        out << '<td><a href="' + createLink(action: 'linkView', params: [type: 1, keyword: consumerList[index]?.id, cnName: consumerList[index]?.nickname]) + '">' + consumerList[index].nickname?.encodeAsHTML() + '</a></td>'
                    } else {
                        out << '<td>&nbsp;</td>'
                    }
                }
                out << '</tr>'

            }
            out << '</table>'
            out << '</div>'
        } else {
            out << "尚无用户点播"
        }

    }

    //点播了此节目的用户还点播了链接列表 三个links有很多重复代码，以后加参数优化
    def otherProgramLinks = { attrs, body ->
        def otherProgramList = attrs.otherProgramList
        if (otherProgramList) {
            otherProgramList = otherProgramList.grep { elem ->
                elem.state > 0
            }

            def cols = 5 //每行显示的列数
            def rows = (otherProgramList.size() + cols - 1) / cols

            out << '<div id="otherProgramList">'
            out << '<table width="100%" align=center border="0" align="center" cellpadding="0" cellspacing="0">'
            for (i in 1..rows) {
                out << '<tr>'
                for (j in 1..cols) {
                    def index = ((i - 1) * cols + j - 1).toInteger()
                    if (index < otherProgramList.size()) {
                        out << '<td><a href="' + createLink(action: 'showProgram', params: [id: otherProgramList[index].id]) + '" title="' + otherProgramList[index]?.name + '">' + CTools.cutString(otherProgramList[index]?.name, 18).encodeAsHTML() + '</a></td>'
                    } else {
                        out << '<td>&nbsp;</td>'
                    }
                }
                out << '</tr>'

            }
            out << '</table>'
            out << '</div>'
        } else {
            out << "尚无用户点播"
        }

    }

    //相关资源链接列表 三个links有很多重复代码，以后加参数优化
    def relationProgramLinks = { attrs, body ->
        def programList = attrs.programList
        if (programList) {
            programList = programList.grep { elem ->
                elem.state > 0
            }

            def cols = 5 //每行显示的列数
            def rows = (programList.size() + cols - 1) / cols

            out << '<div id="relationProgramList">'
            out << '<table width="100%" align=center border="0" align="center" cellpadding="0" cellspacing="0">'
            for (i in 1..rows) {
                out << '<tr>'
                for (j in 1..cols) {
                    def index = ((i - 1) * cols + j - 1).toInteger()
                    if (index < programList.size()) {
                        out << '<td><a href="' + createLink(action: 'showProgram', params: [id: programList[index]?.id]) + '" title="' + programList[index]?.name + '">' + CTools.cutString(programList[index]?.name, 18).encodeAsHTML() + '</a></td>'
                    } else {
                        out << '<td>&nbsp;</td>'
                    }
                }
                out << '</tr>'

            }
            out << '</table>'
            out << '</div>'
        } else {
            out << "尚未设置相关资源"
        }

    }

    //发布到用户组checkbox列表
    def groupListCheckboxes = { attrs, body ->
        def cols = 5 //每行显示的列数
        def list = attrs.list
        if (list) {
            if (attrs.cols) cols = attrs.cols
            def rows = (list.size() + cols - 1) / cols

            out << '<div id="groupList">'
            out << '<table width="100%" align=center border="0" align="center" cellpadding="0" cellspacing="0">'
            for (i in 1..rows) {
                out << '<tr>'
                for (j in 1..cols) {
                    def index = ((i - 1) * cols + j - 1).toInteger()
                    if (index < list.size()) {
                        out << '<td><input type="checkbox" name="groupList" value=' + list[index]?.id + '>&nbsp;' + list[index]?.name + '</td>'
                    } else {
                        out << '<td>&nbsp;</td>'
                    }
                }
                out << '</tr>'

            }
            out << '</table>'
            out << '</div>'
        } else {
            out << "尚无用户组"
        }

    }

    //标签列表
    def programTagLinks = { attrs, body ->
        def programTagList = attrs.programTagList
        if (programTagList) {
            def programTag
            def cols = 5 //每行显示的列数
            def rows = (programTagList.size() + cols - 1) / cols

            for (i in 1..rows) {
                out << '<tr>'
                for (j in 1..cols) {
                    def index = ((i - 1) * cols + j - 1).toInteger()
                    if (index < programTagList.size()) {
                        programTag = programTagList[index]
                        out << '<td><a href="' + createLink(action: 'searchProgram', params: [elementId: -1, keyword: programTag?.id]) + '">' + programTag?.name.encodeAsHTML() + '</a></td>'
                    } else {
                        out << '<td>&nbsp;</td>'
                    }
                }
                out << '</tr>'
            }
        } else {
            out << "<tr><td>尚无标签</td></tr>"
        }
    }

    def linkFunction = { attrs, body ->
        def writer = out
        //println attrs.template
        writer << '<a href="javascript:updateTemplate(\'' + createLink(action: attrs.action) + '\',\'' + attrs.node + '\',\''
        // create the link 
        if (request['flowExecutionKey']) {
            if (!attrs.params) attrs.params = [:]
            attrs.params."_flowExecutionKey" = request['flowExecutionKey']
        }
        def strArgs = ""

        attrs.params.each { k, v ->
            strArgs += "&$k=$v"
        }
        writer << strArgs.encodeAsJavaScript()
        writer << "');"
        writer << '"'
        // process remaining attributes
        attrs.each { k, v ->
            writer << " $k=\"$v\""
        }
        writer << '>'
        // output the body
        writer << body()
        // close tag
        writer << '</a>'
    }

    //分页更新模板或html标签,<g:paginateTemplate node="${node?node:actionName}" total="${total}" params="${params}" />
    def paginateTemplate = { attrs ->
        def writer = out
        if (attrs.total == null)
            throwTagError("Tag [paginate] is missing required attribute [total]")
        def messageSource = grailsAttributes.getApplicationContext().getBean("messageSource")
        def locale = RCU.getLocale(request)
        def total = attrs.total.toInteger()
        def action = (attrs.action ? attrs.action : (params.action ? params.action : "list"))
        def offset = params.offset?.toInteger()
        def max = params.max?.toInteger()
        def maxsteps = (attrs.maxsteps ? attrs.maxsteps.toInteger() : 10)
        if (!offset) offset = (attrs.offset ? attrs.offset.toInteger() : 0)
        if (!max) max = (attrs.max ? attrs.max.toInteger() : 10)
        def linkParams = [offset: offset - max, max: max]
        if (params.sort) linkParams.sort = params.sort
        if (params.order) linkParams.order = params.order
        if (attrs.params) {
            linkParams.putAll(attrs.params)
            linkParams.offset = offset - max//add by jlf
        }
        def linkTagAttrs = [action: action]
        if (attrs.controller) {
            linkTagAttrs.controller = attrs.controller
        }
        if (attrs.id != null) {
            linkTagAttrs.id = attrs.id
        }
        //add by jlf
        if (attrs.node != null) {
            linkTagAttrs.node = attrs.node
        }
        linkTagAttrs.params = linkParams        // determine paging variables
        def steps = maxsteps > 0
        int currentstep = (offset / max) + 1
        int firststep = 1
        int laststep = Math.round(Math.ceil(total / max))        // display previous link when not on firststep
        if (currentstep > firststep) {
            linkTagAttrs.class = 'prevLink'
            writer << linkFunction(linkTagAttrs.clone()) {
                (attrs.prev ? attrs.prev : messageSource.getMessage('paginate.prev', null, messageSource.getMessage('default.paginate.prev', null, 'Previous', locale), locale))
            }
        }        // display steps when steps are enabled and laststep is not firststep
        if (steps && laststep > firststep) {
            linkTagAttrs.class = 'step'            // determine begin and endstep paging variables
            int beginstep = currentstep - Math.round(maxsteps / 2) + (maxsteps % 2)
            int endstep = currentstep + Math.round(maxsteps / 2) - 1
            if (beginstep < firststep) {
                beginstep = firststep
                endstep = maxsteps
            }
            if (endstep > laststep) {
                beginstep = laststep - maxsteps + 1
                if (beginstep < firststep) {
                    beginstep = firststep
                }
                endstep = laststep
            }            // display firststep link when beginstep is not firststep
            if (beginstep > firststep) {
                linkParams.offset = 0
                writer << linkFunction(linkTagAttrs.clone()) { firststep.toString() }
                writer << '<span class="step">..</span>'
            }            // display paginate steps
            (beginstep..endstep).each { i ->
                if (currentstep == i) {
                    writer << "<span class=\"currentStep\">${i}</span>"
                } else {
                    linkParams.offset = (i - 1) * max
                    writer << linkFunction(linkTagAttrs.clone()) { i.toString() }
                }
            }            // display laststep link when endstep is not laststep
            if (endstep < laststep) {
                writer << '<span class="step">..</span>'
                linkParams.offset = (laststep - 1) * max
                writer << linkFunction(linkTagAttrs.clone()) { laststep.toString() }
            }
        }        // display next link when not on laststep
        if (currentstep < laststep) {
            linkTagAttrs.class = 'nextLink'
            linkParams.offset = offset + max
            writer << linkFunction(linkTagAttrs.clone()) {
                (attrs.next ? attrs.next : messageSource.getMessage('paginate.next', null, messageSource.getMessage('default.paginate.next', null, 'Next', locale), locale))
            }
        }
    }


    def sortableHref = { attrs ->
        def writer = out
        if (!attrs.property)
            throwTagError("Tag [sortableColumn] is missing required attribute [property]")
        if (!attrs.title && !attrs.titleKey)
            throwTagError("Tag [sortableColumn] is missing required attribute [title] or [titleKey]")
        def property = attrs.remove("property")
        def action = attrs.action ? attrs.remove("action") : (actionName ?: "list")
        def defaultOrder = attrs.remove("defaultOrder")
        if (defaultOrder != "desc") defaultOrder = "asc"        // current sorting property and order
        def sort = params.sort
        def order = params.order        // add sorting property and params to link params
        def linkParams = [:]
        if (params.id) linkParams.put("id", params.id)
        if (attrs.params) linkParams.putAll(attrs.remove("params"))
        linkParams.sort = property        // determine and add sorting order for this column to link params
        attrs.class = (attrs.class ? "${attrs.class} sortable" : "sortable")
        if (property == sort) {
            attrs.class = attrs.class + " sorted " + order
            if (order == "asc") {
                linkParams.order = "desc"
            } else {
                linkParams.order = "asc"
            }
        } else {
            linkParams.order = defaultOrder
        }        // determine column title
        def title = attrs.remove("title")
        def titleKey = attrs.remove("titleKey")
        if (titleKey) {
            if (!title) title = titleKey
            def messageSource = grailsAttributes.messageSource
            def locale = RCU.getLocale(request)
            title = messageSource.getMessage(titleKey, null, title, locale)
        }        //writer << "<th "
        // process remaining attributes
        attrs.each { k, v ->
            //writer << "${k}=\"${v.encodeAsHTML()}\" "
        }
        writer << "${link(action: action, params: linkParams) { title }}"
    }

    //重写分页
    def paginate = { attrs ->
        def writer = out
        if (attrs.total == null)
            throwTagError("Tag [paginate] is missing required attribute [total]")
        def messageSource = grailsAttributes.messageSource
        def locale = RCU.getLocale(request)
        def total = attrs.int('total') ?: 0
        def action = (attrs.action ? attrs.action : (params.action ? params.action : "list"))
        def offset = params.int('offset') ?: 0
        def max = params.int('max')
        def maxsteps = (attrs.int('maxsteps') ?: 10)
        if (!offset) offset = (attrs.int('offset') ?: 0)
        if (!max) max = (attrs.int('max') ?: 10)
        def linkParams = [:]
        if (attrs.params) linkParams.putAll(attrs.params)
        linkParams.offset = offset - max
        linkParams.max = max
        if (params.sort) linkParams.sort = params.sort
        if (params.order) linkParams.order = params.order
        def linkTagAttrs = [action: action]
        if (attrs.controller) {
            linkTagAttrs.controller = attrs.controller
        }
        if (attrs.id != null) {
            linkTagAttrs.id = attrs.id
        }
        linkTagAttrs.params = linkParams        // determine paging variables
        def steps = maxsteps > 0
        int currentstep = (offset / max) + 1
        int firststep = 1
        int laststep = Math.round(Math.ceil(total / max))        // display previous link when not on firststep
        if (currentstep > firststep) {
            linkTagAttrs.class = 'prevLink'
            linkParams.offset = offset - max
            writer << link(linkTagAttrs.clone()) {
                (attrs.prev ? attrs.prev : messageSource.getMessage('paginate.prev', null, messageSource.getMessage('default.paginate.prev', null, 'Previous', locale), locale))
            }
        }        // display steps when steps are enabled and laststep is not firststep
        if (steps && laststep > firststep) {
            linkTagAttrs.class = 'step'            // determine begin and endstep paging variables
            int beginstep = currentstep - Math.round(maxsteps / 2) + (maxsteps % 2)
            int endstep = currentstep + Math.round(maxsteps / 2) - 1
            if (beginstep < firststep) {
                beginstep = firststep
                endstep = maxsteps
            }
            if (endstep > laststep) {
                beginstep = laststep - maxsteps + 1
                if (beginstep < firststep) {
                    beginstep = firststep
                }
                endstep = laststep
            }            // display firststep link when beginstep is not firststep
            if (beginstep > firststep) {
                linkParams.offset = 0
                writer << link(linkTagAttrs.clone()) { firststep.toString() }
                writer << '<span class="step">..</span>'
            }            // display paginate steps
            (beginstep..endstep).each { i ->
                if (currentstep == i) {
                    writer << "<span class=\"currentStep\">${i}</span>"
                } else {
                    linkParams.offset = (i - 1) * max
                    writer << link(linkTagAttrs.clone()) { i.toString() }
                }
            }            // display laststep link when endstep is not laststep
            if (endstep < laststep) {
                writer << '<span class="step">..</span>'
                linkParams.offset = (laststep - 1) * max
                writer << link(linkTagAttrs.clone()) { laststep.toString() }
            }
        }        // display next link when not on laststep
        if (currentstep < laststep) {
            linkTagAttrs.class = 'nextLink'
            linkParams.offset = offset + max
            writer << link(linkTagAttrs.clone()) {
                (attrs.next ? attrs.next : messageSource.getMessage('paginate.next', null, messageSource.getMessage('default.paginate.next', null, 'Next', locale), locale))
            }
        }

        ////////////////////add by jlf for turn page begin
        if (laststep > 1) {
            //约定一数字，以作替换
            linkParams.offset = 1234554321
            def strLink = createLink(linkTagAttrs.clone())
            writer << '\n<script type="text/javascript" src="' + createLinkTo(dir: "js", file: "boful/common/turnPage.js") + '"></script>\n'
            writer << '<input type="text" name="turnPage" id="turnPage" value="' + currentstep + '" onkeydown="if(event.keyCode==13) turnPageTo(' + max + ',' + laststep + ',\'' + strLink + '\');" onkeyup="this.value=this.value.replace(/\\D/gi,\'\')">/' + laststep + '&nbsp;'
            writer << '<input type="button" name="turnPageBtn" id="turnPageBtn" onclick="turnPageTo(' + max + ',' + laststep + ',\'' + strLink + '\');" value="转页">\n'
        }
        ///////////////////add by jlf for turn page end
    }

    //获得文件物理信息
    def readFileInfo(serial) {
        def str = ''
        if (serial) {
            str += serial.name
            //str += '时长：'+nts.utils.CTools.timeLenToStr(serial.bandWidth)+'<br>'
            //str += '码率：'+nts.utils.CTools.zeroToUnknown(serial.bandWidth)+'<br>'
            //str += nts.program.domain.Serial.cnField.strProgType+'：'+serial.strProgType+'<br>'
            //str += nts.utils.CTools.nullToBlank(serial.formatAbstract)
            //str  = str.replace("\r\n","<br>");
            //str  = str.replace("\n","<br>");
        }

        return str.encodeAsJavaScript();
    }

    //获得图片地址 tnflag: 缩略图标志:   1 - 海报  2 - 剧照  3 - 海报缩略图
    def readImgAddr(serial, isAbbrImg) {
        def sImgAddr = ""
        sImgAddr = readImgAddr(serial, isAbbrImg, servletContext.thumbnailSize, servletContext.thumbnailPos, 3, 0)

        return sImgAddr;
    }

    //获得图片地址 tnflag: 缩略图标志:   1 - 海报  2 - 剧照  3 - 海报缩略图
    def readImgAddr(serial, isAbbrImg, size, position, tnflag) {
        def sImgAddr = ""
        sImgAddr = readImgAddr(serial, isAbbrImg, size, servletContext.thumbnailPos, tnflag, 0)

        return sImgAddr;
    }

    //获得图片地址  size: 图像尺寸 ,如 310x415 , 0 表示使用视频尺寸 pos:  视频截取位置 400 单位 秒 , 如300 表示5分钟开始位置 tnflag: 缩略图标志:   1 - 海报  2 - 剧照  3 - 海报缩略图
    def readImgAddr(serial, isAbbrImg, size, position, tnflag, force) {
        def sImgAddr = ""
        def tnUrl = ""    //自动生成图片url，并用于magic=86f9436c
        //force =1	//用于测试，正式用时应注释掉
        if (serial) {
            def svrAddress = serial.svrAddress
            def filePath = serial.filePath

            if (servletContext.videoSevr == '' || (servletContext.videoSevr == '' && svrAddress.videoSevr == '') || svrAddress.startsWith("127.0.0.1") || svrAddress.startsWith("localhost")) svrAddress = request.getServerName()
            //if(serial.urlType == nts.program.domain.Serial.URL_TYPE_VIDEO && nts.utils.CTools.nullToBlank(serial.photo) != "") filePath = serial.photo

            //tnUrl = nts.utils.CTools.readFileName(filePath,true)+'?size='+size+'&pos='+position+'&tnflag='+tnflag+'&force='+force
            //println tnUrl

            if (serial.urlType == Serial.URL_TYPE_VIDEO) {
                if (CTools.nullToBlank(serial.photo) != "")
                    sImgAddr = 'http://' + svrAddress + ':' + servletContext.videoPort + '/media/' + serial.photo + "." + serial.fileType + '?' + size
                else {
                    sImgAddr = 'http://' + svrAddress + ':' + servletContext.videoPort + '/bmc2/poster/' + serial.fileHash + '/' + size + '_' + position+".png"
                }
            } else if (serial.urlType == Serial.URL_TYPE_IMAGE) {
                sImgAddr = 'http://' + svrAddress + ':' + servletContext.videoPort + '/media/' + serial.fileHash + "." + serial.fileType
            } else {
                if (CTools.nullToBlank(serial.photo) != "")
                    sImgAddr = 'http://' + svrAddress + ':' + servletContext.videoPort + '/media/' + serial.photo + "." + serial.fileType
                else {
                    sImgAddr = 'http://' + svrAddress + ':' + servletContext.videoPort + '/bmc2/poster/' + serial.fileHash + '/' + size + '_' + position+".png"
                }
            }


        }

        return sImgAddr;
    }

    //获得相册图片地址
    def photoLink = { attrs ->
        def serial = attrs.serial
        def isAbbrImg = attrs.isAbbrImg
        String url = programService.generalSerialPlayAddress(serial);
        //def sImgAddr = readImgAddr(serial, isAbbrImg)

        out << url
    }

    //获取公开课程数(只计算视频)
    def publicTotal = { attrs ->
        def serials = attrs.serial;
        List<Serial> serialList = [];
        serials.each {
            if (it.urlType == Serial.URL_TYPE_VIDEO) {
                serialList.add(it);
            }
        }
        out << serialList.size()
    }
    def mydatePicker = { attrs ->
        def xdefault = attrs['default']
        if (xdefault == null) {
            xdefault = new Date()
        } else if (xdefault.toString() != 'none') {
            if (xdefault instanceof String) {
                xdefault = DateFormat.getInstance().parse(xdefault)
            } else if (!(xdefault instanceof Date)) {
                throwTagError("Tag [datePicker] requires the default date to be a parseable String or a Date")
            }
        } else {
            xdefault = null
        }
        def value = attrs['value']
        if (value.toString() == 'none') {
            value = null
        } else if (!value) {
            value = xdefault
        }
        def name = attrs['name']
        def id = attrs['id'] ? attrs['id'] : name

        def noSelection = attrs['noSelection']
        if (noSelection != null) {
            noSelection = noSelection.entrySet().iterator().next()
        }
        def years = attrs['years']
        final PRECISION_RANKINGS = ["year": 0, "month": 10, "day": 20, "hour": 30, "minute": 40]
        def precision = (attrs['precision'] ? PRECISION_RANKINGS[attrs['precision']] :
                (grailsApplication.config.grails.tags.datePicker.default.precision ?
                        PRECISION_RANKINGS["${grailsApplication.config.grails.tags.datePicker.default.precision}"] :
                        PRECISION_RANKINGS["minute"]))
        def day
        def month
        def year
        def hour
        def minute
        def dfs = new java.text.DateFormatSymbols(RCU.getLocale(request))
        def c = null
        if (value instanceof Calendar) {
            c = value
        } else if (value != null) {
            c = new GregorianCalendar();
            c.setTime(value)
        }
        if (c != null) {
            day = c.get(GregorianCalendar.DAY_OF_MONTH)
            month = c.get(GregorianCalendar.MONTH)
            year = c.get(GregorianCalendar.YEAR)
            hour = c.get(GregorianCalendar.HOUR_OF_DAY)
            minute = c.get(GregorianCalendar.MINUTE)
        }
        if (years == null) {
            def tempyear
            if (year == null) {
                // If no year, we need to get current year to setup a default range… ugly
                def tempc = new GregorianCalendar()
                tempc.setTime(new Date())
                tempyear = tempc.get(GregorianCalendar.YEAR)
            } else {
                tempyear = year
            }
            years = (tempyear - 100)..(tempyear + 100)
        }
        out << "<input type=\"hidden\" name=\"${name}\" value=\"struct\" />"
        // create year select
        if (precision >= PRECISION_RANKINGS["year"]) {
            out.println "<select name=\"${name}_year\" id=\"${id}_year\">"
            if (noSelection) {
                renderNoSelectionOption(noSelection.key, noSelection.value, '')
                out.println()
            }
            for (i in years) {
                out.println "<option value=\"${i}\""
                if (i == year) {
                    out.println " selected=\"selected\""
                }
                out.println ">${i}</option>"
            }
            out.println '</select>'
        }
        // create month select
        if (precision >= PRECISION_RANKINGS["month"]) {
            out.println "<select name=\"${name}_month\" id=\"${id}_month\">"
            if (noSelection) {
                renderNoSelectionOption(noSelection.key, noSelection.value, '')
                out.println()
            }
            dfs.months.eachWithIndex { m, i ->
                if (m) {
                    def monthIndex = i + 1
                    out << "<option value=\"${monthIndex}\""
                    if (month == i) out << " selected=\"selected\""
                    out << '>'
                    out << m
                    out.println '</option>'
                }
            }
            out.println '</select>'
        }
        // create day select
        if (precision >= PRECISION_RANKINGS["day"]) {
            out.println "<select name=\"${name}_day\" id=\"${id}_day\">"
            if (noSelection) {
                renderNoSelectionOption(noSelection.key, noSelection.value, '')
                out.println()
            }
            for (i in 1..31) {
                out.println "<option value=\"${i}\""
                if (i == day) {
                    out.println " selected=\"selected\""
                }
                out.println ">${i}</option>"
            }
            out.println '</select>'
        }         // do hour select
        if (precision >= PRECISION_RANKINGS["hour"]) {
            out.println "<select name=\"${name}_hour\" id=\"${id}_hour\">"
            if (noSelection) {
                renderNoSelectionOption(noSelection.key, noSelection.value, '')
                out.println()
            }
            for (i in 0..23) {
                def h = '' + i
                if (i < 10) h = '0' + h
                out << "<option value=\"${h}\" "
                if (hour == h.toInteger()) out << "selected=\"selected\""
                out << '>' << h << '</option>'
                out.println()
            }
            out.println '</select> :'
            // If we're rendering the hour, but not the minutes, then display the minutes as 00 in read-only format
            if (precision < PRECISION_RANKINGS["minute"]) {
                out.println '00'
            }
        }        // do minute select
        if (precision >= PRECISION_RANKINGS["minute"]) {
            out.println "<select name=\"${name}_minute\" id=\"${id}_minute\">"
            if (noSelection) {
                renderNoSelectionOption(noSelection.key, noSelection.value, '')
                out.println()
            }
            for (i in 0..59) {
                def m = '' + i
                if (i < 10) m = '0' + m
                out << "<option value=\"${m}\" "
                if (minute == m.toInteger()) out << "selected=\"selected\""
                out << '>' << m << '</option>'
                out.println()
            }
            out.println '</select>'
        }
    }

    //查出学习社区下面所有的板块	2012/7/6	孙长贵
    def forumBoardList = { attrs, body ->
        def forumBoardList = ForumBoard.createCriteria().list(sort: "id", order: "asc") {
            eq("type", 2)
            studyCommunity {
                eq('id', CTools.nullToZero(session.communityId).longValue())
            }
        }
        forumBoardList?.each { forumBoard ->
            out << '<option value="' + forumBoard?.id + '">' + forumBoard?.name + '</option>'
        }
    }

    //活动作品图片链接
    def workImgLink = { attrs, body ->
        def userWork = attrs.userWork
        def isAbbrImg = attrs.isAbbrImg
        def has = false

        def size = servletContext.thumbnailSize
        def position = servletContext.thumbnailPos
        int tnflag = 1

        out << readWorkImgAddr(userWork, isAbbrImg, size, position, tnflag)

        //缺省图片
        //if(!has) out << createLinkTo(dir: 'images', file: (isAbbrImg ? 'defaultAbbrPoster.jpg' : 'defaultPoster.jpg'))
        //标签库可用${workImgLink(userWork:userWork)}
    }

    //获得图片地址 tnflag: 缩略图标志:   1 - 海报  2 - 剧照  3 - 海报缩略图
    def readWorkImgAddr(userWork, isAbbrImg, size, position, tnflag) {
        def sImgAddr = ""
        sImgAddr = readWorkImgAddr(userWork, isAbbrImg, servletContext.thumbnailSize, servletContext.thumbnailPos, tnflag, 0)

        return sImgAddr;
    }

    //获得作品图片地址  size: 图像尺寸 ,如 310x415 , 0 表示使用视频尺寸 pos:  视频截取位置 400 单位 秒 , 如300 表示5分钟开始位置 tnflag: 缩略图标志:   1 - 海报  2 - 剧照  3 - 海报缩略图
    def readWorkImgAddr(userWork, isAbbrImg, size, position, tnflag, force) {
        def sImgAddr = ""
        def tnUrl = ""    //自动生成图片url，并用于magic=86f9436c

        if (userWork) {
            def svrAddress = userWork.svrAddress
            def filePath = userWork.filePath

            if (servletContext.videoSevr == '' || svrAddress.startsWith("127.0.0.1") || svrAddress.startsWith("localhost")) svrAddress = request.getServerName()
            if (userWork.urlType == Serial.URL_TYPE_VIDEO && CTools.nullToBlank(userWork.photo) != "") filePath = userWork.photo

            tnUrl = CTools.readFileName(filePath, true) + '?size=' + size + '&pos=' + position + '&tnflag=' + tnflag + '&force=' + force
            //println tnUrl

            if (userWork.urlType == Serial.URL_TYPE_VIDEO) {
                if (CTools.nullToBlank(userWork.photo) != "")
                    if (isAbbrImg)
                        sImgAddr = 'http://' + svrAddress + ':' + servletContext.videoPort + '/course_tnimage/res_url/' + CTools.readFileDir(filePath).getBytes("utf-8").encodeAsBase64() + '@/' + tnUrl + '&magic=' + (tnUrl + '-' + servletContext.authPostfix).encodeAsMD5().substring(24)
                    else
                        sImgAddr = 'http://' + svrAddress + ':' + servletContext.videoPort + '/course_def/res_url/' + CTools.readFileDir(filePath).getBytes("utf-8").encodeAsBase64() + '@/' + CTools.readFileName(filePath, true)
                else {
                    sImgAddr = 'http://' + svrAddress + ':' + servletContext.videoPort + '/course_tnvideo/res_url/' + CTools.readFileDir(filePath).getBytes("utf-8").encodeAsBase64() + '@/' + tnUrl + '&magic=' + (tnUrl + '-' + servletContext.authPostfix).encodeAsMD5().substring(24)
                }
            } else {
                if (isAbbrImg)
                    sImgAddr = 'http://' + svrAddress + ':' + servletContext.videoPort + '/course_tnimage/res_url/' + CTools.readFileDir(filePath).getBytes("utf-8").encodeAsBase64() + '@/' + tnUrl + '&magic=' + (tnUrl + '-' + servletContext.authPostfix).encodeAsMD5().substring(24)
                else
                    sImgAddr = 'http://' + svrAddress + ':' + servletContext.videoPort + '/course_def/res_url/' + CTools.readFileDir(filePath).getBytes("utf-8").encodeAsBase64() + '@/' + CTools.readFileName(filePath, true)
            }
        }

        return sImgAddr;
    }

    //播放链接列表
    def workPlayJson = { attrs, body ->
        //def program = null
        def authStateMap = [OK: 0, AUTH_FAIL: 1, NO_EXIST: 2]
        def authState = authStateMap.OK    //0 能播放 1权限不够 2节目不存在
        UserWork userWork = attrs.userWork
        //boolean isPlay = nts.utils.CTools.nullToOne(attrs.isPlay)	== 1
        //def programId = nts.utils.CTools.nullToZero(attrs.programId)
        def webHost = request.getServerName()
        boolean bAuthOK = false

        //def jsSerial = 'var serialObj = null;\n'	//javascript work暂用serial对象字符串
        def jsSerial = 'var serialList = new Array();\n';    //用serialList 不用 serialObj是为了与资源播放页面共用代码

        if (request.getServerPort() != 80) webHost += ":" + request.getServerPort()
        //jsSerial += 'var userWork = new Array();\n'

        if (userWork) {
            //playSerials包括视音频0，课件1，在线课件4,6 链接

            def url = ""


            bAuthOK = true;//isPlay?auth.canPlay:auth.canDownload

            if (bAuthOK) {
                //////////////////////////////////////////////获得播放地址开始
                def videoHost = ""
                def svrAddress = ""
                def sVideoPort = servletContext.videoPort    //视频服务器端口
                def pwd = ""
                def startTime = "00:00:00"
                def endTime = "00:00:00"
                def photo = ""

                svrAddress = userWork.svrAddress
                if (servletContext.videoSevr == '' || svrAddress.startsWith("127.0.0.1") || svrAddress.startsWith("localhost")) svrAddress = request.getServerName()
                videoHost = svrAddress + ":" + sVideoPort

                pwd = (servletContext.authPrefix + session?.consumer?.name + servletContext.authPostfix).encodeAsMD5()

                //args = [serial:serial,consumer:session.consumer,webHost:webHost,videoHost:videoHost,pwd:pwd,isPlay:isPlay,playType:playType]
                //url = 'http://' + videoHost + '/course_def/res_url/' + nts.utils.CTools.readFileDir(userWork.filePath).getBytes("utf-8").encodeAsBase64() + '@/\'+encodeURIComponent("' + nts.utils.CTools.readFileName(userWork.filePath, true) + '")+\''
                def jsonObject = programService.generalFilePlayAddress(userWork.fileHash);
                if (jsonObject && jsonObject.playList[0]) {
                    url = jsonObject.playList[0].url;
                }

                //////////////////////////////////////////////获得播放地址结束

                //photo = getWorkImgAddr(userWork, false, servletContext.thumbnailSize, servletContext.thumbnailPos, 1, 0)
                photo = "${posterLinkNew(fileHash: userWork.fileHash, size: '700x360')}";
                jsSerial += 'serialList[0] = new CSerialObj(' + userWork.id + ',0,1,\'' + userWork.name.encodeAsJavaScript() + '\',\'' + url + '\',\'' + startTime + '\',\'' + endTime + '\',' + userWork.transcodeState + ',\'' + photo + '\',' + userWork.state + ');\n'

            }
            //没有权限
            else {
                //state = authStateMap.AUTH_FAIL
                //strLinks = '<dl><dt>点击播放：</dt><dd><a href="javascript:playProgram(\'AUTH_FAIL\',0,0,'+(isPlay?1:0)+','+state+','+playType+',0)" >'+(isPlay?'点击播放':'点击下载')+'</a></dd></dl>\n'
            }

        }

        out << jsSerial
    }

    //播放链接列表
    def phoneSerialList = { attrs ->
        def program = null
        def authStateMap = [OK: 0, AUTH_FAIL: 1, NO_EXIST: 2]
        def authState = authStateMap.OK    //0 能播放 1权限不够 2节目不存在

        def programId = CTools.nullToZero(params.programId)
        def webHost = request.getServerName()

        def jsSerial = ''    //'<script LANGUAGE="JavaScript">\n'	//javascript serial对象字符串
        def jsIndex = 0    ////javascript serial对象数组下标
        def index = 0

        boolean bAuthOK = true
        Map args = null    //用于传到服务层的参数
        int playType = 1    //programService.judePlayType(request.getHeader("User-Agent")) //0是普通pc机播放，1是移动手机播放，2是移动平板播放

        jsSerial += 'var serialListAll = new Array();\n'    //所有视音频
        jsSerial += 'var serialList = new Array();\n'    //已转码的视音频

        program = Program.get(attrs.programId)

        if (program) {
            //playSerials包括视音频0，课件1，在线课件4,6 链接
            def playSerials = null

            def url = ""

            if (program.serials) {

                def auth = programService.queryAuthority(session?.consumer, program)
                bAuthOK = auth.canPlay

                //playSerials = program.serials.findAll{it.urlType == nts.program.domain.Serial.URL_TYPE_VIDEO }


                if (bAuthOK) {
                    program.serials.each { serial ->
                        if (serial.urlType == Serial.URL_TYPE_VIDEO) {
                            boolean isMp4 = false
                            isMp4 = CTools.readExtensionName(serial.filePath).toUpperCase() == 'MP4'
                            if (serial.state == Serial.CODED_STATE || (serial.state == Serial.NO_NEED_STATE && isMp4)) {
                                def videoHost = ""
                                def svrAddress = ""
                                def sVideoPort = servletContext.videoPort    //视频服务器端口
                                def pwd = ""

                                if (serial) svrAddress = serial.svrAddress
                                if (servletContext.videoSevr == '' || svrAddress.startsWith("127.0.0.1") || svrAddress.startsWith("localhost")) svrAddress = request.getServerName()
                                videoHost = svrAddress + ":" + sVideoPort

                                pwd = (servletContext.authPrefix + session?.consumer?.name + servletContext.authPostfix).encodeAsMD5()

                                args = [serial: serial, consumer: session.consumer, webHost: webHost, videoHost: videoHost, pwd: pwd, isPlay: true, playType: playType, isFlashPlay: true]
                                url = programService.generalSerialUrl(args)

                                jsSerial += 'serialListAll[' + jsIndex + '] = new CSerialObj(' + serial.id + ',' + program.id + ',' + serial.serialNo + ',\'' + serial.name.encodeAsJavaScript() + '\',\'' + url + '\',\'' + serial.startTime + '\',\'' + serial.endTime + '\',' + serial.transcodeState + ',\'' + readImgAddr(serial, true, servletContext.thumbnailSize, servletContext.thumbnailPos, 1) + '\',' + serial.state + ');\n'

                                serial.subtitles.eachWithIndex { subtitle, k ->
                                    args = [subtitle: subtitle, videoHost: videoHost]
                                    url = programService.generalSubtitleUrl(args)
                                    jsSerial += 'serialListAll[' + jsIndex + '].subtitles[' + k + '] = {id:' + subtitle.id + ',type:' + subtitle.type + ',url:\'' + url + '\',lang:{shortName:\'' + subtitle?.lang?.shortName + '\',enName:\'' + subtitle?.lang?.enName + '\',zhName:\'' + subtitle?.lang?.zhName + '\'}};\n'
                                }

                                jsIndex++

                            }
                        }
                    }


                }
                //没有权限
                else {
                    authState = authStateMap.AUTH_FAIL

                }
            }
        }

        //jsSerial += "</script>\n"

        out << jsSerial
        //render(text:jsSerial,contentType:"text/html",encoding:"UTF-8")
    }

    //重写分页 -----2013-4-12 孙长贵 -----
    def guiPaginate = { attrs ->
        def writer = out
        if (attrs.total == null)
            throwTagError("Tag [paginate] is missing required attribute [total]")
        def messageSource = grailsAttributes.messageSource
        def locale = RCU.getLocale(request)
        def total = attrs.int('total') ?: 0
        def action = (attrs.action ? attrs.action : (params.action ? params.action : "list"))
        def offset = params.int('offset') ?: 0
        def max = params.int('max')
        def maxsteps = (attrs.int('maxsteps') ?: 10)
        if (!offset) offset = (attrs.int('offset') ?: 0)
        if (!max) max = (attrs.int('max') ?: 10)
        def linkParams = [:]
        if (attrs.params) linkParams.putAll(attrs.params)
        linkParams.offset = offset - max
        linkParams.max = max
        if (params.sort) linkParams.sort = params.sort
        if (params.order) linkParams.order = params.order
        def linkTagAttrs = [action: action]
        if (attrs.controller) {
            linkTagAttrs.controller = attrs.controller
        }
        if (attrs.id != null) {
            linkTagAttrs.id = attrs.id
        }
        linkTagAttrs.params = linkParams        // determine paging variables
        def steps = maxsteps > 0
        int currentstep = (offset / max) + 1
        int firststep = 1
        int laststep = Math.round(Math.ceil(total / max))        // display previous link when not on firststep
        if (currentstep > firststep) {
            linkTagAttrs.class = 'guipa'
            linkParams.offset = offset - max
            writer << link(linkTagAttrs.clone()) {
                (attrs.prev ? attrs.prev : messageSource.getMessage('paginate.prev', null, messageSource.getMessage('default.paginate.prev', null, 'Previous', locale), locale))
            }
        }        // display steps when steps are enabled and laststep is not firststep
        if (steps && laststep > firststep) {
            linkTagAttrs.class = 'num'            // determine begin and endstep paging variables
            int beginstep = currentstep - Math.round(maxsteps / 2) + (maxsteps % 2)
            int endstep = currentstep + Math.round(maxsteps / 2) - 1
            if (beginstep < firststep) {
                beginstep = firststep
                endstep = maxsteps
            }
            if (endstep > laststep) {
                beginstep = laststep - maxsteps + 1
                if (beginstep < firststep) {
                    beginstep = firststep
                }
                endstep = laststep
            }            // display firststep link when beginstep is not firststep
            if (beginstep > firststep) {
                linkParams.offset = 0
                writer << link(linkTagAttrs.clone()) { firststep.toString() }
                writer << '<span class="num">•••</span>'
            }            // display paginate steps
            (beginstep..endstep).each { i ->
                if (currentstep == i) {
                    writer << "<span class=\"currentStep\">${i}</span>"
                } else {
                    linkParams.offset = (i - 1) * max
                    writer << link(linkTagAttrs.clone()) { i.toString() }
                }
            }            // display laststep link when endstep is not laststep
            if (endstep < laststep) {
                writer << '<span class="num">•••</span>'
                linkParams.offset = (laststep - 1) * max
                writer << link(linkTagAttrs.clone()) { laststep.toString() }
            }
        }        // display next link when not on laststep
        if (currentstep < laststep) {
            linkTagAttrs.class = 'guipa'
            linkParams.offset = offset + max
            writer << link(linkTagAttrs.clone()) {
                (attrs.next ? attrs.next : messageSource.getMessage('paginate.next', null, messageSource.getMessage('default.paginate.next', null, 'Next', locale), locale))
            }
        }

        ////////////////////add by jlf for turn page begin
        if (laststep > 1) {
            //约定一数字，以作替换
            linkParams.offset = 1234554321
            def strLink = createLink(linkTagAttrs.clone())
            writer << '\n<script type="text/javascript" src="' + createLinkTo(dir: "js", file: "boful/common/turnPage.js") + '"></script>\n'
            writer << '<input type="text" class="guinum" name="turnPage" id="turnPage" value="' + currentstep + '" onkeydown="if(event.keyCode==13) turnPageTo(' + max + ',' + laststep + ',\'' + strLink + '\');" onkeyup="this.value=this.value.replace(/\\D/gi,\'\')"><span class=\"page_total_num\">/' + laststep + '</span>&nbsp;'
            writer << '<input type="button" name="turnPageBtn" id="turnPageBtn" onclick="turnPageTo(' + max + ',' + laststep + ',\'' + strLink + '\');" value="转页">\n'
        }
        ///////////////////add by jlf for turn page end
    }
    //统计学习课程数(过滤掉重复)
    def studyCourse = { attrs ->
        def played = attrs.playedPrograms;
        if (played) {
            List<Consumer> consumers = [];
            played.each {
                consumers.add(it.consumer);
            }
            HashSet hs = new HashSet(consumers);
            consumers.clear();
            consumers.addAll(hs);
            out << consumers.size()
        }
    }
    def studyCourseTotal = { attrs ->
        def played = attrs.playedPrograms;
        if (played) {
            List<Consumer> consumers = [];
            played.each {
                consumers.add(it.consumer);
            }
            HashSet hs = new HashSet(consumers);
            consumers.clear();
            consumers.addAll(hs);
            out << consumers.id;
        }
    }

    def playLinksNew = { attrs ->
        def html = '';

        if (servletContext.isCon == "false") {
            out << ""
        } else {
            def serials = attrs.serials;
            def fileHash = attrs.fileHash;
            def serialCount = 0;
            html += "[";
            if (serials) {
                List<String> list = serials*.fileHash;
                JSONArray array = programService.generalFilePlayAddresses(((String[]) list.toArray()));

                serials.each { Serial serial1 ->
                    def objInfo = null;
                    if (serial1.fileHash) {
                        array.each { obj ->
                            if (obj.hash == serial1.fileHash.toUpperCase()) {
                                objInfo = obj;
                            }
                        }
                    }

                    if (objInfo) {
                        serialCount++;
                        html += "{";
                        html += "serialId:${serial1.id},"
                        //html += "file:'${objInfo.url}',"
                        StringBuffer playList = new StringBuffer();
                        StringBuffer thumbnails = new StringBuffer();
                        if (objInfo.playList) {
                            objInfo.playList.each { JSONObject jsonObject ->
                                playList.append("{file:'${jsonObject.url}',label:'${jsonObject.isBase ? "original" : jsonObject.tagName}'},");
                                def vttUrl = jsonObject.vvtUrl;
                                if (vttUrl && vttUrl != null) {
                                    thumbnails.append("{file:'").append(vttUrl).append("',kind:'thumbnails'},");
                                }
                            }
                            playList.deleteCharAt(playList.length() - 1);
                            if (thumbnails.length() > 0) {
                                thumbnails.deleteCharAt(thumbnails.length() - 1);
                            }
                        }
                        html += "sources:[${playList.toString()}],"
                        html += "title:'${serial1.name.encodeAsJavaScript()}',"
                        if ("${serial1.description}" != null) {
                            html += "description:'${serial1.description.encodeAsJavaScript()}',"
                        }
                        html += "image:'${posterLinkNew(fileHash: serial1.fileHash, size: '500x320')}',"
                        html += "levels:[${playList.toString()}]"

                        //字幕、缩略图
                        if (serial1.subtitles.size() > 0 || thumbnails.length() > 0) {
                            html += ",tracks:[";
                            if (thumbnails.length() > 0) {
                                html += "${thumbnails.toString()}" + ",";
                            }
                            if (serial1.subtitles.size() > 0) {
                                List<Subtitle> subtitles = serial1.subtitles.toList();
                                subtitles.sort();
                                subtitles.eachWithIndex { Subtitle subtitle, int index ->
                                    try {
                                        String subtitleUrl = programService.generalFilePlayAddress(subtitle.fileHash, false).playList[0].url;
                                        html += "{";
                                        html += ("file:'" + subtitleUrl + "',");
                                        html += ("kind:'captions',");
                                        if (index == 0) {
                                            html += ("'default': true,");
                                        }
                                        html += ("label:'${subtitle.lang.shortName}'");
                                        if (index == serial1.subtitles.size() - 1) {
                                            html += "}";
                                        } else {
                                            html += "},";
                                        }

                                    } catch (Exception e) {

                                    }
                                }
                            }
                            html += "]";
                        }
                        html += "},";

                    }
                }

                if (serialCount > 0) {
                    html = html.substring(0, html.length() - 1);
                }


            } else {
                if (fileHash) {
                    String[] fileHashes = new String[1];
                    fileHashes[0] = fileHash;
                    JSONArray array = programService.generalFilePlayAddresses(fileHashes);
                    if (array) {
                        if (array.size() > 0) {
                            def objInfo = array[0];
                            html += "{";
                            html += "id:'${fileHash}',"
                            //html += "file:'${objInfo.url}',"
                            StringBuffer playList = new StringBuffer();
                            if (objInfo.playList) {
                                objInfo.playList.each { JSONObject jsonObject ->
                                    playList.append("{file:'${jsonObject.url}',label:'${jsonObject.tagName}'},");
                                }
                                playList.deleteCharAt(playList.length() - 1);
                            }
                            html += "sources:[${playList.toString()}],"
                            html += "title:'${fileHash}',"

                            html += "image:'${posterLinkNew(fileHash: fileHash, size: '500x320')}'"
                            html += "}";
                        }
                    }

                }
            }

            html += "]";
            out << html
        }


    }

    def mobilePlayLink = { attr ->
        if (attr.fileHash) {
            try {
                JSONObject jsonObject = programService.generalFilePlayAddress(attr.fileHash, attr.isPdf);
                out << jsonObject.playList[0].url
            } catch (Exception e) {
                out << ""
            }
        }

    }
    /***
     * 生成社区共享资源路径
     */
    def playSharingLink = { attr ->
        String url = programService.generalSharingPlayAddress(attr.sharing);
        out << url
    }

    //image 和 document 单个
    def playUserFileLink = { attr ->
        try {
            String url = programService.generalFilePlayAddress(attr.fileHash).playList[0].url;
            out << url
        } catch (Exception e) {
            out << "";
        }


    }

    def playDocumentLinksNew = { attr ->
        if (servletContext.isCon != "false") {
            JSONObject url = programService.generalSerialPlayAddress(attr.serial);
            try {
                out << url.playList[0].url
            } catch (Exception e) {
                out << ""
            }
        } else {
            out << ""
        }

    }

    def playLinksNew2 = { attr ->
        Serial serial = Serial.get(attr.serialId as long);
        JSONObject url = programService.generalSerialPlayAddress(serial);
        try {
            out << url.playList[0].url
        } catch (Exception e) {
            out << ""
        }
    }

    /***
     *  获取用户默认图片
     */
    def generalUserPhotoUrl = { attr ->
        String url = "";
        if (attr.consumer) {
            Consumer consumer = attr.consumer;
            File file = new File(SystemConfig.webRootDir, "upload/photo/" + consumer.photo);
            if (file.exists()) {
                url = "${resource(dir: 'upload/photo', file: consumer.photo)}";
            } else {
                url = "${resource(dir: 'skin/blue/pc/front/images', file: "photo.gif")}";
            }
            // consumer.photo;
        } else {
            url = "${resource(dir: 'skin/blue/pc/front/images', file: "photo.gif")}";
        }
        out << url;
    }

    /***
     *  获取用户默认图片
     */
    def generalUserPhotoUrl2 = { attr ->
        String url = "";
        if (attr.consumerID) {
            def consumer = Consumer.get(attr.consumerID);
            File file = new File(SystemConfig.webRootDir, "upload/photo/" + consumer.photo);
            if (file.exists()) {
                url = "${resource(dir: 'upload/photo', file: consumer.photo)}";
            } else {
                url = "${resource(dir: 'skin/blue/pc/front/images', file: "photo.gif")}";
            }
            // consumer.photo;
        } else {
            url = "${resource(dir: 'skin/blue/pc/front/images', file: "photo.gif")}";
        }
        out << url;
    }

    /***
     * 获取社区图片
     */
    def generalCommunityPhotoUrl = { attr ->
        String url = "";
        if (attr.community) {
            StudyCommunity community = attr.community;
            File file = new File(SystemConfig.webRootDir, "upload/communityImg/" + community.photo);
            if (file.exists()) {
                url = "${resource(dir: 'upload/communityImg', file: community.photo)}";
            } else {
                url = "${resource(dir: 'skin/blue/pc/front/images', file: "boful_community_content_items_img.png")}";
            }
            // consumer.photo;
        } else {
            url = "${resource(dir: 'skin/blue/pc/front/images', file: "boful_community_content_items_img.png")}";
        }
        out << url;
    }

    //根据帖子获取最后的回复
    def communityArticle = { attr ->
        def article = attr.article
        def replayArticle = ForumReplyArticle.createCriteria().list(max: 1, order: 'desc', sort: "dateCreated") {
            if (article) {
                eq("forumMainArticle", article)
            }
        }
        def replay;
        if (replayArticle) {
            replay = replayArticle[0]?.id;
        } else {
            replay = "";
        }
        out << replay;
    }

    def calcProgramScore = { attr ->
        Program program = attr.program;
        try {
            def score = program.remarks.size() ? new DecimalFormat("#.##").format((program.remarks*.rank)?.sum() / program.remarks.size()) : 0.0;
            out << score
        } catch (Exception e) {
            out << "0.0"
        }
    }

    //获取logoURl
    def webLogeUrl = { attr ->
        String url = "";
        String filePath = attr.filePath;
        SysConfig webLogo = SysConfig.findByConfigName("webLogo");
        String fileName = "";
        if (webLogo) {
            fileName = webLogo.getConfigValue();
        }
        File file = new File(SystemConfig.webRootDir, filePath + "/" + fileName);
        if (file.isFile()) {
            url = "${resource(dir: filePath, file: fileName)}";
        } else {
            url = "${resource(dir: 'skin/blue/pc/common/images', file: 'web_boful_logo.png')}";
        }
        out << url;
    }
    //是否已推荐
    def judgeRecommendProgram = { attr ->
        Program program = attr.program;
        if (session.consumer && session.consumer.name != 'anonymity') {
            RecommendedProgram recommendedProgram = RecommendedProgram.findByConsumerAndProgram(session.consumer, program);
            if (recommendedProgram) {
                out << true;
            } else {
                out << false;
            }
        } else {
            out << false;
        }
    }
    //是否已收藏
    def judgeCollectProgram = { attr ->
        Program program = attr.program;
        if (session.consumer && session.consumer.name != 'anonymity') {
            CollectedProgram collectedProgram = CollectedProgram.findByConsumerAndProgram(session.consumer, program);
            if (collectedProgram) {
                out << true;
            } else {
                out << false;
            }
        } else {
            out << false;
        }
    }

    def genBaseUrl = { attr ->
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

        out.print(basePath)
    }

    /**
     * 转换单位
     * @param fileSize
     */
    def convertHumanUnit = { attr ->
        def fileSize = attr.fileSize;
        out << programService.stringFileSize(fileSize);
    }

    //根据登录用户的角色来显示菜单
    def checkUserResource = { attrs, body ->
        String isRole = 'false';
        def controllerEnName = attrs.controllerEnName;
        def actionEnName = attrs.actionEnName;

        //如果是超级管理员则显示全部
        if (session.consumer && session.consumer.role == Consumer.SUPER_ROLE) {
            isRole = 'true'
        } else {
            Map<String, String> userResources = session.getAttribute("userResources")
            //println userResources.size()+"--------------------"
            //println controllerEnName+"----------------"+actionEnName+"+++++++++++++++++"+userResources.get((actionEnName+'-'+controllerEnName))+"----"+(userResources.get((actionEnName+'-'+controllerEnName)) == controllerEnName)

            /*userResources.entrySet().each {
                println it.key+','+it.value
            }*/
            if (userResources.get((actionEnName + '-' + controllerEnName)) == controllerEnName) {
                isRole = 'true'
            }
        }

        out << isRole;
    }

    //根据登录用户的角色来显示顶部菜单
    def checkUserTopResource = { attrs, body ->
        String isRole = 'false';
        def controllerEnName = attrs.controllerEnName;
        def actionEnName = attrs.actionEnName;

        //如果是超级管理员则显示全部
        if (session.consumer && session.consumer.role == Consumer.SUPER_ROLE) {
            isRole = 'true'
        } else {
            Map<String, String> userResources = session.getAttribute("userResources")
            for (String key : userResources.keySet()) {
                if ((key.split('-')[1]) == controllerEnName) {
                    isRole = 'true'
                }
            }
        }

        out << isRole;
    }


    def judgeJoinBoard = { attrs ->
        def consumer = attrs.consumer;
        def forumBoard = attrs.forumBoard;
        def result = "false";
        if (consumer && forumBoard) {
            def forumMember = ForumMember.findByConsumerAndForumBoard(consumer, forumBoard);
            if ((forumMember && forumMember.state == ForumMember.STATE_NORMAIL) || (forumBoard.createConsumer.nickname == consumer.nickname)) {
                result = "true";
            }
        }
        out << result;
    }

    def judeLoginConsumer = { attrs ->
        if (session.consumer && (!servletContext.anonymityUserName.equals(session.consumer.name))) {
            out << true
        } else {
            out << false
        }
    }

    //活动时间比较
    def userActivityState = { attrs ->
        def startDate = attrs.startDate.substring(0, 10) + ' 00:00:00'
        def endDate = attrs.endDate.substring(0, 10) + ' 23:59:59'
        def result = ''
        DateFormat df = new SimpleDateFormat('yyyy-MM-dd HH:mm:ss')
        Date sd = df.parse(startDate)
        Date ed = df.parse(endDate)
        Date now = new Date()
        if (sd.getTime() > now.getTime()) {
            result = '即将开始'
        } else if (sd.getTime() <= now.getTime() && ed.getTime() >= now.getTime()) {
            result = '进行中'
        } else if (ed.getTime() < now.getTime()) {
            result = '已结束'
        }
        out << result
    }

    //获取社区成员数
    def readStudyCommunityMembersCount = { attrs ->
        def community = attrs.studyCommunity
        def membersCount = ForumMember.withCriteria {
            eq("studyCommunity", community)
            eq("state", 0)
            consumer {
                notEqual('id', community?.create_comsumer_id as long)
            }
            projections {
                distinct("consumer")
            }
        }.size() + 1
        out << membersCount
    }

    //获取社区创建者
    def readStudyCommunityCreater = { attrs ->
        def id = attrs.id
        def consumer = Consumer.get(id as long)
        def name = consumer ? consumer.nickname : ''
        out << name
    }

    //获取参与社区活动的人数
    def readActivityMemberCount = { attrs ->
        def activity = attrs.activity
        def members = ActivitySubject.withCriteria {
            eq("activity", activity)
            projections {
                distinct('createConsumer')
            }
        }.size()
        out << members
    }

    //判断浏览器类型
    def checkBrowse = { attrs ->
        def userAgent = attrs.userAgent
        def browse = '其它'
        if (CTools.regex("IE", userAgent)) {
            browse = 'IE'
        } else if (CTools.regex("Chrome", userAgent)) {
            browse = 'Chrome'
        } else if (CTools.regex("Firefox", userAgent)) {
            browse = 'Firefox'
        }

        out << browse
    }

    //判断操作系统
    def checkOS = { attrs ->
        def userAgent = attrs.userAgent
        def browse = '其它'
        if (CTools.regex("Windows NT 5.1", userAgent)) {
            browse = 'Windows XP'
        } else if (CTools.regex("Windows NT 5.2", userAgent)) {
            browse = 'Windows Server 2003'
        } else if (CTools.regex("Windows NT 6.1", userAgent)) {
            browse = 'Windows 7'
        } else if (CTools.regex("Mac OS X", userAgent)) {
            browse = '苹果'
        } else if (CTools.regex("Linux", userAgent)) {
            browse = 'linux'
        }

        out << browse
    }
    def frontTheme = { attrs ->
        String theme = "default";
        if (servletContext.theme) {
            theme = servletContext.theme;
        } else {
            def themeConfig = SysConfig.findByConfigName("theme");
            if (themeConfig && themeConfig.configValue) {
                theme = themeConfig.configValue;
            }
        }
        out << theme;
    }
    def communityIndexLayoutImgUrl = { attr ->
        String url = attr.bgPhoto;
        String imgUrl = "${resource(dir: 'upload/communityImg/bgimg', file: url)}"
/*        if(imgUrl==null){
            imgUrl = "${resource(dir: 'skin/blue/pc/front/images', file: 'community_space_bg.png')}";
        }*/
        out << imgUrl
    }

    def userFileCanDownload = { attr ->
        def shareRange = attr.shareRange
        def forumBoardId = attr.forumBoardId
        def result = true
        try {
            def forumBoard = ForumBoard.get(forumBoardId as Long)
            if (shareRange == 0) {
                def consumer = Consumer.get(session.consumer.id)
                def forumMember = ForumMember.findByForumBoardAndConsumerAndState(forumBoard, consumer, 0)
                if (forumMember) {
                    if (forumMember.canDownload) {
                        result = true
                    } else {
                        result = false
                    }
                } else {
                    result = false
                }
            } else if (shareRange == 1) {
                def community = StudyCommunity.get(forumBoard.studyCommunity.id)
                def member = ForumMember.findByStudyCommunityAndStateAndConsumer(community, 0, consumer)
                if (member) {
                    def forumMember = ForumMember.findByForumBoardAndConsumerAndState(forumBoard, consumer, 0)
                    if (forumMember) {
                        if (forumMember.canDownload) {
                            result = true
                        } else {
                            result = false
                        }
                    } else {
                        result = true
                    }
                } else {
                    result = false
                }
            }
        } catch (Exception e) {
            result = false
        }

        out << result
    }

    def queryProgramRemarkScore = { attr ->
        def program = attr.program;
        List<Remark> remarkList = Remark.findAllByProgram(program);
        List<Consumer> consumerList = [];
        int scoreTotal = 0;
        remarkList?.each {
            scoreTotal += it.rank;
            if (!consumerList.contains(it.consumer)) {
                consumerList.add(it.consumer);
            }
        }
        if (consumerList.size() > 0) {
            out << new DecimalFormat("#.##").format(scoreTotal / consumerList.size());
        } else {
            out << 0.0;
        }
    }

    def querySerialFirstTimeLength = { attr ->
        def program = attr.program;
        def type = attr.type;
        Serial serial = programService.serialFirst(program);
        if (serial) {
            if (type == "doc") {
                out << serial.timeLength;
            } else if (type == "video") {
                out << TimeLengthUtils.formatTime(TimeLengthUtils.NumberToString(serial.timeLength));
            }
        } else {
            out << 0;
        }
    }

    def querySerialFirstId = { attr ->
        def program = attr.program;
        Serial serial = programService.serialFirst(program);
        if (serial) {
            out << serial.id;
        } else {
            out << 0;
        }
    }

    //获取资源库图片Url
    def programCategoryUrl = { attr ->
        String url = "";
        String filePath = attr.filePath;
        String fileName = attr.fileName;
        File file = new File(SystemConfig.webRootDir, filePath + "/" + fileName);
        if (file.isFile()) {
            url = "${resource(dir: filePath, file: fileName)}";
        } else {
            url = "${resource(dir: 'skin/blue/pc/common/images', file: 'web_boful_logo.png')}";
        }
        out << url;
    }

    def programPercent = { attr ->
        Program program = attr.program;
        def currentSerialNo = attr.serialNo;
        Serial lastSerial = null;
        def precent = 0;
        if (program) {
            def consumerPlayCount = PlayedProgram.findAllByProgramAndConsumer(program, session?.consumer)?.size();
            def playCount = Serial.findAllByProgram(program)?.size();
            List<Serial> serialList = program.serials.toList();
            if (consumerPlayCount == playCount) {
                def serial = null;
                if (serialList && serialList.size() > 0) {
                    serialList.sort {
                        serial1, serial2 ->
                            serial1.serialNo <=> serial2.serialNo
                    }
                }
                lastSerial = serialList.get(serialList.size() - 1);
                precent = Math.round((lastSerial?.serialNo > 0 ? (currentSerialNo / lastSerial?.serialNo) : 1) * 100);
            } else if (consumerPlayCount < playCount) {
                precent = Math.round((consumerPlayCount / playCount) * 100);
            }
            precent = precent + "%";
            out << precent;
        }

    }
}


