<%@ page import="nts.system.domain.QnaireQuestion" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>网络教学资源发布系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'reset.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'style_my.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'invalid.css')}" type="text/css"/>
    <script type="text/javascript">

        //参数问题ID
        function getQuestionTitle(id) {
            var title = "";
            var nPos = 0;

            var tdObj = document.getElementById("qtd_" + id);
            title = tdObj.innerHTML;
            nPos = title.indexOf(".");
            if (nPos > 0) title = title.substring(0, nPos);

            return title;
        }

        function check() {
            var theInput = null;
            var j = 0;

            for (var i = 0; i < form1.elements.length; i++) {
                theInput = form1.elements[i];
                if (theInput.name.indexOf("question_") != -1) {

                    var obj = document.getElementsByName(theInput.name);
                    for (j = 0; j < obj.length; j++) {

                        if (obj[j].checked) break;
                    }

                    if (j == obj.length) {
                        alert("您还未对 " + getQuestionTitle(theInput.name.substring(9)) + " 做出选择, 请选择。");
                        return false;
                    }
                }

            }

            return true;
        }

    </script>

</head>

<body>
<!--
<g:form action="qnaireSave" method="post" name="form1" onsubmit="return check();">
    <g:hiddenField name="id" value="${qnaire?.id}"/>

    <div class="x_daohang">
		<p>当前位置：<a href="${createLink(controller: 'my', action: 'myInfo')}">个人空间</a>>><a href="${createLink(controller: 'my', action: 'myQnaireList')}">问卷调查</a>>> 问卷</p>
	</div>    
		<div class="body" style="width:97%">
			
            <div class="dialog">
                <table style="width:100%; margin-top:4px;">
                    <tbody>
						<tr>
                            <td style="font-size:16px;line-height:25px;" align="center">${fieldValue(bean: qnaire, field: "name")}</td>
                        </tr>
						<tr>
                            <td style="font-size:12px;line-height:16px;padding:0px 0px 8px 2px;" align="center">发布人：${qnaire.consumer.nickname}&nbsp;发布日期：<g:formatDate
        format="yyyy-MM-dd HH:mm:ss" date="${qnaire?.datePublished}"/></td>
                        </tr>
						<tr>
                            <td valign="top" style='padding-left:25px; padding-right:25px; padding-bottom:10px;line-height:120%'>
								&nbsp;&nbsp;&nbsp;&nbsp;${fieldValue(bean: qnaire, field: "description")}
    </td>
</tr>

    <g:each in="${qnaire.qnaireQuestions}" var="question" status="i">
        <tr><td style="padding:0px 40px 0px 40px"><div style="margin:1px;height:1px;border-top: 1px solid #ccc;"></div></td></tr>
        <tr class="prop">
            <td valign="top" id="qtd_${question?.id}" class="question">
									问题${i + 1}.&nbsp;${fieldValue(bean: question, field: "question")}&nbsp;(${typeTitles[question.type]})
								</td>
							</tr>
							<tr class="prop">
								<td valign="top" style="text-align: left; padding-left:71px;padding-top:4px;padding-bottom:4px" class="value">
        <g:each in="${question?.qnaireOptions ?}" var="option" status="j">
            <g:if test="${question.type == QnaireQuestion.RADIO_TYPE}">
                <input type="radio" class="radioCss" name="question_${question?.id}" value="${option.id}">
            </g:if>
            <g:if test="${question.type == QnaireQuestion.CHECK_BOX_TYPE}">
                <input type="checkbox" class="radioCss" name="question_${question?.id}" value="${option.id}">
            </g:if>
            ${fieldValue(bean: option, field: "optionText")}<br>
        </g:each>
        </td>
    </tr>

    </g:each>
    </tbody>
</table>
</div>
<div class="buttons" style="padding-bottom:5px; padding-right:20px;">
    <input type="submit" class="save" value="提交" />
</div>
</div>
</g:form>
-->
<!---->
<div style="margin-top:5px"></div>

<div id="body-wrapper">
    <g:render template="myLeft"/>
    <div id="main-content">
        <div class="content-box">
            <div class="content-box-header">
                <ul class="content-box-tabs">
                    <li><a href="${createLink(controller: 'my', action: 'myQnaireList')}" class="default-tab current">问卷列表</a></li>
                </ul>

                <div class="clear"></div>
            </div>

            <div class="content-box-content">
                <div class="tab-content default-tab">
                    <g:form action="qnaireSave" method="post" name="form1" onsubmit="return check();">
                        <g:hiddenField name="id" value="${qnaire?.id}"/>
                        <div id="main-content">
                            <h2>${fieldValue(bean: qnaire, field: "name")}</h2>
                            <h4>发布人：${qnaire.consumer.nickname}        发布日期：<g:formatDate format="yyyy-MM-dd HH:mm:ss"
                                                                                          date="${qnaire?.datePublished}"/></h4>
                            <g:each in="${qnaire.qnaireQuestions}" var="question" status="i">
                                <dl>
                                    <dt>
                                        <p style="color:#0096c6" id="qtd_${question?.id}">问题${i + 1}.&nbsp;${fieldValue(bean: question, field: "question")}&nbsp;(${typeTitles[question.type]})</p>
                                <p>
                                    <g:each in="${question?.qnaireOptions ?}" var="option" status="j">
                                        <g:if test="${question.type == QnaireQuestion.RADIO_TYPE}">
                                            <input type="radio" name="question_${question?.id}" value="${option.id}">
                                        </g:if>
                                        <g:if test="${question.type == QnaireQuestion.CHECK_BOX_TYPE}">
                                            <input type="checkbox" name="question_${question?.id}" value="${option.id}">
                                        </g:if>
                                        ${fieldValue(bean: option, field: "optionText")}
                                    </g:each>
                                </p>
                                </dt>
                            </dl>
                            </g:each>
                            <p>
                                <input class="qqbut" type="submit" value="提 交">
                            </p>

                            <div class="clear"></div>
                        </div>
                    </g:form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
