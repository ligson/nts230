<!-- saved from url=(0065)http://zgb.huizhou.gov.cn/personnel/portal/perdata/perdataAdd.jsp -->
<html>
<head>
<title>个人信息修改</title>
<link type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_myInfo.css')}" rel="stylesheet"/>
<script type="text/javascript" src="${resource(dir: 'js/commonLib', file: 'string.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/my_myInfo.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>

</head>

<body>
<div style="width: 1024px; margin:0 auto; overflow: hidden">
    <div class="my_body_container">
        <div class="my_info_tabs">
            <div class="my_info_tab">
                基本信息
            </div>

            <div class="my_info_tab">
                修改头像
            </div>

            <div class="my_info_tab">
                修改密码
            </div>
        </div>

        <div class="my_info_contents">
            <div class="my_info_content">
                <g:form controller="my" action="myUpdate" name="modifyInfoForm">
                    <table>
                        <tr>
                            <td width="100px" align="right">名&nbsp;&nbsp;称：</td><td><input type="hidden"
                                                                                           value="${consumer.id}"
                                                                                           name="id">${session.consumer.name}</td><td></td>
                        </tr>
                        <tr>
                            <td align="right">昵&nbsp;&nbsp;称：</td><td><input id="nicknameId"
                                                                             class="form-control input-sm" type="text"
                                                                             name="nickname"
                                                               value="${consumer.nickname}">
                        </td>
                        </tr>
                        <tr>
                            <td align="right">性&nbsp;&nbsp;别：</td><td>
                            <g:if test="${consumer.gender == 1}">
                                <input name="gender" value="1" type="radio" checked/>男<input name="gender" value="0"
                                                                                             type="radio"/>女
                            </g:if>
                            <g:if test="${consumer.gender == 0}">
                                <input name="gender" value="1" type="radio"/>男<input name="gender" value="0"
                                                                                     type="radio"
                                                                                     checked/>女
                            </g:if>
                        </td>
                        </tr>
                        <tr>
                            <td align="right">email：</td><td><input id="emailId" class="form-control input-sm"
                                                                    type="text"
                                                                    value="${consumer.email}" name="email"/></td><td></td>
                        </tr>
                        <tr>
                            <td align="right">居住地：</td>
                            <td>
                                <label>
                                    <input id="addressId" name="address" type="text" value="${consumer.address}"
                                           class="form-control input-sm">
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">个人介绍：</td>
                            <td>
                                <label>
                                    <input id="descriptionsId" name="descriptions" type="text" autocomplete="off"
                                           value="${consumer.descriptions}" class="form-control">
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <input class="my_info_content_chose" type="button" value="确认修改"
                                       onclick="userInfoSubmit()"/>
                            </td>
                        </tr>
                    </table>
                </g:form>

            </div>

            <div class="my_info_content" style="display:none;">
                <g:uploadForm controller="my" action="myPhotoUpdate">
                    <input type="hidden" value="${session.consumer.id}">
                    <img src="${generalUserPhotoUrl(consumer: consumer)}"
                         onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'photo.gif')}'"/>
                    <input type="file" name="myPhoto">
                    <input class="my_info_content_chose" type="submit" value="上传头像">
                </g:uploadForm>
            </div>

            <div class="my_info_content" style="display: none;">
                <g:form controller="my" action="updatePassword" name="modifyPassWord">
                    <table>
                        <tr>
                            <td>旧密码：</td><td><input class="form-control input-sm" type="password" name="password"
                                                    style="width: 175px"
                                                    id="oldPassWord"
                                                    value=""></td><td></td>
                        </tr>
                        <tr>
                            <td>新密码：</td><td><input class="form-control input-sm" type="password" id="newPassword"
                                                    style="width: 175px"
                                                    name="newPassword"/></td><td></td>
                        </tr>
                        <tr>
                            <td>再次输入：</td><td><input class="form-control input-sm" type="password" id="chkPassword"
                                                     style="width: 175px"
                                                     name="chkPassword"/></td><td></td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <input class="my_info_content_chose" type="button" value="确认修改" id="password_btn"/>
                            </td>
                        </tr>

                    </table>
                </g:form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
