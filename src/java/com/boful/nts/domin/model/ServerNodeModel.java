package com.boful.nts.domin.model;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by lvy6 on 14-6-18.
 */
public class ServerNodeModel implements Serializable{
    private static final long serialVersionUID = 3144454571324944667L;
    private Long id;
    private String name;	//名称
    private String ip;	//ip
    private int port = 1680;	//上传端口
    private int webPort = 80;	//web端口
    private String distriPath = "";	//分发节目预存路径，路径分隔符统一用"/"
    private String harvestPath = "";		//收割节目预存路径，路径分隔符统一用"/"
    private String descriptions	="";	//节点描述信息

    private int parentId = 0;	//上级节点ID,根节点parentId=0,为了简单，没有用对象类型，删除节点时注意手工维护数据完整性
    private int showOrder = 0;	//排序号
    private int grade = 1;	//级别

    private boolean isSendObject = false;	//缺省是否发送对象

    private Date dateCreated = new Date();			//创建时间

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

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public int getPort() {
        return port;
    }

    public void setPort(int port) {
        this.port = port;
    }

    public int getWebPort() {
        return webPort;
    }

    public void setWebPort(int webPort) {
        this.webPort = webPort;
    }

    public String getDistriPath() {
        return distriPath;
    }

    public void setDistriPath(String distriPath) {
        this.distriPath = distriPath;
    }

    public String getHarvestPath() {
        return harvestPath;
    }

    public void setHarvestPath(String harvestPath) {
        this.harvestPath = harvestPath;
    }

    public String getDescriptions() {
        return descriptions;
    }

    public void setDescriptions(String descriptions) {
        this.descriptions = descriptions;
    }

    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public int getShowOrder() {
        return showOrder;
    }

    public void setShowOrder(int showOrder) {
        this.showOrder = showOrder;
    }

    public int getGrade() {
        return grade;
    }

    public void setGrade(int grade) {
        this.grade = grade;
    }

    public boolean isSendObject() {
        return isSendObject;
    }

    public void setSendObject(boolean isSendObject) {
        this.isSendObject = isSendObject;
    }

    public Date getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Date dateCreated) {
        this.dateCreated = dateCreated;
    }
}
