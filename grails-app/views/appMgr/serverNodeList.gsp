<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<script type="text/javascript" src="${resource(dir: "js/boful/appMgr/serverNode",file: "serverNodeTree.js")}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/commonLib', file: 'string.js')}"></script>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/css',file: 'node_list.css')}">
<title>节点管理</title>
<r:require modules="zTree"></r:require>
</head>

<body>
<div class="tree_main">
    <!---------当前位置----->
    <div class="x_daohang">
        <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>>作品管理
    </div>
    <div class="tree_left">
        <div id="zTree" class="ztree">
        </div>
    </div>
    <div class="tree_content">
        <div class="tree_content_but">
        <input class="content_but" type="button" value="创建节点" id="createServerNode">
        <input class="boful_tree_content_but content_but" type="button" value="删除节点" id="removeServerNode">
        <input class="content_but" type="button" value="创建子节点" id="createChildServerNode">
         </div>
            <br><input type="hidden" value="" id="selectServerNodeTypeId">
        <g:form method="post" action="updateServerNode" controller="distributeApply">
            <g:hiddenField name="id" value="" />
            <g:hiddenField name="version" value="" />
            <div class="dialog">
             <table>
                    <tbody>

                    <tr class="prop">
                        <td valign="top" class="name">
                            名称：
                        </td>
                        <td valign="top">
                            <g:textField name="name" id="name" maxlength="250" value="" />
                        </td>
                    </tr>

                    <tr class="prop">
                        <td valign="top" class="name">
                            IP：
                        </td>
                        <td valign="top">
                            <g:textField name="ip" id="ip" maxlength="250" value="" />
                        </td>
                    </tr>

                    <tr class="prop">
                        <td valign="top" class="name">
                            端口：
                        </td>
                        <td valign="top">
                            <g:textField name="port" id="port" maxlength="20" value="" />
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
          <div class="buttons">
              <span class="buttons buttons_right"><input class="return content_bu" type="button" onclick="history.back();" value="取消" /></span>
                <span class="buttons buttons_right"><input class="save content_bu" type="submit" value="修改" /></span>

            </div>
        </g:form>
    </div>
<div id="createRootServerNodeDialog" style="display:none;">
    <g:form action="createServerNode" controller="distributeApply" name="createServerNodeForm" onsubmit="return check();">
        <div class="ui-dialog-content ui-widget-content">
            节点名称&nbsp;<input type="text" value="" name="name"/> <br>
            IP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" value="" name="ip"><br>
            端口&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" value="" name="port">
        </div>
    </g:form>
</div>

<div id="createChildServerNodeDialog" style="display:none;">
     <g:form action="createServerNode" name="createChildServerNodeForm" onsubmit="return checkChild();">
        <div class="ui-dialog-content ui-widget-content">
            <input type="hidden" value="" id="parentId" name="parentId">
            节点名称&nbsp;<input type="text" value="" name="name"/> <br>
            IP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" value="" name="ip"><br>
            端口&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" value="" name="port">
         </div>
     </g:form>
</div>

</div>
<script type="text/javascript">
    function checkChild(){
        if(!document.createChildServerNodeForm.name.value){
            alert("节点名称不能为空！")
            document.createChildServerNodeForm.name.focus();
            return false;
        }
        if(!document.createChildServerNodeForm.ip.value){
            alert("节点IP不能为空！")
            document.createChildServerNodeForm.ip.focus();
            return false;
        }
        if(!document.createChildServerNodeForm.port.value){
            alert("节点端口不能为空！")
            document.createChildServerNodeForm.port.focus();
            return false;
        }else if(isNaN(document.createChildServerNodeForm.port.value)){
            alert("节点端口只能是数字！")
            document.createChildServerNodeForm.port.focus();
            document.createChildServerNodeForm.port.value = ""
            return false;
        }

    }
    function check(){
        if(!document.createServerNodeForm.name.value){
            alert("节点名称不能为空！")
            document.createServerNodeForm.name.focus();
            return false;
        }
        if(!document.createServerNodeForm.ip.value){
            alert("节点IP不能为空！")
            document.createServerNodeForm.ip.focus();
            return false;
        }
        if(!document.createServerNodeForm.port.value){
            alert("节点端口不能为空！")
            document.createServerNodeForm.port.focus();
            return false;
        }else if(isNaN(document.createServerNodeForm.port.value)){
            alert("节点端口只能是数字！")
            document.createServerNodeForm.port.focus();
            document.createServerNodeForm.port.value = ""
            return false;
        }

    }
</script>
</body>
</html>

