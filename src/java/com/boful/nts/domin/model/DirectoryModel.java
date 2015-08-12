package com.boful.nts.domin.model;

import org.apache.commons.codec.binary.Base64;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by lvy6 on 14-6-11.
 */
public class DirectoryModel implements Serializable {
    private static final long serialVersionUID = -7660187241138227805L;

    public DirectoryModel() {

    }

    private Long id;
    private String name;
    private String uploadPath;
    private String description;

    private int showOrder;                        //显示顺序
    private int parentId;                    //因不用树目录，故没有用Directory类型		--暂为0
    private int classId;                    //类库ID 用来标识所属类库
    private int childNumber;                    //子目录数目，建树目录时提高效率用		--暂为0

    private boolean allGroup;                    //所属组
    private boolean canUpload;                    //上传标记

    private String img = "";                //类库图片

    private Date dateCreated;                //创建时间
    private Date dateModified;            //修改时间

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

    public String getUploadPath() {
        return uploadPath;
    }

    public void setUploadPath(String uploadPath) {
        this.uploadPath = uploadPath;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public int getShowOrder() {
        return showOrder;
    }

    public void setShowOrder(int showOrder) {
        this.showOrder = showOrder;
    }

    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public int getClassId() {
        return classId;
    }

    public void setClassId(int classId) {
        this.classId = classId;
    }

    public int getChildNumber() {
        return childNumber;
    }

    public void setChildNumber(int childNumber) {
        this.childNumber = childNumber;
    }

    public boolean isAllGroup() {
        return allGroup;
    }

    public void setAllGroup(boolean allGroup) {
        this.allGroup = allGroup;
    }

    public boolean isCanUpload() {
        return canUpload;
    }

    public void setCanUpload(boolean canUpload) {
        this.canUpload = canUpload;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
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

    @Override
    public String toString() {
        return "DirectoryModel{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", uploadPath='" + uploadPath + '\'' +
                ", description='" + description + '\'' +
                ", showOrder=" + showOrder +
                ", parentId=" + parentId +
                ", classId=" + classId +
                ", childNumber=" + childNumber +
                ", allGroup=" + allGroup +
                ", canUpload=" + canUpload +
                ", img='" + img + '\'' +
                ", dateCreated=" + dateCreated +
                ", dateModified=" + dateModified +
                '}';
    }
}
