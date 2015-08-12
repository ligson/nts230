package nts.front.mobile.controllers

import nts.meta.domain.MetaDefine
import nts.program.services.ProgramService
import nts.program.domain.Program
import nts.program.domain.Serial
import nts.program.domain.ViewedProgram
import nts.program.services.ProgramService
import nts.system.domain.Directory
import nts.system.domain.OperationEnum
import nts.system.domain.OperationLog
import nts.user.domain.Consumer
import nts.utils.CTools

import java.text.DateFormat;
import java.text.SimpleDateFormat

import groovy.xml.MarkupBuilder
import grails.converters.*

class MobileController {
	ProgramService programService
   
	def directory = {
		if(!params.fmt) params.fmt = 'json'
		
		def encoding = "UTF-8"
		def directoryList = Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"])

		def out = []
		directoryList.each { d->
			out.add([id:d.id, name:d.name])
		}
		if(params.fmt == 'xml')
		{
			def writer = new StringWriter()
			def mB = new MarkupBuilder(writer)
			def data = ""
			mB.list(){
				out.each { d->
					mB.directory(id:d.id, name:d.name)
				}
			}
			data = writer.toString()
			render(text:data,contentType:"text/xml",encoding:encoding)
		}
		else 
		{
            render out as JSON
		}
	}
	def group = {
		if(!params.fmt) params.fmt = 'json'
		def encoding = "UTF-8"
		def metaDefineList = MetaDefine.getAll([166,103,105])

		def out=[]
		metaDefineList.each {m ->
			def group_obj = [
				id : m.id,
				name : m.cnName,
				category : []
				]

			m.metaEnums.each { e ->
				group_obj.category.add([id:e.enumId, name:e.name])
			}
			out.add(group_obj)
		}
		if(params.fmt == 'xml')
		{
			def writer = new StringWriter()
			def mB = new MarkupBuilder(writer)
			def data = ""
			mB.list(){
				out.each{m ->
					mB.group(id:m.id, name:m.name){
						m.category.each { e ->
							mB.category(id:e.id, name:e.name)
						} 
					}
				}
			}
			data = writer.toString()
			render(text:data,contentType:"text/xml",encoding:encoding)
		}
		else
		{
			render out as JSON
		}
	}
	def progListAsXml(out)
	{
		def encoding = "UTF-8"
		def writer = new StringWriter()
		def mB = new MarkupBuilder(writer)
		def data = ""
		mB.list(){
			out.each { p->
				mB.program(id:p.id, name:p.name)
				{
					dir(id:p.dir.id, name:p.dir.name)
					url(photo:p.url.photo)
					hot(play:p.hot.play, down:p.hot.down, recommend: p.hot.recommend, collect:p.hot.collect)
				}
			}
		}
		data = writer.toString()
		render(text:data,contentType:"text/xml",encoding:encoding)
	}
	
	def progListAsOut(programList, isAbbrImg)
	{
		def out = []
		programList.each { p->
			def program_obj = [
				id:p.id,
				name:p.name,
				dir:[],
				url:[],
				hot:[]] 
			program_obj.dir = [id:p?.directory?.id, name:p?.directory?.name]
			//TODO 增加适应手机的海报尺寸
			program_obj.url = [photo:posterLink(serials:p.serials,isAbbrImg:isAbbrImg)]
			program_obj.hot = [play:p.frequency, down:p.downloadNum, recommend: p.recommendNum, collect:p.collectNum]
			out.add(program_obj)
		}
		return out
	}
	
	def recommend = {
		if(!params.fmt) params.fmt = 'json'
		
		def programList = Program.findAllByState(Program.PUBLIC_STATE, [max:6, sort: "recommendNum", order: "desc"])
		def out = progListAsOut(programList, false)
		if(params.fmt == 'xml')
		{
			progListAsXml(out)
		}
		else
		{
			render out as JSON
		}
	}
	
