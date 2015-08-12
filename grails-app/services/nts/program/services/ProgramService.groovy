package nts.program.services

import com.boful.common.file.utils.FileType
import com.boful.common.file.utils.FileUtils
import com.boful.nts.service.model.RMSNode
import com.boful.nts.utils.SystemConfig
import grails.converters.JSON
import nts.commity.domain.Sharing
import nts.meta.domain.MetaDefine
import nts.program.category.domain.CategoryFacted
import nts.program.category.domain.FactedValue
import nts.program.domain.PlayedProgram
import nts.program.domain.Program
import nts.program.category.domain.ProgramCategory
import nts.program.domain.ProgramTag
import nts.program.domain.Remark
import nts.program.domain.RemarkReply
import nts.program.domain.Serial
import nts.system.domain.Directory
import nts.system.domain.OperationEnum
import nts.system.domain.OperationLog
import nts.system.domain.SysConfig
import nts.user.domain.IpAddress
import nts.user.domain.Consumer
import nts.user.file.domain.UserFile
import nts.user.special.domain.SpecialFile
import nts.user.special.domain.UserSpecial
import nts.utils.BfConfig
import nts.utils.CTools
import org.apache.commons.lang.StringUtils
import org.apache.http.NameValuePair
import org.apache.http.client.HttpClient
import org.apache.http.client.entity.UrlEncodedFormEntity
import org.apache.http.client.methods.CloseableHttpResponse
import org.apache.http.client.methods.HttpPost
import org.apache.http.impl.client.HttpClients
import org.apache.http.message.BasicNameValuePair
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONElement
import org.codehaus.groovy.grails.web.json.JSONObject

import javax.servlet.ServletContext
import javax.servlet.http.HttpSession
import java.text.DecimalFormat

class ProgramService {

    static boolean transactional = true
    def utilService
    def metaDefineService
    def appService
    def serverNodeService
    def fileQuery
    def userService;
    def programCategoryService;
    def programMgrService;

    //////获取资源权限,返回权限映射
    public Map queryAuthority(Consumer consumer, Program program, String clientIP) {
        def auth = ["canPlay": false, "canDownload": false]


        clientIP = CTools.read15WIP(clientIP);
        //println clientIP

        if (consumer == null || program == null) return auth

        //如果资源是自己创建的，允许点播下载
        if (program.consumer.id == consumer.id) {
            auth.canPlay = true
            auth.canDownload = true
        }
        //如果是管理员登录，允许点播下载
        else if (consumer.role <= Consumer.MANAGER_ROLE) {
            auth.canPlay = true
            auth.canDownload = true
        }
        //如果资源已入库，则直接使用资源的权限
        else if (program.state >= Program.PUBLIC_STATE) {

            auth.canPlay = program.canPlay
            auth.canDownload = program.canDownload

            //如果资源可能播放，再细化组权限是否可以播放
            if (auth.canPlay) {

                def programUserGroupList = program.playGroups
                /////如果资源没有设置组，用资源本身的权限
                if (programUserGroupList.size() > 0) {
                    //登录用户所在组
                    def loginUserGroupList = Consumer.get(consumer.id).userGroups
                    auth.canPlay = !programUserGroupList.disjoint(loginUserGroupList)

                    ////如果用户组没有权限，查看客户端IP对应组是否有交集
                    if (!auth.canPlay) {
                        def ipUserGroupList = IpAddress.executeQuery("select distinct a.userGroup from IpAddress a where a.isActive=true and a.beginIp <= :clientIP and a.endIp >= :clientIP", [clientIP: clientIP]);
                        //println ipUserGroupList.size()
                        auth.canPlay = !programUserGroupList.disjoint(ipUserGroupList)
                    }
                }
            }
        }
        //资源尚未入库
        else {
            auth.canPlay = false
            auth.canDownload = false
        }
        //println "canPlay:"+canPlay

        //如果用户被禁止下载，则不能下载
        if (!program.consumer.canDownload) {
            auth.canDownload = false
        }


        return auth

    }
    ///////////////////////////////////////////////权限结束

    //获取子目播放地址
    public String generalSerialUrl(Map args) {
        Serial serial = args.serial
        Program program = serial?.program
        def videoHost = args.videoHost
        def webHost = args.webHost
        Consumer consumer = args.consumer
        def pwd = args.pwd
        def playType = CTools.nullToZero(args.playType)

        def url = ""
        def playUrl = ""
        def isPlay = args.isPlay
        def isFlashPlay = args.isFlashPlay
        def isWeb = true
        def isBatchPlay = false
        def bAuthOK = false

        def subtitles = null
        def subtitle1 = "" //字幕文件1路径
        def subtitle2 = "" //字幕文件2路径
        def playProtocol = "BMSP"    //协议

        playProtocol = BfConfig.getPlayProtocol()

        //def auth = queryAuthority(consumer,program)
        //bAuthOK = isPlay?auth.canPlay:auth.canDownload

        if (!serial) return ""

        subtitles = serial.subtitles.toList()
        if (subtitles && subtitles.size() > 0) {
            subtitle1 = subtitles[0].filePath
            if (subtitles.size() > 1) subtitle2 = subtitles[1].filePath
        }

        //是url类型链接,文件路径含//:
        isWeb = serial.filePath.indexOf("://") != -1

        if (isWeb || serial.urlType == Serial.URL_TYPE_LINK) {
            playUrl = serial.filePath.encodeAsJavaScript()
        }
        //是 isFlashPlay 用播放文档类型 http
        /*else if (isFlashPlay) {
            playUrl = 'http://' + videoHost + '/course_def/res_url/' + nts.utils.CTools.getFileDir(serial.filePath).getBytes("utf-8").encodeBase64() + '@/\'+encodeURIComponent("' + nts.utils.CTools.readFileName(serial.filePath, true) + '")+\''
        }*/
        else if (isFlashPlay || serial.urlType == Serial.URL_TYPE_VIDEO || serial.urlType == Serial.URL_TYPE_DOCUMENT) {
            playUrl = 'http://' + videoHost + '/bmc/play/play'
        }
        //是下载
        else if (!isPlay) {
            def filePath = serial.filePath
            def sFileExt = ""

            if (serial.urlType == Serial.URL_TYPE_VIDEO) {
                if ((serial.transcodeState & Serial.OPT_VIDEW_SUPER) == Serial.OPT_VIDEW_SUPER) filePath += "_cq.mp4"
                else if ((serial.transcodeState & Serial.OPT_VIDEW_HIGH) == Serial.OPT_VIDEW_HIGH) filePath += "_gq.mp4"
                else if ((serial.transcodeState & Serial.OPT_VIDEW_STANDARD) == Serial.OPT_VIDEW_STANDARD) filePath += "_bq.mp4"
            }

            sFileExt = CTools.readExtensionName(filePath)//Use Default Extract FileName

            if (serial.urlType == Serial.URL_TYPE_TEXT_LIBRARY) {
                playUrl = 'http://' + videoHost + '/course_def/res_url/' + CTools.getFileDir(filePath).getBytes("utf-8").encodeBase64() + '@/' + CTools.readFileName(filePath, true)
            } else {
                url = "${playProtocol}://ADDR=${videoHost};UID=${consumer?.name};PWD=${pwd};FILE=${filePath};PN=${serial.name};EXT=${sFileExt};PFG=2;"
                playUrl = "bfp://" + webHost + "/pfg=d&enc=b&url=" + url.getBytes("GBK").encodeBase64().toString()
            }
        } else {

            //视音频 适用于各种视音频文件
            if (serial.urlType == Serial.URL_TYPE_VIDEO || (playType == Serial.PLAY_TYPE_PC && (serial.urlType == Serial.URL_TYPE_MOBILE || serial.urlType == Serial.URL_TYPE_TABLET))) {
                url = "${playProtocol}://ADDR=${videoHost};UID=${consumer?.name};PWD=${pwd};FILE=${serial.filePath};SUB1=${subtitle1};SUB2=${subtitle2};STM=${serial.startTime};ETM=${serial.endTime};PFG=2;"
                playUrl = "bfp://" + webHost + "/pfg=p&enc=b&url=" + url.getBytes("GBK").encodeBase64().toString()
            }
            //文档，适用于WORD,PPT,EXCEL,PDF等支持WEB-DAV协议的文档
            else if (serial.urlType == Serial.URL_TYPE_DOCUMENT) {
                ////文库
                if ((serial.transcodeState & Serial.OPT_DOC_LIB) == Serial.OPT_DOC_LIB) {
                    if (serial.state == Serial.CODED_STATE) {
                        playUrl = 'http://' + videoHost + '/course_def/res_url/' + CTools.readFileDir(serial.filePath).getBytes("utf-8").encodeBase64() + '@/\'+encodeURIComponent(\'' + CTools.getFileName(serial.filePath, true) + '_text.swf\')+\''
                    } else if (serial.state == Serial.NO_NEED_STATE) {
                        playUrl = 'http://' + videoHost + '/course_def/res_url/' + CTools.readFileDir(serial.filePath).getBytes("utf-8").encodeBase64() + '@/\'+encodeURIComponent(\'' + CTools.getFileName(serial.filePath, true) + '\')+\''
                    } else {
                        def sFileExt = CTools.readExtensionName(serial.filePath)//Use Default Extract FileName
                        url = "${playProtocol}://ADDR=${videoHost};UID=${consumer?.name};PWD=${pwd};FILE=${serial.filePath};PN=${serial.name};EXT=${sFileExt};PFG=2;"
                        playUrl = "bfp://" + webHost + "/pfg=d&enc=b&url=" + url.getBytes("GBK").encodeBase64().toString()
                    }
                } else {
                    def sFileExt = CTools.readExtensionName(serial.filePath)//Use Default Extract FileName
                    url = "${playProtocol}://ADDR=${videoHost};UID=${consumer?.name};PWD=${pwd};FILE=${serial.filePath};PN=${serial.name};EXT=${sFileExt};PFG=2;"
                    playUrl = "bfp://" + webHost + "/pfg=d&enc=b&url=" + url.getBytes("GBK").encodeBase64().toString()
                }

            }
            //中控
            else if (serial.urlType == Serial.URL_TYPE_MIDDLE_CONTROL) {
                //尚未实现
            }
            //在线课件
            else if (serial.urlType == Serial.URL_TYPE_ONLINE_COURSE) {
                playUrl = 'http://' + videoHost + '/course_def/res_url/' + CTools.readFileDir(serial.filePath).getBytes("utf-8").encodeBase64() + '@/' + CTools.readFileName(serial.filePath, true)
            }
            //确然课件
            else if (serial.urlType == Serial.URL_TYPE_TRURAN_COURSE) {
                playUrl = 'http://' + videoHost + '/course_truran/res_url/' + CTools.readFileDir(serial.filePath).getBytes("utf-8").encodeBase64() + '@/' + CTools.readFileName(serial.filePath, true)
            }
            //移动手机点播,移动平板点播
            else if ((playType == Serial.PLAY_TYPE_MOBILE || playType == Serial.PLAY_TYPE_TABLET) && (serial.urlType == Serial.URL_TYPE_MOBILE || serial.urlType == Serial.URL_TYPE_TABLET)) {
                playUrl = 'http://' + videoHost + '/mobile_def/res_url/' + CTools.readFileDir(serial.filePath).getBytes("utf-8").encodeBase64() + '@/' + CTools.readFileName(serial.filePath, true)
            }
            //文库
            else if (serial.urlType == Serial.URL_TYPE_TEXT_LIBRARY) {
                playUrl = 'http://' + videoHost + '/course_def/res_url/' + CTools.readFileDir(serial.filePath).getBytes("utf-8").encodeBase64() + '@/\'+encodeURIComponent(\'' + CTools.readFileName(serial.filePath, true) + '_text.swf\')+\''
            }
            //其余的都当作下载播放 下载到本地，通过MIME类型播放
            else {
                def sFileExt = CTools.readExtensionName(serial.filePath);//Use Default Extract FileName
                url = "${playProtocol}://ADDR=${videoHost};UID=${consumer?.name};PWD=${pwd};FILE=${serial.filePath};PN=${serial.name};EXT=${sFileExt};PFG=2;"
                playUrl = "bfp://" + webHost + "/pfg=d&enc=b&url=" + url.getBytes("GBK").encodeBase64().toString()
            }

        }

        return playUrl
    }

    //获取子目播放地址
    def generalSubtitleUrl(Map args) {
        def playUrl = ""
        def subtitle = args.subtitle
        def videoHost = args.videoHost
        playUrl = 'http://' + videoHost + '/course_def/res_url/' + CTools.readFileDir(subtitle.filePath).getBytes("utf-8").encodeBase64() + '@/\'+encodeURIComponent("' + CTools.readFileName(subtitle.filePath, true) + '")+\''
        return playUrl
    }

    //远程接口认证,参数：从配置文件中获取的:prefix前缀 postfix后缀 timeout 超时时间秒; 从请求中获致的：UID用户名 verify认证字符串 time当前时间毫秒
    public boolean isAuthPass(String prefix, String postfix, String UID, String verify, long time, long timeout) {
        if (prefix.equals("") || postfix.equals("") || UID.equals("") || verify.equals("")) return false;

        boolean isOK = false;
        String authStr = "";
        long currentTimeMillis = 0L;//系统当前时间（毫秒）

        try {
            authStr = prefix + UID + time + postfix;
            //System.out.println(authStr);
            authStr = authStr.encodeAsMD5();
            //System.out.println(authStr);
            //System.out.println(System.currentTimeMillis()+"");
            if (authStr.equalsIgnoreCase(verify)) {
                currentTimeMillis = System.currentTimeMillis();
                //秒化成毫秒
                timeout = timeout * 1000;

                if ((time - timeout) < currentTimeMillis && (time + timeout) > currentTimeMillis) isOK = true;
            }
        }
        catch (Exception e) {
            System.out.println("AuthPass error:" + e.toString());
        }


        return isOK;
    }

    ////////利用request.getHeader("user-agent")获取客户端浏览器
    public int judePlayType(String sUserAgent) {
        int playType = Serial.PLAY_TYPE_PC

        if (sUserAgent != null) {
            def agent = sUserAgent.toUpperCase();
            if (agent.indexOf("IPHONE") > 0 || agent.indexOf("ANDROID") > 0 || agent.indexOf("ITOUCH") > 0) playType = Serial.PLAY_TYPE_MOBILE
            else if (agent.indexOf("IPAD") > 0) playType = Serial.PLAY_TYPE_TABLET
        }

        return playType
    }

    //获取活动作品播放地址
    /*def getWorkUrl(Map args){
        def userWork = args.userWork
        def videoHost = args.videoHost
        def webHost = args.webHost
        def consumer = args.consumer
        def pwd = args.pwd

        def url = ""
        def playUrl = ""
        def isPlay = args.isPlay
        def isFlashPlay = args.isFlashPlay
        def isWeb = true

        def bAuthOK = false

        def subtitles = null
        def subtitle1 = "" //字幕文件1路径
        def subtitle2 = "" //字幕文件2路径
        def playProtocol = "BMSP"	//协议

        //playProtocol = nts.nts.utils.BfConfig.getPlayProtocol()

        //def auth = queryAuthority(consumer,program)
        //bAuthOK = isPlay?auth.canPlay:auth.canDownload

        if(!userWork) return ""

        playUrl = 'http://'+videoHost+'/course_def/res_url/'+nts.utils.CTools.readFileDir(userWork.filePath).getBytes("utf-8").encodeBase64()+'@/\'+encodeURIComponent("'+nts.utils.CTools.readFileName(userWork.filePath,true)+'")+\''

        return playUrl
    }*/

    /**
     * 资源海报截图
     * @param program
     * @param size
     * @param position
     * @return
     */
    public String generalProgramPoster(Program program, String size, long position) {
        if (!program.posterHash) {

            Serial serial = null;
            if (program.serials.size() > 0) {
                serial = serialFirst(program);
            }

            if (!serial) {
                if (program.serials.size() > 0) {
                    serial = serialFirst(program);
                }
            }

            if (serial) {
                String url = generalSerialPoster(serial, size, position);
                return url;
            }
        } else {
            //TODO 默认海报未截取
            return null;
        }
        return null;
    }

