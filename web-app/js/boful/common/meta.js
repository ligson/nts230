/***
 * 元数据对象
 * @param vSelfId       metaDefine.id
 * @param vParentId     metaDefine.parentId
 * @param vName         metaDefine.name
 * @param vCnName       metaDefine.cnName
 * @param vDataType     metaDefine.dataType
 * @param vShowOrder    metaDefine.showOrder
 * @param vIsNecessary  metaDefine.isNecessary
 * @param vShowType     metaDefine.showType
 * @param vSearchType   metaDefine.searchType
 * @param vDirectorys   metaDefine.directorys*.id
 * @param vDefault      metaDefine.defaultValue
 * @param vMaxLen       metaDefine.maxLen
 * @param vArrEnum      处理枚举类型
 * @param vRepeatNum    0
 * @param vIndex        index
 * @constructor
 */
function CMetaTypeObj(vSelfId, vParentId, vName, vCnName, vDataType, vShowOrder, vIsNecessary, vShowType, vSearchType, vDirectorys, vDefault, vMaxLen, vArrEnum, vRepeatNum, vIndex) {
    //Meta Property
    this.selfId = vSelfId;
    this.parentId = vParentId;
    this.name = vName;
    this.cnName = vCnName;
    this.dataType = vDataType;
    this.showOrder = vShowOrder;
    this.isNecessary = vIsNecessary;
    this.showType = vShowType;
    this.searchType = vSearchType;
    this.directorys = vDirectorys;
    this.defaultValue = vDefault;
    this.maxLen = vMaxLen;
    this.arrEnum = vArrEnum;
    this.repeatNum = vRepeatNum;
    this.index = vIndex;
}

function CContentTypeObj(vSelfId, vMetaId, vMetaPId, vDataType, vNContent, vSContent) {
    this.selfId = vSelfId;
    this.metaId = vMetaId;
    this.metaParentId = vMetaPId;
    this.dataType = vDataType;
    this.numContent = vNContent;
    this.strContent = vSContent;
}

/***
 * 枚举对象
 * @param vId metaEnum.id
 * @param vName metaEnum.name
 * @constructor
 */
function CEnumTypeObj(vId, vName) {
    //Enum Property
    this.id = vId;
    this.name = vName;
}

function CDirectoryTypeObj(vId, vName) {
    this.id = vId;
    this.name = vName;
}

function CSerail(id, name, description, bigImg, smallImg, dateCreated) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.bigImg = bigImg;
    this.smallImg = smallImg;
    this.dateCreated = dateCreated;

}

function getMetaFromId(vMetaId) {
    if (vMetaId == null || isNaN(vMetaId) || vMetaId < 0)
        return null;

    var i;
    for (i = 0; i < metaList.length; i++) {
        if (metaList[i].selfId == vMetaId)
            return metaList[i];
    }

    return null;
}

function inArray(classId, arr) {
    var bIn = false;
    if ("undefined" != typeof jQuery) {
        bIn = jQuery.inArray(classId, arr) > -1;
    }
    else if ("undefined" != typeof Prototype) {
        bIn = arr.include(classId);
    }

    return bIn;
}
//为了提高效率，从所有元数据中提取当前类,当前显示，当前检索元数据,showType,searchType为-1表示没有限制
function setCurMetaList(classId, showType, searchType) {
    var j = 0;
    for (var i = 0; i < allMetaList.length; i++) {
        if ((showType == -1 || (allMetaList[i].showType & showType) == showType) && (searchType == -1 || (allMetaList[i].searchType & searchType) == searchType) && (allMetaList[i].directorys == null || allMetaList[i].directorys.length == 0 || inArray(classId, allMetaList[i].directorys))) {
            metaList[j] = allMetaList[i];
            metaList[j].index = j;
            j++;
        }
    }
}

function getArrLink(vValue) {
    //vValue:<a href=\"http:\/\/www.google.com\" target=\"_blank\">google<\/a>
    var nTPos = 0;
    var nTPos2 = 0;
    var arr = ["", ""];
    if (vValue != "") {
        nTPos = vValue.indexOf("\"");
        if (nTPos > 0) {
            nTPos2 = vValue.indexOf("\"", nTPos + 2);
            if (nTPos2 > 0) {
                arr[0] = vValue.substring(nTPos + 1, nTPos2);
            }
        }
        if (arr[0] != "") {
            nTPos = vValue.indexOf(">", nTPos2);
            if (nTPos > 0) {
                nTPos2 = vValue.indexOf("</a>", nTPos);
                if (nTPos2 > 0) {
                    arr[1] = vValue.substring(nTPos + 1, nTPos2);
                }
            }
        }
    }

    return arr;
}