	def list = {
        if(!params.max) params.max = 20
		if(!params.offset) params.offset = 0     
		if(!params.sort) params.sort = 'id'
		if(!params.order) params.order = 'desc'
		if(!params.fmt) params.fmt = 'json'
		
		def did = 0
		def cid = 0
		def gid = 0
		
		if(params.did) 
			did = params.did.toLong()
		if(params.gid) 
			gid = params.gid.toLong()
		if(params.cid)
			cid = params.cid.toInteger()

		def search = ''
		if(params.search)
			search = params.search.trim()
			
		
		def programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) 
		{
			ge("state",Program.PUBLIC_STATE)
			if (did>0)
			{
				eq("directory.id",did)
			}
			if (search)
			{
				ilike("name","%${search}%")
			}
			if(gid > 0)
			{
				def metaDefine = MetaDefine.get(gid)
				if(metaDefine) 
				{
					if(metaDefine.dataType == "enumeration") 
					{
						metaContents 
						{
							eq('metaDefine',metaDefine)
							if(cid > 0)
							{ 
								eq('numContent', cid)
							}
						}
					}
				}
			}
		}
		def out = progListAsOut(programList, true)
		if(params.fmt == 'xml')
		{
			progListAsXml(out)
		}
		else
		{
			render out as JSON

		}
	}
	def program = {
		if(!params.fmt) params.fmt = 'json'
		def encoding = "UTF-8"
		if(!params.id)
			return false
			
		def p = Program.get( params.id )
		if(!p)
		{
			flash.message = "program not found with id ${p.id}"
			render "program not found with id ${p.id}"
			return false
		}

		def writer = new StringWriter()
		def mB = new MarkupBuilder(writer)
		def data = ""
		
		def webHost = request.getServerName()
		def videoHost = ""
		def svrAddress = ""
		def sVideoPort = servletContext.videoPort	//视频服务器端口
		def pwd = ""
		
		if(request.getServerPort() != 80) webHost += ":" + request.getServerPort()
		

		pwd = (servletContext.authPrefix+session?.consumer?.name+servletContext.authPostfix).encodeAsMD5()
        def out = [
            id: p.id,
                   name: p.name,
                   dir:[id:p?.directory?.id, name:p?.directory?.name],
                   url:[photo:posterLink(serials:p.serials,isAbbrImg:false)],
                   hot:[play:p.frequency, down:p.downloadNum, recommend: p.recommendNum, collect:p.collectNum],
                   description:p.description,
                   serial:[],
                   metadata:[],
        ]
        p.serials.each { s ->
            def stageUrl = posterSerialLink(serial:s,isAbbrImg:true)
            if(s) svrAddress = s.svrAddress
            if(servletContext.videoSevr == '' || svrAddress.startsWith("127.0.0.1") || svrAddress.startsWith("localhost")) svrAddress=request.getServerName()
            videoHost = svrAddress + ":" + sVideoPort
            boolean isMp4 = false
            //int playType = programService.judePlayType(request.getHeader("User-Agent")) //0是普通pc机播放，1是移动手机播放，2是移动平板播放
            def playUrl = ''
            def downUrl = ''
            isMp4 = CTools.readExtensionName(s.filePath).toUpperCase() == 'MP4'
            if((s.state == Serial.CODED_STATE || (s.state == Serial.NO_NEED_STATE && isMp4)))
            {
//						def args = [serial:s,consumer:session.consumer,webHost:webHost,videoHost:videoHost,pwd:pwd,isPlay:true,playType:playType,isFlashPlay:true]
                playUrl = 'http://'+videoHost+'/course_def/res_url/'+CTools.readFileDir(s.filePath).getBytes("utf-8").encodeAsBase64().encodeAsURL()+'%40/'+CTools.readFileName(s.filePath,true).encodeAsURL()
//							playUrl = programService.generalSerialUrl(args)
                downUrl = playUrl  
            }
            def serial = [
                id: s.id,
                          name: s.name,
                          url: [stage:stageUrl, play:playUrl, down:downUrl]
                ]
            out.serial.add(serial)
        }
        p.metaContents.each{m ->
            if(m.metaDefine.dataType == 'number'){
                out.metadata.add([key:m.metaDefine.cnName,value:m.numContent.toString()])
            }
            else if(m.metaDefine.dataType == 'enumeration')
            {
                def value = m.metaDefine.metaEnums.find{it.enumId==m.numContent}
                out.metadata.add([key:m.metaDefine.cnName,value:value])
            }
            else
            {
                out.metadata.add([key:m.metaDefine.cnName,value:m.strContent])
            }
        }
		if(params.fmt == 'xml')
		{
            mB.program(id:out.id, name:out.name) {
                dir(id:out.dir.id, name:out.dir.name)
                //TODO 增加适应手机的海报尺寸
                url(photo:out.url.photo)
                hot(play:out.hot.play, down:out.hot.down, recommend: out.hot.recommend, collect:out.hot.collect)
                description(out.description)
                mB.serials()
                {
                    out.serial.each{s ->
                        mB.serial(id:s.id, name:s.name){
                            url(stage:s.url.stage, play:s.url.play, down:s.url.down)
                        }
                    }
                }
                mB.metadatas()
                {
                    out.metadata.each{m ->
						mB.metadate(key:m.key,value:m.value)
					}
				}
			}
            data = writer.toString()
            render(text:data,contentType:"text/xml",encoding:encoding)
        }
        else
        {
            render out as JSON
        }
    }

