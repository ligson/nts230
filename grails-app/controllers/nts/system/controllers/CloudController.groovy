package nts.system.controllers

import groovy.xml.MarkupBuilder
import nts.meta.domain.MetaDefine
import nts.program.domain.Program
import nts.program.services.ProgramService
import nts.utils.CTools

class CloudController {
	ProgramService programService
    def index = { }

	/**
     * 由外部统发出请求，邦丰nts返回资源XML数据,因为是供外部调用，故规范xml中program改为resource
     * http://192.168.1.12:8080/nts/cloud/resourceList?page=1&size=10&beginId=0&endId=100
     * 说明：RMS云平台接口说明
     */
	def resourceList = {
		def encoding = "UTF-8"
		def consumer = null
		def programList = null
		
		def xmlText = ""
		boolean isAuthPass = false
		
		if(!params.size) params.size = 10
		if(!params.page) params.page = 1     
		if(!params.sort) params.sort = 'id'
		if(!params.order) params.order = 'asc'

		if(params.encoding && params.encoding != "") encoding = params.encoding

		params.offset = (CTools.nullToZero(params.page)-1) * CTools.nullToZero(params.size)

		def userName = CTools.nullToBlank(params.user).trim()
		def type = CTools.nullToOne(params.type)	//搜索关键词对应的类别：名称 作者 创建者 标签			
		def keyword = CTools.nullToBlank(params.keyword).trim()
		def verify = CTools.nullToBlank(params.verify)
		def time = (params.time)?Long.parseLong(params.time):0L
		def beginId = (params.beginId)?Long.parseLong(params.beginId):0L
		def endId = (params.endId)?Long.parseLong(params.endId):0L
		
		isAuthPass = true
		/*if(servletContext.clientName == "fujian")
			isAuthPass = true
		else
			isAuthPass = programService.isAuthPass(servletContext.authPrefix,servletContext.authPostfix,userName,verify,time,servletContext.authTimeout.toLong())	
		*/
		
		if(isAuthPass) {

			programList = Program.createCriteria().list(max: params.size, offset: params.offset, sort: params.sort, order: params.order) {							
				
				if(beginId > 0) ge("id",beginId)
				if(endId > 0) le("id",endId)
				//已入库并发布
				ge("state",Program.PUBLIC_STATE)
			}

			
			//mB.resources(count:programList.totalCount,page:params.page,size:params.size) {
			StringBuffer buf = new StringBuffer("<resources count='${programList.totalCount}' page='${params.page}' size='${params.size}'>\n")
			for(p in programList) {
				buf.append(getProgramXmlString(p)+"\n")
			}
			buf.append("</resources>\n")
			xmlText = buf.toString()
			//}
		
		}
		else{
			xmlText = '<resources count="-1" page="0" size="5">Authentication failure</resources>'
		}

		render(text:xmlText,contentType:"text/xml",encoding:encoding)
	}

