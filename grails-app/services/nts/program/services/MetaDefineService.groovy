package nts.program.services

import com.boful.nts.utils.SystemConfig
import grails.converters.JSON
import nts.meta.domain.MetaContent
import nts.meta.domain.MetaDefine
import nts.meta.domain.MetaEnum
import nts.program.domain.Program
import nts.system.domain.Directory
import nts.user.domain.Consumer
import nts.utils.BfConfig
import nts.utils.CTools

class MetaDefineService {

    boolean transactional = true
    def utilService;
   
	//获得 标题列中元数据ID，标题列形如：资源原名(8)
	def creatMetaJs() {	
		//def filePath = SystemConfig.webRootDir+"/js/metalist.js"
		//filePath = filePath.replace('\\','/')
		//filePath = filePath.replace('//','/')

		def outFile = new File(SystemConfig.webRootDir,"js/metalist.js");
		if(outFile.exists()) outFile.delete()
		def printWriter = outFile.newPrintWriter('UTF-8')
		List<MetaDefine> metaDefineList = MetaDefine.listOrderByShowOrder()

		//元数据js对象
		printWriter.println("var allMetaList = [];")
		metaDefineList.eachWithIndex {MetaDefine metaDefine, i ->
			printWriter.println("allMetaList[${i}] = new CMetaTypeObj(${metaDefine.id}, ${metaDefine.parentId},'${metaDefine.name}','${metaDefine.cnName.encodeAsJavaScript()}','${metaDefine.dataType}',${metaDefine.showOrder},${metaDefine.isNecessary},${metaDefine.showType},${metaDefine.searchType},${metaDefine.directorys*.id},'${CTools.nullToBlank(metaDefine.defaultValue)}',${metaDefine.maxLength},null,0,${i});")
			if(metaDefine.dataType == 'enumeration') {
				printWriter.println("allMetaList[${i}].arrEnum = [];")
				metaDefine.metaEnums.eachWithIndex {MetaEnum metaEnum, j ->
				printWriter.println("allMetaList[${i}].arrEnum[${j}] = new CEnumTypeObj(${metaEnum.enumId},'${metaEnum.name.encodeAsJavaScript()}');")
				}
			}
		}

		//元数据树目录列表
		def tree = ""
        /*
		metaDefineList?.each{MetaDefine ele ->
			//元数据树目录列表
			if(ele.parentId == 0 && (ele.showType & 4) == 4 && (ele.dataType == "decorate" || ele.dataType == "enumeration")) {
				tree += '<ul>'
				//tree += '<li class="Closed"><a href="#" onclick="toViewAction(this,1,'+ele.id+',0,1);return false;"><img class=s src="../images/tree/sp.gif">'+ele.cnName.encodeAsJavaScript()+'('+getProgramNum(ele,-1)+')</a>'
				tree += '<li class="Closed"><a href="#" onclick="toViewAction(this,1,'+ele.id+',0,1);return false;"><img class=s src="/images/tree/sp.gif">'+ele.cnName.encodeAsJavaScript()+'</a>'

				if(ele.dataType == "decorate") { 
					tree += '<ul>'
					metaDefineList.each{ deco ->
						if(deco.parentId == ele.id) {
							tree += '<li class="Closed"><a href="#" onclick="toViewAction(this,1,'+deco.id+',0,0);return false;"><img class=s src="/images/tree/sp.gif">'+deco.cnName.encodeAsJavaScript()+'('+getProgramNum(deco,-1)+')</a>'
							tree += getMetaEnumsLiTag(deco)
							tree += '</li>'
						}
					}
					tree += '</ul>'
				}
				else {
					tree += getMetaEnumsLiTag(ele)
				}
				
				tree += '</li>'
				tree += '</ul>'
			}

		}
		*/
        tree += '['
        metaDefineList?.each{MetaDefine ele ->
            //元数据树目录列表
            if((ele.showType & 4) == 4 && (ele.dataType == "decorate" || ele.dataType == "enumeration")) {
                tree += '{id:'+ele.id+', pid:'+ele.parentId+', name:"'+ele.cnName+'",enumId:0},'

                if(ele.dataType=="enumeration"){
                    tree += findMetaEnumsLiTag2(ele)
                }
                /*if(ele.dataType == "decorate") {
                    metaDefineList.each{ deco ->
                        String html = '{id:'+deco.id+', pid:'+ele.id+', name:"'+deco.cnName+'",enumId:0},';
                        if(!tree.contains(html)&&deco.parentId){
                            tree += html;
                        }
                    }
                }else if(ele.dataType == "enumeration") {
                    tree += findMetaEnumsLiTag2(ele)
                }*/
            }
        }
        if(tree.lastIndexOf(',') == tree.length()-1){
            tree = tree.substring(0, tree.lastIndexOf(','))
        }
        tree += ']'
		printWriter.println("")
		printWriter.println("var treeNodes="+tree+";")

		printWriter.flush()
		printWriter.close()
	}


	//获得树目录中的枚举li标签列表
	def getMetaEnumsLiTag(metaDefine) {
		def sHtml = '<ul>'
		if(metaDefine.dataType == "enumeration") {
			metaDefine.metaEnums.each {
				sHtml += '<li class="Child"><img class=s src="/images/tree/sp.gif"><a href="#" onclick="toViewAction(this,1,'+metaDefine.id+','+it.enumId+',0);return false;">'+it.name.encodeAsJavaScript()+'('+getProgramNum(metaDefine,it.enumId)+')</a></li>'
			}
		}
		sHtml += '</ul>'
		return sHtml
	}

