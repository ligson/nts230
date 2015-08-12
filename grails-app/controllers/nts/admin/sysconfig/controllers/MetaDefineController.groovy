package nts.admin.sysconfig.controllers

import nts.meta.domain.MetaContent
import nts.meta.domain.MetaDefine
import nts.meta.domain.MetaEnum
import nts.program.services.MetaDefineService
import nts.system.domain.Directory
import nts.user.domain.Consumer
import nts.utils.CTools

class MetaDefineController {
    MetaDefineService metaDefineService

    def beforeInterceptor = {
        //if(session.consumer.role != 0) redirect(controller:'index',action:'msg?msg=Access is prohibited')
    }

    def index = {
        //session.consumer = nts.user.domain.Consumer.get(1) //因为没做登录，故先直接登录
        redirect(action: list, params: params)
    }

    def list = {
        //session.consumer = nts.user.domain.Consumer.get(1)//易于测试
        if (!params.max) params.max = 1000
        def metaDefineList = null
        def directoryList = null
        def directoryId = CTools.nullToZero(params.directoryId)

        if (directoryId > 0) {
            def criteria = MetaDefine.createCriteria()
            metaDefineList = criteria.list {
                or {
                    sizeEq("directorys", 0)
                    directorys {
                        eq('id', directoryId.toLong())
                    }
                }
                order("showOrder", "asc")
            }
        } else {
            metaDefineList = MetaDefine.listOrderByShowOrder()
        }

        directoryList = Directory.findAllByParentId(0, [sort: "showOrder", order: "asc"])

        if (flash.createJs) metaDefineService.creatMetaJs()//排序时重新生成js

        [metaDefineList: metaDefineList, directoryList: directoryList, directoryId: directoryId]
    }

    def create = {
        def directoryList = null
        directoryList = Directory.findAllByParentId(0, [sort: "showOrder", order: "asc"])
        [directoryId: params.directoryId, directoryList: directoryList]
    }

