<%@ page import="nts.broadcast.domain.Channel" %>



<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
       <script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/dateSelectBox.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/appMgr/prototype.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/appMgr/div.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/appMgr/updateNode.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/allselect.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/truevod.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/Jtrim.js')}"></script>
        <script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/common.js')}"></script>
        <g:set var="entityName" value="${message(code: 'courseBcast.label', default: 'nts.broadcast.domain.CourseBcast')}" />
        <style> 
       
        .t5 {
		font-size: 12px;
		line-height: 15px;
		color: #003366;
		padding:0px;
		margin:0px;
        }
        </style>
	<SCRIPT LANGUAGE="JavaScript">
	        function cancel(){
		      self.location=baseUrl + 'appMgr/noticeMgr';
		}

              

		function check(){
		  
		  if (form1.dvbTitle.value.length<1)
		  {
		    alert("请在信息标题框中输入值。");
		    form1.dvbTitle.focus();
		    return false;
		  }
		form1.action="saveNotice";
	        form1.submit();
                return true;
		 
           }

	

          </SCRIPT>
    </head>

    <body>
         
             
	     <div class="x_daohang">
			       <p  style="font-size:12px" >当前位置：<a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'news', action: 'list')}">广播直播</a>>>节目预告</p>
	    </div>
	    <div class="body">
	           <div class="explain">添加节目预告
		   </div>
		    <g:if test="${flash.message}">
		    <div class="message">${flash.message}</div>
		    </g:if>
		    <g:hasErrors bean="${courseBcast}">
		    <div class="errors">
			<g:renderErrors bean="${courseBcast}" as="list" />
		    </div>
            </g:hasErrors>
            <g:form name="form1"  method="post" >
               
	            
		   <div class="dialog">
                    <table align="center" >
                        <tbody>
			    
                            <tr align="center" >
                                <td   colspan="4" > <h4>节目预告信息 </h4></td>
			    </tr>
                            
                             <tr class="prop">
                                <td valign="top" class="name">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="dvbTitle"><g:message code="dvbforeNotice.dvbTitle.label" default="信息标题" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dvbforeNotice, field: 'dvbTitle', 'errors')}">
                                    <g:textField name="dvbTitle" maxlength="80" value="${dvbforeNotice?.dvbTitle}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <label for="channel"><g:message code="dvbforeNotice.channel.label" default="播出频道" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dvbforeNotice, field: 'channel', 'errors')}">
                                    <g:select name="channel.id" from="${Channel.list()}" optionKey="id" optionValue="channelName" value="${dvbforeNotice?.channel?.id}"  />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="datePlayed"><g:message code="dvbforeNotice.datePlayed.label" default="开播时间" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dvbforeNotice, field: 'datePlayed', 'errors')}">
                                    <g:mydatePicker name="datePlayed" maxlength="40" precision="minute"  value="${dvbforeNotice?.datePlayed}"  />
                                </td>
                            </tr>
                        
                          
                            <tr class="prop">
                                <td valign="top" class="name">
                                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <label for="descriptions"><g:message code="dvbforeNotice.descriptions.label" default="内容介绍" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dvbforeNotice, field: 'descriptions', 'errors')}">
                                    <g:textArea style="width:400px" name="descriptions" maxlength="2000" cols="40" rows="5" value="${dvbforeNotice?.descriptions}" />
                                </td>
                            </tr>
                        
                            
                           
                           </tbody>
                    </table>
		    </div>
		    <div class="buttons">
		     <span class="button">
		      
		     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		     <img src="${resource(dir: 'images/skin', file: 'queding.gif')}" border="0" style="cursor:pointer;" onClick="return check();">
		     </span>
		     <span class="button"> 
		     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		     <a href="#dd" onClick="cancel();return false;"><img src="${resource(dir: 'images/skin', file: 'cancel.gif')}" border="0" ></a>
		     </span>
		    </div>
               </g:form>
          </div>
    </body>
</html>
