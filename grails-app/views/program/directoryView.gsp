<%@ page import="nts.utils.CTools; nts.program.domain.Program; nts.system.domain.Directory" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>资源管理</title>
    <link type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'list_style.css')}" rel="stylesheet">
    <link rel="stylesheet" href="${createLinkTo(dir: 'skin/blue/pc/admin/css', file: 'tree.css')}"/>

    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/meta.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/metalist.js')}"></script>


    <meta name="layout" content="index"/>

    <script type="text/javascript" src="${resource(dir: 'js/qinghua', file: 'fenlei.js')}"></script>
    <script type="text/javascript">
        $(function () {
            $("#shid").click(function () {

            })


        })
        function showhide_obj(obj, icon) {
            obj = document.getElementById(obj);
            icon = document.getElementById(icon);
            if (obj.style.display == "none") {
                //指定文档中的对象为div,仅适用于IE;
                div_list = document.getElementsByTagName("div");
                for (i = 0; i < div_list.length; i++) {
                    thisDiv = div_list[i];
                    if (thisDiv.id.indexOf("title") != -1)//当文档div中的id含有list时,与charAt类似;
                    {
                        //循环把所有菜单链接都隐藏起来
                        thisDiv.style.display = "none";
                        icon.innerHTML = "+";
                    }
                }

                myfont = document.getElementsByTagName("font");
                for (i = 0; i < myfont.length; i++) {
                    thisfont = myfont[i];
                }
                icon.innerHTML = "-";
                obj.style.display = ""; //只显示当前链接
            }
            else {
                //当前对象是打开的，就关闭它;
                icon.innerHTML = "+";
                obj.style.display = "none";
            }
        }

        function submitSch() {
            document.form1.offset.value = 0;
            document.form1.submit();
        }

        function resetSearch() {
            var params = "max=${params.max}&category=${params.category}&metaId=${params.metaId}&enumId=${params.enumId}&isAll=${params.isAll}&enumId2=${params.enumId2}";
            document.location.href = baseUrl + "program/directoryView?" + params;
        }

        function onPageNumPer(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;
            submitSch();
        }

        //如果右边页面用类库(目录) 则metaId2是目录ID，enumId2为0 名称后缀2表示是右边的类别,如此设计是为了用户如果...
        function categorySch(metaId2, enumId2) {
            document.form1.metaId2.value = metaId2;
            document.form1.keyword.value = "";//点击时不使用搜索条件
            submitSch();
        }

        function init() {
            document.form1.type.value = "${CTools.nullToOne(params.type)}";
            changePageImg(${CTools.nullToOne(params.max)});
        }

        function yearSearch(year) {
            form1.year.value = year;
            form1.offset.value = "";
            form1.submit();
        }
    </script>

    <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
        <!--
        var metaList = [];//当前类
        var directoryList = [];//目录
        var selectedLink = null;//当前选中的树节点
        var simpleSearchMeta = ['title', 'creator'];//简单检索元素名


        function init() {
            //setCurMetaList(0,4,-1);//4分类浏览
            metaList = allMetaList;
            //setSchOptions();
            showTree();
        }

        $(function () {
            init();
        });
        function showTree() {
            document.getElementById("CategoryTree").innerHTML = treeHtml;//getDirectoryLi()+treeHtml;
            //alert(document.getElementById("CategoryTree").innerHTML);
        }

        //参数：linkObj,category(浏览类别：0库 1元数据),metaId(在库浏览中是directoryId,在元数据是metaId),enumId(元数据枚举值)
        function toViewAction(linkObj, category, metaId, enumId, isAll) {
            if (selectedLink) selectedLink.className = "";
            linkObj.className = "curLink";
            selectedLink = linkObj;
            changeStatus(linkObj);

            if ($(linkObj).find('img').length == 0) {
                location.href = baseUrl + 'program/directoryView?category=' + category + '&metaId=' + metaId + '&enumId=' + enumId + '&isAll=' + isAll + '&canPublic=${CTools.nullToZero(params.canPublic)}';
            }
            if ($(linkObj).find('img').length == 0) {
                location.href = baseUrl + 'program/directoryView?category=' + category + '&metaId=' + metaId + '&enumId=' + enumId + '&isAll=' + isAll + '&canPublic=${CTools.nullToZero(params.canPublic)}';
            }
        }

        function changeStatus(o) {
            if (o.parentNode && (o.parentNode.className == "Opened" || o.parentNode.className == "Closed")) {
                o.parentNode.className = (o.parentNode.className == "Opened") ? "Closed" : "Opened";
            }
        }

        function getDirectoryLi() {
            var libName = '${Directory.cnTableName}';
            var tree = '<ul>';
            tree += '<li class="Closed"><a href="#" onclick="toViewAction(this,0,0,0,1);return false;"><img class="s" src="../images/tree/sp.gif">' + libName + '</a>';
            tree += '<ul>';
            for (var i = 0; i < directoryList.length; i++) {
                tree += '<li class="Child"><img class="s" src="../images/tree/sp.gif"><a href="#" onclick="toViewAction(this,0,' + directoryList[i].id + ',0,0);return false;">' + directoryList[i].name + '</a></li>';
            }
            tree += '</ul>';
            tree += '</li>';
            tree += '</ul>';
            return tree;
        }

        //目录数据
        <g:each in="${directoryList}" status="i" var="directory">
        directoryList[${i}] = new CDirectoryTypeObj(${directory.id}, '${directory.name.encodeAsJavaScript()}');
        </g:each>

        //-->
    </SCRIPT>