    /**
     * 子节目海报截图
     * @param serial
     * @param size
     * @param position
     * @return
     */
    public String generalSerialPoster(Serial serial, String size, long position) {
        if (!serial.fileHash) {
            return null
        } else {
            ServletContext servletContext = utilService.getServletContext();
            String videoSevr = servletContext.getAttribute("videoSevr");
            String videoPort = servletContext.getAttribute("videoPort");    //视频服务器端口


            String ip = null;
            String port = null;

            if (!videoSevr) {
                SysConfig sysConfig = SysConfig.findByConfigName('VideoSevr');     //视频服务器IP地址
                if (sysConfig && sysConfig.configValue) {
                    ip = sysConfig.configValue;
                } else {
                    ip = InetAddress.getLocalHost().getHostAddress();
                }
                servletContext.setAttribute("videoSevr", ip);
            } else {
                ip = videoSevr;
            }

            if (!videoPort) {
                SysConfig sysConfig = SysConfig.findByConfigName('videoPort');     //视频服务器IP地址
                if (sysConfig && sysConfig.configValue) {
                    port = sysConfig.configValue;
                } else {
                    port = "1680";
                }

                servletContext.setAttribute("videoPort", port);
            } else {
                port = videoPort;
            }

            if (position == -1) {
                String pos = servletContext.getAttribute("thumbnailPos");
                if (!pos) {
                    SysConfig sysConfig = SysConfig.findByConfigName('thumbnailPos');     //视频服务器IP地址
                    if (sysConfig && sysConfig.configValue) {
                        position = sysConfig.configValue as long;
                    } else {
                        position = 1;
                    }
                    servletContext.setAttribute("thumbnailPos", position);
                }
            }
            String url = "http://${ip}:${port}/bmc2/api/poster/${serial.fileHash.toUpperCase()}/${size}_${position}.png";
            return url;
        }


    }
    /**
     * 获取任意文件截图
     * @param hash
     * @param size
     * @param position
     * @return
     */
    public String generalFilePoster(String hash, String size, long position) {
        ServletContext servletContext = utilService.getServletContext();
        String videoSevr = servletContext.getAttribute("videoSevr");
        String videoPort = servletContext.getAttribute("videoPort");    //视频服务器端口
        String ip = null;
        String port = null;

        if (!videoSevr) {
            SysConfig sysConfig = SysConfig.findByConfigName('VideoSevr');     //视频服务器IP地址
            if (sysConfig && sysConfig.configValue) {
                ip = sysConfig.configValue;
            } else {
                ip = InetAddress.getLocalHost().getHostAddress();
            }
            servletContext.setAttribute("videoSevr", ip);
        } else {
            ip = videoSevr;
        }

        if (!videoPort) {
            SysConfig sysConfig = SysConfig.findByConfigName('videoPort');     //视频服务器IP地址
            if (sysConfig && sysConfig.configValue) {
                port = sysConfig.configValue;
            } else {
                port = "1680";
            }

            servletContext.setAttribute("videoPort", port);
        } else {
            port = videoPort;
        }
        if (size == null) {
            size = "-1x-1";
        }
        String url = "http://${ip}:${port}/bmc2/api/poster/${hash}/${size}_${position}.png";
        return url;
    }
    /***
     * 生成社区共享资源路径
     */
    public String generalSharingPlayAddress(Sharing sharing) {
        return generalFilePlayAddress(sharing.fileHash);
    }
    /**
     * 生成serial的播放地址
     * @param serial
     * @return
     */
    public JSONObject generalSerialPlayAddress(Serial serial) {
        if (serial.svrAddress && serial.svrPort && (serial.program.fromNodeId != 0)) {
            return generalFilePlayAddress(serial.svrAddress, serial.svrPort as int, serial.fileHash, false);
        } else {
            return generalFilePlayAddress(serial.fileHash);
        }

    }

    /**
     * 返回program的子节目列表
     * @param program
     * @return
     */
    public JSONArray generalProgramPlayAddressList(Program program) {
        return generalFilePlayAddresses((program.serials*.fileHash).toArray() as String[]);
    }

