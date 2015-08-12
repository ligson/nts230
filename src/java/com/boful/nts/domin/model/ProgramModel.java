package com.boful.nts.domin.model;

import org.apache.commons.codec.binary.Base64;

import java.io.Serializable;
import java.util.*;

/**
 * Created by lvy6 on 14-6-11.
 */
public class ProgramModel implements Serializable{
    private static final long serialVersionUID = -2159642724449436255L;
    private Long id;
    private String name;
    private Integer type = 0;
    private Integer serialNum = 1;
    private Integer otherOption = 0;
    private String description;
    private String programTag;
    private String actor = "";
    private String director = "";
    private Integer frequency = 0;
    private Integer remarkNum = 0;
    private Integer viewNum = 0;
    private Integer downloadNum = 0;
    private Integer collectNum = 0;
    private Integer recommendNum = 0;
    private SerialModel[] serials;
    private DirectoryModel classLib;
    private String guid = UUID.randomUUID().toString();    //guid
    private int state = 1;
    private int nowVersion = 0   ; //现在版本,用于收割，新添加的资源为0,修改后加1，上级收割审批后，preVesion=nowVersion
    private int preVersion = -1   ; //前版本,用于收割，新添加的资源为-1,上级收割审批后，preVesion=nowVersion
    private int outClassId = 0  ;  //来源库ID，如果是来源新东方或爱迪克森等库:100000新东方 100001爱迪科森 100002知识视界 200000其它
    private boolean canPlay = true;   //允许点播
    private boolean canDownload = false   ; //允许下载
    private boolean canAllPlay = true;    //允许所有组或用户点播
    private boolean canAllDownload = true  ;  //允许所有组或用户下载
    private boolean canDistribute = true  ;  //是否可分发到下级节点
    private boolean canUnion = false ;   //是否可分发到联盟
    private boolean canPublic = false  ;  //是否可公开

    //海报 暂时不分发收割
    private String posterHash;
    private String posterType;
    private String posterPath;

    private Date dateCreated = new Date();
    private Date dateModified = dateCreated;
    private Date dateDeleted;
    private Date datePassed = dateCreated;    //审批通过日期，即入库日期

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
        /*try{
            this.name = Base64.encodeBase64String(name.getBytes("UTF-8"));
        }catch(Exception e){
        }*/
        this.name=name;

    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Integer getSerialNum() {
        return serialNum;
    }

    public void setSerialNum(Integer serialNum) {
        this.serialNum = serialNum;
    }

    public Integer getOtherOption() {
        return otherOption;
    }

    public void setOtherOption(Integer otherOption) {
        this.otherOption = otherOption;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        //this.description = description;
        /*try{
            this.description = Base64.encodeBase64String(description.getBytes("UTF-8"));
        }catch(Exception e){
        }*/
        this.description=description;
    }

    public String getProgramTag() {
        return programTag;
    }

    public void setProgramTag(String programTag) {
        this.programTag = programTag;
    }

    public String getActor() {
        return actor;
    }

