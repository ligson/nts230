<!-- saved from url=(0065)http://zgb.huizhou.gov.cn/personnel/portal/perdata/perdataAdd.jsp -->
<HTML>
<HEAD>
    <TITLE>个人信息修改</TITLE>

</HEAD>

<BODY>

<div id="main-content">
    <div class="content-box">
        <div class="content-box-header">
            <ul class="content-box-tabs">
                <li><a href="${createLink(controller: 'my', action: 'myInfo')}">基本信息</a>
                </li>
                <li><a href="${createLink(controller: 'my', action: 'myPhoto')}">修改头像</a></li>
                <li><a href="${createLink(controller: 'my', action: 'myPassword')}" class="default_tab current">修改密码</a>
                </li>
            </ul>
        </div>

        <div class="content-box-content" style="margin-left: 20px">
        <!--密码修改-->
            <g:if test="${flash.message}">
                <small class="gr gn">${flash.message}</small>
            </g:if>
            <g:hasErrors bean="${consumer}">
                <small class="gr gn"<g:renderErrors bean="${consumer}" as="list"/></small>
            </g:hasErrors>
            <div class="tab-content default-tab">
                <g:form name="infoForm" action="updatePassword" method="post">
                    <fieldset>
                        <p>
                            <label>
                                原密码：<small class="gr gn">(可修改)</small>
                            </label>
                            <input class="text-input small-input" type="password" id="password" name="password"
                                   value="${consumer.password}" maxLength=20/>
                        </p>

                        <p>
                            <label>
                                新密码：<small class="gr gn">(可修改)</small>
                            </label>
                            <input class="text-input small-input" type="password" id="newPassword" name="newPassword"
                                   value="" maxLength=20/>
                        </p>

                        <p>
                            <label>
                                确认密码：<small class="gr gn">(可修改)</small>
                            </label>
                            <input class="text-input small-input" type="password" id="chkPassword" name="chkPassword"
                                   value="" maxLength=20/>
                        </p>

                        <p><input class="button" type="submit" value="保存修改"/></p>
                    </fieldset>
                    <input type="hidden" name="id" value="${consumer?.id}"/>
                </g:form>
            </div>
        </div>
    </div>
</div>
</BODY>
</HTML>
