<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-8-8
  Time: 上午9:44
--%>

<%@ page import="nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>文档搜索</title>
    <r:require modules="string"/>
    <meta name="layout" content="index">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/default/pc/front/css',file: 'doc_search.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css',file: 'federated_search.css')}">
    <script type="text/javascript">
        var localObj = window.location;
        var contextPath = localObj.pathname.split("/")[1];
        var baseUrl = '';
        if('nts' != contextPath) {
            baseUrl = localObj.protocol + "//" + localObj.host + "/";
        } else {
            baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
        }
        $(function () {
            $("#keyInput").bind("input propertychange", function () {
                var key = $(this).val();
                if (!(key + "").isEmpty()) {
                    $.post(baseUrl + "program/docSuggest", {key: key}, function (data) {
                        var suggestion = $(".f_inp_remin");
                        suggestion.hide();
                        if (data.list !=null &&!(data.list+"").isEmpty() && data.list.length > 0) {
                            suggestion.empty();
                            for (var i = 0; i < data.list.length; i++) {
                                suggestion.append("<a  href='" + baseUrl + "program/docSearch?key=" + data.list[i] + "'>" + data.list[i] + "</a>");
                            }
                            suggestion.show();
                        }
                    });
                }

            });
            $("#keyInput").blur(function () {
                var suggestion = $(".f_inp_remin");
                suggestion.hide();
            });
        });
    </script>
</head>

<body>
    <div class="boful_content">
        <div class="doc_search_header">
            <div class="f_inp_remin" style="display:none;">
            </div>
            <g:form controller="program" action="docSearch">
                <input id="keyInput" autocomplete="off" type="text" name="key" class="doc_srearch_inp" value="${params.key}"/>
                <input type="submit" value="文档搜索" class="doc_srearch_but">
            </g:form>
        </div>
        <div class="doc_search_number">
            总共<span class="sea_num">${total}条</span>,使用时间<span class="sea_time">${useTime}</span>秒
        </div>
        <div class="doc_search_body">
            <div class="doc_search_items">
                <g:each in="${serialModels}" var="serialModel">
                    <div class="doc_search_item">
                        <h1><a href="${createLink(controller:'program',action:'playDocument',params:[programId:serialModel.programId])}" target="_blank">${serialModel.getName()}</a></h1>
                        <p class="doc_search_des"><span class="reource_name"><a href="${createLink(controller:'program',action:'showProgram',params:[id:serialModel.programId])}" target="_blank">${serialModel.programName}</a></span><span class="doc_search_creatname">${serialModel.getDateCreated().format("yyyy-MM-dd HH:mm:ss")}</span><span>${serialModel.getDescription()}</span></p>
                        <p class="doc_search_date"><a href="${createLink(controller:'my',action:'userSpace',params:[id:serialModel.getCreatorId()])}" target="_blank">${consumerName(id:serialModel.getCreatorId())}</a></p>
                        <p class="doc_search_con"> ${CTools.cutString(serialModel.getContent(),300)}</p>

                    </div>
                </g:each>

            </div>

            <div class="f_page">
                <g:guiPaginate controller="program" action="docSearch" total="${total}" params="${params}"/>
            </div>
        </div>
    </div>
</body>
</html>