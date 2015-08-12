<%@ page import="nts.program.domain.Program; nts.user.domain.Consumer" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title>无标题文档</title>
<link href="${createLinkTo(dir:'css',file:'index.css')}"  rel="stylesheet" type="text/css">
<SCRIPT language="JavaScript1.2" src="${createLinkTo(dir:'js',file:'boful/userspace/stmenu.js')}"  type=text/javascript></SCRIPT>
<SCRIPT language="javascript" src="${createLinkTo(dir:'js',file:'boful/userspace/menu2.js')}"></SCRIPT>

</head>
 
<style   type="text/css">   
  body   {   
  overflow-x   :   hidden   ;   
  }
  .STYLE1 {color: #000000}
</style>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<HTML><HEAD>

<META content="MSHTML 6.00.2900.5694" name=GENERATOR>

<BODY>

  <TABLE width=150 border=0 align="left" cellPadding=0 cellSpacing=0>
  <TBODY>
  <TR>
    <TD width=150 height=539 vAlign=top  background="${createLinkTo(dir:'images/skin',file:'grkj_leftbg.jpg')}" >
      <DIV align=center>
        <TABLE width=150 border=0 align=left cellPadding=0 cellSpacing=0 background="${createLinkTo(dir:'images/skin',file:'grkj_leftbg.jpg')}" >
          <TBODY>
            <TR>
              <TD width=150 height="539" align=left vAlign=top class=bgy-l><TABLE cellSpacing=0 cellPadding=0 width="70%" border=0>
                  <TBODY>
                    <TR>
                      <TD width="37%"><img src="${resource(dir: 'images/skin', file: 'leftarrow.gif')}"  width="35" height="28"></TD>
                      <TD width="63%"><A class=link3   href="http://www.supermap.com.cn/index.htm"><BR>
                      </A></TD>
                    </TR>
                    <TR>
                      <TD colSpan=2 height=12><IMG height=1  src="${createLinkTo(dir:'images/skin',file:'line1.gif')}"  width=150></TD>
                    </TR>
                  </TBODY>
                </TABLE>
                  <TABLE cellSpacing=0 cellPadding=0 width=150 border=0> 
                    <TBODY>
                      <TR>
                        <TD class=leftmenu-x style="CURSOR: hand" height=26><TABLE height=16 cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>
                              <TR>
                                <TD width="150" height="26" align=middle vAlign=center class=text12><div align="left">&nbsp;&nbsp;&nbsp;
				<IMG height="9"   src="${createLinkTo(dir:'images/skin',file:'point.gif')}" width=9> 
				<a href="${createLink(action:'myInfo') } " target="myMainFrame" class="text12">个人信息</a></div></TD>
                              </TR> 
                            </TBODY>
                        </TABLE></TD>
                      </TR>
                     <TR><TD>
						
		<!--用户角色为老师的时候显示-->
		<g:if test="${role < Consumer.STUDENT_ROLE}">

		 <TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                    <TBODY>
                      <TR>
                        <TD class=leftmenu-x style="CURSOR: hand" height=26><TABLE height=26 cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>
                              <TR>
                                <TD width="150" align=middle vAlign=center class=text12><TABLE height=26 cellSpacing=0 cellPadding=0 width=150 border=0>
                                    <TR>
                                      <TD width="150" height="26" align=middle vAlign=center><div align="left">&nbsp;&nbsp;&nbsp;
				      <IMG height=9  src="${createLinkTo(dir:'images/skin',file:'point.gif')}" width=9>  
				      <a href="uploadApply.gsp" target="myMainFrame" class="text12">上传申请</a></div></TD>
                                    </TR>
                                  
                                </TABLE></TD>
                              </TR>
                            </TBODY>
                        </TABLE></TD>
                      </TR>
                </table>
		<!-------------------------------------------------------------------资源上传------------------------------>
                 </TD>
                      </TR>
                      <TR>
			<g:if test="${session.consumer.uploadState== 1 || role == 0 }">
                        <TD align=left vAlign=top>
			<TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>
                              <TR>
                                <TD width="100%" ><TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                                  <TBODY>
                                    <TR>
                                      <TD width="150" height="26" align=middle vAlign=center class="text12"><div align="left">&nbsp;&nbsp;&nbsp;
				      <IMG height=9 src="${createLinkTo(dir:'images/skin',file:'point.gif')}" width=9> 
				      <a href="${createLink(controller:'program',action:'create')}" target="myMainFrame" class="text12">资源上传</a></div></TD>
                                    </TR>
                                  </TBODY>
                                </TABLE></TD>
                              </TR>
                            </TBODY>
                        </TABLE>
			</g:if >
			<!-------------------------------------------------------------------我的资源------------------------5------>

			<TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                    <TBODY>
                      <TR>
                        <TD width="150"  height=26 class=leftmenu-x style="CURSOR: hand" onclick=showMenu(5,${count});>
			<TABLE height=26 cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>
                              <TR>
                                <TD width="150" height="26" align=middle vAlign=center><div align="left">&nbsp;&nbsp;&nbsp;
				<IMG id=Img5 height=9  src="${createLinkTo(dir:'images/skin',file:'point.gif')}" width=9> 
				<span class="text12"><a href="${createLink(controller:'my',action:'manageProgram')}" target="myMainFrame">我的资源</a></span></div></TD>
                              </TR>
                            </TBODY>
                        </TABLE></TD>
                      </TR>
                      <TR  id=menu5 style="DISPLAY: none">
                        <TD vAlign=top align=left><TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>

                              <TR>
                                <TD width="20%" height=30><IMG height=30 src="${createLinkTo(dir:'images/skin',file:'tree.gif')}"  width=40></TD>
                                <TD width="80%"><FONT color=#ff0000>
				<a href="${createLink(controller:'my',action:'manageProgram')}" target="myMainFrame" class="text12">资源管理</a>
				</FONT></TD>
                              </TR>

                              <TR>
                                <TD width="20%" height=30><IMG height=30  src="${createLinkTo(dir:'images/skin',file:'tree.gif')}"  width=40></TD>
                                <TD width="80%">
				<a href="${createLink(controller:'my',action:'manageProgram',params:[fromModel:'myRecycler'])}" target="myMainFrame" class="text12">回 收 站</A>
				</TD>
                              </TR>
                              <TR>
                              </TR>
                            </TBODY>
                        </TABLE></TD>
                      </TR></table>
		      </g:if >
		      <!-------------------------------------------------------------------我的资源------------------------5------>

			<!--以上是用户角色为老师的时候显示-->

		<!-------------------------------------------------------------------我的推荐------------------------------>
		<TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                    <TBODY>
                      <TR>
                        <TD width="150"   height=26 class=leftmenu-x style="CURSOR: hand" ><TABLE height=26 cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>
                              <TR>
                                <TD width="150" align=middle vAlign=center class="text12">
				<div align="left">&nbsp;&nbsp;&nbsp;
				<IMG height=9  src="${createLinkTo(dir:'images/skin',file:'point.gif')}" width=9> 
				<a href="${createLink(action:'myRecommendProgramList') }" target="myMainFrame" class="text12">我的推荐</a></div></TD>
                              </TR>
                            </TBODY>
                        </TABLE>
			<!-------------------------------------------------------------------我的订阅------------------------1------>
		<TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                    <TBODY>
                      <TR>
                        <TD width="150"   height=26 >
			 <TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                    <TBODY>
                      <TR>
                        <TD width="163"    height=26 class=leftmenu-x style="CURSOR: hand" onclick=showMenu(1,${count});>
			<TABLE height=26 cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>
                              <TR>
                                <TD width="150" height="26" align=middle vAlign=center><div align="left">&nbsp;&nbsp;&nbsp;
				<IMG id=Img1 height=9  src="${createLinkTo(dir:'images/skin',file:'point.gif')}" width=9> 
				<span class="text12"><a href="${createLink(controller:'my',action:'myTagList')}" target="myMainFrame">我的订阅</a></span></div></TD>
                              </TR>
                            </TBODY>
                        </TABLE></TD>
                      </TR>
                      <TR id=menu1 style="DISPLAY: none" >
                        <TD vAlign=top align=left><TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>
                              <TR>
                                <TD width="20%" height=30><IMG height=30  src="${createLinkTo(dir:'images/skin',file:'tree.gif')}"  width=40></TD>
                                <TD width="80%"><A  href="${createLink(action:'myTagList')}" target="myMainFrame" >${Program.cnField['programTags']}列表</A></TD>
                              </TR> <TR>
                                <TD width="20%" height=30><IMG height=30  src="${createLinkTo(dir:'images/skin',file:'tree.gif')}"  width=40></TD>
                                <TD width="80%"><A  href="${createLink(action:'myProgramList') }"  target="myMainFrame">资源列表</A></TD>
                              </TR>
                            </TBODY>
                        </TABLE></TD>
                      </TR></table> 
		      <!-------------------------------------------------------------------我的订阅------------------------1------>

		<!-------------------------------------------------------------------我的收藏------------------------2------>
		  <TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                    <TBODY>
                      <TR>
                        <TD width="150"  height=26 class=leftmenu-x style="CURSOR: hand" onclick=showMenu(2,${count});>
			<TABLE height=26 cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>
                              <TR>
                                <TD width="182" align=middle vAlign=center class="text12">
				<div align="left">&nbsp;&nbsp;&nbsp;
				<IMG id=Img2  height=9 src="${createLinkTo(dir:'images/skin',file:'point.gif')}" width=9> 
				<span class="text12"><a href="myCollectProgramList" target="myMainFrame">我的收藏</a></span></div></TD>
                              </TR>
                            </TBODY>
                        </TABLE></TD>
                      </TR>
                      <TR id=menu2 style="DISPLAY: none" >
                        <TD vAlign=top align=left>

			<TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>
			      <g:each in="${myCollectTagList}" status="i" var="collectTag">
				      <TR>
					<TD width="20%" height=30><IMG height=30  src="${createLinkTo(dir:'images/skin',file:'tree.gif')}"  width=40></TD>
					<TD width="80%"><a href="myCollectProgramList?tag=${collectTag}" target="myMainFrame">${collectTag}</a></TD>
				      </TR>
			    </g:each>
                              <TR>
                                <TD height="16" colSpan=2>&nbsp;</TD>
                              </TR>

                            </TBODY>

                        </TABLE></TD>
                      </TR></table>
		      <!-------------------------------------------------------------------我的收藏------------------------2------>

		<!-------------------------------------------------------------------历史纪录------------------------3------>
		<TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                    <TBODY>
                      <TR>
                        <TD width="150"   height=26 class=leftmenu-x style="CURSOR: hand" onclick=showMenu(3,${count});>
			<TABLE height=26 cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>
                              <TR>
                                <TD width="150" align=middle vAlign=center>
				<div align="left">&nbsp;&nbsp;&nbsp;
				<IMG id=Img3 height=9  src="${createLinkTo(dir:'images/skin',file:'point.gif')}" width=9> 历史纪录</div></TD>
                              </TR>
                            </TBODY>
                        </TABLE></TD>
                      </TR>
                      <TR id=menu3 style="DISPLAY: none" >
                        <TD align=left vAlign=top><TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>

                              <TR>
                                <TD width="20%" height=30><IMG height=30  src="${createLinkTo(dir:'images/skin',file:'tree.gif')}"  width=40></TD>
                                <TD width="80%"><A  href="myHistoryProgramList?listType=view" target=myMainFrame>已浏览资源</A></TD>
                              </TR>

                              <TR>
                                <TD width="20%" height=30><IMG height=30   src="${createLinkTo(dir:'images/skin',file:'tree.gif')}"  width=40></TD>
                                <TD width="80%"><A    href="myHistoryProgramList?listType=play" target="myMainFrame" >已点播资源</A></TD>
                              </TR>

                              <TR>
                                <TD width="20%" height=30><IMG height=30   src="${createLinkTo(dir:'images/skin',file:'tree.gif')}"  width=40></TD>
                                <TD width="80%"><A  href="myHistoryProgramList?listType=down" target="myMainFrame" >已下载资源</A></TD>
                              </TR> 

			      <TR>
                                <TD height="16" colSpan=2>&nbsp;</TD>
                              </TR>

                            </TBODY>
                        </TABLE></TD>
                      </TR></table>
		      <!-------------------------------------------------------------------历史纪录------------------------3------>
<!-------------------------------------------------------------------问卷调查------------------------2------>
		    <TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
				<TR>
					<TD width="150"  height=26 class=leftmenu-x style="CURSOR: hand" onclick=showMenu(6,${count});>
						<TABLE height=26 cellSpacing=0 cellPadding=0 width=150 border=0>
							<TBODY>
								<TR>
									<TD width="182" align=middle vAlign=center class="text12">
										<div align="left">&nbsp;&nbsp;&nbsp;
										<IMG id=Img6  height=9 src="${createLinkTo(dir:'images/skin',file:'point.gif')}" width=9> 
										<span class="text12"><a href="myQnaireList" target="myMainFrame">问卷调查</a></span></div>
									</TD>
								</TR>
								<TR id=menu6 style="DISPLAY: none" >
									<TD align=left vAlign=top>
										<TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
											<TBODY>

											</TBODY>
										</TABLE>
									</TD>
								</TR>
							</TBODY>
						</TABLE>
					</TD>
				</TR>
			</table>
 <!-------------------------------------------------------------------问卷调查------------------------2------>
		<!-------------------------------------------------------------------用户管理------------------------4------>
		<g:if test="${role < Consumer.STUDENT_ROLE }">
		 <TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                    <TBODY>
                      <TR>
                        <TD width="163"    height=26 class=leftmenu-x style="CURSOR: hand" onclick=showMenu(4,${count});>
			<TABLE height=26 cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>
                              <TR>
                                <TD width="150" align=middle vAlign=center>
				<div align="left">&nbsp;&nbsp;&nbsp;
				<IMG id="Img4" height=9   src="${createLinkTo(dir:'images/skin',file:'point.gif')}" width=9> 用户管理</div></TD>
                              </TR>
                            </TBODY>
                        </TABLE></TD>
                      </TR>
                      <TR id=menu4 style="DISPLAY: none" >
                        <TD vAlign=top align=left><TABLE cellSpacing=0 cellPadding=0 width=150 border=0>
                            <TBODY>
                              <TR>
                                <TD width="20%" height=30><IMG height=30  src="${createLinkTo(dir:'images/skin',file:'tree.gif')}"  width=40></TD>
                                <TD width="80%"><A  href="${createLink(action:'myGroupList') }" target=myMainFrame>用户组管理</A></TD>
                              </TR> <TR>
                                <TD width="20%" height=30><IMG height=30  src="${createLinkTo(dir:'images/skin',file:'tree.gif')}"  width=40></TD>
                                <TD width="80%"><A  href="${createLink(action:'myGroupConsumerList') }" target=myMainFrame>组成员管理</A></TD>
                              </TR>
                            </TBODY>
                        </TABLE></TD>
                      </TR></table> 
		      </g:if>
		<!-------------------------------------------------------------------用户管理------------------------4------>
                    </TBODY>
              </TABLE></TD>
            </TR>
          </TBODY>
        </TABLE>
      </TD>
</TR></TBODY></TABLE>
</BODY>

