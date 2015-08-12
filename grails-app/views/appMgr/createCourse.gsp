


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
       <script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/dateSelectBox.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/appMgr/div.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/appMgr/updateNode.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/allselect.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/truevod.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/Jtrim.js')}"></script>
        <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
        <g:set var="entityName" value="${message(code: 'courseBcast.label', default: 'nts.broadcast.domain.CourseBcast')}" />
       
	<SCRIPT LANGUAGE="JavaScript">
	        function cancel(){
		      self.location= baseUrl + 'appMgr/courseMgr';
		}

               function onIsPush(isPush)
		{
			var pullDiv = document.getElementById("pullDiv");
			var pushDiv = document.getElementById("pushDiv");
			
			 if(isPush==1){
				pullDiv.style.display = "block";
				pushDiv.style.display = "none"
				form1.isMediaPush2.checked=""

			}else{
				pullDiv.style.display = "none";
				pushDiv.style.display = "block"
				form1.isMediaPush1.checked=""
			}
			
		}

		function check(){
		  if (form1.channel.value.length<1)
		  {
		    alert("请在频道名称框中输入值。");
		    form1.channel.focus();
		    return false;
		  }
		  if (form1.mediaUrl.value.length < 1)
		  {
		    alert("请在音视频流Url框中输入值。");
		    form1.mediaUrl.focus();
		    return false;
		  }
		  if (form1.screenUrl.value.length < 1)
		  {
		    alert("请在屏幕流Url框中输入值。");
		    form1.screenUrl.focus();
		    return false;
		  }
          if(form1.askServerTeacher.value.length<1){
             alert("请在主讲人账号框中输入值");
             form1.askServerTeacher.focus();
             return false;
          }
		  if (form1.title.value.length < 1)
		  {
		    alert("请在频道主题框中输入值。");
		    form1.title.focus();
		    return false;
		  }
		  if (form1.author.value.length < 1)
		  {
		    alert("请在频道主讲框中输入值。");
		    form1.author.focus();
		    return false;
		  }
		    //alert(form1.isMediaPush1.checked)
		   // alert(form1.isMediaPush2.checked)
		   if (form1.isMediaPush2.checked==false){
		     
		       if(form1.mediaSource.value.length<1){
		         alert("请在音视频信号来源框中输入值。");
			 form1.mediaSource.focus();
			 return false;
		       }
		       if(form1.screenSource.value.length<1){
		         alert("请在屏幕流信号来源框中输入值。");
			 form1.screenSource.focus();
			 return false;
		       }
		  }
		   if (form1.isMediaPush2.checked==true){
		       if(form1.mediaPushPort.value.length<1){
				 alert("请在音视频接受端口框中输入值。");
				 form1.mediaPushPort.focus();
				 return false;
			}
			if(form1.screenPushPort.value.length<1){
				 alert("请在屏幕流接受端口框中输入值。");
				 form1.screenPushPort.focus();
				 return false;
			}

		   }
		
		form1.action="saveCourse";
	        form1.submit();
                return true;
		 
           }

	
          </SCRIPT>
    </head>

    <body>
        
             <div class="x_daohang">
                 <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'courseBcast', action: 'courseMgr')}">广播直播</a>>>直播课堂
	     </div>
	      <div class="body">
	           <div class="explain">添加频道
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
                                <td   colspan="4" > <h4>频道信息 </h4></td>
			    </tr>
                            <tr  class="prop"  >
                                <td  valign="top" class="name"  >
                                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;频道名称 
                                </td>
                                <td colspan="3" class="value${hasErrors(bean: courseBcast, field: 'channel', 'errors')}">
                                    <g:textField  name="channel" size="70" maxlength="200" value="${courseBcast?.channel}" />
                                </td>
				
                            </tr>
				
			    <tr class="prop">
                                <td valign="top" class="name"  >
                                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="mediaUrl"><g:message code="courseBcast.mediaUrl.label" default="音视频流URL" /></label>
                                </td>
                                <td colspan="3" valign="top" class="value ${hasErrors(bean: courseBcast, field: 'mediaUrl', 'errors')}">
                                    <g:textField name="mediaUrl" size="70" maxlength="200" value="${courseBcast?.mediaUrl}" />
                                </td>
				
                            </tr>
	
			   <tr class="prop">
                                <td valign="top" class="name"  >
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="screenUrl"><g:message code="courseBcast.screenUrl.label" default="屏幕流URL" /></label>
                                </td>
                                <td colspan="3" valign="top"  class="value ${hasErrors(bean: courseBcast, field: 'screenUrl', 'errors')}">
                                    <g:textField name="screenUrl" size="70" maxlength="200" value="${courseBcast?.screenUrl}" />
                                </td>
				
                            </tr>
			    
			    <tr class="prop">
			      
                             <td colspan="4" class="t5">
			      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<fieldset style="width: 600; height: 35; padding: 2">
					<legend>组播</legend>
					<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <label for="isMultcast"><g:message code="courseBcast.isMultcast.label" default="是否允许组播" /></label>
						<g:checkBox name="isMultcast" value="${courseBcast?.isMultcast}" />
					</div>
					<div>	
						 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <label for="multcastIP"><g:message code="courseBcast.multcastIP.label" default="地址" /></label>
						
						
						   :&nbsp;&nbsp;&nbsp; <g:textField name="multcastIP" maxlength="100" value="${courseBcast?.multcastIP}" />
						
						 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <label for="multcastPort"><g:message code="courseBcast.multcastPort.label" default="端口" /></label>
						
						  :&nbsp;&nbsp; <g:textField name="multcastPort" value="${fieldValue(bean: courseBcast, field: 'multcastPort')}" />
						
					</div>
				</fieldset>
	                     </td>
			    </tr>

			  
			     <tr class="prop">
                                 <td colspan="4" class="t5">
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				     <fieldset style="width: 600; height: 100; padding: 2">
						<legend>信号来源</legend>
						<div>
						     <input type="radio"  name="isMediaPush1" value="${courseBcast?.isMediaPush=1?"1":"0"}" checked="checked" onclick="onIsPush(this.value)">拉模式&nbsp;
						     <input type="radio"  name="isMediaPush2" value="0"  onclick="onIsPush(this.value)">推模式
						 </div>
						
						<div id="pullDiv" style="display:'block'">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="mediaSource"><g:message code="courseBcast.mediaSource.label" default="音视频信号来源" /></label>
							：&nbsp;&nbsp;<g:textField id="mediaSource" name="mediaSource" size="55" maxlength="200" value="${courseBcast?.mediaSource}" /><br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="screenSource"><g:message code="courseBcast.screenSource.label" default="屏幕流信号来源" /></label>
							：&nbsp;&nbsp;<g:textField id="screenSource" name="screenSource" size="55" maxlength="200" value="${courseBcast?.screenSource}" />
						    <div style="padding-left:10px;padding-top:3px;">提示：由当前频道主动从课件录制器或者转播服务器“拉”数据。</div>
						</div>
						<div id="pushDiv" style="display:'none'">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="mediaPushPort"><g:message code="courseBcast.mediaPushPort.label" default="音视频接受端口" /></label>
							：&nbsp;&nbsp;<g:textField name="mediaPushPort" size="55" value="${fieldValue(bean: courseBcast, field: 'mediaPushPort')}" /><br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="screenPushPort"><g:message code="courseBcast.screenPushPort.label" default="屏幕流接受端口" /></label>
							：&nbsp;&nbsp;<g:textField name="screenPushPort" size="55" value="${fieldValue(bean: courseBcast, field: 'screenPushPort')}" />
						    <div style="padding-left:10px;padding-top:3px;">提示：由课件录制器或者转播服务器以“推”方式传送给当前频道。</div>
						</div>
                                               
				    </fieldset>
				 </td>
                             </tr>

                          
                           <tr class="prop">
                              <td colspan="4" class="t5">
			       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		               <fieldset style="width: 600; height: 35; padding: 2">
			        <legend>提问服务器</legend>
			         <div style="height:18px;padding:5px;">
				        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <label for="askServerIP"><g:message code="courseBcast.askServerIP.label" default="服务器地址" /></label>
					 ：<g:textField name="askServerIP" maxlength="100" value="${courseBcast?.askServerIP}" />
					 &nbsp;&nbsp;&nbsp;<label for="askServerPort"><g:message code="courseBcast.askServerPort.label" default="服务器端口" /></label>
					 ：&nbsp;&nbsp;<g:textField name="askServerPort" value="${courseBcast?.askServerPort}" />
				 </div>
				 <div style="height:18px;padding:5px;">
				        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <label for="askServerTeacher"><g:message code="courseBcast.askServerTeacher.label" default="主讲人账号" /></label>
					 ：<g:textField name="askServerTeacher" maxlength="100" value="${courseBcast?.askServerTeacher}" />
					
				 </div>
			      </fieldset>
	                    </td>
                          </tr>

                          
                        
                           <tr class="prop">
			         <td valign="top" class="name"  >
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="datePlayed">开始时间</label>
				 </td>
                                 <td valign="top" class="name"  >
                                      <g:mydatePicker style="width:40px" name="datePlayed" maxlength="40" precision="minute" value="${courseBcast?.datePlayed}"  />
				    <!--input name="datePlayed" id="datePlayed" readonly=""  type="text" class="newsinput1"  value="" onClick="return Calendar('datePlayed');"-->
                                    <label for="dateDeleted">结束时间</label>
				     <g:mydatePicker name="dateDeleted" maxlength="40" precision="minute" value="${courseBcast?.dateDeleted}"  />
                                    <!--input name="dateDeleted" id="dateDeleted" readonly=""  type="text" class="newsinput1"  value="" onClick="return Calendar('dateDeleted');"-->
				</td>
                                <td valign="top" class="name"  >
                                    
                                </td>
                                 <td valign="top" class="name"  >
				   
                                </td>
                            </tr>


			    <tr class="prop">
                                <td valign="top" class="name"  >
                                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="privilege"><g:message code="courseBcast.privilege.label" default="权限级别" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: courseBcast, field: 'privilege', 'errors')}">
                                    <g:textField name="privilege" value="${fieldValue(bean: courseBcast, field: 'privilege')}" />
                                </td>
                            </tr>

                             <tr class="prop">
                                <td valign="top" class="name">
                                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="title"><g:message code="courseBcast.title.label" default="频道主题" /></label>
                                </td>
                                <td colspan="2" valign="top" class="value ${hasErrors(bean: courseBcast, field: 'title', 'errors')}">
                                    <g:textField name="title"  maxlength="320" value="${courseBcast?.title}" />
                                </td>
                            </tr>
                        
                            <tr class="prop" >
                                <td valign="top" class="name"  >
                                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="author"><g:message code="courseBcast.author.label" default="频道主讲" /></label>
                                </td>
                                <td colspan="3" valign="top"  class="value ${hasErrors(bean: courseBcast, field: 'author', 'errors')}">
                                    <g:textField name="author" size="70" maxlength="320" value="${courseBcast?.author}" />
                                </td>
				
                            </tr>
                        
                            <tr  class="prop">
                                <td valign="top" class="name" >
                                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="notes"><g:message code="courseBcast.notes.label" default="频道描述" /></label>
                                </td>
                                <td colspan="3" valign="top"  class="value ${hasErrors(bean: courseBcast, field: 'notes', 'errors')}">
                                    <g:textArea name="notes" style="width:450px" size="70" maxlength="800" cols="40" rows="5" value="${courseBcast?.notes}" />
                                </td>
				
                            </tr>
                        
				<tr class="prop">
				    <td colspan="4" align="center" class="t5"><hr color="#006699" size="3"></td>
				  </tr>
				  <tr class="prop" >
				    <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;提示信息：</td>
				    <td colspan="3" align="center" >1.“音视频URL”和“音视频信号来源”的协议均为bmct。</td>
				  </tr>
				  <trclass="prop">
				    <td ></td>
				    <td colspan="3" align="center" >如: bmct://192.168.1.222:5151。</td>
				  </tr>
				  <tr class="prop">
				    <td ></td>
				    <td colspan="3" align="center" >2.“屏幕流URL”和“屏幕流信号来源”的协议均为bsct。</td>
				  </tr>
				  <tr class="prop">
				    <td ></td>
				    <td colspan="3" align="center" >如: bsct://192.168.1.222:6161。</td>
				  </tr>
				  <tr class="prop">
				    <td ></td>
				    <td colspan="3" align="center" >3. 对于“媒体来源”和“屏幕来源”均为课件录制器的，</td>
				  </tr>
				  <tr class="prop">
				    <td ></td>
				    <td colspan="3" align="center"  >无需启动该频道即可接收直播。</td>
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