    public JSONObject generalFilePlayAddress(String ip, int port, String fileHash, boolean isPdf = false) {
        String url = "http://${ip}:${port}/bmc2/api/playList";

        HttpPost httpPost = new HttpPost(url);
        ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("hash", fileHash));
        params.add(new BasicNameValuePair("isPdf", isPdf.toString()));
        httpPost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
        HttpClient httpClient = HttpClients.createDefault();
        log.debug("访问URL:${url},hash:${fileHash}")
        try {
            CloseableHttpResponse httpResponse = httpClient.execute(httpPost);
            String text = httpResponse.getEntity().getContent().getText("UTF-8");
            JSONElement result = JSON.parse(text);
            if (result.success) {
                JSONObject playList = result.playList;

                return playList;
            } else {
                log.error(result.msg);
                return null;
            }
        } catch (Exception e) {
            log.error(e.message, e);
            return null;
        }
    }
    /**
     * 根据文件hash返回播放地址
     * @param fileHash
     * @return
     */
    public JSONObject generalFilePlayAddress(String fileHash, boolean isPdf = false) {
        ServletContext servletContext = utilService.getServletContext();
        String videoSevr = servletContext.getAttribute("videoSevr");
        String videoPort = servletContext.getAttribute("videoPort");    //视频服务器端口
        String ip = null;
        String port = null;
        if (!videoSevr) {
            SysConfig sysConfig = SysConfig.findByConfigName('VideoSevr');     //视频服务器IP地址
            if (sysConfig && sysConfig.configValue) {
                ip = sysConfig.configValue;
            } else {
                ip = InetAddress.getLocalHost().getHostAddress();
            }
            servletContext.setAttribute("videoSevr", ip);
        } else {
            ip = videoSevr;
        }
        if (!videoPort) {
            SysConfig sysConfig = SysConfig.findByConfigName('videoPort');     //视频服务器IP地址
            if (sysConfig && sysConfig.configValue) {
                port = sysConfig.configValue;
            } else {
                port = "1680";
            }

            servletContext.setAttribute("videoPort", port);
        } else {
            port = videoPort;
        }
        JSONObject jsonObject = generalFilePlayAddress(ip, port as int, fileHash, isPdf);
        return jsonObject;
    }

    /**
     * 根据文件hash返回播放地址列表
     * @param fileHashs
     * @return [{url,msg,hash},{url,msg,hash},{url,msg,hash}...]
     */
    public JSONArray generalFilePlayAddresses(String[] fileHashs) {
        ServletContext servletContext = utilService.getServletContext();
        String videoSevr = servletContext.getAttribute("videoSevr");
        String videoPort = servletContext.getAttribute("videoPort");    //视频服务器端口
        String ip = null;
        String port = null;
        if (!videoSevr) {
            SysConfig sysConfig = SysConfig.findByConfigName('VideoSevr');     //视频服务器IP地址
            if (sysConfig && sysConfig.configValue) {
                ip = sysConfig.configValue;
            } else {
                ip = InetAddress.getLocalHost().getHostAddress();
            }
            servletContext.setAttribute("videoSevr", ip);
        } else {
            ip = videoSevr;
        }
        if (!videoPort) {
            SysConfig sysConfig = SysConfig.findByConfigName('videoPort');     //视频服务器IP地址
            if (sysConfig && sysConfig.configValue) {
                port = sysConfig.configValue;
            } else {
                port = "1680";
            }

            servletContext.setAttribute("videoPort", port);
        } else {
            port = videoPort;
        }

        String url = "http://${ip}:${port}/bmc2/api/playList";

        HttpPost httpPost = new HttpPost(url);
        ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
        for (String hash : fileHashs) {
            params.add(new BasicNameValuePair("hash", hash));
        }

        httpPost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
        HttpClient httpClient = HttpClients.createDefault();
        log.debug("访问URL:${url},hashes:${fileHashs}")
        try {
            CloseableHttpResponse httpResponse = httpClient.execute(httpPost);
            String text = httpResponse.getEntity().getContent().getText("UTF-8");
            def result = JSON.parse(text);
            if (result.success) {
                JSONArray playList = result.playList;
                return playList;
            } else {
                log.error(result.msg);
                return null;
            }
        } catch (Exception e) {
            log.error(e.message, e);
            return null;
        }
    }

    /**
     * 资源分类库创建
     * @param params
     * @return
     */
    public Map createProgramCategory(Map params) {
        def result = [:];

        ProgramCategory category = new ProgramCategory();
        if (params.pid) {
            ProgramCategory father = ProgramCategory.findById(params.pid as Long);
            if (father) {

                if (father.name.equals("默认资源库") && father.level < 0) {
                    result.success = false;
                    result.msg = "默认资源库不能创建子分类";
                    return result;
                }

                category.parentCategory = father;
                int count = ProgramCategory.countByParentCategory(father);
                if (count > 0) {
                    category.orderIndex = count;
                } else {
                    category.orderIndex = 0;
                }
                category.level = father.level + 1;
            }
        } else {
            int count = ProgramCategory.countByParentCategoryIsNull();
            if (count > 0) {
                category.orderIndex = count;
            } else {
                category.orderIndex = 0;
            }
        }
        category.name = params.categoryName;
        category.description = params.description;
        category.mediaType = params.mediaType as int;
        category.isDisplay = params.isDisplay as int; //默认显示状态,可通过ztree修改显示状态
        category.allowDelete = true;
        category.posterFormatType = params.posterFormat;

        //子分类不设置
//        if(params.directoryId) {
//            category.directoryId = params.directoryId as long;
//        }
//        def uploadResult = uploadImg("save", params.updateId);
//        if (!uploadResult.success) {
//            result.message = uploadResult.message;
//        }
//        if (params.uploadPath) category.uploadPath = params.uploadPath;
//        category.img = uploadResult.imgPath;

        if (category.save(flush: true) && (!category.hasErrors())) {
            result.success = true;
            result.id = category.id;
        } else {
            result.success = false;
            result.msg = category.errors.allErrors;
        }
        return result;
    }

    /**
     * 资源分类库创建
     * @param params
     * @return
     */
    public Map createProgramCategoryLibrary(Map params) {
        def result = [:];
        ProgramCategory category = new ProgramCategory();
        ProgramCategory parentCategory = programCategoryService.querySuperCategory();
        int count = ProgramCategory.countByParentCategoryIsNull();
        if (count > 0) {
            category.orderIndex = count;
        } else {
            category.orderIndex = 0;
        }
        category.parentCategory = parentCategory;
        category.name = params.categoryLibraryName;
        category.description = params.libraryDesc;
        category.mediaType = params.libraryMediaType as int;
        if (params.libraryDirectoryId && params.libraryDirectoryId != "-1") {
            category.directoryId = params.libraryDirectoryId as long;
        }

        //资源默认海报
        if (params.defaultProgramPosterHashCreate) {
            category.defaultProgramPosterHash = params.defaultProgramPosterHashCreate;
        }
        if (params.defaultProgramPosterHashPath) {
            category.defaultProgramPosterPath = params.defaultProgramPosterHashPath;
        }

        category.allowDelete = true;

        def uploadResult = uploadImg("saveLibrary", "");
        if (!uploadResult.success) {
            result.message = uploadResult.message;
        }
        if (params.libraryUploadPath) category.uploadPath = params.libraryUploadPath;
        category.img = uploadResult.imgPath;

        if (category.save(flush: true) && (!category.hasErrors())) {
            result.success = true;
            result.id = category.id;
        } else {
            result.success = false;
            result.msg = category.errors.allErrors;
        }
        return result;
    }

    /**
     * 资源分类库修改
     * @param params
     * @return
     */
    public Map modifyProgramCategory(Map params) {
        def result = [:];
        if (!params.updateId) {
            result.success = false;
            result.msg = "参数不齐全!";
            return result;
        }
        ProgramCategory category = ProgramCategory.findById(params.updateId as Long);
        if (!category) {
            result.success = false;
            result.msg = "what are you doing?";
            return result;
        }

        if (category.name.equals("默认资源库") && category.level < 0) {
            result.success = false;
            result.msg = "默认资源库不能修改";
            return result;
        }

        category.name = params.updatePCategoryName;
        category.description = params.updateDesc;
        category.mediaType = params.updateMediaType as int;
        category.isDisplay = params.updateIsDisplay as int;
        category.posterFormatType = params.posterFormat;
        //资源默认海报图片
        if (params.defaultProgramPosterHash) {
            category.defaultProgramPosterHash = params.defaultProgramPosterHash;
        }
        if (params.defaultProgramPosterPath) {
            category.defaultProgramPosterPath = params.defaultProgramPosterPath;
        }

        if (params.updateDirectoryId && params.updateDirectoryId != "-1") {
            category.directoryId = params.updateDirectoryId as long;
        }
        if (params.updateImg) {
            def uploadResult = uploadImg("update", params.updateId);
            if (!uploadResult.success) {
                result.message = uploadResult.message;
            }
            if (uploadResult.imgPath) category.img = uploadResult.imgPath;
        } else {
            category.img = "";
        }
        if (params.updateUploadPath) category.uploadPath = params.updateUploadPath;

        if (category.save(flush: true) && (!category.hasErrors())) {
            result.success = true;
        } else {
            result.success = false;
            result.msg = category.errors.allErrors;
        }
        return result;
    }

    /**
     * 资源分类库删除
     * @param params
     * @return
     */
    public Map removeProgramCategory(Map params) {
        def result = [:];
        if (params.id) {
            ProgramCategory category = ProgramCategory.findById(params.id as Long);
            if (category) {
                if (category.name.equals("默认资源库") && category.level < 0) {
                    result.success = false;
                    result.msg = "默认资源库不能删除";
                    return result;
                }
                int count = category.programs.size();

                int subCount = ProgramCategory.countByParentCategory(category);
                if (count > 0 || subCount > 0) {
                    if (count > 0) {
                        result.success = false;
                        result.msg = "分类下面还有资源，请先移动资源到其他分类!";
                        return result;
                    }
                    if (subCount > 0) {
                        result.success = false;
                        result.msg = "分类下面还有子分类!";
                        return result;
                    }
                } else {
                    def categories1 = ProgramCategory.withCriteria {
                        if (category.parentCategory) {
                            eq("parentCategory", category.parentCategory)
                        } else {
                            isNull("parentCategory")
                        }
                        eq("level", category.level);
                    }
                    categories1.each { ProgramCategory programCategory ->
                        programCategory.save(flush: true);
                    }

                    String str = deleteImg(category.img);
                    if (str) {
                        result.success = false;
                        result.msg = str;
                    } else {
                        def parentCategory = null;
                        if (category?.parentCategory) {
                            parentCategory = category?.parentCategory;
                        } else {
                            parentCategory = programCategoryService.querySuperCategory();
                        }
                        category.delete(flush: true);
                        //重新设定orderIndex
                        programCategoryOrderIndexSetting(parentCategory);
                        result.success = true;
                    }
                    return result;
                }
            } else {
                result.success = false;
                result.msg = "分类不存在!";
            }
        } else {
            result.success = false;
            result.msg = "参数不全!";
        }
        return result;
    }

    /**
     * 资源分类位置修改
     * @param params
     * @return
     */
    Map modifyProgramCategoryOrderIndex(Map params) {
        def result = [:];
        def id = params.id; //被拖拽分类ID
        def targetId = params.targetId; //目标分类ID
        def moveType = params.moveType;

        ProgramCategory category = ProgramCategory.get(id as long);
        ProgramCategory targetCategory = ProgramCategory.get(targetId as long);
        List<ProgramCategory> categoryList = [];
        if ("inner".equals(moveType)) {
            categoryList = ProgramCategory.findAllByParentCategory(targetCategory);
            categoryList.sort { category1, category2 ->
                category1.orderIndex <=> category2.orderIndex
            }

            //重新排序
            def index = 0;
            categoryList.each {
                it.orderIndex = index;
                index++;
            }

            category.orderIndex = ProgramCategory.countByParentCategory(targetCategory);
            category.parentCategory = targetCategory;
            if (category.save(flush: true) && (!category.hasErrors())) {
                result.success = true;
            } else {
                result.success = false;
                result.msg = category.errors.allErrors;
            }
        } else {
            ProgramCategory parentCategory = targetCategory.parentCategory;
            categoryList = ProgramCategory.findAllByParentCategory(parentCategory);
            categoryList.sort { category1, category2 ->
                category1.orderIndex <=> category2.orderIndex
            }

            def orderIndex = targetCategory.orderIndex;

            if (parentCategory) {
                if (category.parentCategory.id == parentCategory.id) { //同一级拖拽
                    categoryList.remove(category);
                }

                //重新排序
                def index = 0;
                categoryList.each {
                    if (orderIndex == it.orderIndex) {
                        orderIndex = index; //新的目标位置
                    }
                    it.orderIndex = index;
                    index++;
                }

                if ("next".equals(moveType)) {
                    categoryList.each { ProgramCategory programCategory ->
                        if (programCategory.orderIndex > orderIndex) {
                            programCategory.orderIndex++;
                        }
                        programCategory.save(flush: true);
                    }
                    category.parentCategory = parentCategory;
                    category.orderIndex = orderIndex + 1;
                } else if ("prev".equals(moveType)) {
                    categoryList.each { ProgramCategory programCategory ->
                        if (programCategory.orderIndex >= orderIndex) {
                            programCategory.orderIndex++;
                        }
                        programCategory.save(flush: true);
                    }
                    category.parentCategory = parentCategory;
                    category.orderIndex = orderIndex;
                }

                if (category.save(flush: true) && (!category.hasErrors())) {
                    result.success = true;
                } else {
                    result.success = false;
                    result.msg = category.errors.allErrors;
                }

            } else { //与根分类同级
                category.orderIndex = ProgramCategory.countByParentCategoryIsNull();
                category.parentCategory = null;
                if (category.save(flush: true) && (!category.hasErrors())) {
                    result.success = true;
                } else {
                    result.success = false;
                    result.msg = category.errors.allErrors;
                }
            }
        }
        return result;
    }

    /**
     * 资源分类库显示状态设置失败
     * @param params
     * @return
     */
    public Map modifyProgramCategoryIsDisplay(Map params) {
        def result = [:];
        if (!params.id || !params.isDisplay) {
            result.success = false;
            result.msg = "参数不齐全!";
            return result;
        }
        ProgramCategory category = ProgramCategory.findById(params.id as Long);
        if (!category) {
            result.success = false;
            result.msg = "what are you doing?";
            return result;
        }

        category.isDisplay = params.isDisplay as int;
        if (category.save(flush: true) && (!category.hasErrors())) {
            result.success = true;
        } else {
            result.success = false;
            result.msg = "显示状态设置失败";
        }
        return result;
    }

    /**
     * 分面创建
     * @param params
     * @return
     */
    public Map createCategoryFacted(Map params) {
        def result = [:];
        def categoryId = params.selectProgramCategoryId;
        def categoryFactedName = params.categoryFactedName;
        CategoryFacted facted = new CategoryFacted();
        if (categoryFactedName && categoryId) {
            ProgramCategory category = ProgramCategory.findById(categoryId as Long);
            if (CategoryFacted.countByCategory(category) >= 10) {
                result.success = false;
                result.msg = "分面添加不能超过10个!";
                return result;
            }
            if (CategoryFacted.findByNameAndCategory(params.categoryFactedName, category)) {
                result.success = false;
                result.msg = "分面名不能重复!";
                return result;
            }
            facted.category = category;
            facted.name = params.categoryFactedName;
            def count = CategoryFacted.countByCategory(category) == 0 ? 1 : CategoryFacted.countByCategory(category) + 1;
            facted.orderIndex = count;
            facted.enName = "value" + count + "_facet";
            if (facted.save(flush: true) && (!facted.hasErrors())) {
                result.success = true;
                result.id = categoryId;
            } else {
                result.success = false;
                result.msg = facted.errors.allErrors;
            }
            return result;
        } else {
            result.success = false;
            result.msg = "参数不全!";
            return result;
        }
    }

    /**
     * 创建分面值
     * @param params
     * @return
     */
    public Map createFactedValue(Map params) {
        def result = [:];
        if (!params.factedId || !params.factedName) {
            result.success = false;
            result.msg = "参数不齐全!";
            return result;
        }

        CategoryFacted facted = CategoryFacted.findById(params.factedId as Long);

        if (!facted) {
            result.success = false;
            result.msg = "what are you doing?";
            return result;
        }
        def values = FactedValue.findAllByContentValueAndCategoryFacted(params.factedName, facted);
        if (values) {
            result.success = false;
            result.msg = "分面名称/值不能重复!";
            return result;
        }
        FactedValue factedValue = new FactedValue();
        factedValue.categoryFacted = facted;
        factedValue.contentValue = params.factedName;
        def count = FactedValue.countByCategoryFacted(facted);
        if (count == 0) {
            factedValue.orderIndex = 1;
        } else {
            factedValue.orderIndex = count;
        }

        if (factedValue.save(flush: true) && (!factedValue.hasErrors())) {
            facted.values.add(factedValue);
            facted.save(flush: true);
            result.success = true;
        } else {
            result.success = false;
            result.msg = factedValue.errors.allErrors;
        }
        return result;
    }

    /**
     * 修改分面名称
     * @param params
     * @return
     */
    public Map modifyCategoryFacted(Map params) {
        def result = [:];
        if (!params.factedId || !params.factedName) {
            result.success = false;
            result.msg = "参数不齐全!";
            return result;
        }
        CategoryFacted facted = CategoryFacted.findById(params.factedId as Long);
        if (!facted) {
            result.success = false;
            result.msg = "what are you doing?";
            return result;
        }
        def facteds = CategoryFacted.findAllByNameAndIdNotEqual(params.factedName, params.factedId as Long);
        if (facteds) {
            result.success = false;
            result.msg = "分面名称/值不能重复!";
            return result;
        }
        facted.name = params.factedName;
        if (facted.save(flush: true) && (!facted.hasErrors())) {
            result.success = true;
        } else {
            result.success = false;
            result.msg = facted.errors.allErrors;
        }
        return result;
    }

    /**
     * 修改分面值
     * @param params
     * @return
     */
    public Map modifyFactedValue(Map params) {
        def result = [:];
        if (!params.factedId || !params.factedName) {
            result.success = false;
            result.msg = "参数不齐全!";
            return result;
        }
        FactedValue factedValue = FactedValue.findById(params.factedId as Long);
        if (!factedValue) {
            result.success = false;
            result.msg = "what are you doing?";
            return result;
        }

        def values = FactedValue.findAllByContentValueAndIdNotEqual(params.factedName, params.factedId as long);
        if (values) {
            result.success = false;
            result.msg = "分面名称/值不能重复!";
            return result;
        }
        factedValue.contentValue = params.factedName;
        if (factedValue.save(flush: true) && (!factedValue.hasErrors())) {
            result.success = true;
        } else {
            result.success = false;
            result.msg = factedValue.errors.allErrors;
        }
        return result;
    }

    /**
     * 分面值删除
     * @param params
     * @return
     */
    public Map removeFactedValue(Map params) {
        def result = [:];
        if (!params.factedId) {
            result.success = false;
            result.msg = "参数不齐全!";
            return result;
        }
        FactedValue factedValue = FactedValue.findById(params.factedId as Long);
        if (!factedValue) {
            result.success = false;
            result.msg = "what are you doing?";
            return result;
        }
        try {
            if (factedValue.categoryFacted) {
                CategoryFacted facted = CategoryFacted.get(factedValue.categoryFacted.id);
                facted.removeFromValues(factedValue);
                facted.save();
            }
            factedValue.delete(flush: true);
            result.success = true;
        } catch (Exception e) {
            result.success = false;
            result.msg = "删除失败!";
        }
        return result;
    }

    /**
     * 分面删除
     * @param params
     * @return
     */
    public Map removeCategoryFacted(Map params) {
        def result = [:];
        if (!params.factedId) {
            result.success = false;
            result.msg = "参数不齐全!";
            return result;
        }
        CategoryFacted facted = CategoryFacted.findById(params.factedId as Long);
        if (!facted) {
            result.success = false;
            result.msg = "what are you doing?";
            return result;
        }
        try {
            facted?.values.each { FactedValue value ->
                value.categoryFacted.removeFromValues(value);
                value.delete(flush: true);
            }
            facted.delete(flush: true);
            result.success = true;
        } catch (Exception e) {
            result.success = false;
            result.msg = '删除失败!';
        }
        return result;
    }

    /**
     * 查询分面
     * @param params
     * @return
     */
    public Map queryCategoryFacted(Map params) {
        def result = [:];
        def rows = [];
        def row = [:];
        def values = [];
        List categoryIds = [];
        String categoryIdStr = params.categoryId;
        if (categoryIdStr && categoryIdStr.contains(",")) {
            categoryIds = params.categoryId.split(",")
        } else {
            categoryIds.add(params.categoryId);
        }

        categoryIds.each { categoryId ->
            ProgramCategory category = ProgramCategory.get(categoryId as long);
            if (category) {
                List<CategoryFacted> factedList = category?.facteds.toList().sort();
                factedList.sort { facted1, facted2 ->
                    facted1.id <=> facted2.id;
                }
                if (factedList && factedList.size() > 0) {
                    for (CategoryFacted facted : factedList) {
                        row = [:];
                        if (facted?.values) {
                            row.factedId = facted.id;
                            row.factedName = facted.name;
                            values = [];
                            def fValues = facted?.values.toList().sort();
                            fValues.sort { val1, val2 ->
                                val1.id <=> val2.id;
                            }
                            fValues?.each { FactedValue value ->
                                def val = [:];
                                val.valId = value.id;
                                val.valName = value.contentValue;
                                values.add(val);
                            }
                            values.sort { val1, val2 ->
                                val1.valId <=> val2.valId
                            };
                            row.values = values;
                            rows.add(row);
                        }
                    }
                    //rows.sort();
                }
            }
        }

        result.rows = rows;
        result.success = true;
        return result;
    }

    /**
     * 查询元数据标准和上传路径(如果是子分类,使用父分类的)
     * @param params
     * @return
     */
    public Map queryCategoryDirectoryAndUploadPath(Map params) {
        def result = [:];
        def categoryId = params.categoryId;
        // 获取第二级分类list
        List<ProgramCategory> categoryList = programCategoryService.querySubCategoryForAdmin(programCategoryService.querySuperCategory());
        def categoryIdList = categoryList?.id;
        ProgramCategory category = ProgramCategory.get(categoryId as long);
        if (category) {
            ProgramCategory parent = queryParentCategory(category, categoryIdList);
            if (parent) {
                result.uploadPath = parent.uploadPath;
                result.directoryId = parent.directoryId;
                result.success = true;
            }
        } else {
            result.msg = "查询失败";
            result.success = false;
        }

        return result;
    }

    /**
     * 查询第二级分类
     * @param category
     * @return
     */
    private ProgramCategory queryParentCategory(ProgramCategory category, List<Long> categoryIdList) {
        ProgramCategory parentCategory = null;
        if (!categoryIdList.contains(category?.id)) {
            parentCategory = queryParentCategory(category.parentCategory, categoryIdList);
        } else {
            parentCategory = category;
        }
        return parentCategory;
    }

    /**
     * 判断所选分类是否属于同一分类库
     * @param params
     * @return
     */
    public Map checkProgramCategory(Map params) {
        def result = [:];
        // 获取第二级分类list
        List<ProgramCategory> categoryList = programCategoryService.querySubCategoryForAdmin(programCategoryService.querySuperCategory());
        def categoryIdList = categoryList?.id;
        def categoryId = params.categoryId;
        if (categoryId != '') {
            String[] categoryIds = categoryId.split(",");
            def firstCategory = ProgramCategory.get(categoryIds[0] as long);
            def firstParentCategory = queryParentCategory(firstCategory, categoryIdList); //获取第一个分类所属的分类库
            if (firstParentCategory) {
                for (int i = 1; i < categoryIds.length; i++) {
                    def category = ProgramCategory.get(categoryIds[i] as long);
                    def parentCategory = queryParentCategory(category, categoryIdList);
                    if (firstParentCategory.id != parentCategory.id) {
                        result.success = false;
                        result.msg = firstCategory.name + " 与 " + category.name + " 不在同一库下, 请重新选择!";
                        break;
                    } else {
                        result.success = true;
                    }
                }
            }
        } else {
            result.msg = "参数不全!";
            result.success = false;
        }
        return result;
    }

    /**
     *
     * @param params
     *          name      资源名称
     *          canPublic  公开
     *          directoryId  类库
     *          programCategoryId 分类
     *          programTagId 标签
     *          urlType 媒体类型
     *          offset 分页参数与
     *          max
     *          orderBy  排序属性
     *          order 排序方向
     * @isCount false 分页 true 不分页
     * @return 搜索的集合
     */
    public List<Program> search(Map params, boolean isCount = false) {
        StringBuffer hql = new StringBuffer("select distinct(p) from Program  p ");
        List<Program> programList = [];
        def conditions = [:];
        StringBuffer whereHql = new StringBuffer(" where p.state = :p_state ");
        conditions.p_state = Program.PUBLIC_STATE;
        ProgramCategory category = null;
        if (params.programCategoryId) {
            category = ProgramCategory.load(params.programCategoryId);
            def categoryIds = programCategoryService.querySubAllCategory(category)*.id;
            categoryIds.add(category.id);

            hql.append(" join p.programCategories c ");
            whereHql.append(" and c.id in(:cid)")
            conditions.cid = categoryIds;
        }

        whereHql.append(" and p.transcodeState in :p_transcodeState ")
        List states = new ArrayList();
        states.add(Program.STATE_SUCCESS);
        states.add(Program.STATE_SUCCESS_PART);
        conditions.p_transcodeState = states;

        if (params.programTagId) {
            ProgramTag tag = ProgramTag.load(params.programTagId);
            hql.append(" join p.programTags t ");
            whereHql.append(" and t.name = :t_name ");
            conditions.t_name = tag.name;
        }

        //分面查询
        if (params.factedValue && params.factedName) {
            def facetList = [];
            if (params.factedValue instanceof List) { //PC端查询用
                facetList = params.factedValue;
            } else if (params.factedValue instanceof String) { //手机端查询用
                def facets = params.factedValue.split(",");
                facets.each {
                    facetList.add(it);
                }
            }

            def facetNameList = [];
            if (params.factedName instanceof List) { //PC端查询用
                facetNameList = params.factedName;
            } else if (params.factedName instanceof String) { //手机端查询用
                def facets = params.factedName.split(",");
                facets.each {
                    facetNameList.add(it);
                }
            }


            def facetValueIds = [];
            if (facetList && facetList.size() > 0 && facetNameList && facetNameList.size() > 0 && category) {
                //根据分面名和分类查询分面id
                for (int i = 0; i < facetNameList.size(); i++) {
                    def facet = CategoryFacted.findByEnNameAndCategory(facetNameList[i], category);
                    if (facet) {
                        def facetValue = FactedValue.findByCategoryFactedAndContentValue(facet, facetList[i]);
                        if (facetValue && !facetValueIds.contains(facetValue.id)) {
                            facetValueIds.add(facetValue.id);
                        }
                    }
                }
            }

            if (facetValueIds.size() > 0) {
                Set<Program> programs = new HashSet<Program>();
                for (int i = 0; i < facetValueIds.size(); i++) {
                    def p1 = Program.executeQuery("select fv.programs  from FactedValue fv where fv.id=" + facetValueIds[i]);
                    if (i == 0) {
                        programs.addAll(p1);
                    } else {
                        programs.retainAll(p1);
                    }
                }

                if (programs && programs.size() > 0) {
                    def programIds = [];
                    programIds = programs.id.toList();
                    whereHql.append(" and p.id in :p_id ");
                    conditions.p_id = programIds;
                } else {
                    programList = [];
                    return programList;
                }
            }
        }

        if (userService.judeAnonymity()) {
            whereHql.append(" and p.canPublic = true ");
        }

        if (params.otherOption && (params.otherOption != -1)) {
            whereHql.append(" and p.otherOption = :p_otherOption ");
            if (params.otherOption instanceof Integer) {
                conditions.p_otherOption = params.otherOption;
            } else {
                conditions.p_otherOption = Integer.parseInt(params.otherOption);
            }
        }

        if (params.name) {
            whereHql.append(" and p.name like :p_name ");
            conditions.p_name = "%" + params.name + "%";
        }

        if (params.directoryId) {
            whereHql.append(" and p.directory.id = :p_dirId");
            conditions.p_dirId = Long.parseLong(params.directoryId);
        }
        if (params.recommendState) {
            whereHql.append(" and p.recommendState = :p_recommendState");
            conditions.p_recommendState = params.recommendState;
        }

        if (params.order && params.orderBy) {
            whereHql.append(" order by p." + params.orderBy + " " + params.order)
        }
        int offset = 0;
        int max = 10;
        if (params.offset) {
            try {
                if (params.offset instanceof Integer) {
                    offset = params.offset;
                } else {
                    offset = Integer.parseInt(params.offset);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (params.max) {
            try {
                if (params.max instanceof Integer) {
                    max = params.max;
                } else {
                    max = Integer.parseInt(params.max);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        hql.append(whereHql);

        if (isCount) {
            programList = Program.executeQuery(hql.toString(), conditions);
        } else {
            try {
                programList = Program.executeQuery(hql.toString(), conditions, ["max": max, "offset": offset, "cache": true]);
            } catch (Exception e) {
                e.printStackTrace()
            }

        }

        return programList;
    }

    /**
     *
     * @param params
     *          name      资源名称
     *          canPublic  公开
     *          directoryId  类库
     *          programCategoryId 分类
     *          programTagId 标签
     *          urlType 媒体类型
     *          offset 分页参数与
     *          max
     *          orderBy  排序属性
     *          order 排序方向
     * @return 搜索的集合总数
     */
    public long searchTotalCount(Map params) {
        long totalCount = 0;
        StringBuffer hql = new StringBuffer("select count(distinct p) from Program  p ");
        def conditions = [:];
        StringBuffer whereHql = new StringBuffer(" where p.state = :p_state ");
        conditions.p_state = Program.PUBLIC_STATE;
        ProgramCategory category = null;
        if (params.programCategoryId) {
            category = ProgramCategory.load(params.programCategoryId);
            def categoryIds = programCategoryService.querySubAllCategory(category)*.id;
            categoryIds.add(category.id);

            hql.append(" join p.programCategories c ");
            whereHql.append(" and c.id in(:cid)")
            conditions.cid = categoryIds;
        }

        whereHql.append(" and p.transcodeState in :p_transcodeState ")
        List states = new ArrayList();
        states.add(Program.STATE_SUCCESS);
        states.add(Program.STATE_SUCCESS_PART);
        conditions.p_transcodeState = states;
        if (params.programTagId) {
            ProgramTag tag = ProgramTag.load(params.programTagId);
            hql.append(" join p.programTags t ");
            whereHql.append(" and t.name = :t_name ");
            conditions.t_name = tag.name;
        }

        //分面查询
        if (params.factedValue && params.factedName) {
            def facetList = [];
            if (params.factedValue instanceof List) { //PC端查询用
                facetList = params.factedValue;
            } else if (params.factedValue instanceof String) { //手机端查询用
                def facets = params.factedValue.split(",");
                facets.each {
                    facetList.add(it);
                }
            }

            def facetNameList = [];
            if (params.factedName instanceof List) { //PC端查询用
                facetNameList = params.factedName;
            } else if (params.factedName instanceof String) { //手机端查询用
                def facets = params.factedName.split(",");
                facets.each {
                    facetNameList.add(it);
                }
            }


            def facetValueIds = [];
            if (facetList && facetList.size() > 0 && facetNameList && facetNameList.size() > 0 && category) {
                //根据分面名和分类查询分面id
                for (int i = 0; i < facetNameList.size(); i++) {
                    def facet = CategoryFacted.findByEnNameAndCategory(facetNameList[i], category);
                    if (facet) {
                        def facetValue = FactedValue.findByCategoryFactedAndContentValue(facet, facetList[i]);
                        if (facetValue && !facetValueIds.contains(facetValue.id)) {
                            facetValueIds.add(facetValue.id);
                        }
                    }
                }
            }

            if (facetValueIds.size() > 0) {
                Set<Program> programs = new HashSet<Program>();
                for (int i = 0; i < facetValueIds.size(); i++) {
                    def p1 = Program.executeQuery("select fv.programs  from FactedValue fv where fv.id=" + facetValueIds[i]);
                    if (i == 0) {
                        programs.addAll(p1);
                    } else {
                        programs.retainAll(p1);
                    }
                }

                def programIds = [];
                if (programs && programs.size() > 0) {
                    programIds = programs.id.toList();
                    whereHql.append(" and p.id in :p_id ");
                    conditions.p_id = programIds;
                } else {
                    totalCount = 0;
                    return totalCount;
                }
            }
        }

        if (userService.judeAnonymity()) {
            whereHql.append(" and p.canPublic = true ");
        }

        if (params.otherOption && (params.otherOption != -1)) {
            whereHql.append(" and p.otherOption = :p_otherOption ");
            if (params.otherOption instanceof Integer) {
                conditions.p_otherOption = params.otherOption;
            } else {
                conditions.p_otherOption = Integer.parseInt(params.otherOption);
            }
        }

        if (params.name) {
            whereHql.append(" and p.name like :p_name ");
            conditions.p_name = "%" + params.name + "%";
        }

        if (params.directoryId) {
            whereHql.append(" and p.directory.id = :p_dirId");
            conditions.p_dirId = Long.parseLong(params.directoryId);
        }
        if (params.recommendState) {
            whereHql.append(" and p.recommendState = :p_recommendState");
            conditions.p_recommendState = params.recommendState;
        }

        if (params.order && params.orderBy) {
            whereHql.append(" order by p." + params.orderBy + " " + params.order)
        }

        hql.append(whereHql);

        try {
            totalCount = Program.executeQuery(hql.toString(), conditions)[0];
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalCount;
    }

    public Map myModifyProgram(Map params) {
        def result = [:];
        def id = params.programId;
        def name = params.name;
        def otherOption = params.otherOption;
        def description = params.description;
        int fileCount = params.fileCount as int;
        def canPublic = params.canPublic;
        def programTag = params.programTag;
        def posterHash = params.posterHash;
        def posterPath = params.posterPath;
        def dirId = params.dirId;
        def categoryId = params.categoryId;


        Program program = Program.findById(id);

        if (program) {
            //保存资源
            if (fileCount > 0) {
                def maxSerialNo = Serial.withCriteria {
                    eq('program', program)
                    projections {
                        max('serialNo')
                    }
                };
                try {
                    maxSerialNo = (maxSerialNo[0] as int) + 1;
                } catch (e) {
                    maxSerialNo = 1;
                }
                //maxSerialNo = maxSerialNo ? ((maxSerialNo[0] as int) + 1) : 1;
                for (int i = 0; i <= fileCount; i++) {
                    def fileName = params.get("fileName_" + i);
                    def fileHash = params.get("fileHash_" + i);
                    def filePath = params.get("filePath_" + i);
                    def fileDesc = params.get("fileDesc_" + i);
                    if (fileName && fileHash && filePath) {
                        Serial serial = new Serial();
                        File file = new File(filePath as String);
                        serial.filePath = filePath;
                        serial.name = fileName;
                        serial.program = program;
                        serial.fileHash = fileHash.toString().toUpperCase();
                        if (fileDesc) {
                            serial.description = fileDesc;
                        }
                        serial.fileType = FileType.getFileType(file);
                        serial.serialNo = maxSerialNo++;
                        serial.dateCreated = new Date();
                        serial.dateModified = new Date();
                        if (com.boful.common.file.utils.FileType.isVideo(fileName as String)) {
                            serial.urlType = Serial.URL_TYPE_VIDEO;
                        } else if (com.boful.common.file.utils.FileType.isDocument(fileName as String)) {
                            serial.urlType = Serial.URL_TYPE_DOCUMENT;
                        } else if (com.boful.common.file.utils.FileType.isImage(fileName as String)) {
                            serial.urlType = Serial.URL_TYPE_IMAGE;
                        } else {
                            serial.fileType = -1;
                        }
                        program.addToSerials(serial);
                    }
                }
                //program.save(flush: true)
            }

            program.name = name;
            program.description = description;
            program.otherOption = otherOption as int;
            program.canPublic = Boolean.parseBoolean(canPublic);

            //获得标签
            //TODO 以前数据库设计逻辑有问题 从资源中删除标签 如果其他地方也有 则不能删除
            program.programTags.clear();
            program.save(flush: true)
            if (programTag && (!StringUtils.isEmpty(programTag))) {
                String[] tags = programTag.split(";");
                tags.each { String tag ->
                    if (StringUtils.isNotBlank(tag)) {
                        tag = tag.trim();
                        ProgramTag programTag1 = ProgramTag.findByName(tag);
                        if (programTag1) {
                            programTag1.frequency++;
                            def isExsit = false;
                            for (ProgramTag programTag2 : program.programTags) {
                                if (programTag2.name.equals(programTag1.name)) {
                                    isExsit = true;
                                    break;
                                }
                            }
                            if (!isExsit) {
                                program.addToProgramTags(programTag1)
                            }
                        } else {
                            programTag1 = new ProgramTag(name: tag, frequency: 0);
                            program.addToProgramTags(programTag1)
                        }
                    }
                }
            }

            //类库
            if (dirId && (dirId != program.directoryId)) {
                Directory directory = Directory.findById(dirId);
                if (directory) {
                    program.directory = directory;
                    program.classLib = directory;
                }
            }

            //分类
            if (categoryId) {
                String[] categoryIds = categoryId.split(",");
                categoryIds?.each {
                    def programCategory = ProgramCategory.get(it as long);
                    program.addToProgramCategories(programCategory);
                }
            } else {
                //默认分类
                ProgramCategory programCategory = ProgramCategory.findByName("默认资源库");
                program.addToProgramCategories(programCategory);
            }

            if (program.save(flush: true)) {
                result.success = true;
                result.msg = "资源修改成功!";
                result.program = program;
            } else {
                result.success = false;
                result.msg = "资源修改失败!";
                result.id = id;
            }
        } else {
            result.success = false;
            result.msg = "参数不全!";
            result.id = id;
        }
        return result;
    }

    /***
     * 修改资源信息
     * @param params
     * @return
     */
    public Map modifyProgramInfo(Map params) {
        def result = [:];
        def id = params.programId;
        def name = params.name;
        def otherOption = params.otherOption;
        def description = params.description;
        def canPublic = params.canPublic;
        def programTag = params.programTag;
        def posterHash = params.posterHash;
        def posterPath = params.posterPath;
        def dirId = params.dirId;
        def categoryId = params.categoryId;
        def recommendNum = params.recommendNum;
        def factedValIds = [];
        if (params.factedValue) {
            if (params.factedValue instanceof String) {
                factedValIds.add(params.factedValue);
            } else if (params.factedValue instanceof String[]) {
                String[] values = params.factedValue;
                for (String value : values) {
                    factedValIds.add(value);
                }
            }
        }

        Program program = Program.findById(id);

        if (program) {
            //保存资源
            program.name = name;
            program.description = description;

            // 分面
            // 清除原有的分面
            List<FactedValue> factedValues = program?.factedValues.toList();
            if (factedValues && factedValues.size() > 0) {
                for (FactedValue value : factedValues) {
                    program.removeFromFactedValues(value);
                }
            }
            if (factedValIds && factedValIds.size() > 0) {
                factedValIds?.each {
                    FactedValue value = FactedValue.get(it as long);
                    if (value) {
                        program.addToFactedValues(value);
                    }
                }
            }

            //资源推荐数手动修改
            if (recommendNum) {
                program.recommendNum = Integer.parseInt(recommendNum);
            }
            //如果要改为课程，该program所属分类必须是开放课程
            if ("128".equals(otherOption) && program.programCategories) {
                ProgramCategory programCategory = ProgramCategory.findByName("开放课程资源库");
                List<ProgramCategory> categoryList = programCategoryService.querySubAllCategory(programCategory);
                //判断修改的program为课程，分类是否为开放课程
                for (ProgramCategory category : categoryList) {
                    if (program.programCategories.id.contains(category.id)) {
                        program.otherOption = otherOption as int;
                        break;
                    }
                }
            } else {
                program.otherOption = otherOption as int;
            }
            program.canPublic = Boolean.parseBoolean(canPublic);

            //获得标签
            //TODO 以前数据库设计逻辑有问题 从资源中删除标签 如果其他地方也有 则不能删除
//            program.programTags.clear();
//            program.save(flush: true)
            List<ProgramTag> programTags = program?.programTags.toList().sort();
            if (programTags && programTags.size() > 0) {
                for (ProgramTag programTag1 : programTags) {
                    program.removeFromProgramTags(programTag1);
                }
            }
            if (programTag && (!StringUtils.isEmpty(programTag))) {
                String[] tags = programTag.split(" ");
                tags.each { String tag ->
                    if (StringUtils.isNotBlank(tag)) {
                        tag = tag.trim();
                        ProgramTag programTag1 = ProgramTag.findByName(tag);
                        if (programTag1) {
                            programTag1.frequency++;
                            def isExsit = false;
                            for (ProgramTag programTag2 : program.programTags) {
                                if (programTag2.name.equals(programTag1.name)) {
                                    isExsit = true;
                                    break;
                                }
                            }
                            if (!isExsit) {
                                program.addToProgramTags(programTag1)
                            }
                        } else {
                            programTag1 = new ProgramTag(name: tag, frequency: 0);
                            program.addToProgramTags(programTag1)
                        }
                    }
                }
            }

            //类库
//            if (dirId && (dirId != program.directoryId)) {
//                Directory directory = Directory.findById(dirId);
//                if (directory) {
//                    program.directory = directory;
//                    program.classLib = directory;
//                }
//            }

            //分类
            //移除原有分类
            if (program.programCategories) {
                def categoryList = program.programCategories.toList().sort();
                categoryList?.each {
                    program.removeFromProgramCategories(it);
                }
//                program.save(flush: true)
            }

            def firstCategoryId = 0;
            if (categoryId) {
                String[] categoryIds = categoryId.split(",");
                categoryIds?.each {
                    def programCategory = ProgramCategory.get(it as long);
                    program.addToProgramCategories(programCategory);
                }
                if (categoryIds && categoryIds.size() > 0) {
                    // 设置元数据标准,第一个分类id
                    firstCategoryId = categoryIds[0] as long;
                }
            } else {
                //默认分类
                ProgramCategory programCategory = ProgramCategory.findByName("默认资源库");
                program.addToProgramCategories(programCategory);
                firstCategoryId = programCategory.id;
            }
            if (firstCategoryId != 0) {
                // 设置元数据标准, 第一个分类id
                def directoryId = programMgrService.queryCategoryDirectoryId(firstCategoryId);
                def directory = Directory.findById(directoryId);
                program.directory = directory;
                program.classLib = directory
                program.firstCategoryId = firstCategoryId;
            }
//            Program program2 = Program.get(program.id);
//            program2.properties.each {
//            }
            if (program.save(flush: true)) {
                result.success = true;
                result.msg = "资源修改成功!";
                result.program = program;
                new OperationLog(tableName: 'program', tableId: program.id, operator: params.consumer.name, operatorIP: params.request.getRemoteAddr(),
                        modelName: '修改资源', brief: program.name, operatorId: params.consumer.id, operation: OperationEnum.EDIT_PROGRAM).save(flush: true)
            } else {
                result.success = false;
                result.msg = "资源修改失败!";
                result.id = id;
            }
        } else {
            result.success = false;
            result.msg = "参数不全!";
            result.id = id;
        }
        return result;
    }

    /**
     * 修改子目信息
     * @param params
     * @return
     */
    public Map modifySerialList(Map params) {
        def result = [:];
        def fileCount = params.fileCount as int;
        def programId = params.programId;
        if (!programId || !fileCount) {
            result.success = false;
            result.msg = "参数不全！！";
            return result;
        }
        Program program = Program.findById(programId as long);
        if (!program) {
            result.success = false;
            result.msg = "资源不存在!";
            return result;
        }
        //保存资源
        if (fileCount > 0) {
            def maxSerialNo = Serial.withCriteria {
                eq('program', program)
                projections {
                    max('serialNo')
                }
            };
            try {
                maxSerialNo = (maxSerialNo[0] as int) + 1;
            } catch (e) {
                maxSerialNo = 1;
            }
            //maxSerialNo = maxSerialNo ? ((maxSerialNo[0] as int) + 1) : 1;
            int serialNum = 0;
            for (int i = 0; i <= fileCount; i++) {
                def fileName = params.get("fileName_" + i);
                def fileHash = params.get("fileHash_" + i);
                def filePath = params.get("filePath_" + i);
                def fileDesc = params.get("fileDesc_" + i);
                if (fileName && fileHash && filePath) {
                    Serial serial = new Serial();
                    File file = new File(filePath as String);
                    serial.filePath = filePath;
                    serial.name = fileName;
                    serial.program = program;
                    serial.fileHash = fileHash.toString().toUpperCase();
                    if (fileDesc) {
                        serial.description = fileDesc;
                    }
                    serial.fileType = FileType.getFileType(file);
                    serial.serialNo = maxSerialNo++;
                    serial.dateCreated = new Date();
                    serial.dateModified = new Date();
                    if (FileType.isVideo(filePath as String)) {
                        serial.urlType = Serial.URL_TYPE_VIDEO;
                    } else if (FileType.isDocument(filePath as String)) {
                        serial.urlType = Serial.URL_TYPE_DOCUMENT;
                    } else if (FileType.isImage(filePath as String)) {
                        serial.urlType = Serial.URL_TYPE_IMAGE;
                    } else {
                        serial.urlType = -1;
                    }
                    serial.state = 1;
                    serial.fileSize = params.get("fileSize_" + i) as Long;
                    serial.save(flush: true)
                    program.addToSerials(serial);
                    serialNum++;
                }

            }
            program.serialNum = serialNum;
            // 变为正在转码
            program.transcodeState = Program.STATE_RUNNING;
            HttpSession session = utilService.getSession();
            Consumer consumer = Consumer.get(session.consumer.id);
            if (consumer.role != Consumer.SUPER_ROLE) {
                if (params.useSpaceSize) {
                    consumer.useSpaceSize = params.useSpaceSize as long;
                    consumer.save(flush: true);
                }
            }
            if (program.save(flush: true)) {
                result.success = true;
                return result;
            } else {
                result.success = false;
                result.msg = "保存失败！！";
                return result;
            }

        }
    }


    public void fixTimeLength(Program program, ServletContext servletContext) {
        List<Serial> serialList = Serial.withCriteria {
            eq("timeLength", 0)
            eq("program", program)
            ne("urlType", Serial.URL_TYPE_IMAGE)
        };
        if (serialList.size() > 0) {
            String url = utilService.generalVideoServerUrl() + "play/queryFileLogicLength";
            HttpPost httpPost = new HttpPost(url);
            ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
            serialList.each {
                params.add(new BasicNameValuePair("hash", it.fileHash));
            }

            httpPost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
            HttpClient httpClient = HttpClients.createDefault();
            try {
                CloseableHttpResponse httpResponse = httpClient.execute(httpPost);
                String text = httpResponse.getEntity().getContent().getText("UTF-8");
                JSONElement result = JSON.parse(text);
                if (result.success) {
                    result.playList.each {
                        Serial.executeUpdate("update Serial set timeLength=? where fileHash=?", [it.timeLength, it.hash]);
                    }
                } else {
                    log.error(result.msg);
                }
            } catch (Exception e) {
                log.error(e.message, e);
                if (e.cause.message.equals("拒绝连接")) {
                    servletContext.isCon = "false";
                }
            }
        }

    }


    public Map saveProgram(Map params) {
        def result = [:];
        HttpSession session = utilService.getSession();

        Consumer consumer = Consumer.get(session.consumer.id);
        if (consumer) {
            String name = params.name;
            String classId = params.classLibId;
            String description = CTools.htmlToBlank(params.description);
            String categoryId = params.categoryId;
            def canPublic = params.canPublic;
            def factedValIds = [];
            if (params.factedValue) {
                if (params.factedValue instanceof String) {
                    factedValIds.add(params.factedValue);
                } else if (params.factedValue instanceof String[]) {
                    String[] values = params.factedValue;
                    for (String value : values) {
                        factedValIds.add(value);
                    }
                }
            }
            Program program = new Program();
            program.name = name;
            if (classId && classId != "") { //元数据标准可为空
                program.directory = Directory.get(classId as long);
                program.classLib = program?.directory;
            }

            program.consumer = consumer;
            program.description = description;
            if ("true".equals(canPublic)) {
                program.canPublic = true;
            }
            program.state = Program.APPLY_STATE;
            //如果当前上传用户是master，或者是资源管理员且拥有免审权限，上传资源资源状态直接设置为发布
            if (consumer.role == Consumer.SUPER_ROLE || (consumer.role == Consumer.MANAGER_ROLE && consumer.notExamine)) {
                program.state = Program.PUBLIC_STATE;
            }
            //获取分面
            factedValIds?.each {
                FactedValue value = FactedValue.get(it as long);
                if (value) {
                    program.addToFactedValues(value);
                }
            }
            //获得标签
            String programTag = params.programTag;
            if (programTag && (!StringUtils.isEmpty(programTag))) {
                String[] tags = programTag.split(";");
                def countMap = [:];

                tags.each { String tag ->
                    countMap.put(tag, 1);
                }
                countMap.keySet().each { String tag ->
                    if (StringUtils.isNotBlank(tag)) {
                        ProgramTag programTag1 = ProgramTag.findByName(tag);
                        if (programTag1) {
                            programTag1.frequency++;
                            program.addToProgramTags(programTag1);
                        } else {
                            program.addToProgramTags(new ProgramTag(name: tag, frequency: 0));
                        }
                    }
                }
            }


            ProgramCategory programCategory = null;
            if (categoryId != '') {
                String[] categoryIds = categoryId.split(",");
                categoryIds?.each {
                    programCategory = ProgramCategory.get(it as long);
                    program.addToProgramCategories(programCategory);
                }
                if (categoryIds && categoryIds.size() > 0) {
                    program.firstCategoryId = categoryIds[0] as long;
                }
            } else {
                programCategory = ProgramCategory.findByName("默认资源库");
//                if (!programCategory) {
//                    programCategory = ProgramCategory.findByName("默认资源库");
//                }
                program.addToProgramCategories(programCategory);
                program.firstCategoryId = programCategory.id;
            }



            String otherOption = params.get("otherOption");
            if (otherOption) {
                program.otherOption = Integer.parseInt(otherOption);
            }
//            if (programCategory.mediaType == 5) {
//                program.otherOption = Program.ONLY_LESSION_OPTION;
//            } else {
//                if (FileType.isVideo(fileName)) {
//                    program.otherOption = 0;
//                } else if (FileType.isDocument(fileName) || fileName.endsWith("pdf")) {
//                    program.otherOption = Program.ONLY_TXT_OPTION;
//                } else if (FileType.isImage(fileName)) {
//                    program.otherOption = Program.ONLY_IMG_OPTION;
//                }
//            }


            int fileCount = params.fileCount ? params.int("fileCount") : 0;
            int serialNum = 0;
            for (int i = 0; i < fileCount; i++) {
                if (params.get("fileName_" + i) && params.get("fileSavePath_" + i) && params.get("fileHash_" + i)) {
                    Serial serial = new Serial();
                    serial.name = params.get("fileName_" + i);
                    serial.filePath = params.get("fileSavePath_" + i);
                    serial.fileType = FileUtils.getFileSufix(serial.filePath);
                    serial.fileHash = params.get("fileHash_" + i);
                    serial.description = params.get("fileDesc_" + i);
                    serial.serialNo = (i + 1);
                    serial.dateCreated = new Date();
                    serial.dateModified = new Date();
                    serial.state = 1;
                    if (FileType.isVideo(serial.filePath)) {
                        serial.urlType = Serial.URL_TYPE_VIDEO;
                    } else if (FileType.isDocument(serial.filePath)) {
                        serial.urlType = Serial.URL_TYPE_DOCUMENT;
                    } else if (FileType.isImage(serial.filePath)) {
                        serial.urlType = Serial.URL_TYPE_IMAGE;
                    } else if (FileType.isAudio(serial.filePath)) {
                        serial.urlType = Serial.URL_TYPE_AUDIO;
                    } else {
                        serial.urlType = Serial.URL_TYPE_UNKNOWN;
                    }
                    serial.fileSize = params.get("fileSize_" + i) as long;
                    program.addToSerials(serial);
                    serialNum++;
                }
            }

            program.serialNum = serialNum; //设置文件个数

            // 设置海报
            def otherOption1 = Integer.parseInt(otherOption);
            ProgramCategory superProgramCategory = null;
            if (!(params.posterHash && params.posterPath && params.posterName)
                    || !(params.verticalPosterHash && params.verticalPosterPath && params.verticalPosterName)) {
                // 从资源库中取默认海报,如果有设值,没有则不设值
                superProgramCategory = programCategoryService.querySuperCategoryByCategory(programCategory);
            }

            if (params.posterHash && params.posterPath && params.posterName) {
                program.posterHash = params.posterHash;
                program.posterPath = params.posterPath;
                program.posterName = params.posterName;
                program.posterType = FileUtils.getFileSufix(params.posterPath);
            } else {
                if (superProgramCategory && superProgramCategory.defaultProgramPosterPath && superProgramCategory.defaultProgramPosterHash) {
                    program.posterHash = superProgramCategory.defaultProgramPosterHash;
                    program.posterPath = superProgramCategory.defaultProgramPosterPath;
                    program.posterType = FileUtils.getFileSufix(superProgramCategory.defaultProgramPosterPath);
                }
            }
            if (params.verticalPosterHash && params.verticalPosterPath && params.verticalPosterName) {
                program.verticalPosterHash = params.verticalPosterHash;
                program.verticalPosterPath = params.verticalPosterPath;
                program.verticalPosterName = params.verticalPosterName;
                program.verticalPosterType = FileUtils.getFileSufix(params.verticalPosterPath);
            } else {
                if (superProgramCategory && superProgramCategory.defaultProgramPosterPath && superProgramCategory.defaultProgramPosterHash) {
                    program.verticalPosterHash = superProgramCategory.defaultProgramPosterHash;
                    program.verticalPosterPath = superProgramCategory.defaultProgramPosterPath;
                    program.verticalPosterType = FileUtils.getFileSufix(superProgramCategory.defaultProgramPosterPath);
                }
            }

            // 设置推荐数
            if (params.recommendNum) {
                program.recommendNum = params.recommendNum as int;
            }

            if (program.save() && !program.hasErrors()) {
                consumer.uploadNum++;
                if (consumer.role != Consumer.SUPER_ROLE) {
                    if (params.useSpaceSize) {
                        consumer.useSpaceSize = params.useSpaceSize as Long;
                    }
                }

                consumer.save();
                result.success = true;
                result.id = program.id;
                result.msg = "资源上传成功,可以继续上传！"
                new OperationLog(tableName: 'program', tableId: program.id, operator: consumer.name, operatorIP: params.request.getRemoteAddr(),
                        modelName: '添加资源', brief: program.name, operatorId: consumer.id, operation: OperationEnum.ADD_PROGRAM).save()
            } else {
                result.success = false;
                result.msg = "资源上传失败"
            }
        } else {
            result.success = false;
            result.msg = "用户不存在"
        }
        return result;

    }

    public Map deleteProgram(Map params) {
        def result = [:];
        def programList = null

        def bAuthOK = true
        def isFromRecycler = false
        def delIdList = params.idList
        def operation = CTools.nullToBlank(params.operation)

        //如果只选中一条记录，其为字符串，collect 会分其为单个字符
        if (delIdList instanceof String)
            delIdList = [params.idList.toLong()]
        else
            delIdList = params.idList.collect { elem -> elem.toLong() }
        //查询条件
        programList = Program.createCriteria().list {

            //是删除选中操作

            'in'("id", delIdList)
        }

        HttpSession session = utilService.getSession();

        //为了安全一个一个删除
        programList?.each { program ->
            if (program) {
                //防止恶意用户恶意删除
                bAuthOK = (session.consumer.role <= Consumer.MANAGER_ROLE) || (program.state <= 0 && program.state >= -Program.APPLY_STATE && program.consumer.id == session.consumer.id)
                if (bAuthOK) {
                    //生成操作日志
                    new OperationLog(operation: OperationEnum.DELETE_PROGRAM, modelName: OperationEnum.cnType[OperationEnum.DELETE_PROGRAM.id], tableName: 'program', tableId: program.id, brief: program.name, operator: session.consumer.name, operatorId: session.consumer.id).save(flush: true)

                    //删除相关
                    program.relationPrograms.each { rProgram ->
                        program.removeFromRelationPrograms(rProgram)
                        rProgram.removeFromRelationPrograms(program)
                    }

                    //删除物理文件
                    deleteFiles(program)

                    //删除数据库中记录
                    program.delete()
                    result.success = true;
                } else {
                    result.success = false;
                    result.msg = "操作被禁止！"
                }
            } else {
                result.success = false;
                result.msg = "program not found with id"
            }
        }
        return result;
    }

    def deleteFiles(Program program) {
        ServletContext servletContext = utilService.getServletContext();
        if (servletContext.fileDelOpt == 1) {
            def filePath = ""
            def serial = null

            if (program && program.serials) {
                program.serials.toList().each {
                    filePath = it.filePath
                    //链接类型不删除
                    if (filePath.indexOf("://") == -1) {
                        serial = Serial.findByFilePathAndProgramNotEqual(filePath, program)
                        //如果没有其它资源引用此文件才删除
                        if (!serial) {
                            def file = new File(filePath)
                            if (file.exists()) {
                                boolean bOK = file.delete();
                            } else {
                                //println "file not exists:"+filePath
                            }
                        }
                    }
                }
            }
        }
    }


    public void setMyProgramState(Map params) {
        def bAuthOK = true    //是否认证通过
        List<String> idList = new ArrayList<String>();
        def applyState = CTools.nullToOne(params.applyState)
        def operation = CTools.nullToBlank(params.operation)
        def canDownload;
        def canPublic;
        def canPlay;
        if (params.className == "canPublic") {
            canPublic = params.isFlag;
        } else if (params.className == "canDownload") {
            canDownload = params.isFlag;
        } else if (params.className == "canPlay") {
            canPlay = params.isFlag;
        } else {
            canDownload = params.canDownload;
            canPublic = params.canPublic
            canPlay = params.canPlay;
        }
        if (params.idList.indexOf(',') != -1) {
            String[] str = params.idList.split(",");
            str.each {
                idList.add(it);
            }
        } else {
            idList.add(params.idList);
        }


        idList?.each { String id ->
            def program = Program.get(id as Long)
            //权限待调整,管理员才能审批发布
            if (program) {
                //bAuthOK = (applyState <= Program.APPLY_STATE && program.consumer.id == session.consumer.id) || (session.consumer.role <= Consumer.MANAGER_ROLE)

                //生成操作日志
                if (program.state == Program.APPLY_STATE && applyState == Program.PUBLIC_STATE) new OperationLog(operation: OperationEnum.APPROVAL_PROGRAM, tableName: 'program', tableId: program.id, brief: program.name, operator: session.consumer.name, operatorId: session.consumer.id).save()
                //资源允许下载
                if (canDownload == 'true') {
                    program.canDownload = false;
                }
                //资源禁止下载
                else if (canDownload == 'false') {
                    program.canDownload = true;
                }
                //资源点播
                else if (canPlay == 'true') {
                    program.canPlay = false;
                } else if (canPlay == 'false') {
                    program.canPlay = true;
                }
                //公开资源
                else if (canPublic == 'false') {
                    program.canPublic = true;
                } else if (canPublic == 'true') {
                    program.canPublic = false;
                }
                //还原
                else if (operation == "restore") {
                    program.state = Math.abs(program?.state)
                }
                //审批通过
                else if (operation == "pass") {
                    //只通过待审批状态的资源
                    if (program.state == Program.APPLY_STATE) program.state = Program.PUBLIC_STATE
                }
                //审批不通过(退回)
                else if (operation == "noPass") {
                    //只退回待审批状态的资源
                    if (program.state == Program.APPLY_STATE) program.state = Program.NO_PASS_STATE
                }
                //发布
                else if (operation == "public") {
                    //只发布关闭状态(不发布)的资源
                    if (program.state == Program.CLOSE_STATE) program.state = Program.PUBLIC_STATE
                }
                //取消发布
                else if (operation == "close") {
                    //只取消已发布的资源
                    if (program.state == Program.PUBLIC_STATE) program.state = Program.CLOSE_STATE
                }
                //申请入库
                else if (operation == "apply") {
                    //只申请尚未申请的资源
                    if (program.state < Program.APPLY_STATE) program.state = Program.APPLY_STATE
                }
                //没有操作参数，直接设置状态
                else {
                    program.state = applyState
                }

            } else {
                flash.message = "program not found with id ${id}"
            }
            program.save(flush: true);
        }

        params.idList = ""
    }
    /**
     * 本地web服务器配置
     */
    def localWebServerConfig() {
        def result = [:];
        ServletContext servletContext = utilService.getServletContext();
        def localWebPort = SysConfig.findByConfigName('LocalWebPort'); ;//本地web服务器端口
        def localWebIp = SysConfig.findByConfigName('LocalWebIp'); ;//本地web服务器端口
        def remarkAuthOpt = SysConfig.findByConfigName('RemarkAuthOpt');        //评论是否审核
        def playLogOpt = SysConfig.findByConfigName('PlayLogOpt');        //点播日志选项
        def viewLogOpt = SysConfig.findByConfigName('ViewLogOpt');        //浏览日志选项
        def fileDelOpt = SysConfig.findByConfigName('FileDelOpt');        //删除媒体文件选项设置  0不删除 1删除，默认不删除
        def rmsversion = SysConfig.findByConfigName("rmsversion");
        def theme = SysConfig.findByConfigName("theme");
        def fileSizeLimit = SysConfig.findByConfigName('fileSizeLimit'); //上传文件最大容量配置
        def seniorSearchOpt = SysConfig.findByConfigName('SeniorSearchOpt'); //高级搜索启用配置
        //----------------------------- 读取属性文件，显示项目名称和页脚 -----------------
        def applicationName = ""
        def applicationBottom = ""

        def classPath
        def beautiful
        Properties properties = new Properties()
        try {
            File file = new File(SystemConfig.webRootDir, "WEB-INF/grails-app/i18n/messages_zh_CN.properties");
            InputStream is = new FileInputStream(file)

            properties.load(is)
            is.close()
        } catch (java.io.FileNotFoundException e) {
            File file = new File(SystemConfig.webRootDir, "../grails-app/i18n/messages_zh_CN.properties");
            InputStream is = new FileInputStream(file)

            properties.load(is)
            is.close()
        }

        applicationName = properties.getProperty("application.name")
        applicationBottom = properties.getProperty("application.bottom")

        if (true) {
            applicationBottom = applicationBottom.replaceAll("<p>", "")
            applicationBottom = applicationBottom.replaceAll("</p>", "")
        }
        File skinDir = new File(SystemConfig.webRootDir, "skin");
        result = [skins        : skinDir.listFiles(), theme: theme?.configValue, rmsversion: rmsversion?.configValue, applicationName: applicationName, applicationBottom: applicationBottom, localWebPort: localWebPort, localWebIp: localWebIp,
                  remarkAuthOpt: remarkAuthOpt, playLogOpt: playLogOpt, viewLogOpt: viewLogOpt, fileDelOpt: fileDelOpt, fileSizeLimit: fileSizeLimit, seniorSearchOpt: seniorSearchOpt]
        return result;
    }
    /**
     * 本地web服务器配置Set
     */
    void localWebServerConfigSet(Map params) {
        ServletContext servletContext = utilService.getServletContext();
        def LocalWebPort = SysConfig.findByConfigName('LocalWebPort');    //省中心web服务器端口
        def LocalWebIp = SysConfig.findByConfigName('LocalWebIp'); ;//本地web服务器端口
        def remarkAuthOpt = SysConfig.findByConfigName('RemarkAuthOpt');        //缺省播放格式
        def playLogOpt = SysConfig.findByConfigName('PlayLogOpt');        //点播日志选项
        def viewLogOpt = SysConfig.findByConfigName('ViewLogOpt');        //浏览日志选项

        def fileDelOpt = SysConfig.findByConfigName('FileDelOpt');        //删除媒体文件选项设置  0不删除 1删除，默认不删除
        def rmsversion = SysConfig.findByConfigName("rmsversion");
        def theme = SysConfig.findByConfigName("theme");
        def fileSizeLimit = SysConfig.findByConfigName('fileSizeLimit');
        def seniorSearchOpt = SysConfig.findByConfigName('SeniorSearchOpt'); //高级搜索启用配置

        // ------------------------------- 修改项目名称和页脚 -------------------------------
        def filePath
        Properties properties = new Properties()
        try {
            filePath = servletContext.getRealPath("") + "/WEB-INF/grails-app/i18n/messages_zh_CN.properties"
            InputStream is = new FileInputStream(filePath)

            properties.load(is)
            is.close()
        } catch (FileNotFoundException e) {
            filePath = servletContext.getRealPath("") + "/../grails-app/i18n/messages_zh_CN.properties"
            InputStream is = new FileInputStream(filePath)

            properties.load(is)
            is.close()
        }
        try {
            if (params.applicationName) params.applicationName = params.applicationName.trim()
            if (params.applicationBottom) params.applicationBottom = params.applicationBottom.trim()

            def an = properties.getProperty("application.name")
            def ab = properties.getProperty("application.bottom")

            //if(ab.contains("<p>") || ab.contains("</p>")){
            // ab = ab.replaceAll("<p>", "")
            //ab = ab.replaceAll("</p>", "")
            //}

            if ((params.applicationName && params.applicationName != an) || (params.applicationBottom && params.applicationBottom != ab)) {

                if (params.applicationName && params.applicationName != an) {
                    properties.setProperty("application.name", params.applicationName)
                }
                if (params.applicationBottom && params.applicationBottom != ab) {
                    properties.setProperty("application.bottom", params.applicationBottom)
                }

                File file = new File(filePath)

                OutputStream fos = new FileOutputStream(file.absolutePath);
                properties.store(fos, "")
                fos.close()
            }
        } catch (Exception e) {
            e.printStackTrace()
        }

        // ------------------------------- 修改项目名称和页脚 结束 -------------------------------

        if (!LocalWebPort) {
            new SysConfig(configName: 'LocalWebPort', configValue: params.LocalWebPort, configDesc: '本地web服务器端口', configScope: 0, configMod: 0).save()
        } else {
            LocalWebPort.configValue = params.LocalWebPort
        }
        if (!LocalWebIp) {
            new SysConfig(configName: 'LocalWebIp', configValue: params.LocalWebIp, configDesc: '本地web服务器IP', configScope: 0, configMod: 0).save()
        } else {
            LocalWebIp.configValue = params.LocalWebIp
        }

        //-----------关键帧设置2012/8/20-----------
        if (!remarkAuthOpt) {
            new SysConfig(configName: 'RemarkAuthOpt', configValue: params.remarkAuthOpt, configDesc: '评论是否审核', configScope: 0, configMod: 0).save()
        } else {
            remarkAuthOpt.configValue = params.remarkAuthOpt
        }

        if (!playLogOpt) {
            new SysConfig(configName: 'PlayLogOpt', configValue: params.playLogOpt, configDesc: '点播日志是否记录', configScope: 0, configMod: 0).save()
        } else {
            playLogOpt.configValue = params.playLogOpt
        }

        if (!viewLogOpt) {
            new SysConfig(configName: 'ViewLogOpt', configValue: params.viewLogOpt, configDesc: '浏览日志是否记录', configScope: 0, configMod: 0).save()
        } else {
            viewLogOpt.configValue = params.viewLogOpt
        }

        if (!fileDelOpt) {
            new SysConfig(configName: 'FileDelOpt', configValue: params.fileDelOpt, configDesc: '删除媒体文件选项设置', configScope: 0, configMod: 0).save()
        } else {
            fileDelOpt.configValue = params.fileDelOpt
        }

        if (!rmsversion) {
            new SysConfig(configName: 'rmsversion', configValue: params.rmsversion, configDesc: '系统版本号', configScope: 0, configMod: 0).save()
        } else {
            rmsversion.configValue = params.rmsversion;
            rmsversion.save();
        }

        if (!theme) {
            new SysConfig(configName: 'theme', configValue: params.theme, configDesc: '系统主题', configScope: 0, configMod: 0).save()
        } else {
            theme.configValue = params.theme;
            theme.save();
        }

        if (!fileSizeLimit) {
            new SysConfig(configName: 'fileSizeLimit', configValue: params.fileSizeLimit, configDesc: '上传文件最大容量配置', configScope: 0, configMod: 0).save()
        } else {
            fileSizeLimit.configValue = params.fileSizeLimit
        }

        if (!seniorSearchOpt) {
            new SysConfig(configName: 'SeniorSearchOpt', configValue: params.seniorSearchOpt, configDesc: '高级搜索是否启用', configScope: 0, configMod: 0).save()
        } else {
            seniorSearchOpt.configValue = params.seniorSearchOpt;
            seniorSearchOpt.save();
        }

        // 上传文件最大容量配置
        servletContext.fileSizeLimit = params.fileSizeLimit ? params.fileSizeLimit : 0;
        //更新配置类
        BfConfig.setFileSizeLimit(params.fileSizeLimit ? params.fileSizeLimit : '0');

        //更新全局变量
        servletContext.localWebPort = CTools.nullToBlank(params.LocalWebPort)            //本地web服务器端口
        servletContext.LocalWebIp = CTools.nullToBlank(params.LocalWebIp)            //本地web服务器端口
        servletContext.remarkAuthOpt = CTools.nullToZero(params.remarkAuthOpt)        //评论是否审核
        servletContext.playLogOpt = CTools.nullToZero(params.playLogOpt)        //点播日志选项
        servletContext.viewLogOpt = CTools.nullToZero(params.viewLogOpt)        //浏览日志选项
        servletContext.fileDelOpt = CTools.nullToZero(params.fileDelOpt)        //删除媒体文件选项设置
        servletContext.theme = CTools.nullToZero(params.theme)
        // 高级搜索设置
        SystemConfig.setConfig("search.enable", params.seniorSearchOpt);
        servletContext.searchEnable = Boolean.parseBoolean(params.seniorSearchOpt);
        if (servletContext.searchEnable) {
            def solrProgramUrl = SysConfig.findByConfigName('SolrProgramUrl');
            def solrSerialUrl = SysConfig.findByConfigName("SolrSerialUrl");
            def cronExpression = SysConfig.findByConfigName("CronExpression");
            servletContext.solrProgramUrl = solrProgramUrl ? solrProgramUrl.configValue : "http://127.0.0.1:8080/mysolr/dev_program";
            servletContext.solrSerialUrl = solrSerialUrl ? solrSerialUrl.configValue : "http://127.0.0.1:8080/mysolr/dev_serial";
            servletContext.cronExpression = cronExpression ? cronExpression.configValue : "0 0 0 * * ?";
            SystemConfig.setConfig("search.cronExpression", servletContext.cronExpression);
        }
        ////更新配置类
        BfConfig.setLocalWebPort(params.LocalWebPort)

        //本地WEB服务器设置完成后初始化并且把IP、PORT保存到serverNode中
        appService.initAppService();
        serverNodeService.saveServerNode(params.LocalWebIp, params.LocalWebPort as int);
    }
    /**
     * 文件服务器配置
     */
    Map fileServerConfig() {
        def result = [:];
        def VideoSevr = SysConfig.findByConfigName('VideoSevr');                //视频服务器IP地址
        def videoPort = SysConfig.findByConfigName("videoPort");    //视频服务端口
        def uploadPort = SysConfig.findByConfigName("uploadPort"); //上传服务端口
        def serverNodePort = SysConfig.findByConfigName("serverNodePort");//分发收割端口
        result = [VideoSevr: VideoSevr, videoPort: videoPort, uploadPort: uploadPort, serverNodePort: serverNodePort];
        return result;
    }
    /**
     * 文件服务器配置Set
     */
    void fileServerConfigSet(Map params) {
        ServletContext servletContext = utilService.getServletContext();
        def VideoSevr = SysConfig.findByConfigName('VideoSevr');                //视频服务器IP地址
        def videoPort = SysConfig.findByConfigName("videoPort");    //视频服务端口
        def uploadPort = SysConfig.findByConfigName("uploadPort"); //上传服务端口
        def serverNodePort = SysConfig.findByConfigName("serverNodePort");//分发收割端口
        if (!VideoSevr) {
            new SysConfig(configName: 'VideoSevr', configValue: params.VideoSevr, configDesc: '视频服务器IP地址', configScope: 0, configMod: 0).save()
        } else {
            VideoSevr.configValue = params.VideoSevr
        }
        if (!videoPort) {
            new SysConfig(configName: 'videoPort', configValue: params.videoPort, configDesc: '视频服务端口', configScope: 0, configMod: 0).save()
        } else {
            videoPort.configValue = params.videoPort;
        }
        if (!uploadPort) {
            new SysConfig(configName: 'uploadPort', configValue: params.uploadPort, configDesc: '上传服务端口', configScope: 0, configMod: 0).save()
        } else {
            uploadPort.configValue = params.uploadPort;
        }
        if (!serverNodePort) {
            new SysConfig(configName: 'serverNodePort', configValue: params.serverNodePort, configDesc: '分发收割端口', configScope: 0, configMod: 0).save()
        } else {
            serverNodePort.configValue = params.serverNodePort;
        }
        servletContext.videoSevr = CTools.nullToBlank(params.VideoSevr)                //视频服务器IP地址
        servletContext.videoPort = params.videoPort ? params.videoPort : 1680;
        servletContext.uploadPort = params.uploadPort ? params.uploadPort : 1670;
        servletContext.serverNodePort = params.serverNodePort ? params.serverNodePort : 1681;
        //更新配置类
        BfConfig.setVideoSevr(params.VideoSevr);
    }

    /**
     * 上传文件最大容量配置
     */
    Map fileSizeLimitConfig() {
        def result = [:];
        def fileSizeLimit = SysConfig.findByConfigName('fileSizeLimit');                //上传文件最大容量配置
        result = [fileSizeLimit: fileSizeLimit];
        return result;
    }
    /**
     * 上传文件最大容量配置Set
     */
    void fileSizeLimitConfigSet(Map params) {
        ServletContext servletContext = utilService.getServletContext();
        def fileSizeLimit = SysConfig.findByConfigName('fileSizeLimit');                //上传文件最大容量配置

        if (!fileSizeLimit) {
            new SysConfig(configName: 'fileSizeLimit', configValue: params.fileSizeLimit, configDesc: '上传文件最大容量配置', configScope: 0, configMod: 0).save()
        } else {
            fileSizeLimit.configValue = params.fileSizeLimit
        }
        // 上传文件最大容量配置
        servletContext.fileSizeLimit = params.fileSizeLimit ? params.fileSizeLimit : 0;
        //更新配置类
        BfConfig.setFileSizeLimit(params.fileSizeLimit ? params.fileSizeLimit : '0');
    }

    /**
     * 记录文档查看，视频播放位置
     * @param params
     */
    public void recoderPosition(Map params) {
        PlayedProgram playedProgram = params.playedProgram;
        Program program = params.program;
        if (!playedProgram.isDirty("timeLength")) {
            try {
                playedProgram.save(flush: true);
            } catch (Exception ignored) {

            }
        }
        program.save(flush: true);
    }

    /**
     * 验证用户是否有点播资源权限
     * @param consumer
     * @param program
     * @return
     */
    public boolean canPlay(Consumer consumer, Program program) {
        boolean canPlay = false

        // 超级管理员和资源管理员无视资源的点播设置
        if (consumer.role == Consumer.SUPER_ROLE || consumer.role == Consumer.MANAGER_ROLE) {
            return true;
        }

        if (consumer == null) return canPlay

        def consumer2 = Consumer.get(consumer.id)

        if (consumer2 == null || program == null || program.state < Program.PUBLIC_STATE) return canPlay

        //如果资源canPlay为true再继续判断其他，否则不能点播
        if (program.canPlay) {
            //如果资源canAllPlay为true则允许点播，否则继续判断其它
            if (program.canAllPlay) {
                canPlay = userCanPlay(consumer2, program, true);
                return canPlay;
            } else { //禁止所有用户组点播
                canPlay = userCanPlay(consumer2, program, false);
                return canPlay;
            }
        } else {
            return canPlay
        }
        return canPlay
    }

    /**
     * 判断用户是否是点播权限
     * @param consumer
     * @param program
     * @param canAllPlay
     * @return
     */
    private boolean userCanPlay(Consumer consumer, Program program, boolean canAllPlay) {
        boolean canPlay = false;
        //如果用户的状态是激活，则继续判断其它，否则不能点播
        if (consumer.userState) {
            //如果用户的canPlay为true，则继续判断其它，否则不能点播
            if (consumer.canPlay) {
                if (consumer.role == Consumer.SUPER_ROLE || consumer.name == 'anonymity') {
                    canPlay = true
                    return canPlay
                } else {
                    //如果用户为活动状态并且允许点播并且所在用户组数大于0则继续判断其他，否则不允许点播
                    if (consumer.userGroups.size() > 0) {
                        //判断资源是否在用户所在组的所有可点播资源的交集里
                        def userGroups = consumer.userGroups
                        def programList = []
                        if (userGroups.size() > 1) {
                            def num = 0
                            userGroups.each { userGroup ->
                                def playPrograms = Program.createCriteria().list {
                                    playGroups {
                                        eq("id", userGroup.id)
                                    }
                                }
                                if (playPrograms?.size() > 0) {
                                    if (num == 0) {
                                        programList = playPrograms
                                    } else {
                                        if (canAllPlay) { //允许所有用户组点播
                                            programList = programList.intersect(playPrograms) //取交集
                                        } else { //禁止所有用户组点播
                                            programList = programList.plus(playPrograms) //取和
                                            programList.unique(); //去重
                                        }
                                    }
                                    num++
                                }
                            }
                        } else if (userGroups.size() == 1) {
                            def playPrograms = Program.createCriteria().list {
                                playGroups {
                                    eq("id", userGroups[0].id)
                                }
                            }
                            programList = playPrograms
                        } else {
                            canPlay = true; //如果是普通用户,但没有加入用户组的;用户有点播权限的话,也可以点播
                            return canPlay
                        }

                        if (programList.contains(program)) {
                            if (canAllPlay) { //允许所有用户组点播
                                canPlay = true //用户所在的用户组必须都含有此资源
                            } else { //禁止所有用户组点播
                                canPlay = false; //只要有一个组可点播资源列表含有此资源,则用户不能点播
                            }
                            return canPlay
                        } else {
                            canPlay = false
                            return canPlay
                        }
                    } else {
                        canPlay = true; //如果是普通用户,但没有加入用户组的;用户有点播权限的话,也可以点播
                        return canPlay
                    }
                }
            } else {
                return canPlay
            }
        } else {
            return canPlay
        }
        return canPlay
    }

    /**
     * 用户是否能下载
     * @param consumer
     * @param program
     * @param canAllDownload
     * @return
     */
    private boolean userCanDownload(Consumer consumer, Program program, boolean canAllDownload) {
        boolean canDownload = false;
        if (consumer.userState) {
            if (consumer.canDownload) {
                if (consumer.role == Consumer.SUPER_ROLE || consumer.name == 'anonymity') {
                    canDownload = true
                    return canDownload
                } else {
                    if (consumer.userGroups.size() > 0) {
                        //判断资源是否在用户所在组的所有可点播资源的交集里
                        def userGroups = consumer.userGroups
                        def programList = []
                        if (userGroups.size() > 1) {
                            def num = 0
                            userGroups.each { userGroup ->
                                def downloadPrograms = Program.createCriteria().list {
                                    downloadGroups {
                                        eq("id", userGroup.id)
                                    }
                                }
                                if (downloadPrograms?.size() > 0) {
                                    if (num == 0) {
                                        programList = downloadPrograms
                                    } else {
                                        if (canAllDownload) { //允许所有用户组下载
                                            programList = programList.intersect(downloadPrograms) //取交集
                                        } else { //禁止所有用户组下载
                                            programList = programList.plus(downloadPrograms) //取和
                                            programList.unique(); //去重
                                        }
                                    }
                                    num++
                                }
                            }
                        } else if (userGroups.size() == 1) {
                            def downloadPrograms = Program.createCriteria().list {
                                downloadGroups {
                                    eq("id", userGroups[0].id)
                                }
                            }
                            programList = downloadPrograms
                        } else {
                            canDownload = true; //如果是普通用户,但没有加入用户组的;用户有下载权限的话,也可以下载
                            return canDownload
                        }

                        if (programList.contains(program)) {
                            if (canAllDownload) { //允许所有用户组下载
                                canDownload = true //用户所在的用户组必须都含有此资源
                            } else { //禁止所有用户组下载
                                canDownload = false; //只要有一个组可下载资源列表含有此资源,则用户不能下载
                            }
                            return canDownload
                        } else {
                            canDownload = false
                            return canDownload
                        }
                    } else {
                        canDownload = true; //如果是普通用户,但没有加入用户组的;用户有下载权限的话,也可以下载
                        return canDownload
                    }
                }
            } else {
                return canDownload;
            }
        } else {
            return canDownload;
        }
        return canDownload;
    }

    /**
     * 验证用户是否有下载资源权限
     * @param consumer
     * @param program
     * @return
     */
    public boolean canDownload(Consumer consumer, Program program) {
        def canDownload = false

        def consumer2 = Consumer.get(consumer.id)

        if (consumer2 == null || program == null || consumer2.name == 'anonymity') return canDownload

        if (program.canDownload) {
            if (program.canAllDownload) {
                canDownload = userCanDownload(consumer2, program, true);
                return canDownload;
            } else {
                // 判断用户是否有权限下载
                canDownload = userCanDownload(consumer2, program, false);
            }
        } else {
            return canDownload;
        }
        return canDownload
    }

    public Map listMetaDefinePrograms(params) {
        def result = [:]

        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "id";

        if (!params.id) return result

        def programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
            def metaDefine = MetaDefine.get(params.id as Long)
            if (metaDefine) {
                metaContents {
                    eq('metaDefine', metaDefine)
                    if (params.enumId != '0') eq('numContent', params.enumId as Integer)
                }
            }
        }

        if (programList.size() > 0) {
            def total = programList.totalCount;
            result.page = page;
            //总记录数
            result.records = total;
            //总页数
            result.total = Math.ceil(total * 1.00 / params.max);
            result.rows = [];
            programList.each {
                def tmp = [:];
                tmp.id = it.id;
                tmp.name = it.name;
                tmp.directoryName = it?.directory?.name;
                tmp.consumer = it.consumer.name;
                tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
                tmp.recommendNum = it.recommendNum;
                tmp.collectNum = it.collectNum;
                tmp.frequency = it.frequency;
                tmp.state = Program.cnState.get(it.state);
                tmp.canPublic = it.canPublic;
                result.rows.add(tmp);
            }
        }

        return result
    }

    public String stringFileSize(Long fileSize) {
        String fileStr = "";
        if (fileSize < 1024) {
            fileStr = fileSize.toString();
            return fixFloatNum(fileStr, 2) + "B";
        } else if ((fileSize >= 1024) && (fileSize < 1024 * 1024)) {
            fileStr = (fileSize / (1024)).toString();
            return fixFloatNum(fileStr, 2) + "KB";
        } else if ((fileSize >= 1024 * 1024) && (fileSize < 1024 * 1024 * 1024)) {
            fileStr = (fileSize / (1024 * 1024)).toString();
            return fixFloatNum(fileStr, 2) + "MB";
        } else if ((fileSize >= 1024L * 1024L * 1024L) && (fileSize < 1024L * 1024L * 1024L * 1024L)) {
            fileStr = (fileSize / (1024L * 1024L * 1024L)).toString();
            return fixFloatNum(fileStr, 2) + "GB";
        } else {
            fileStr = fileSize.toString();
            return fixFloatNum(fileStr, 2) + "B";
        }


    }

    public String fixFloatNum(String num, int size) {
        if (size == null) {
            size = 2;
        }
        String numStr = num;
        int index = numStr.indexOf(".");
        if (index != -1) {
            index = (index + size) > (numStr.length() - 1) ? (numStr.length() - 1) : (index + size);
            return numStr.substring(0, index);
        } else {
            return num;
        }
    }
    /**
     * 获取最新10条Audio资源
     * @return
     */
    public List<Program> newTop10() throws Exception {
        def newProgramList = search([otherOption: Program.ONLY_AUDIO_OPTION, offset: 0, max: 10, orderBy: "dateCreated", order: "desc"], false);

        return newProgramList;
    }
    /**
     * 获取音频资源2级目录
     * @return
     */
    public List<ProgramCategory> audioTypeList() {
        def audioList = [];
        ProgramCategory category = ProgramCategory.findByMediaType(2);
        if (category) {
            audioList = ProgramCategory.withCriteria {
                eq("parentCategory", category)
            }
        }

        return audioList;
    }
    /**
     * 获取音频资源2级目录top10
     * @return
     */
    public List<ProgramCategory> audioTypeListTop10() {
        def audioList = [];
        ProgramCategory category = programCategoryService.queryAudioCategory();
        if (category) {
            audioList = ProgramCategory.withCriteria {
                eq("parentCategory", category)
                maxResults(10)
            }
        }

        return audioList;
    }
    /**
     * 根据类型获取资源
     * @param programCategory
     * @return
     */
    public List<Program> programByAudioType(ProgramCategory programCategory) {
        def audioList = search([programCategoryId: programCategory, max: 8, offset: 0], false)
        return audioList;
    }
    /**
     * 获取分类资源
     * @return
     */
    public Map<String, List<Program>> programByAudioTypeList() {
        def audioList = [:]
        def audioTypeList = audioTypeList();
        audioTypeList.each {
            audioList.put(it.name, programByAudioType(it));
        }
        return audioList;
    }
    /**
     * 前10热门资源
     * @return List < Program >
     */
    public List<Program> audioHot10() {
        ProgramCategory audioSuperCategory = programCategoryService.queryAudioCategory();
        def audioList = search([programCategoryId: audioSuperCategory.id, otherOption: Program.ONLY_AUDIO_OPTION, orderBy: "frequency", order: "desc", offset: 0, max: 10], false)
        return audioList;
    }
    /**
     * 获取前四的热门资源
     * @return
     */
    public List<Program> audioHot4() {
        ProgramCategory audioSuperCategory = programCategoryService.queryAudioCategory();
        List<Program> audioList = search([programCategoryId: audioSuperCategory.id, otherOption: Program.ONLY_AUDIO_OPTION, orderBy: "frequency", order: "desc", offset: 0, max: 4], false)
        return audioList;
    }

    public int audioSum() {
        return Program.countByOtherOption(Program.ONLY_AUDIO_OPTION);
    }
    /**
     * 推荐前十资源
     * @return List < Program >
     */
    public List<Program> recommendNumTop10() {
        def newProgramList = [];
        ProgramCategory audioSuperCategory = programCategoryService.queryAudioCategory();
        def audioList = search([programCategoryId: audioSuperCategory.id, otherOption: Program.ONLY_AUDIO_OPTION, orderBy: "recommendNum", order: "desc", offset: 0, max: 10], false)
        return audioList;
    }
    /**
     * 获取前十热门标签
     * @return
     */
    public List<ProgramTag> programTagsHot10() {
        def audioList = [];
        // 按分类查询出符合条件的program
        def categoryIds = ProgramCategory.createCriteria().list() {
            projections {
                distinct('id')
            }
            eq('mediaType', 2)
        };
        List states = new ArrayList();
        states.add(Program.STATE_SUCCESS);
        states.add(Program.STATE_SUCCESS_PART);
        if (categoryIds && categoryIds.size() > 0) {
            def programIds = Program.createCriteria().list() {
                projections {
                    distinct('id')
                }
                programCategories {
                    'in'('id', categoryIds.toArray())
                }
                'in'("transcodeState", states.toArray())
            };

            audioList = ProgramTag.withCriteria {
                programs {
                    inList('id', programIds)
                }
                maxResults(10)
            }
        }

        return audioList;
    }
    /**
     * 获取专辑资源
     * @return Set < Serial >
     */
    public Set<Serial> programIn(def id) {
        return Program.get(id).serials;
    }
    /**
     * 增加资源评论
     * @param programId
     * @param consumer
     * @param text
     */
    public Remark addEvaluate(def programId, Consumer consumer, def text, int rank) throws Exception {
        Remark remark = new Remark();
        remark.topic = " 影视主题猜猜猜";
        remark.content = text;
        Program program = Program.get(programId);
        remark.program = program;
        remark.dateModified = new Date();
        remark.consumer = consumer;
        List<Remark> remarkList = Remark.findAllByConsumerAndProgram(consumer, program);
        List<Integer> scoreList = [];
        remarkList?.each {
            if (it.rank > 0) {
                scoreList.add(it.rank);
            }
        }
        if (scoreList.size() == 0) {
            remark.rank = rank;
        }
        remark.save(flash: true);
        ServletContext servletContext = utilService.getServletContext();
        remark.isPass = servletContext.remarkAuthOpt == 0 ? true : false;
        program.addToRemarks(remark);
        List<Remark> remarkList2 = Remark.findAllByProgram(program);
        if (remarkList2 && remarkList2.size() > 0) {
            program.remarkNum = remarkList2.size();
        }
        program.save(flash: true);
        saveProgramScore(program.id);
        return remark;
    }
    /**
     * 获取资源评论列表
     * @param pid
     * @return
     */
    public List<Remark> evaluateList(def pid) {
        def list = Remark.withCriteria {
            eq('program', Program.get(pid))
            eq('isPass', true)
            order("dateCreated", "desc")
            maxResults(10);
        }
        //return Program.get(pid).remarks.toList();
        return list;
    }
    //增加回复
    public RemarkReply addReply(def remarkId, def text, Consumer consumer) throws Exception {
        Remark remark = Remark.get(remarkId);
        RemarkReply reply = new RemarkReply();
        reply.consumer = consumer;
        reply.content = text;
        reply.dateCreated = new Date();
        reply.remark = remark;
        if (reply.save(flush: true) && (!reply.hasErrors())) {
            remark.replyNum = remark.replyNum + 1;
            remark.addToRemarkReplys(reply);
        }
        return reply;
    }

    //删除评论
    public Map remarkDelete(Map params) {
        def result = [:]
        def remark = Remark.get(params.remarkID as Long)
        if (remark) {
            remark.delete()
            result.success = true
            result.msg = '删除评论成功'
        } else {
            result.success = false
            result.msg = '参数错误'
        }
        return result
    }

    /**
     * 获取视频资源2级目录
     * @return 2级资源list
     */
    public List<ProgramCategory> videoTypeList() {
        def videoList = [];
        ProgramCategory category = ProgramCategory.findByMediaType(1);
        if (category) {
            videoList = ProgramCategory.withCriteria {
                eq("parentCategory", category)
            }
        }

        return videoList;
    }

    /**
     * 获取文档资源2级目录
     * @return 2级资源list
     */
    public List<ProgramCategory> docTypeList() {
        def docList = [];
        ProgramCategory category = ProgramCategory.findByMediaType(3);
        if (category) {
            docList = ProgramCategory.withCriteria {
                eq("parentCategory", category)
            }
        }

        return docList;
    }

    /**
     * 获取图片资源2级目录
     * @return 2级资源list
     */
    public List<ProgramCategory> photoTypeList() {
        def photoList = [];
        ProgramCategory category = ProgramCategory.findByMediaType(4);
        if (category) {
            photoList = ProgramCategory.withCriteria {
                eq("parentCategory", category)
            }
        }

        return photoList;
    }

    /**
     * 同步海报图片
     * @param program 资源Domain
     */
    private String syncPosterImg(Program program) {
        if (appService) {
            RMSNode rmsNode = appService.queryNodeInfo();

            try {
                ServletContext servletContext = utilService.getServletContext();
                // Web服务器存放海报位置
                String imgPath = servletContext.getRealPath("") + "/images/poster"
                // 海报名称
                String imgName = "program_" + program.id + ".png"
                String verticalImgName = "program_v_" + program.id + ".png"
                String url;
                String verticalUrl;
                // 获取生成海报的链接
                if (program.posterPath && program.posterType && program.posterHash) {
                    url = generalFilePoster(program.posterHash, "", -1);
                    verticalUrl = generalFilePoster(program.verticalPosterHash, "", -1);
                } else {
                    url = generalProgramPoster(program, "", -1);
                    verticalUrl = generalProgramPoster(program, "", -1);
                }
                // 获取生成的海报URL
                String imgUrl = new URL(url).openConnection().getInputStream().getText("UTF-8");
                String verticalImgUrl = new URL(verticalUrl).openConnection().getInputStream().getText("UTF-8");
                try {
                    // 获取海报文件流
                    InputStream input = new URL(imgUrl).openConnection().getInputStream();
                    InputStream verticalInput = new URL(verticalImgUrl).openConnection().getInputStream();
                    // 保存海报
                    FileUtils.copyFile(input, new File(imgPath, imgName))
                    FileUtils.copyFile(verticalInput, new File(imgPath, verticalImgName))
                    // 更新资源表中的海报名称
                    program.posterName = imgName;
                    program.verticalPosterName = verticalImgName;
                } catch (Exception e) {
                    program.posterName = "boful_default_img.png";
                    program.verticalPosterName = "boful_default_img.png";
                }
            } catch (Exception e) {
                log.error(e.message, e);
            }
        }
    }

    /**
     * 查询分类下的所有资源
     * @param categoryList
     * @return
     */
    public Map queryProgramByCategory(List<ProgramCategory> categoryList, ProgramCategory parentCategory) {
        Set<ProgramCategory> categorySet = new HashSet<ProgramCategory>();
        def categoryIds = [];
        categoryList.each {
            categoryIds.add(it.id);
            categorySet.add(it);
        }
        List<ProgramCategory> categories = categorySet.asList();

        def result = [:];
        List<Program> programList = new ArrayList<Program>();
        def programTotal = 0;

        // 按分类查询出符合条件的program
        def programIds = [];
        List states = new ArrayList();
        states.add(Program.STATE_SUCCESS);
        states.add(Program.STATE_SUCCESS_PART);
        if (categoryIds.size() > 0) {
            programIds = Program.createCriteria().list() {
                projections {
                    distinct('id')
                }
                programCategories {
                    'in'("id", categoryIds.toArray())
                }
            }
        }
        if (categoryIds.size() > 0 && programIds.size() == 0) {
            programList = [];
            programTotal = 0;
        } else {
            programList = Program.createCriteria().list(max: 12, order: "desc", sort: "dateCreated") {
                eq('state', Program.PUBLIC_STATE)
                'in'('transcodeState', states.toArray())
                if (userService.judeAnonymity()) {
                    eq('canPublic', true)
                }
                if (programIds && programIds.size() > 0) {
                    'in'('id', programIds.toArray())
                }
//            if(parentCategory.mediaType==1){
//                eq("otherOption", Program.ONLY_VIDEO_OPTION)
//            }else if(parentCategory.mediaType == 2){ //音频
//                eq("otherOption", Program.ONLY_AUDIO_OPTION)
//            }else if(parentCategory.mediaType == 3){ //文档
//                eq("otherOption", Program.ONLY_TXT_OPTION)
//            }else if(parentCategory.mediaType == 4){ //图片
//                eq("otherOption", Program.ONLY_IMG_OPTION)
//            }else if(parentCategory.mediaType == 5){ //课程
//                eq("otherOption", Program.ONLY_LESSION_OPTION)
//            }
            }
            programTotal = programList.totalCount;
        }
        result.programList = programList;
        result.programTotal = programTotal;
        return result;
    }

    /**
     * 获取资源的第一个子资源
     * @param program
     * @return
     */
    public Serial serialFirst(Program program) {
        List<Serial> serialList = program.serials.toList();
        List<Serial> serialList2 = new ArrayList<Serial>();
        def serial = null;
        if (serialList && serialList.size() > 0) {
            for (Serial serial3 : serialList) {
                if (serial3.state == Serial.NO_NEED_STATE || serial3.state == Serial.CODED_STATE) {
                    serialList2.add(serial3);
                }
            }
            if (serialList2.size() > 1) {
                serialList2.sort {
                    serial1, serial2 ->
                        serial1.serialNo <=> serial2.serialNo
                }
                serial = serialList2.get(0);
            } else if (serialList2.size() == 1) {
                serial = serialList2.get(0);
            }
        }
        return serial;
    }

    //上传图片
    private Map uploadImg(def opt, def updateId) {
        def result = [:];
        result.success = true;
        def request = utilService.getRequest();
        def servletContext = utilService.getServletContext();
        def imgFile = request.getFile(opt + "Img")
        def imgType = imgFile.getContentType()

        def path = servletContext.getRealPath("/upload");

        def imgPath = ""

        if (imgFile && !imgFile.isEmpty()) {
            if (imgType == "image/pjpeg" || imgType == "image/jpeg" || imgType == "image/png" || imgType == "image/x-png" || imgType == "image/gif") {
                if (opt == "save" || opt == "saveLibrary") {
                    def pt = ProgramCategory.createCriteria()
                    def id = pt.get {
                        projections {
                            max "id"
                        }
                    }
                    id = id == null ? 1 : id + 1
                    imgPath = "i_" + id + ".jpg"
                    File file = new File("${path}/programCategoryImg");
                    if (!file.exists()) file.mkdirs();
                    imgFile.transferTo(new File(file.getAbsolutePath(), imgPath));
                } else if (opt == "update") {
                    def directory = ProgramCategory.get(updateId as long);
                    def id = directory.id
                    imgPath = "i_" + id + ".jpg"
                    File file = new File("${path}/programCategoryImg");
                    if (!file.exists()) file.mkdirs();
                    imgFile.transferTo(new File(file.getAbsolutePath(), imgPath));
                }
            } else {
                result.success = false;
                result.message = "上传图片格式不对..."
            }
        }
        result.imgPath = imgPath;
        return result;
    }

    /**
     * 分类库图片删除
     * @param imgPath
     */
    private String deleteImg(String imgPath) {
        def result = "";
        def servletContext = utilService.getServletContext();
        def path = servletContext.getRealPath("/upload");
        def filePath = path + "/programCategoryImg/" + imgPath;
        try {
            def file = new File(filePath);
            if (file.exists()) {
                file.delete();
            } else {
                log.error("图片不存在");
            }
        } catch (Exception e) {
            result = "图片删除失败";
            log.error("图片删除失败");
        }
        return result;
    }

    /**
     * 重新设定orderIndex
     * @param parentCategory
     */
    private void programCategoryOrderIndexSetting(ProgramCategory parentCategory) {
        List<ProgramCategory> programCategories = ProgramCategory.findAllByParentCategory(parentCategory, [sort: "orderIndex", order: "asc"]);
        def index = 0;
        programCategories?.each { ProgramCategory category ->
            category.orderIndex = index;
            category.save(flush: true);
            index++;
        }
    }

/**
 * 高级搜索配置
 */
    Map seniorSearchConifg() {
        def result = [:];
        def solrProgramUrl = SysConfig.findByConfigName('SolrProgramUrl');
        def solrSerialUrl = SysConfig.findByConfigName("SolrSerialUrl");
        def cronExpression = SysConfig.findByConfigName("CronExpression");
        def programUrl = solrProgramUrl ? solrProgramUrl.configValue : "http://127.0.0.1:8080/mysolr/dev_program";
        def serialUrl = solrSerialUrl ? solrSerialUrl.configValue : "http://127.0.0.1:8080/mysolr/dev_serial";
        def cronExpr = cronExpression ? cronExpression.configValue : "0 0 0 * * ?";
        result = [solrProgramUrl: programUrl, solrSerialUrl: serialUrl, cronExpression: cronExpr];
        return result;
    }

    /**
     * 文件服务器配置Set
     */
    void seniorSearchConfigSet(Map params) {
        ServletContext servletContext = utilService.getServletContext();
        def solrProgramUrl = SysConfig.findByConfigName('SolrProgramUrl');
        def solrSerialUrl = SysConfig.findByConfigName("SolrSerialUrl");
        def cronExpression = SysConfig.findByConfigName("CronExpression");
        if (!solrProgramUrl) {
            new SysConfig(configName: 'SolrProgramUrl', configValue: params.solrProgramUrl, configDesc: '资源搜索地址', configScope: 0, configMod: 0).save()
        } else {
            solrProgramUrl.configValue = params.solrProgramUrl
        }
        if (!solrSerialUrl) {
            new SysConfig(configName: 'SolrSerialUrl', configValue: params.solrSerialUrl, configDesc: '连续剧搜索地址', configScope: 0, configMod: 0).save()
        } else {
            solrSerialUrl.configValue = params.solrSerialUrl;
        }
        if (!cronExpression) {
            new SysConfig(configName: 'CronExpression', configValue: params.cronExpression, configDesc: '数据同步表达式', configScope: 0, configMod: 0).save()
        } else {
            cronExpression.configValue = params.cronExpression;
        }
        //更新全局变量
        servletContext.solrProgramUrl = params.solrProgramUrl ? params.solrProgramUrl : "http://127.0.0.1:8080/mysolr/dev_program";
        servletContext.solrSerialUrl = params.solrSerialUrl ? params.solrSerialUrl : "http://127.0.0.1:8080/mysolr/dev_serial";
        servletContext.cronExpression = params.cronExpression ? params.cronExpression : "0 0 0 * * ?";
        SystemConfig.setConfig("search.cronExpression", servletContext.cronExpression);
    }

    // 专辑发布为资源
    public Map albumResourceReleaseProgram(Map params) {
        def result = [:];
        Consumer consumer = Consumer.get(params.consumerId);
        if (consumer) {
            String name = params.programName;
            String classId = params.classLibId;
            String description = CTools.htmlToBlank(params.description);
            String categoryId = params.categoryId;
            def canPublic = params.canPublic;
            def factedValIds = [];
            if (params.factedValue) {
                if (params.factedValue instanceof String) {
                    factedValIds.add(params.factedValue);
                } else if (params.factedValue instanceof String[]) {
                    String[] values = params.factedValue;
                    for (String value : values) {
                        factedValIds.add(value);
                    }
                }
            }
            Program program = new Program();
            program.name = name;
            if (classId && classId != "") { //元数据标准可为空
                program.directory = Directory.get(classId as long);
                program.classLib = program?.directory;
            }

            program.consumer = consumer;
            program.description = description;
            if ("true".equals(canPublic)) {
                program.canPublic = true;
            }
            program.state = Program.APPLY_STATE;
            //获取分面
            factedValIds?.each {
                FactedValue value = FactedValue.get(it as long);
                if (value) {
                    program.addToFactedValues(value);
                }
            }
            //获得标签
            String programTag = params.programTag;
            if (programTag && (!StringUtils.isEmpty(programTag))) {
                String[] tags = programTag.split(";");
                def countMap = [:];

                tags.each { String tag ->
                    countMap.put(tag, 1);
                }
                countMap.keySet().each { String tag ->
                    if (StringUtils.isNotBlank(tag)) {
                        ProgramTag programTag1 = ProgramTag.findByName(tag);
                        if (programTag1) {
                            programTag1.frequency++;
                            program.addToProgramTags(programTag1);
                        } else {
                            program.addToProgramTags(new ProgramTag(name: tag, frequency: 0));
                        }
                    }
                }
            }

            ProgramCategory programCategory = null;
            if (categoryId != '') {
                String[] categoryIds = categoryId.split(",");
                categoryIds?.each {
                    programCategory = ProgramCategory.get(it as long);
                    program.addToProgramCategories(programCategory);
                }
                if (categoryIds && categoryIds.size() > 0) {
                    program.firstCategoryId = categoryIds[0] as long;
                }
            } else {
                programCategory = ProgramCategory.findByName("默认资源库");
                program.addToProgramCategories(programCategory);
                program.firstCategoryId = programCategory.id;
            }

            String otherOption = params.get("otherOption");
            if (otherOption) {
                program.otherOption = Integer.parseInt(otherOption);
            }

            program.specialId = params.specialId as Long;
            program.specialName = params.specialName;

            // 取得专辑里的文件
            UserSpecial userSpecial = UserSpecial.get(program.specialId);
            List<SpecialFile> specialFileList = SpecialFile.findAllByUserSpecial(userSpecial);

            def list = []//记录我的文件中回收站被删除的文件
            specialFileList.each {
                try {
                    it.userFile
                } catch (Exception e) {
                    if (e.getClass().getSimpleName() == 'ObjectNotFoundException') {
                        // specialFileList.remove(it)
                        list.add(it)
                    } else {
                        log.debug(e)
                    }

                }
            }
            list.each {
                specialFileList.remove(it)
            }

            int serialNo = 1;
            specialFileList.each {
                Serial serial = new Serial();
                serial.name = it.name;
                serial.filePath = it.userFile.filePath;
                serial.fileType = it.userFile.fileType;
                serial.fileHash = it.userFile.fileHash;
                serial.serialNo = serialNo;
                serial.dateCreated = new Date();
                serial.dateModified = new Date();
                serial.state = 1;
                if (FileType.isVideo(serial.name)) {
                    serial.urlType = Serial.URL_TYPE_VIDEO;
                } else if (FileType.isDocument(serial.filePath)) {
                    serial.urlType = Serial.URL_TYPE_DOCUMENT;
                } else if (FileType.isImage(serial.filePath)) {
                    serial.urlType = Serial.URL_TYPE_IMAGE;
                } else if (FileType.isAudio(serial.filePath)) {
                    serial.urlType = Serial.URL_TYPE_AUDIO;
                } else {
                    serial.urlType = Serial.URL_TYPE_UNKNOWN;
                }
                program.addToSerials(serial);
                serialNo++;
            }

            program.serialNum = specialFileList.size(); //设置文件个数

            if (program.save() && !program.hasErrors()) {
                consumer.uploadNum++;
                consumer.save();
                result.programId = program.id;
                result.success = true;
                new OperationLog(tableName: 'program', tableId: program.id, operator: consumer.name, operatorIP: params.remoteAddr,
                        modelName: '添加资源', brief: program.name, operatorId: consumer.id, operation: OperationEnum.ADD_PROGRAM).save()
            } else {
                result.success = false;
                result.msg = "资源发布失败"
            }
        } else {
            result.success = false;
            result.msg = "用户不存在"
        }
        return result;

    }

    /**
     * 资源评分保存
     * @param programId
     */
    public void saveProgramScore(long programId) {
        Program program = Program.findById(programId);
        //资源评分保存
        program.programScore = Float.parseFloat(program.remarks.size() ? new DecimalFormat("#.##").format((program.remarks*.rank)?.sum() / program.remarks.size()) : '0.0');
        List<Remark> remarkList = Remark.findAllByProgram(program);
        program.remarkNum = remarkList.size();
        program.save(flash: true);
    }

    /**
     * 根据媒体类型和资源分类选取热门标签
     * @param otherOption
     * @return
     */
    public List<ProgramTag> queryHotProgramTag(int otherOption, long categoryId) {
        def programIds = [];
        List states = new ArrayList();
        states.add(Program.STATE_SUCCESS);
        states.add(Program.STATE_SUCCESS_PART);
        List<ProgramTag> programTagList = new ArrayList<ProgramTag>();
        if (categoryId && categoryId != -1) {
            def categoryIdList = [];
            ProgramCategory programCategory = ProgramCategory.findById(categoryId)
            if (programCategory) {
                List<ProgramCategory> programCategoryList = programCategoryService.querySubAllCategory(programCategory);
                if (programCategoryList && programCategoryList.size() > 0) {
                    categoryIdList = programCategoryList.id;
                }
                categoryIdList.add(programCategory.id);
            }

            // 按分类查询出符合条件的program
            if (categoryIdList.size() > 0) {
                programIds = Program.createCriteria().list() {
                    projections {
                        distinct('id')
                    }
                    if (userService.judeAnonymity()) {
                        eq('canPublic', true)
                    }
                    eq("state", Program.PUBLIC_STATE)
                    'in'("transcodeState", states.toArray())
                    if (otherOption) {
                        if (otherOption == Program.ONLY_AUDIO_OPTION) {
                            eq('otherOption', Program.ONLY_AUDIO_OPTION)
                        } else if (otherOption == Program.ONLY_FLASH_OPTION) {
                            eq('otherOption', Program.ONLY_FLASH_OPTION)
                        } else if (otherOption == Program.ONLY_VIDEO_OPTION) {
                            eq('otherOption', Program.ONLY_VIDEO_OPTION)
                        } else if (otherOption == Program.ONLY_IMG_OPTION) {
                            eq('otherOption', Program.ONLY_IMG_OPTION)
                        } else if (otherOption == Program.ONLY_COURSE_OPTION) {
                            eq('otherOption', Program.ONLY_COURSE_OPTION)
                        } else if (otherOption == Program.ONLY_LESSION_OPTION) {
                            eq('otherOption', Program.ONLY_LESSION_OPTION)
                        } else if (otherOption == Program.ONLY_TXT_OPTION) {
                            eq('otherOption', Program.ONLY_TXT_OPTION)
                        } else if (otherOption == Program.ONLY_LINK_OPTION) {
                            eq('otherOption', Program.ONLY_LINK_OPTION)
                        }
                    }
                    programCategories {
                        'in'('id', categoryIdList.toArray())
                    }
                }
            }

        } else if (categoryId == -1) {
            programIds = Program.createCriteria().list() {
                projections {
                    distinct('id')
                }
                if (userService.judeAnonymity()) {
                    eq('canPublic', true)
                }
                eq("state", Program.PUBLIC_STATE)
                'in'("transcodeState", states.toArray())
                or {
                    eq('otherOption', Program.ONLY_AUDIO_OPTION)
                    eq('otherOption', Program.ONLY_FLASH_OPTION)
                    eq('otherOption', Program.ONLY_VIDEO_OPTION)
                    eq('otherOption', Program.ONLY_IMG_OPTION)
                    eq('otherOption', Program.ONLY_COURSE_OPTION)
                    eq('otherOption', Program.ONLY_LESSION_OPTION)
                    eq('otherOption', Program.ONLY_TXT_OPTION)
                    eq('otherOption', Program.ONLY_LINK_OPTION)
                }
            }
        }

        //获取热门标签
        if (programIds && programIds.size() > 0) {
            def programTags = ProgramTag.createCriteria().list() {
                projections {
                    distinct('id')
                }
                programs {
                    'in'('id', programIds.toArray())
                }
            };
            if (programTags && programTags.size() > 0) {
                programTagList = ProgramTag.createCriteria().list() {
                    'in'('id', programTags.toArray())
                    order('frequency', 'desc')
                    setMaxResults(8)
                }
            }
        }
        if (programTagList == null) programTagList = new ArrayList<ProgramTag>();
        return programTagList;
    }
}