///////////////////////////////////////////////////////////////////////上面是陈帆移动接口

    def index = {
        if(!params.max) params.max = 6
        if(!params.sort) params.sort = 'submitTime'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        ////////////////////////没有登录的作为匿名用户 开始
        if(!session.consumer){
            def consumer = Consumer.findByName(servletContext.anonymityUserName)
            //判断用户是否是锁定状态
            if(consumer){
                if (!consumer.userState)	{
                    redirect(action:loginError,params:[loginFlg:4])
                    return
                }
                session.consumer = consumer
            }
            else{
                redirect(action:loginError,params:[loginFlg:1])
                return
            }
        }
        ////////////////////////没有登录的作为匿名用户 结束

        def canPlay = session.consumer != null
        def canValid = session.valid != null

        def logonFlg = true

        //def directoryList = nts.system.domain.Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"])
		//手机暂不支持文档17
		def directoryList = Directory.findAll("from nts.system.domain.Directory as d where d.parentId=0 and d.showOrder>0 and d.id<>17 order by d.showOrder asc")

        def newsList = null	//nts.system.domain.News.list([max: 4, sort: "id", order: "desc"])			//最新发布公告

        //def newProgramList = nts.program.domain.Program.findAllByState(nts.program.domain.Program.PUBLIC_STATE, [max:8, sort: "id", order: "desc"])		//最新发布节目
		def newProgramList = Program.findAll("from nts.program.domain.Program as a where a.state=:state and a.directory.id<>17  order by a.id asc",[state:Program.PUBLIC_STATE],[max:8])

        def remProgramList = Program.findAllByState(Program.PUBLIC_STATE, [max:5, sort: "recommendNum", order: "desc"])		//推荐节目
        def freProgramList = Program.findAllByState(Program.PUBLIC_STATE, [max:11, sort: "frequency", order: "desc"])		//最热门节目
        def toolsList = null	//nts.system.domain.Tools.list([max: 12, sort: "id", order: "asc"])						//工具下载
        def topicShowNum = null	//nts.system.domain.SysConfig.findByConfigName('TopicShowNum');
        def programTopicList = null	//nts.program.domain.ProgramTopic.findAllByState(nts.program.domain.ProgramTopic.PUBLIC_STATE, [max: topicShowNum?topicShowNum.configValue:3, sort: "id", order: "desc"])	//热点专题
        def channelList = null	//nts.broadcast.domain.Channel.list([max: 10, sort: "dateCreated", order: "desc"])
        def courseBcastList = null	//nts.broadcast.domain.CourseBcast.list([max: 10, sort: "datePlayed", order: "desc"])
        def friendLinkList = null	//nts.system.domain.FriendLink.list([max: 10, sort: "showOrder", order: "desc"])	//外部资源

        def cateProgramList = []
        def cateTopList = []
        //cateTopList.add(nts.program.domain.Program.findAllByState(nts.program.domain.Program.PUBLIC_STATE, [max: 11, sort: "frequency", order: "desc"]))

        directoryList.each {
            cateProgramList.add(Program.findAllByStateAndClassLib(Program.PUBLIC_STATE, it, [max: 8, sort: "id", order: "desc"]))
            //cateTopList.add(nts.program.domain.Program.findAllByStateAndClassLib(nts.program.domain.Program.PUBLIC_STATE, it, [max: 11, sort: "frequency", order: "desc"]))
        }

        [directoryList: directoryList, cateProgramList: cateProgramList, newsList: newsList, newProgramList: newProgramList, remProgramList: remProgramList, freProgramList: freProgramList, canPlay: canPlay, canValid: canValid, loginFlg: logonFlg, toolsList: toolsList, programTopicList: programTopicList, cateTopList: cateTopList, channelList: channelList, courseBcastList: courseBcastList,friendLinkList:friendLinkList]

    }

    // --- login 用户登陆验证方法   0 - 密码错误 1 - 用户不存在  2 - 用户已过期
    def login = {
        //
    }

    def checkLogin = {
        //println '-----------密码--------------------'+EncodePasswd.EncodePasswd(params.name)

        def consumer = Consumer.findByName(params.name)
        if (consumer) {
            def nowDate = getNowDate();
            def dateValid = consumer.dateValid.format("yyy-MM-dd")
            if (nowDate > dateValid) {								// 判断用户是否已过有效期
                redirect(action: 'loginError', params: [loginFlg: 2])
            }
            else if (consumer.isRegister) {								//判断用户是否是锁定状态
                redirect(action: 'loginError', params: [loginFlg:7])
            }
            else if (!consumer.userState) {								//判断用户是否是锁定状态
                redirect(action: 'loginError', params: [loginFlg: 4])
            }
            else {
                //匿名用户不用验证密码了，因为匿名用户用户名密码是硬编码的，如果管理员将匿名密码改了，则不能匿名登录了
                //println consumer.password +"=="+ params.password
                if(consumer.password == params.password || consumer.password == params.password.encodeAsPassword() || consumer.name == 'anonymity') {
                    /*servletContext.programCount = nts.program.domain.Program.countByStateGreaterThan(nts.program.domain.Program.APPLY_STATE)

                    def programPlaySum = nts.program.domain.Program.createCriteria().get {
                        projections {
                            sum "frequency"
                        }
                    }

                    def programDownloadSum = nts.program.domain.Program.createCriteria().get {
                        projections {
                            sum "downloadNum"
                        }
                    }

                    //获取在线人数
                    servletContext.onlineNum = getOnlineNum()

                    //println programViewSum
                    //---获得节目点播次数 sum
                    servletContext.programPlaySum = programPlaySum
                    //---获得节目访问次数 sum
                    servletContext.programDownloadSum = programDownloadSum
                    */
                    if(consumer.name != 'anonymity') {
                        consumer.loginNum = consumer.loginNum + 1
                        consumer.dateLastLogin = new Date()
                        //---将登陆信息写入日志 nts.system.domain.OperationLog
                        new OperationLog(tableName: 'consumer', tableId:consumer.id, operator: consumer.name, modelName: '用户登陆', brief: '登陆操作', operatorId: consumer.id, operation: OperationEnum.LOGIN).save()


                    }

                    session.consumer = consumer

                    /*if(params.from && params.from == "search") {
                        params.remove("name")
                        redirect(action: main, params: params)
                    }
                    else {
                        redirect(action: index)
                    }*/
                }
                else {
                    redirect(action: loginError, params: [loginFlg: 1])
                }
            }
        }
        else {
            redirect(action: loginError, params: [loginFlg: 1])
        }
    }



    //资源详细页面
    def showProgram = {
        long t1=System.currentTimeMillis()
        def program = Program.get( params.id )
        def programList = null
        def consumerList = null
        def otherProgramList = null
        def remarkList = null
        def bAuthOK = true	//是否认证通过
        def fromNodeName = ""
        def fromNode = null	//来源节点
        def isOutPlay = false	//是否来自外部播放，此专指用省图下级节点播放
        def arrOutPlay = null	//福建省图采集外部(子节点):0海报 1播放列表 2批量播放列表

        ////////////////////////没有登录的作为匿名用户 开始
        if(!session.consumer){
            def consumer = Consumer.findByName(servletContext.anonymityUserName)
            //判断用户是否是锁定状态
            if(consumer){
                if (!consumer.userState)	{
                    redirect(action:loginError,params:[loginFlg:4])
                    return
                }
                session.consumer = consumer
            }
            else{
                redirect(action:loginError,params:[loginFlg:1])
                return
            }
        }
        ////////////////////////没有登录的作为匿名用户 结束


        if(program) {
            //纯文库、视音频、图片时直接跳转
            if ((program.otherOption&Program.ONLY_IMG_OPTION)==Program.ONLY_IMG_OPTION){
                return redirect(action:'photoShow',params:[programId:program.id])
            }else if ((program.otherOption&Program.ONLY_TXT_OPTION)==Program.ONLY_TXT_OPTION){
                return  redirect(action:'textLibrary',params:[programId:program.id] )
            }else if ((program.otherOption&0)==0){
            }

            if(program.serials.size()>0){
                Serial serial = programService.serialFirst(program);
                if(serial.urlType==Serial.URL_TYPE_LINK){
                    return redirect(url:serial.filePath);
                }
            }

            if(bAuthOK) {


                //考虑到评论可能很多并可能要分页，故没用program.remarks
                //remarkList = nts.program.domain.Remark.findAllByProgramAndIsPass(program,1,[max:20,sort:'id',order:'desc'])

                //插入到浏览历史表并设置浏览次数if(session.consumer && session.consumer.name != 'anonymity')
                if(session.consumer && servletContext.viewLogOpt == 1) {
                    new ViewedProgram(consumer:session.consumer,program:program).save()
                    def consumerTemp = Consumer.get(session.consumer.id)
                    consumerTemp.viewNum++
                    consumerTemp.save(flush: true)
                }
                //program.viewNum++
                //program.save(flush: true)



                //def topProgramList = nts.program.domain.Program.findAllByStateAndDirectory(nts.program.domain.Program.PUBLIC_STATE,program.directory,[max:10,sort:'frequency',order:'desc']);
                return [program: program,consumerList:consumerList,otherProgramList:otherProgramList,remarkList:remarkList,fromNode:fromNode,isOutPlay:isOutPlay,arrOutPlay:arrOutPlay,t1:t1]
            }
        }
        else {
            flash.message = "program not found with id ${params.id}"
            render "program not found with id ${params.id}"
        }
    }



    //资源浏览 右边资源列表
    def categoryView = {
        //long t1=System.currentTimeMillis()
        if(!params.max) params.max = 20
        if(!params.offset) params.offset = 0
        if(!params.sort) params.sort = 'id'
        if(!params.order) params.order = 'desc'

        def total = 0
        def programList = null
        def directoryId = CTools.nullToZero(params.directoryId)
        def keyword = CTools.nullToBlank(params.keyword).trim()

        //查询条件
        programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            //左边树条件

            if(directoryId > 0) {
                eq("directory.id",(long)directoryId)
            }
			else{
				ne("directory.id",17L)
			}

            //关键词条件
            if(keyword) {
                //资源名称
                //if(type == 1) {
                ilike("name","%${keyword}%")
                //}

            }

            //已入库并发布
            ge("state",Program.PUBLIC_STATE)


        }


        //用于页面上面目录
        def directoryList = null //nts.system.domain.Directory.findAllByParentIdAndShowOrderGreaterThan ( 0,0,[ sort:"showOrder", order:"asc" ])
        def directory = null

        if(directoryId > 0) directory = Directory.get(params.directoryId);

        def offset= CTools.nullToZero(params.offset) + CTools.nullToZero(params.max)
        def args = "directoryId=${params.directoryId}&keyword=${keyword}&max=${params.max}&sort=${params.sort}&order=${params.order}&offset=${offset}"

        return [ programList: programList, total:programList?.totalCount,params:params,directoryList:directoryList,directory:directory,args:args]
    }







    //---新增getNowDate 用来获得“yyyy-MM-DD”格式的日期
    def getNowDate = {
        def date = new Date()
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd")
        def nowDate = dateFormat.format(date)
        return nowDate
    }
}