</head>

<body>
<div id="contentA" class="area areabg1">
    <div class="left areabg ">
        <div class="indexMenu bord clear">
            <h2 style="text-align:left"><span>多媒体资源库浏览</span></h2>

            <div id="CategoryTree" class="TreeMenu" style="width:208px;height:780px;overflow:auto;text-align:left;">
            </div>
        </div>
    </div>

    <div class="right areabg">
        <div class="seleRe bord clear">
            <div class="l">%{--${directoryList.get(0).name}--}%</div>

            <div class="c">
                <div class="cc ll">共有 <span>${total}</span> 个符合条件的资源</div>
            </div>

            <div class="r">%{--<a href="#" onclick="resetSearch();">重置筛选</a>--}%</div>
        </div>

        <div class="seaKey bord clear" id="seaKey">
            <form name="form1" method="POST" action="directoryView">
                <input type="hidden" name="max" value="${params.max}">
                <input type="hidden" name="offset" value="${params.offset}">
                <input type="hidden" name="sort" value="${params.sort}">
                <input type="hidden" name="category" value="${params.category}">
                <input type="hidden" name="metaId" value="${params.metaId}">
                <input type="hidden" name="enumId" value="${params.enumId}">
                <input type="hidden" name="isAll" value="${params.isAll}">
                <input type="hidden" name="metaId2" value="${params.metaId2}">
                <input type="hidden" name="enumId2" value="${params.enumId2}">
                <input type="hidden" name="year" value="${params.year}">

                <div class="input-append right" style="margin-top:10px;">
                    资源搜索：
                    <select name="type" style="border:1px solid #dddddd;width:120px;">
                        <option value="1" ${"1".equals(params.type) ? "selected" : ""}>${Program.cnField.name}</option>
                        <option value="2" ${"2".equals(params.type) ? "selected" : ""}>${Program.cnField.actor}</option>
                        <option value="4" ${"4".equals(params.type) ? "selected" : ""}>${Program.cnField.programTags}</option>
                        <option value="5" ${"5".equals(params.type) ? "selected" : ""}>${Program.cnField.description}</option>
                    </select>
                    <input type="text" name="keyword" id="name" size="50" value="${params.keyword}"
                           style="margin-right:-1px;"/>
                    <button onclick="submitSch();" class="btn" type="button">搜索</button>
                </div>
            </form>
            <ul>
                <li><span>类库：</span></li>
                <li class="${CTools.nullToZero(params.metaId2) == 0 ? 'now' : ''}"><a href="#"
                                                                                      onclick="categorySch(0, 0);
                                                                                      return false;">全部</a></li>
                <g:each in="${directoryList}" status="i" var="directory">
                    <li class="${directory.id == CTools.strToInt(params.metaId2) ? 'now' : ''}"><a href="#"
                                                                                                   onclick="categorySch(${directory.id});
                                                                                                   return false;">${directory.name}</a>
                    </li>
                </g:each>
            </ul>
            <ul>
                <g:set var="currentdate" value="${Calendar.getInstance()}"/>
                <li><span>年份：</span></li>
                <li class= ${Integer.parseInt(params.year) == 0 ? 'now' : ''}><a href="#"
                                                                                 onclick="yearSearch(0);">全部</a></li>
                <li class= ${Integer.parseInt(params.year) == currentdate.get(Calendar.YEAR) ? 'now' : ''}><a href="#"
                                                                                                              onclick="yearSearch(${currentdate.get(Calendar.YEAR)});">${currentdate.get(Calendar.YEAR)}</a>
                </li>
                <li class= ${Integer.parseInt(params.year) == (currentdate.get(Calendar.YEAR) - 1) ? 'now' : ''}><a
                        href="#"
                        onclick="yearSearch(${currentdate.get(Calendar.YEAR)-1});">${currentdate.get(Calendar.YEAR) - 1}</a>
                </li>
                <li class= ${Integer.parseInt(params.year) == (currentdate.get(Calendar.YEAR) - 2) ? 'now' : ''}><a
                        href="#"
                        onclick="yearSearch(${currentdate.get(Calendar.YEAR)-2});">${currentdate.get(Calendar.YEAR) - 2}</a>
                </li>
                <li class= ${Integer.parseInt(params.year) == (currentdate.get(Calendar.YEAR) - 3) ? 'now' : ''}><a
                        href="#"
                        onclick="yearSearch(${currentdate.get(Calendar.YEAR)-3});">${currentdate.get(Calendar.YEAR) - 3}</a>
                </li>
                <li class= ${Integer.parseInt(params.year) == (currentdate.get(Calendar.YEAR) - 4) ? 'now' : ''}><a
                        href="#"
                        onclick="yearSearch(${currentdate.get(Calendar.YEAR)-4});">${currentdate.get(Calendar.YEAR) - 4}</a>
                </li>
                <li class= ${Integer.parseInt(params.year) == (-(currentdate.get(Calendar.YEAR) - 4)) ? 'now' : ''}><a
                        href="#" onclick="yearSearch(${-(currentdate.get(Calendar.YEAR)-4)});">更早</a></li>
            </ul>
            <ul>
                <li><span>排序：</span></li>
                <li class="${'id'.equals(params.sort) ? 'now' : ''}"><g:sortableHref property="id"
                                                                                     title="${Program.cnField.dateCreated}"
                                                                                     params="${params}"/></li>
                <li class="${'name'.equals(params.sort) ? 'now' : ''}"><g:sortableHref property="name"
                                                                                       title="${Program.cnField.name}"
                                                                                       params="${params}"/></li>
            </ul>
        </div>

        <div class="shLay" id="shid"></div>

        <div class="hdLay" style="display: none"></div>

        <div class="input-append right" style="margin-top:10px;"></div>

        <div class="menuC">
            <div class="l">
                <ul>
                    <li class="libg">相关资源</li>
                </ul>
            </div>

            <div class="taglist"><span onclick="lvs(2)" id="ltA" class="ltA" title="海报">海报</span> <span onclick="lvs(1)"
                                                                                                        title="列表"
                                                                                                        id="lzA"
                                                                                                        class="lzB">列表</span>
            </div>
        </div>

        <div class="jumpA clear" style="margin-bottom:10px;margin-right:5px;">
            <div class="r">
                <g:if test="${Integer.parseInt(params.offset) > 0}">
                    <a href="${createLink(controller: 'program', action: 'directoryView', params: [max: params.max, offset: Integer.parseInt(params.offset) - Integer.parseInt(params.max), sort: params.sort, order: params.order, category: params?.category, canPublic: params?.canPublic, metaId: params?.metaId, enumId: params?.enumId, isAll: params?.isAll])}"
                       class="pa">上一页</a>
                </g:if>
                <g:else>上一页</g:else>
                ${Integer.parseInt(params.offset) / Integer.parseInt(params.max) + 1}/${Math.round(Math.ceil(total / Integer.parseInt(params.max)))}
                <g:if test="${total - Integer.parseInt(params.offset) > Integer.parseInt(params.max)}">
                    <a href="${createLink(controller: 'program', action: 'directoryView', params: [max: params.max, offset: Integer.parseInt(params.offset) + Integer.parseInt(params.max), sort: params.sort, order: params.order, category: params?.category, canPublic: params?.canPublic, metaId: params?.metaId, enumId: params?.enumId, isAll: params?.isAll])}"
                       class="pa">下一页</a>
                </g:if>
                <g:else>下一页</g:else>
            </div>
        </div>

        <div class="clear" id="videoData">
            <!-- *******一组<div class="vData clear">有4个内容--开始  循环<div class="vData clear">..</div>即可多组显示***** -->
            <div class="vData clear">

            <!-- *******单个内容显示开始 且<div class="vInfo">单个内容</div>只能放3个内容为一排***** -->
                <g:each in="${programList ?}" status="i" var="program">
                    <div class="vInfo">
                        <div class="vPic" style="z-index: 1;"><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                                                 target="_blank"><img
                                    src="${posterLinkNew(program: program, size: '120x80')}" width="120"
                                    height="80" alt="" title="${program.name}"
                                    onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'">
                        </a>
                            <span class="gq_ico"></span>
                            %{--<div style="display:none" class="popInfo">
                                <div class="popBG"></div>
                                <div class="popLay">
                                    <h4><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}" target="_blank">${nts.utils.CTools.cutString(fieldValue(bean:program, field:'name'),22)}</a></h4>
                                    <p>${nts.utils.CTools.cutString(fieldValue(bean:program, field:'description'),114)}&nbsp<a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}" title="${fieldValue(bean:program, field:'description')}" target="_blank">[详细]</a></p>
                                </div>
                            </div>--}%
                        </div>

                        <div class="vTxt" style="text-align:center;">
                            <h4 style="font-size: 12px;text-align: center;line-height: 22px;"><a
                                    href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}" target="_blank"
                                    title="${fieldValue(bean: program, field: 'name')}">${CTools.cutString(fieldValue(bean: program, field: 'name'), 7)}</a>
                            </h4>

                            <p style="text-align:left;margin:0;padding:0;">主要责任者：${CTools.cutString(fieldValue(bean: program, field: 'actor'), 3)}</p>

                            <p style="text-align: left;margin:0;padding:0;">总播放：<em>${fieldValue(bean: program, field: 'frequency')}次</em>
                            </p>
                            <!-- 增加开始 -->
                            <dl style="text-align:left">
                                <dd>总播放：<em>${fieldValue(bean: program, field: 'frequency')}次</em></dd>
                                <dd>年份：2011</dd>
                                <dd>主要责任者：${CTools.cutString(fieldValue(bean: program, field: 'actor'), 12)}</dd>
                            </dl>

                            <p class="detail">${CTools.cutString(CTools.htmlToBlank(fieldValue(bean: program, field: 'description')), 114)}&nbsp<a
                                    href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                    title="${CTools.htmlToBlank(fieldValue(bean: program, field: 'description'))}" target="_blank">[详细]</a>
                            </p>
                            <h5><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}" target="_blank">播 放</a></h5>
                            <!-- 增加结束 -->
                        </div>
                    </div>
                </g:each>
            </div>
            <!-- *******一组<div class="vData clear">有4个内容--结束***** -->
            <div class="vData clear"></div>
        </div>

        <div class="jumpB clear">
            <div class="xb_pages" align="right" style="height: 40px;">
                <g:guiPaginate controller="program" action="directoryView" total="${total}" params="${params}"
                               maxsteps="8"/>
            </div>
        </div>

    </div>
</div>
</body>
</html>