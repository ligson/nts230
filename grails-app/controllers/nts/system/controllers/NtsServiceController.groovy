package nts.system.controllers

import com.boful.common.file.utils.FileType
import com.boful.nts.utils.SystemConfig
import grails.converters.JSON
import nts.program.domain.Program
import nts.program.domain.Serial
import nts.system.domain.SysConfig
import nts.user.domain.Consumer
import nts.user.file.domain.UserFile
import nts.utils.CTools
import org.apache.http.NameValuePair
import org.apache.http.client.HttpClient
import org.apache.http.client.entity.UrlEncodedFormEntity
import org.apache.http.client.methods.CloseableHttpResponse
import org.apache.http.client.methods.HttpPost
import org.apache.http.impl.client.HttpClients
import org.apache.http.message.BasicNameValuePair
import org.codehaus.groovy.grails.web.json.JSONArray

import javax.servlet.ServletContext
import java.text.SimpleDateFormat

/**
 * nts对外接口服务接口
 */
class NtsServiceController {
    def utilService;

    def index() {
        List serials = Serial.list();
        return render(view: 'index', model: [serials: serials])
    }

    def posterImg = {

        def result = [:];
        def program = Program.get(params.id)
        def size = CTools.nullToBlank(params.size)
        if (size == "") size = servletContext.thumbnailSize
        result.src = "${posterLinkNew(program: program, size: size)}";
        result.id = params.id;
        //println "dddd"+result.src
        return render(result as JSON);
    }

    def posterUserFileImg = {

        def result = [:];
        def fileHash = params.fileHash;
        def size = CTools.nullToBlank(params.size)
        if (size == "") size = servletContext.thumbnailSize
        result.src = "${posterLinkNew(fileHash: fileHash, size: size)}";
        result.id = params.id;
        //println "dddd"+result.src
        return render(result as JSON);
    }

    def playUserFileImg = {
        def result = [:];
        def fileHash = params.fileHash;
        result.fileUrl = "${playUserFileLink(fileHash: fileHash)}";
        return render(result as JSON);
    }

    def playUserFileLinkNew = {
        def result = [:];
        def fileHash = params.fileHash;
        def userFile = UserFile.findByFileHash(fileHash)
        if (userFile) {
            if (FileType.isDocument(userFile.filePath) || userFile.filePath.endsWith("pdf") || userFile.filePath.endsWith("PDF") || userFile.filePath.endsWith("swf") || userFile.filePath.endsWith("SWF")) {
                result.fileUrl = "${playUserFileLink(fileHash: fileHash)}"
            }
        }
        if (!result.fileUrl) {
            result.fileUrl = "${playLinksNew(fileHash: fileHash)}";
        }
        result.id = params.id;
        //println "dddd"+result.src
        return render(result as JSON);
    }

    def noticeFileState() {

    }

    /**
     * 根据文件hash获取转码状态
     */
    def updateTranscodeStateByFileHash() {
        def result = [:];
        String fileHash = params.fileHash;
        String transcodeState = params.transcodeState;
        String ipAddress = params.ipAddress;
        Serial serial = Serial.findByFileHash(fileHash)
        if (serial) {
            if (transcodeState == "0") {
                serial.state = Serial.NO_CODE_STATE;
            } else if (transcodeState == "1") {
                serial.state = Serial.CODING_STATE;
            } else if (transcodeState == "2") {
                serial.state = Serial.CODED_STATE;
            } else if (transcodeState == "3") {
                serial.state = Serial.CODED_FAILED_STATE;
            } else if (transcodeState == "-1") {
                serial.state = Serial.NO_NEED_STATE;
            }
            serial.save(flush: true);
            result.success = true;
            result.msg = ipAddress + "下" + fileHash + "状态修改完成!";
        } else {
            result.success = false;
            result.msg = ipAddress + "下没有" + fileHash + "这个文件！";
        }
        return render(result as JSON)
    }

    def queryConsumerPhoto() {
        def result = [:];
        String url = "";
        if (params.photo) {
            File file = new File(SystemConfig.webRootDir, "upload/photo/" + params.photo);
            if (file.exists()) {
                url = "${resource(dir: 'upload/photo', file: params.photo)}";
            } else {
                url = "${resource(dir: 'skin/blue/pc/front/images', file: "photo.gif")}";
            }
            // consumer.photo;
        } else {
            url = "${resource(dir: 'skin/blue/pc/front/images', file: "photo.gif")}";
        }
        result.url = url;
        return render(result as JSON)
    }


}
