package com.boful.nts.domin.model;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by lvy6 on 14-6-11.
 */
public class SerialModel implements Serializable {
    private static final long serialVersionUID = 4515014873300161440L;

    public SerialModel() {

    }

    private Long id;
    private String name;
    private Integer serialNo = 1;
    private Integer urlType = 0;
    private Integer timeLength = 0;
    private String svrAddress = "";
    private Integer svrPort;
    private String filePath = "";
    private String description = "";
    private String fileHash;
    private String fileType;
    private long programId;

    private int progType = 0;    //文件格式
    private int bandWidth = 0;
    private int state = 3; //转码状态
    private int transcodeState = 0;    //1. 标清. 2高清, 4超清,表示已经转码的文件
    private int process = 0;   //转码进度

    private String startTime = "00:00:00"; //因为与日期无关，故不用Date或Time
    private String endTime = "00:00:00";
    private String webPath = "";   //在线课件的虚拟目录
    private String strProgType = "";    //字符串型文件格式
    private String formatAbstract = "";    //格式摘要
    private String photo = "";    //海报

    private Date dateCreated;
    private Date dateModified;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getSerialNo() {
        return serialNo;
    }

    public void setSerialNo(Integer serialNo) {
        this.serialNo = serialNo;
    }

    public Integer getUrlType() {
        return urlType;
    }

    public void setUrlType(Integer urlType) {
        this.urlType = urlType;
    }

    public Integer getTimeLength() {
        return timeLength;
    }

    public void setTimeLength(Integer timeLength) {
        this.timeLength = timeLength;
    }

    public String getSvrAddress() {
        return svrAddress;
    }

    public void setSvrAddress(String svrAddress) {
        this.svrAddress = svrAddress;
    }

    public Integer getSvrPort() {
        return svrPort;
    }

    public void setSvrPort(Integer svrPort) {
        this.svrPort = svrPort;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getFileHash() {
        return fileHash;
    }

    public void setFileHash(String fileHash) {
        this.fileHash = fileHash;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }


    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public int getProgType() {
        return progType;
    }

    public void setProgType(int progType) {
        this.progType = progType;
    }

    public int getBandWidth() {
        return bandWidth;
    }

    public void setBandWidth(int bandWidth) {
        this.bandWidth = bandWidth;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public int getTranscodeState() {
        return transcodeState;
    }

    public void setTranscodeState(int transcodeState) {
        this.transcodeState = transcodeState;
    }

    public int getProcess() {
        return process;
    }

    public void setProcess(int process) {
        this.process = process;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getWebPath() {
        return webPath;
    }

    public void setWebPath(String webPath) {
        this.webPath = webPath;
    }

    public String getStrProgType() {
        return strProgType;
    }

    public void setStrProgType(String strProgType) {
        this.strProgType = strProgType;
    }

    public String getFormatAbstract() {
        return formatAbstract;
    }

    public void setFormatAbstract(String formatAbstract) {
        this.formatAbstract = formatAbstract;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public Date getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Date dateCreated) {
        this.dateCreated = dateCreated;
    }

    public Date getDateModified() {
        return dateModified;
    }

    public void setDateModified(Date dateModified) {
        this.dateModified = dateModified;
    }

    public long getProgramId() {
        return programId;
    }

    public void setProgramId(long programId) {
        this.programId = programId;
    }

    @Override
    public String toString() {
        return "SerialModel{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", serialNo=" + serialNo +
                ", urlType=" + urlType +
                ", timeLength=" + timeLength +
                ", svrAddress='" + svrAddress + '\'' +
                ", svrPort=" + svrPort +
                ", filePath='" + filePath + '\'' +
                ", description='" + description + '\'' +
                ", fileHash='" + fileHash + '\'' +
                ", fileType='" + fileType + '\'' +
                ", program=" + programId +
                ", progType=" + progType +
                ", bandWidth=" + bandWidth +
                ", state=" + state +
                ", transcodeState=" + transcodeState +
                ", process=" + process +
                ", startTime='" + startTime + '\'' +
                ", endTime='" + endTime + '\'' +
                ", webPath='" + webPath + '\'' +
                ", strProgType='" + strProgType + '\'' +
                ", formatAbstract='" + formatAbstract + '\'' +
                ", photo='" + photo + '\'' +
                ", dateCreated=" + dateCreated +
                ", dateModified=" + dateModified +
                '}';
    }
}

