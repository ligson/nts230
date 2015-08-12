<%@ page import="nts.system.domain.Qnaire" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
	<title>网络教学资源发布系统</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />


	<style>	
	.ProgressBar {
		position: relative;
		width: 500px;  
		border: 1px solid #B1D632;
		padding: 1px; 
	}  
	.ProgressBar div {
		display: block;
		position: relative;
		background: #B1D632;
		color: #333333;
		height: 16px;  
		line-height: 20px;
		vertical-align:middle; 
	}
	.ProgressBar div span { 
		position: absolute;
		width: 500px;  
		text-align: center;
		font-weight: bold;
		font-size:12px
	}
	.datalist{
	font-family:Arial;
	border-collapse:collapse;
	font-size:14px;
	margin:0px 10px 20px 20px;
	
	border: 1px solid #aaa;
	 }

.STYLE3 {font-size: 12px; color: #cc3300;padding-left:5px; }
.STYLE4 {font-size: 12px; color: #555555;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;line-height:22px}
.STYLE5 {font-size: 12px;color: #CC3300; font-weight: bold; }


	</style>	
    </head>
    <body>
        <div class="x_daohang">
            <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'qnaire', action: 'list')}">调查问卷</a>>><a href="${createLink(controller: 'qnaire', action: 'statisticsList')}">统计</a>>> 统计图表
		</div>
        <div class="body" style="width:95%">
            <div class="dialog">
                <table style="width:100%; margin-top:4px;">
                    <tbody>
						<tr>
                            <td style="font-size:16px;line-height:25px;" align="center">${fieldValue(bean: qnaire, field: "name")}&nbsp;调查结果</td>
                        </tr>
						<tr>
                            <td style="font-size:12px;line-height:20px;padding-bottom:10px;" align="center">发布人：${session.consumer.nickname}&nbsp;&nbsp;人次：${qnaire.surveyNum}&nbsp;&nbsp;状态:${(qnaire.state == Qnaire.PUBLIC_STATE)?"正在时行中":"已关闭"}&nbsp;&nbsp;发布日期：<g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${qnaire?.datePublished}" /></td>
                        </tr>
						<tr>
                            <td valign="top" align="left" style='padding-left:25px; padding-right:25px; padding-bottom:10px;line-height:120%'>
								&nbsp;&nbsp;&nbsp;&nbsp;${fieldValue(bean: qnaire, field: "description")}
							</td>
                        </tr>
                        <tr>
							<td>
						<g:each in="${qnaire.qnaireQuestions}" var="question" status="i">
							<table width="90%" border="1" cellpadding="0" cellspacing="0" class="datalist">
							  <tr>
								<td height="30" colspan="3" class="STYLE3">问题${i+1}.&nbsp;${fieldValue(bean: question, field: "question")}&nbsp;(${typeTitles[question.type]})</td>
							  </tr>

							<g:each in="${question?.qnaireOptions?}" var="option" status="j">
							  <tr>
								<td width="53%" height="22" align="left" class="STYLE4">${fieldValue(bean: option, field: "optionText")}</td>
								<td width="7%" align="right" class="STYLE4"><g:formatNumber number="${(option.count*100)/total}" type="number" maxFractionDigits="1" />％</td>
								<td width="40%" class="STYLE4" style="padding-left:0px;"><img src="${resource(dir: 'images/skin', file: 'photo_blue.gif')}" width="${(option.count*100)/total}" height="12" />&nbsp;${option.count}票</td>
							  </tr>
							</g:each>
 
							</table>
						</g:each>
							</td>
						</tr>
                    </tbody>
                </table>
            </div>
            <div class="buttons" style="height:25px;">
            </div>
        </div>
    </body>
</html>
