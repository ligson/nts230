<%@ page import="nts.system.domain.QnaireQuestion; nts.system.domain.Qnaire" %>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>网络教学资源发布系统</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<style type="text/css">
		.radioCss{
			border:0px;
		}
		.question{font-size:12px;color:#0096C6;padding-left:50px;}
		</style>

<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/appMgr/prototype.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/common.js')}"></script>
<script type="text/javascript">
function check()
{
	return true;			
}

</script>

    </head>
    <body>
	<g:form action="qnaireSave" method="post" name="form1" onsubmit="return check();">
		<g:hiddenField name="id" value="${qnaire?.id}" />
		<div class="x_daohang">
			<p>当前位置：<a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'qnaire', action: 'list')}">调查问卷</a>>><a href="${createLink(controller: 'qnaire', action: 'list')}">问卷管理</a>>> 问卷</p>
		</div>
        <div class="body" style="width:95%">
			
            <div class="dialog">
                <table style="width:100%; margin-top:4px;">
                    <tbody>
						<tr>
                            <td style="font-size:16px;line-height:25px;" align="center">${fieldValue(bean: qnaire, field: "name")}</td>
                        </tr>
						<tr>
                            <td style="font-size:12px;line-height:16px;padding:0px 0px 8px 2px;" align="center">
							发布人：${qnaire.consumer.nickname}&nbsp;&nbsp;
							发布日期：<g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${qnaire?.datePublished}" />&nbsp;&nbsp;
						<g:if test="${qnaire.state == Qnaire.CLOSE_STATE}">
							关闭日期：<g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${qnaire?.dateClosed}" />
						</g:if>
							</td>
                        </tr>
						<tr>
                            <td valign="top" align="left" style='padding-left:25px; padding-right:25px; padding-bottom:10px;line-height:120%'>
								&nbsp;&nbsp;&nbsp;&nbsp;${fieldValue(bean: qnaire, field: "description")}
							</td>
                        </tr>
                        
						<g:each in="${qnaire.qnaireQuestions}" var="question" status="i">
							<tr><td style="padding:0px 40px 0px 40px"><div style="margin:1px;height:1px;border-top: 1px solid #ccc;"></div></td></tr>
							<tr class="prop">
								<td valign="top" class="question">
									问题${i+1}.&nbsp;${fieldValue(bean: question, field: "question")}&nbsp;(${typeTitles[question.type]})
								</td>
							</tr>
							<tr class="prop">
								<td valign="top" style="text-align: left; padding-left:71px;padding-top:4px;padding-bottom:4px" class="value">
								
								<g:each in="${question?.qnaireOptions?}" var="option" status="j">
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
				<g:if test="${qnaire.state == Qnaire.NO_PUBLIC_STATE}">
					<input type="button" class="save" onclick="self.location.href=baseUrl + 'appMgr/setState?id=${qnaire.id}&oldState=${qnaire.state}&newState=${Qnaire.PUBLIC_STATE}'" value="发布" /> <input type="button" class="save" onclick="self.location.href=baseUrl + 'appMgr/editQnaire?id=${qnaire.id}'" value="编辑" />
				</g:if>
				<g:elseif test="${qnaire.state == Qnaire.PUBLIC_STATE}">
					<input type="button" class="save" onclick="self.location.href=baseUrl + 'appMgr/setState?id=${qnaire.id}&oldState=${qnaire.state}&newState=${Qnaire.CLOSE_STATE}'" title="点击设置成关闭状态" value="设置成关闭状态" />
				</g:elseif>
				<g:elseif test="${qnaire.state == Qnaire.CLOSE_STATE}">
					<input type="button" class="save" onclick="self.location.href=baseUrl + 'appMgr/setState?id=${qnaire.id}&oldState=${qnaire.state}&newState=${Qnaire.PUBLIC_STATE}'" value="发布" />
				</g:elseif>
            </div>
        </div>
		</g:form>
    </body>
</html>