    public void setActor(String actor) {
        this.actor = actor;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public Integer getFrequency() {
        return frequency;
    }

    public void setFrequency(Integer frequency) {
        this.frequency = frequency;
    }

    public Integer getRemarkNum() {
        return remarkNum;
    }

    public void setRemarkNum(Integer remarkNum) {
        this.remarkNum = remarkNum;
    }

    public Integer getViewNum() {
        return viewNum;
    }

    public void setViewNum(Integer viewNum) {
        this.viewNum = viewNum;
    }

    public Integer getDownloadNum() {
        return downloadNum;
    }

    public void setDownloadNum(Integer downloadNum) {
        this.downloadNum = downloadNum;
    }

    public Integer getCollectNum() {
        return collectNum;
    }

    public void setCollectNum(Integer collectNum) {
        this.collectNum = collectNum;
    }

    public Integer getRecommendNum() {
        return recommendNum;
    }

    public void setRecommendNum(Integer recommendNum) {
        this.recommendNum = recommendNum;
    }

    public SerialModel[] getSerials() {
        return serials;
    }

    public void setSerials(SerialModel[] serials) {
        this.serials = serials;
    }

    public DirectoryModel getClassLib() {
        return classLib;
    }

    public void setClassLib(DirectoryModel classLib) {
        this.classLib = classLib;
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public String getGuid() {
        return guid;
    }

    public void setGuid(String guid) {
        this.guid = guid;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public int getNowVersion() {
        return nowVersion;
    }

    public void setNowVersion(int nowVersion) {
        this.nowVersion = nowVersion;
    }

    public int getPreVersion() {
        return preVersion;
    }

    public void setPreVersion(int preVersion) {
        this.preVersion = preVersion;
    }

    public int getOutClassId() {
        return outClassId;
    }

    public void setOutClassId(int outClassId) {
        this.outClassId = outClassId;
    }

    public boolean isCanPlay() {
        return canPlay;
    }

    public void setCanPlay(boolean canPlay) {
        this.canPlay = canPlay;
    }

    public boolean isCanDownload() {
        return canDownload;
    }

    public void setCanDownload(boolean canDownload) {
        this.canDownload = canDownload;
    }

    public boolean isCanAllPlay() {
        return canAllPlay;
    }

    public void setCanAllPlay(boolean canAllPlay) {
        this.canAllPlay = canAllPlay;
    }

    public boolean isCanAllDownload() {
        return canAllDownload;
    }

    public void setCanAllDownload(boolean canAllDownload) {
        this.canAllDownload = canAllDownload;
    }

    public boolean isCanDistribute() {
        return canDistribute;
    }

    public void setCanDistribute(boolean canDistribute) {
        this.canDistribute = canDistribute;
    }

    public boolean isCanUnion() {
        return canUnion;
    }

    public void setCanUnion(boolean canUnion) {
        this.canUnion = canUnion;
    }

    public boolean isCanPublic() {
        return canPublic;
    }

    public void setCanPublic(boolean canPublic) {
        this.canPublic = canPublic;
    }

    public String getPosterHash() {
        return posterHash;
    }

    public void setPosterHash(String posterHash) {
        this.posterHash = posterHash;
    }

    public String getPosterType() {
        return posterType;
    }

    public void setPosterType(String posterType) {
        this.posterType = posterType;
    }

    public String getPosterPath() {
        return posterPath;
    }

    public void setPosterPath(String posterPath) {
        this.posterPath = posterPath;
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

    public Date getDateDeleted() {
        return dateDeleted;
    }

    public void setDateDeleted(Date dateDeleted) {
        this.dateDeleted = dateDeleted;
    }

    public Date getDatePassed() {
        return datePassed;
    }

    public void setDatePassed(Date datePassed) {
        this.datePassed = datePassed;
    }

    @Override
    public String toString() {
        String serialString = "";
        if((serials!=null)&&(serials.length>0)){
            for(int i = 0;i<serials.length;i++){
                serialString+=("serial"+i);
            }
        }
        return "ProgramModel{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", type=" + type +
                ", serialNum=" + serialNum +
                ", otherOption=" + otherOption +
                ", description='" + description + '\'' +
                ", programTag='" + programTag + '\'' +
                ", actor='" + actor + '\'' +
                ", director='" + director + '\'' +
                ", frequency=" + frequency +
                ", remarkNum=" + remarkNum +
                ", viewNum=" + viewNum +
                ", downloadNum=" + downloadNum +
                ", collectNum=" + collectNum +
                ", recommendNum=" + recommendNum +
                ", serials=" + serialString +
                ", classLib=" + classLib +
                ", guid='" + guid + '\'' +
                ", state=" + state +
                ", nowVersion=" + nowVersion +
                ", preVersion=" + preVersion +
                ", outClassId=" + outClassId +
                ", canPlay=" + canPlay +
                ", canDownload=" + canDownload +
                ", canAllPlay=" + canAllPlay +
                ", canAllDownload=" + canAllDownload +
                ", canDistribute=" + canDistribute +
                ", canUnion=" + canUnion +
                ", canPublic=" + canPublic +
                ", posterHash='" + posterHash + '\'' +
                ", posterType='" + posterType + '\'' +
                ", posterPath='" + posterPath + '\'' +
                ", dateCreated=" + dateCreated +
                ", dateModified=" + dateModified +
                ", dateDeleted=" + dateDeleted +
                ", datePassed=" + datePassed +
                '}';
    }
}
