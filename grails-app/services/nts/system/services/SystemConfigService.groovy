package nts.system.services

import grails.transaction.Transactional
import nts.system.domain.SysConfig

@Transactional
class SystemConfigService {
    static String uploadServerIpAddress;
    static int uploadServerPort;
    static float fileSizeLimit;
    def utilService

    public String findUploadServerAddress() {
        if (utilService.servletContext.videoSevr) {
            uploadServerIpAddress = utilService.servletContext.videoSevr;
            return uploadServerIpAddress;
        }
        if (uploadServerIpAddress) {
            return uploadServerIpAddress;
        } else {
            SysConfig videoSevr = SysConfig.findByConfigName("VideoSevr");
            uploadServerIpAddress = videoSevr ? videoSevr.configValue : InetAddress.getLocalHost().getHostAddress();
            return uploadServerIpAddress;
        }

    }

    public int findUploadPort() {
        //uploadPort
        if (utilService.servletContext.uploadPort) {
            uploadServerPort = utilService.servletContext.uploadPort as int;
            return uploadServerPort;
        }
        if (uploadServerPort) {
            return uploadServerPort;
        } else {
            SysConfig uploadPort = SysConfig.findByConfigName("uploadPort");
            uploadServerPort = uploadPort ? Integer.parseInt(uploadPort.configValue) : 8080;
            return uploadServerPort;
        }
    }

    public float findFileSizeLimit(){
        if (utilService.servletContext.fileSizeLimit) {
            fileSizeLimit = utilService.servletContext.fileSizeLimit as float;
            return fileSizeLimit;
        }
        if (fileSizeLimit) {
            return fileSizeLimit;
        } else {
            SysConfig fileSizeLimit = SysConfig.findByConfigName("fileSizeLimit");
            fileSizeLimit = fileSizeLimit ? Long.parseLong(fileSizeLimit.configValue) : 0;
            return fileSizeLimit;
        }
    }
}