    def edit = {
        def directoryList = null
        def metaDefine = MetaDefine.get(params.id)
        if (metaDefine) {
            directoryList = Directory.findAllByParentId(0, [sort: "showOrder", order: "asc"])
            return [metaDefine: metaDefine, directoryList: directoryList, directoryId: params.directoryId]
        } else {
            flash.message = "program not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def delete = {
        MetaDefine metaDefine = MetaDefine.get(params.id)
        if (metaDefine && session.consumer.role == Consumer.SUPER_ROLE) {
            //删除元素下修饰词，手动维护完整性
            if (metaDefine.dataType == "decorate" || metaDefine.dataType == "decorate2") {
                MetaDefine.findAllByParentId(metaDefine.id as int).each {
                    it?.directorys?.toList()?.each { directory ->
                        directory.removeFromMetaDefines(it)
                    }

                    it.delete();
                }
            }

            metaDefine?.directorys?.toList()?.each {
                it.removeFromMetaDefines(metaDefine)
            }
            metaDefine.delete(flush: true)
            metaDefineService.creatMetaJs()
        } else {
            flash.message = "metaDefine not found with id ${id}"
        }

        redirect(action: "list")
    }

    def update = {
        def metaDefine = MetaDefine.get(params.id)
        if (metaDefine && session.consumer.role == Consumer.SUPER_ROLE) {
            def oldPrentId = metaDefine.parentId    //修改前的父ID
            params.maxLength = CTools.nullToZero(params.maxLength)
            params.parentId = CTools.nullToZero(params.parentId)
            params.isNecessary = CTools.nullToZero(params.isNecessary)
            if (params.elementType == '1') params.dataType = "decorate"

            metaDefine.properties = params
            metaDefine.creatorName = session.consumer.name
            metaDefine.dateModified = new Date()

            //设置类库
            def allClass = CTools.nullToOne(params.allClass)
            if (allClass == 0) {
                //删除以前存在的 ,注意参数中不能有名为directorys的参数，否则metaDefine?.directorys不是数据库的对象列表了
                metaDefine?.directorys?.toList().each {
                    it.removeFromMetaDefines(metaDefine)
                }

                //设置类库
                def dirIdList = params.selDirectory
                if (dirIdList instanceof String) dirIdList = [params.selDirectory]
                dirIdList?.each {
                    metaDefine.addToDirectorys(Directory.get(it))
                }
            }

            //设置枚举
            if (metaDefine.dataType == "enumeration") {
                //删除以前存在的
                metaDefine?.metaEnums?.toList().each {
                    it.delete() //不加出现 not-null property
                    metaDefine.removeFromMetaEnums(it)
                }

                def maxEnumId = CTools.nullToZero(params.maxEnumId)
                def dateModified = new Date()
                for (int i = 1; i <= maxEnumId; i++) {
                    def enumId = CTools.strToInt(params."enumId${i}")
                    def enumName = params."enumName${i}"
                    if (enumId >= 0 && enumName) {
                        metaDefine.addToMetaEnums(new MetaEnum(enumId: enumId, name: enumName, dateModified: dateModified))
                    }
                }
            }

            //设置显示状态
            def showType = 0;
            params.showTypeList.each {
                showType += CTools.nullToZero(it)
            }
            metaDefine.showType = showType

            //设置搜索状态
            def searchType = 0;
            params.searchTypeList.each {
                searchType += CTools.nullToZero(it)
            }
            metaDefine.searchType = searchType
            if (metaDefine.save()) {
                metaDefineService.creatMetaJs()
                //如果修饰修饰词更改了父元素，MetaContent表中的parentId也同步修改
                if (oldPrentId != metaDefine.parentId) updateMetaContentParentId(metaDefine)
                redirect(action: "list", params: [directoryId: params.directoryId])
            } else {
                render(view: 'edit', model: [metaDefine: metaDefine])
            }
        } else {
            flash.message = "metaDefine not found with id ${params.id}"
            redirect(action: "edit", id: params.id)
        }
    }

    def save = {
        def metaDefine = new MetaDefine()
        params.maxLength = CTools.nullToZero(params.maxLength)
        params.parentId = CTools.nullToZero(params.parentId)

        if (params.elementType == '1') params.dataType = "decorate"
        if (params.elementType == '3') params.dataType = "decorate2"

        metaDefine.properties = params
        metaDefine.creatorName = session.consumer.name
        metaDefine.dateModified = new Date()

        //设置类库
        def dirIdList = params.selDirectory
        if (dirIdList instanceof String) dirIdList = [params.selDirectory]
        dirIdList?.each {
            metaDefine.addToDirectorys(Directory.get(it))
        }

        //设置枚举
        if (metaDefine.dataType == "enumeration") {
            def maxEnumId = CTools.nullToZero(params.maxEnumId)
            def dateModified = new Date()
            for (int i = 1; i <= maxEnumId; i++) {
                def enumId = CTools.strToInt(params."enumId${i}")
                def enumName = params."enumName${i}"
                if (enumId >= 0 && enumName) {
                    metaDefine.addToMetaEnums(new MetaEnum(enumId: enumId, name: enumName, dateModified: dateModified))
                }
            }
        }

        //设置显示状态
        def showType = 0;
        params.showTypeList.each {
            showType += CTools.nullToZero(it)
        }
        metaDefine.showType = showType

        //设置搜索状态
        def searchType = 0;
        params.searchTypeList.each {
            searchType += CTools.nullToZero(it)
        }
        metaDefine.searchType = searchType

        //设置排序
        def showOrder = MetaDefine.createCriteria().get {
            projections {
                max('showOrder')
            }
        }
        metaDefine.showOrder = CTools.nullToZero(showOrder) + 1

        if (metaDefine.save(flush: true)) {
            metaDefineService.creatMetaJs()
            redirect(action: "list", params: [directoryId: params.directoryId])
        } else {
            //flash.message = message(code:"controller.save")
            render(view: 'create', model: [metaDefine: metaDefine])
        }
    }

    //两个相邻的元数据交换showOrder值，没有直接到list页面，是防止刷新时进行排序
    def setShowOrder = {
        def metaDefine = MetaDefine.get(params.curId)
        def metaDefine2 = MetaDefine.get(params.otherId)
        if (metaDefine && metaDefine2) {
            def showOrder = metaDefine.showOrder
            metaDefine.showOrder = metaDefine2.showOrder
            metaDefine2.showOrder = showOrder
        }

        redirect(action: list, params: params)
        flash.createJs = true
    }

    def getParentMetaOption = {
        //println global
        def options = "<option value=0>-请选择-</option>"
        def metaDefineList = null
        def metaDefine = null
        def allClass = CTools.nullToOne(params.allClass)
        def parentId = CTools.nullToZero(params.parentId)
        def directoryList = params.selDirectory ? params.selDirectory.tokenize(',') : [];

        def criteria = MetaDefine.createCriteria()
        if (allClass == 0) {
            metaDefineList = criteria.list {
                if (params.elementType == "2") {
                    or {
                        eq("dataType", "decorate");
                        eq("dataType", "decorate2");
                    }
                } else {
                    eq("dataType", "decorate");
                }
            }
        } else {
            metaDefineList = criteria.list {
                if (params.elementType == "2") {
                    or {
                        eq("dataType", "decorate");
                        eq("dataType", "decorate2");
                    }
                } else {
                    eq("dataType", "decorate");
                }
                sizeEq("directorys", 0)
            }
        }
        metaDefineList.each {
            if (parentIncludeChild(it.directorys, directoryList)) {
                options += "<option value=${it.id} ${it.id == parentId ? "selected" : ""}>${it.cnName}</option>"
            }
        }
        render options
    }

    //元数据导出到xml
    def metaToXml = {
        def metaDefineList = null
        def metaEnumList = null
        def writer = null
        def xml = null
        def filePath = ''
        def fileName = ''

        metaDefineList = MetaDefine.listOrderByShowOrder()
        metaEnumList = MetaEnum.listOrderByMetaDefine()

        fileName = "meta" + CTools.readNowDateTime('yyyyMMdd') + ".xml";
        filePath = servletContext.getRealPath("/") + "/xml/${fileName}"
        filePath = filePath.replace('\\', '/')//单个字符可全替换
        filePath = filePath.replace('//', '/')//单个字符可全替换
        writer = new FileWriter(new File(filePath))
        writer.write("<?xml version=\"1.0\" encoding=\"GBK\"?>\n");
        xml = new groovy.xml.MarkupBuilder(writer)


        xml.metaData() {
            xml.metaDefines() {
                metaDefineList.each {
                    metaDefine(id: it.id, parentId: it.parentId, libraries: it.directorys, name: it.name, cnName: it.cnName, dataType: it.dataType, defaultValue: it.defaultValue, isNecessary: it.isNecessary, showType: it.showType, searchType: it.searchType, maxLength: it.maxLength, showOrder: it.showOrder, metaEnums: it.metaEnums, dateCreated: it.dateCreated, dateModified: it.dateModified)
                }
            }

            xml.metaEnums() {
                metaEnumList.each {
                    metaEnum(id: it.id, enumId: it.enumId, metaDefineId: it.metaDefine.id, name: it.name)
                }
            }
        }

        render("成功备份到：${filePath}。")
    }

    //获得树目录中的枚举li标签列表
    def getMetaEnumsLiTag(metaDefine) {
        def sHtml = '<ul>'
        if (metaDefine.dataType == "enumeration") {
            metaDefine.metaEnums.each {
                sHtml += '<li class="Child"><img class=s src="../images/tree/sp.gif"><a href="#" onclick="toViewAction(this,1,' + metaDefine.id + ',' + it.enumId + ',0);return false;">' + it.name.encodeAsJavaScript() + '</a></li>'
            }
        }
        sHtml += '</ul>'
        return sHtml
    }

    //同步MetaContent表中的parentId
    def updateMetaContentParentId = { metaDefine ->
        MetaContent.executeUpdate("update nts.meta.domain.MetaContent  set parentId = :parentId  where metaDefine = :metaDefine", [parentId: metaDefine.parentId, metaDefine: metaDefine])
    }

    //检测元数据名称是否已存在
    def checkNameExist = {
        def exist = "not exist"
        def metaDefine = MetaDefine.findByName(params.value)

        if (metaDefine && metaDefine.id != params.id.toLong()) exist = "exist"
        render exist
    }

    //修饰词类库集必须是其父元素类库的子集,因此方法调用很少，不考虑效率
    def parentIncludeChild(parentList, childList) {
        if (parentList.size() > 0) {
            /*childList.each {
                if(!parentList.id.contains(it.toLong())) return false	//不支持 return false
            }*/
            for (it in childList) {
                if (!parentList.id.contains(it.toLong())) return false
            }
        }
        return true
    }
    //---fanjia添加 导航转向空闭包
    def coreMgrIndex = {}
}
