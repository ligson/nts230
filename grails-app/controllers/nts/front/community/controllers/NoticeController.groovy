package nts.front.community.controllers

import nts.commity.domain.Notice
import nts.commity.domain.StudyCommunity
import nts.system.domain.LogsPublic
import nts.utils.CTools

import java.util.Date;

class NoticeController {

  //  static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
		if(!params.max) params.max = 12
		if(!params.sort) params.sort = 'dateCreated'
		if(!params.order) params.order = 'desc'
		if(!params.offset) params.offset = 0
		session.communityMenuId = 2
		session.classLibId = CTools.nullToOne(params.classLib?.id)//nullToZero

		def setCount = 0
		if (params.pageIndex!=null&&params.pageIndex!="")
		{
			setCount = params.max.toInteger() * (params.pageIndex.toInteger()-1)
		}
		if(params.pageIndex==null||params.pageIndex=="") params.pageIndex=1

		def noticeList = Notice.createCriteria().list(max: params.max, offset: setCount, sort: "dateCreated",order: "desc") {
			studyCommunity {
				eq("id", CTools.nullToZero(session.communityId).longValue())
			}
		}

		def total = noticeList.totalCount
		def pageCount = Math.round(Math.ceil(total / params.max.toInteger()))
		if (params.listType!=null&&params.listType=="lump")
		{
			render(view: params.listType, model: ["noticeList": noticeList, "total": total, "pageIndex": params.pageIndex.toInteger(), "pageCount": pageCount, 'params': params])
			return 
		}
		if (params.toPage!=null&&params.toPage!="")
		{
			session.communityMenuId = 8
			session.communityManagerMenuId = 3
			render(view: params.toPage, model: ["noticeList": noticeList, "total": total, "pageIndex": params.pageIndex.toInteger(), "pageCount": pageCount, 'params': params])
			return 
		}
		["noticeList": noticeList, "total": total, "pageIndex": params.pageIndex.toInteger(), "pageCount": pageCount, 'params': params]
    }

	def save = {
		def communityId = session.communityId
		def studyCommunity = StudyCommunity.get(communityId)
		def notice = new Notice(
			name: params.name,								//公告名字
			description: params.description,					//描述
			dateCreated: new Date(),
			studyCommunity: studyCommunity
		)		
		studyCommunity.addToNotices(notice)
		if(!notice.hasErrors() && notice.save()) {
			flash.message = "公告 ${notice.name} 创建成功"
			String photo = session.consumer?.photo==null||session.consumer?.photo==""?"/images/default.gif":session.consumer?.photo
			def logsDescription = "<li><div class='qc01l'><img src='"+photo+"' class='qimg' /><a href='javascript:void(0)' onclick='sendMessage("+session.consumer.id+")' class='g3f'>发送消息</a></div><div class='qc01r'>"+session.consumer.name+"&nbsp;&nbsp;发布了公告<a href='/notice/show?id="+notice.id+"' class='gblue qck qh2'>查看</a><p>"+params.name+"</p></div></li>"
			def logsPublic = new LogsPublic(
				studyCommunity_id: communityId,
				description: logsDescription,
				dateCreated: new Date(),
				type: LogsPublic.type_notice,
				typeId: notice.id
			)
			if (!logsPublic.hasErrors() && logsPublic.save()) {
				flash.message = "动态创建成功"
			}
			redirect(action:list, params: params)
		}
		else {
			flash.message = "公告创建失败"
			redirect(action:list, params: params)
		}
	}

    def show = {
        def noticeInstance = Notice.get(params.id)
        if (!noticeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tools.label', default: 'nts.system.domain.Tools'), params.id])}"
            redirect(action: "list", params: params)
        }
        else {
            [noticeInstance: noticeInstance, 'params': params]
        }
    }

    def edit = {
        def noticeInstance = Notice.get(params.id)
        if (!noticeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tools.label', default: 'nts.system.domain.Tools'), params.id])}"
            redirect(action: "show", params: params)
        }
        else {
            return [noticeInstance: noticeInstance, 'params': params]
        }
    }

    def update = {
        def noticeInstance = Notice.get(params.id)
        if (noticeInstance!=null) {
            noticeInstance.properties = params
            if (!noticeInstance.hasErrors() && noticeInstance.save(flush: true)) {
                flash.message = "修改完成"
				params.id = noticeInstance.id
				if (params.noticeType)
				{
					redirect(action: params.noticeType, params: params)
				}
                redirect(action: "list", params: params)
            }
        }
    }

    def delete = {
        def notice = Notice.get(params.delId)
        if (notice) {
            try {				
                notice.delete(flush: true)
				//删除日志
				deleteLogsPublic(LogsPublic.type_notice, notice.id)
                flash.message = "删除完成"				
                redirect(action: "list", params: params)
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "删除失败"
                redirect(action: "list", params: params)
            }
        }
        else {
            flash.message = "没有找不到该公告"
            redirect(action: "list", params: params)
        }
    }

	//批量删除
	def deleteNoticeList = {
		def delIdList = params.idList
		
		if(delIdList instanceof String) delIdList = [params.idList]

		delIdList?.each { id ->
			def notice = Notice.get(id)
			if (notice) {
				try {
					notice.delete(flush: true)
					//删除日志
					deleteLogsPublic(LogsPublic.type_notice, notice.id)
					flash.message = "删除完成"
				}
				catch (org.springframework.dao.DataIntegrityViolationException e) {
					flash.message = "删除失败"
				}
			}
		}

		redirect(action: "list", params: params)
	}

	//删除日志
	def deleteLogsPublic(def type, def typeId) {
		def logsPublicList = null
		if (type&&typeId)
		{
			logsPublicList = LogsPublic.createCriteria().list(max: 1) {
				eq("type", (""+type).toInteger())
				eq("typeId", (""+typeId).toInteger())
			}
		}
		if (logsPublicList&&logsPublicList!=[]&&logsPublicList[0]) {
			def logsPublic = logsPublicList[0]
			try {
				logsPublic.delete(flush: true)
				flash.message = "删除完成"
				return true;
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "删除失败"
				return false;
			}
		}
	}

}
