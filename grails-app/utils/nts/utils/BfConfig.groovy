package nts.utils

class BfConfig {
	private static webRootPath = ''	//web根路径供服务等类用
	private static videoSevr = '127.0.0.1'	//视频服务器IP
	private static videoPort = '1680'	//视频服务器端口供服务等类用
	private static playProtocol = 'BMSP'	//播放协议
	private static localWebPort = '80'	//本机web端口
    private static fileSizeLimit = '0' //上传文件最大容量配置

	static setWebRootPath(filePath) {
		this.webRootPath = filePath
	}	
	static getWebRootPath() {
		return webRootPath
	}

	static setVideoSevr(videoSevr) {
		this.videoSevr = videoSevr
	}
	static getVideoSevr() {
		return videoSevr
	}

	static setVideoPort(port) {
		this.videoPort = port
	}
	static getVideoPort() {
		return videoPort
	}

	static setPlayProtocol(playProtocol) {
		this.playProtocol = playProtocol
	}
	static getPlayProtocol() {
		return playProtocol
	}

	static setLocalWebPort(localWebPort) {
		this.localWebPort = localWebPort
	}
	static getLocalWebPort() {
		return localWebPort
	}

    static getFileSizeLimit() {
        return fileSizeLimit
    }

    static void setFileSizeLimit(fileSizeLimit) {
        this.fileSizeLimit = fileSizeLimit
    }
}