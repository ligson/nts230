<%@ page import="nts.utils.CTools; nts.system.domain.OperationEnum; nts.user.domain.Consumer" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>系统日志</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}">
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/common', file: 'allselect.js')}"></script>
    <style>


    a:link, a:visited {
        font-weight: normal;
    }

    .paginateButtons {
        height: 30px;
    }

    a:hover {
        color: #FF6600;
        font-weight: normal;
    }

    #catetab .curLink {
        color: #f60;
    }

    #progListTab td {
        line-height: 18px;
    }

    .STYLE9 {
        color: #990000;
        font-weight: bold;
        font-size: 12px;
    }
    </style>

    <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
        <!--

        function submitSch() {
            document.form1.submit();
        }

        function onPageNumPer(max) {
            setParams();
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
            changePageImg(${CTools.nullToOne(params.max)});
        }

        function logSearch() {
            form1.action = "operationLogList";
            form1.submit();
        }
        function setParams() {
            form1.searchConsumer.value = "${params.searchConsumer }";
            form1.searchOperation.value = "${params.searchOperation}";
            form1.beginDate.value = "${params.beginDate}";
            form1.endDate.value = "${params.endDate}";
        }
        function deleteLog() {
            if (hasChecked("idList") == false) {
                alert("请至少选择一条日志！");
                return false;
            }

            setParams();
            form1.action = "deleteOperationLog";
            form1.submit();
        }
        function deleteAllLog() {
            if (!confirm('确定删除所查日志?')) {
                return false;
            }

            setParams();
            form1.action = "deleteAllLog";
            form1.submit();
        }
        //-->
        $(function () {
            $("#beginDate").datepicker();
            $("#endDate").datepicker();
        })
    </SCRIPT>
</head>

<body onLoad="init();">
<DIV class="programMgrMain">
    <form name="form1">
        <input type="hidden" name="max" value="${params.max}">
        <input type="hidden" name="offset" value="${params.offset}">
        <input type="hidden" name="sort" value="${params.sort}">
        <input type="hidden" name="order" value="${params.order}">


        <div class="tbsearch" style="margin:10px 0 10px 0; ">
            <table cellSpacing=3 cellPadding=3>
                <tr>
                    <td width="8%" align="center">用户帐号:</td>
                    <td width="15%" align="left"><input type="text" class="admin_default_inp admin_default_inp_size1"
                                                        name="searchConsumer" value=""/></td>
                    <td width="8%" align="center">日志类型:</td>
                    <td width="15%" align="left">
                        <select class="admin_default_inp admin_default_inp_size2" name="searchOperation">
                            <option value="">--操作类型--</option>
                            <g:each in="${OperationEnum}" var="operation">
                                <option value="${operation}">${OperationEnum.cnType[operation.id]}</option>
                            </g:each>
                        </select></td>
                    <td width="8%" align="center">操作时间:</td>
                    <td width="2%" align="center">从</td>
                    <td width="15%" align="left">
                        <input name="beginDate" id="beginDate" readonly="" type="text"
                               class="admin_default_inp admin_default_inp_size1"
                               value=""></td>
                    <td width="2%" align="center">至</td>
                    <td width="15%" align="left"><input name="endDate" id="endDate" readonly="" type="text"
                                                        class="admin_default_inp admin_default_inp_size1" value=""></td>
                    <td width="6%" align="center"><input name="search" type="button" class="admin_default_but_yellow"
                                                         onClick="logSearch()" value="查询"/></td>
                </tr>
            </table>
        </div>

        <div id="tblist">
            <table width="100%"
                   border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff" id="progListTab">
                <tr class="th">
                    <td width="30" align="center">选择</td>
                    <g:sortableColumn align="center" property="tableName" title="操作表名" params="${params}"/>
                    <g:sortableColumn align="center" style="font-weight:normal;" property="tableId" title="操作表ID"
                                      params="${params}"/>
                    <g:sortableColumn align="center" style="font-weight:normal;" property="operator" title="操作人"
                                      params="${params}"/>
                    <g:sortableColumn align="center" style="font-weight:normal;" property="operatorId" title="操作人ID"
                                      params="${params}"/>
                    <g:sortableColumn align="center" style="font-weight:normal;" property="modelName" title="操作模块"
                                      params="${params}"/>
                    <g:sortableColumn align="center" style="font-weight:normal;" property="operation" title="操作类型"
                                      params="${params}"/>
                    <g:sortableColumn align="center" style="font-weight:normal;" property="dateCreated" title="操作时间"
                                      params="${params}"/>
                    <g:sortableColumn align="center" style="font-weight:normal;" property="brief" title="备注"
                                      params="${params}"/>

                </tr>
                <g:each in="${logList}" status="i" var="log">
                    <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                        <td align="center"><g:checkBox name="idList" value="${log.id}" checked=""
                                                       onclick="unCheckAll('selall');"/></td>
                        <td align="center">${log.tableName}</td>
                        <td align="center">${log.tableId}</td>
                        <td align="center">${log.operator}</td>
                        <td align="center">${log.operatorId}</td>
                        <td align="center">${log.modelName}</td>
                        <td align="center">${OperationEnum.cnType[log.operation.id]}</td>
                        <td align="center"><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${log.dateCreated}"/></td>
                        <td align="center">${log.brief}</td>
                    </tr>
                </g:each>
            </table>
    </form>
            <g:if test="${session.consumer.role == Consumer.SUPER_ROLE}">
                <table width="100%"
                       border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff">
                    <tr>
                        <td>
                            <input id="selall" name="selall" onClick="checkAll(this, 'idList')"
                                   type="checkbox">&nbsp;全选&nbsp;
                            <input class="admin_default_but_blue" type="button" value="删除所选"
                                   onClick="deleteLog()"/>&nbsp;
                            <input type="button" class="admin_default_but_blue" value="删除全部"
                                   onClick="deleteAllLog()"/>&nbsp;
                            <a class="admin_default_but_blue" style="color: #FFF"
                               href='exportExecl?searchConsumer=${params.searchConsumer}&searchOperation=${params.searchOperation}&beginDate=${params.beginDate}&endDate=${params.endDate}'>导出EXECL</a>
                        </td>
                    </tr>
                </table>
            </g:if>

            <table width="100%"
                   border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff">
                <tr>
                    <td align="right"><div class="paginateButtons"><g:guiPaginate total="${total}"
                                                                                  params="${params}"/></div></td>
                </tr>
            </table>


</DIV>
</DIV>
</body>
</html>

