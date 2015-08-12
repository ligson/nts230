function CMetaTypeObj(vSelfId, vParentId,vName,vCnName,vDataType,vShowOrder,vIsNecessary,vShowType,vSearchType,vDirectorys,vDefault,vMaxLen,vArrEnum,vRepeatNum,vIndex)
{
		//Meta Property
		this.selfId=vSelfId;
		this.parentId=vParentId;
		this.name=vName;
		this.cnName=vCnName;
		this.dataType=vDataType;
		this.showOrder=vShowOrder;
		this.isNecessary=vIsNecessary;
		this.showType=vShowType;
		this.searchType=vSearchType;
		this.directorys=vDirectorys;
		this.defaultValue=vDefault;
		this.maxLen=vMaxLen;
		this.arrEnum=vArrEnum;
		this.repeatNum=vRepeatNum;
		this.index=vIndex;
}

function CContentTypeObj(vSelfId,vMetaId,vMetaPId,vDataType,vNContent,vSContent)
{
		this.selfId=vSelfId;
		this.metaId=vMetaId;
		this.metaParentId=vMetaPId;
		this.dataType=vDataType;
		this.numContent=vNContent;
		this.strContent=vSContent;
}

function CEnumTypeObj(vId, vName)
{
		//Enum Property
		this.id=vId;
		this.name=vName;
}

function CDirectoryTypeObj(vId, vName)
{
		this.id=vId;
		this.name=vName;
}

function getMetaFromId(vMetaId)
{
	if(vMetaId == null || isNaN(vMetaId) || vMetaId<0)
		return null;

	var i;
	for (i=0;i<metaList.length;i++)
	{
		if(metaList[i].selfId == vMetaId)
			return metaList[i];
	}

	return null;	 
}

//为了提高效率，从所有元数据中提取当前类,当前显示，当前检索元数据,showType,searchType为-1表示没有限制
function setCurMetaList(classId,showType,searchType)
{
	var j=0;
	for (var i=0;i<allMetaList.length;i++)
	{
		if((showType == -1 || (allMetaList[i].showType & showType) == showType) && (searchType == -1 || (allMetaList[i].searchType & searchType) == searchType) && (allMetaList[i].directorys == null || allMetaList[i].directorys.size() == 0 || allMetaList[i].directorys.include(classId)))
		{
			metaList[j] = allMetaList[i];
			metaList[j].index = j;
			j++;	
		}
	}
}

function getArrLink(vValue)
{
	//vValue:<a href=\"http:\/\/www.google.com\" target=\"_blank\">google<\/a>
	var nTPos=0;
	var nTPos2=0;
	var arr=["",""];
	if(vValue != "")
	{
		nTPos=vValue.indexOf("\"");
		if(nTPos>0)
		{
			nTPos2=vValue.indexOf("\"",nTPos+2);
			if(nTPos2>0)
			{
				arr[0]=vValue.substring(nTPos+1,nTPos2);
			}
		}
		if(arr[0] != "")
		{
			nTPos=vValue.indexOf(">",nTPos2);
			if(nTPos>0)
			{
				nTPos2=vValue.indexOf("</a>",nTPos);
				if(nTPos2>0)
				{
					arr[1]=vValue.substring(nTPos+1,nTPos2);
				}
			}
		}
	}
	
	return arr;
}