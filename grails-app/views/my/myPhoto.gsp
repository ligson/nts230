<!-- saved from url=(0065)http://zgb.huizhou.gov.cn/personnel/portal/perdata/perdataAdd.jsp -->
<HTML>
<HEAD>
    <TITLE>个人信息修改</TITLE>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>
    <SCRIPT LANGUAGE="JavaScript" type="text/javascript">

        function photoUpdate() {
            //清空所有提示
            $('#labimg').innerHTML = '';

            var url = $('#myPhoto').val().trim();
            var msg = checkImg(url);

            if ($('#myPhoto').val().trim().length == 0) {
                $('#labimg').innerHTML = '缩略图不能为空值';
                return;
            }
            else if (msg != '') {
                $('#labimg').innerHTML = msg;
                return;
            }

            document.photoForm.submit();
        }

    </SCRIPT>
</HEAD>

<BODY>

<div id="main-content">
    <div class="content-box">
        <div class="content-box-header">
            <ul class="content-box-tabs">
                <li><a href="${createLink(controller: 'my', action: 'myInfo')}">基本信息</a>
                </li>
                <li><a href="${createLink(controller: 'my', action: 'myPhoto')}" class="default_tab current">修改头像</a>
                </li>
                <li><a href="${createLink(controller: 'my', action: 'myPassword')}">修改密码</a></li>
            </ul>
        </div>

        <div class="content-box-content" style="margin-left: 20px">
        <!--基本信息-->
            <g:if test="${flash.message}">
                <small class="gr gn">${flash.message}</small>
            </g:if>
            <g:hasErrors bean="${consumer}">
                <small class="gr gn"<g:renderErrors bean="${consumer}" as="list"/></small>
            </g:hasErrors>
            <div class="tab-content default-tab">
                <form name="photoForm" id="photoForm" action="/my/myPhotoUpdate" method="post"
                      enctype="multipart/form-data">
                    <p>
                        <b>当前头像：</b><br/>
                        如果您还没有自己的头像，系统为显示为默认头像，您可以选择一张自己的照片作为自己的个人头像<br/>
                        <img
                            <g:if test="${consumer.photo == null || consumer.photo == ''}">src="${resource(dir: 'images/skin', file: 'default.gif')}"</g:if>
                            <g:else>src="${consumer.photo.encodeAsHTML()}"</g:else> class="qtx"/>
                    </p>

                    <p>
                        <b>设置我的头像：</b><Br/>
                        建议尺寸120*120，图片格式为jpg、jpeg、gif、bmp、png<br/>
                        <small id="labimg" class="gr gn"></small>
                    <fieldset>
                        <label>
                            <!--<input class="text-input small-input" type="text" id="myFile" name="myFile" readonly/>&nbsp;&nbsp;<a class="button" href="javascript:void(0)" onclick="javascript:document.getElementById('myPhoto').click();">选择图片</a>
										<input type="file" id="myPhoto" name="myPhoto" style="display:none;" onchange="document.getElementById('myFile').value=this.value"/>-->
                            <input class="text-input small-input" type="file" id="myPhoto" name="myPhoto"/>
                        </label>
                    </fieldset>
                </p>
                    <p><input class="button" type="button" value="保存修改" onclick="photoUpdate()"/></p>
                    <input type="hidden" name="id" value="${consumer?.id}"/>
                </form>
            </div>
        </div>
    </div>
</div>
</BODY>
</HTML>