    def findMetaEnumsLiTag2(metaDefine) {
        def tree = ''
        if(metaDefine.dataType == "enumeration") {
            metaDefine.metaEnums.each {
                tree += '{id:"enum_'+it.id+'",pid:'+metaDefine.id+',name:"'+it.name.encodeAsJavaScript()+'",enumId:'+it.enumId+'},'
            }
        }
        return tree
    }

	//获得每个元数据的资源数
	def getProgramNum(metaDefine,enumId) {
		def programNum = 0
		def c = Program.createCriteria()
	
		programNum = c.get {
			projections {
				countDistinct("id")
			}
			metaContents {
				if(metaDefine.parentId > 0 || (metaDefine.parentId == 0 && metaDefine.dataType == "enumeration" && enumId > 0)) {
					eq("metaDefine",metaDefine)
					//eq("metaDefine",metaDefine)
					if(enumId > 0) eq("numContent",enumId)
				}
			}

			ge("state",Program.CLOSE_STATE)
		}

		return programNum
	}


    public Map createMetaDefine(Map params){
        def metaDefine = new MetaDefine()
        params.maxLength = CTools.nullToZero(params.maxLength)
        params.parentId = CTools.nullToZero(params.parentId)

        if (params.elementType == '1') params.dataType = "decorate"
        if (params.elementType == '3') params.dataType = "decorate2"

        metaDefine.properties = params
        metaDefine.creatorName = utilService.getSession().consumer.name
        metaDefine.dateModified = new Date()

        //设置类库
        def dirIdList = params.selDirectory
        if (dirIdList instanceof String) dirIdList = [params.selDirectory]
        dirIdList?.each {
            metaDefine.addToDirectorys(Directory.get(it as long))
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

        def result = [:];
        if (metaDefine.save(flush: true)) {
            creatMetaJs()
            result.success = true;
            result.directoryId = params.directoryId;
        } else {
            result.success = false;
            result.metaDefine = metaDefine;
            //flash.message = message(code:"controller.save")
        }
        return  result;
    }

    public Map findParentMetaOption(Map params){
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

        def result = [:];
        result.success = true;
        result.elements = [];
        metaDefineList.each {
            if (parentIncludeChild(it.directorys, directoryList)) {
                //options += "<option value=${it.id} ${it.id == parentId ? "selected" : ""}>${it.cnName}</option>"
                def tmp = [:];
                tmp.id = it.id;
                tmp.name = it.cnName;
                tmp.selected = (it.id == parentId);
                result.elements.add(tmp);
            }
        }
        return result;
    }

    //修饰词类库集必须是其父元素类库的子集,因此方法调用很少，不考虑效率
    private static boolean parentIncludeChild(Set<Directory> parentList, List<String> childList) {
        if (parentList.size() > 0) {
            for (it in childList) {
                if (!parentList*.id.contains(it.toLong())) return false
            }
        }
        return true
    }

    public Map metaDefineDelete(Map params){
        def result=[:];
        def idList=params.idList;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            MetaDefine metaDefine = MetaDefine.get(it)
            if (metaDefine && params.consumer.role == Consumer.SUPER_ROLE) {
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
                metaDefine?.metaContents?.toList()?.each {
                    if(it.program){
                        it.program.removeFromMetaContents(it);
                    }
                    it.delete();
                    metaDefine.removeFromMetaContents(it);
                }

                metaDefine.delete();
                //creatMetaJs();
                result.success=true;
                result.msg="删除成功！";
            } else {
                result.success=false;
                result.msg = "metaDefine not found with id ${it}"
            }

        }
        return result
    }

    public Map metaDefineUpdate(Map params){
        def result=[:];
        MetaDefine metaDefine=params.metaDefine;
        def oldPrentId = metaDefine.parentId    //修改前的父ID
        params.maxLength = CTools.nullToZero(params.maxLength)
        params.parentId = CTools.nullToZero(params.parentId)
        params.isNecessary = CTools.nullToZero(params.isNecessary)
        if (params.elementType == '1') params.dataType = "decorate"

        metaDefine.properties = params
        metaDefine.creatorName = params.consumer.name
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
            creatMetaJs();
            //如果修饰修饰词更改了父元素，MetaContent表中的parentId也同步修改
            if (oldPrentId != metaDefine.parentId) updateMetaContentParentId(metaDefine)
            result.isFlag=1;
        } else {
            result.isFlag=2;
        }
        return result
    }

    public void updateMetaContentParentId(MetaDefine metaDefine){
        MetaContent.executeUpdate("update nts.meta.domain.MetaContent  set parentId = :parentId  where metaDefine = :metaDefine", [parentId: metaDefine.parentId, metaDefine: metaDefine])
    }

    public List<MetaContent> listMetaContentByMetaDefine(params){
        List<MetaContent> metaContentList = []
        def metaDefine = MetaDefine.get(params.id as Long)
        metaContentList = MetaContent.findAllByMetaDefine(metaDefine)
        return metaContentList
    }
}