	/**
     * 由外部统发出请求，邦丰nts返回资源XML数据,因为是供外部调用，故规范xml中program改为resource
     * http://192.168.1.12:8080/nts/cloud/resourceList?page=1&size=10&beginId=0&endId=100
     * 说明：RMS云平台接口说明
     */
	def resource = {
		def encoding = "UTF-8"
		def xmlText = ""
		boolean isAuthPass = false

		def program = Program.get(params.id)

		try {
			if(program) {
				isAuthPass = true
				if(isAuthPass) {
					xmlText = getProgramXmlString(program)
				}
				else{
					xmlText = '<message status="e_auth">Error:authentication failure</message>'
			}
			
			}
			else{
				xmlText = '<message status="e_noresource">Error:resource not exist</message>'
			}
		}
		catch (Exception e) {
			xmlText = '<message status="e_throw">Error:'+e.toString()+'</message>'
		}

		render(text:xmlText,contentType:"text/xml",encoding:encoding)
	}


//获得program对应的xml字符串，如果还有后续模块用到此方法，则移入到ProgramService中
	def getProgramXmlString(p){
		def metaDefineList = null
		def metaEnumList = null
		def metaContentList = null
		def xmlText = ""
		Map args = null	//用于传到服务层的参数
		def data = ""
		def writer = new StringWriter()
		def mB = new MarkupBuilder(writer)

		def webHost = request.getServerName()
		if(request.getServerPort() != 80) webHost += ":" + request.getServerPort()
		

		///////////////////////////////////////////////////////////get metaDefineList start
		def c = MetaDefine.createCriteria()
		metaDefineList = c.list {
			//like("holderFirstName", "Fred%")
			or{
				sizeLt("directorys",1)
				directorys{
					eq("id",p?.directory?.id)
				}
			}
			
			order("showOrder", "asc")
		}
		//////////////////////////////////////////////////////////get metaDefineList end

		/////////////////////////////////////////////////////////get metaEnumList start	
		c = MetaEnum.createCriteria()
		metaEnumList = c.list {
			'in'("metaDefine",metaDefineList) 
			
			//order("showOrder", "asc")
		}
		
		////////////////////////////////////////////////////////get metaEnumList end
		metaContentList = p.metaContents

		mB.resource(){ 
			id(p.id)
			directoryId(p?.directory?.id)
			name(p.name)
			actor(p.actor)
			director(p.actor)
			playNum(p.frequency)
			downloadNum(p.downloadNum)
			dateCreated(p.dateCreated)
			guid(p.guid)
			state(p.state)
			fromState(p.fromState)
			description(p.description)
			
			//ddd("mkp.yieldUnescaped "<!CDATA[$myContent]]>" ")

			programTags(){
				p.programTags.each{ tag ->
					programTag(tag.name)
				}
			}

			/////////////////////////////////元数据信息开始
			
			metaContents(programId:p.id){
				for(metaDefine in metaDefineList) {
					if(metaDefine.parentId == 0){
						if(metaDefine.dataType == "decorate"){
							def dataList = []
							
								for(metaDefine2 in metaDefineList) {
									if(metaDefine2.parentId == metaDefine.id){
										data = getMetaData(metaDefine2,metaEnumList,metaContentList)
										if(data != "") {
										dataList.add([name:metaDefine2.name,cnName:metaDefine2.cnName,dataType:metaDefine2.dataType,data:data])
										}
									}
								}

								if(dataList.size() > 0){
									element(dataType:metaDefine.dataType){
									cnName(metaDefine.cnName)
									decorates(){
										dataList.each{ curData ->
											decorate(){
												cnName(curData.cnName)
												content(dataType:curData.dataType,curData.data)
											}
										}
									}
								}
							}
						}
						else{
							data = getMetaData(metaDefine,metaEnumList,metaContentList)
							if(data != "") {
								element(dataType:metaDefine.dataType){
									cnName(metaDefine.cnName)
									content(dataType:metaDefine.dataType,data)
								}
							}
						}
					}
					
				}
			}
			//////////////////////////////元数据信息结束

			serials(programId:p.id){
				p.serials.each{ curSerial ->
					
					serial(serialNo:curSerial.serialNo,urlType:curSerial.urlType,timeLength:curSerial.timeLength,state:curSerial.state,transcodeState:curSerial.transcodeState, process:curSerial.process){
						name(curSerial.name)
						svrAddress(curSerial.svrAddress)
						filePath(curSerial.filePath)
						startTime(curSerial.startTime)
						endTime(curSerial.endTime)
						webPath(curSerial.webPath)
						photo(curSerial.photo)
						description(curSerial.description)
						subtitles(){
							curSerial.subtitles.each{ curSubtitle ->
								subtitle(serialNo:curSubtitle.serialNo,type:curSubtitle.type){
									filePath(curSubtitle.filePath)
									lang(){
										if(curSubtitle.lang){													
											shortName(curSubtitle.lang.shortName)
											enName(curSubtitle.lang.enName)
											zhName(curSubtitle.lang.zhName)
										}
										else{
											shortName("zh-CN")
											enName("Chinese - China")
											zhName("中文 中国")
										}
									}

								} 
							}
						}
						
					}
				}
			}
		}
	
		xmlText = writer.toString()
		return xmlText
	}

	//获得元数据对应的文本值，如果还有后续模块用到此方法，则移入到ProgramService中
	def getMetaData(metaDefine,metaEnumList,metaContentList){
		def strData = ""
		
		for(metaContent in metaContentList) {
			
			if(metaContent.metaDefine.id == metaDefine.id){
				if(MetaContent.numDataTypes.contains(metaDefine.dataType)){										
					if(metaDefine.dataType == "enumeration") 
						strData = getEnumName(metaContent.numContent,metaDefine,metaEnumList)
					else
						strData = metaContent.numContent
				}
				else{
					strData = metaContent.strContent
				}
				
				break;
			}
		}

		return strData
		
	}

	//获得枚举对应的文本值，如果还有后续模块用到此方法，则移入到ProgramService中
	def getEnumName(enumId,metaDefine,metaEnumList){
		def strData = ""

		for(metaEnum in metaEnumList) {			
			if(metaEnum.metaDefine.id == metaDefine.id && metaEnum.enumId == enumId){				
				strData = metaEnum.name				
				break;
			}
		}

		return strData		
	}

}
