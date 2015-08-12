//将复选框中的所有值转换成1,2,3,5的字符串值
function getListStr(checkBoxName) {
    var listStr = "";
    var checkBoxs = document.getElementsByName(checkBoxName);

    for (var i = 0; i < checkBoxs.length; i++) {
        if (checkBoxs[i].checked) {
            listStr += "," + checkBoxs[i].value;
        }
    }
    if (listStr != "") listStr = listStr.substring(1);
    return listStr;
}
function checkMetaName(textName, messageBox, num) {
    var validphonechar = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890";
    //intLength = $("input[name='textName']").val.length;
    theNameObj = document.form1.name;
    intLength = theNameObj.value.length;

    if (intLength > 0) {
        if (intLength > num) {
            alert(messageBox + "不能超过" + num + "字");
            theNameObj.focus();
            return false;
        }
        else {
            for (j = 0; j < intLength; j++) {
                var strValue = theNameObj.value.charAt(j);
                if (validphonechar.indexOf(strValue) == -1) {
                    alert(messageBox + "含有非法字符,请输入字母或'_'！");
                    theNameObj.focus();
                    return false;
                }
            }
            return true;
        }
    }
    else
        return true;
}
function onAllClass(theForm) {
    var i;
    var isAll = theForm.allClass[0].checked;
    $("input[name=selDirectory]").prop("disabled",isAll);
//    var nItemCount = theForm.selDirectory.length;
//    if (nItemCount == 0) return;
//    if (nItemCount == 1) {
//        theForm.selDirectory.disabled = isAll;
//        return;
//    }
//
//    for (i = 0; i < nItemCount; i++) {
//        theForm.selDirectory[i].disabled = isAll;
//    }
    onIsDeco();
}

function onIsDeco() {
    /*
     <option value="0" selected>简单元素(不包含修饰词)</option>
     <option value="1">复合元素(包含修饰词)</option>
     <option value="2">修饰词</option>
     */
    var v = form1.elementType.value;
    var objDecoTR = $("#decoTR");
    var objEnumTR = $("#enumTR");

    var dataType = $("#dataType");
    var maxLength = $("#maxLength");

    if (v == 2 || v == 3) {
        objDecoTR.show();
    } else {
        objDecoTR.hide();
    }
    if (v == 1 || v == 3) {
        dataType.attr("disabled", true);
        maxLength.attr("disabled", true);
    } else {
        dataType.attr("disabled", false);
        maxLength.attr("disabled", false);
    }

    //if(objEnumTR) objEnumTR.style.display=v==1?"none":"block";
    if (objEnumTR) {
        //objEnumTR.style.display=dataType;
    }

    //0简单元素 1复合元素 2修饰词 3复合修饰词
    if (v == 2 || v == 3) {
        var allClass = form1.allClass[0].checked ? 1 : 0;
        var selDirectory = getListStr("selDirectory");
        if (allClass == 0 && selDirectory == "") {
            objDecoTR.hide();
            alert("请至少选择一个库！");
        }
        else {

            var url = baseUrl + "programMgr/findParentMetaOption";
            var params = 'allClass=' + allClass + '&parentId=' + global.parentId + '&selDirectory=' + selDirectory + '&elementType=' + v;

            $.post(url, {allClass: allClass, parentId: global.parentId, selDirectory: selDirectory, elementType: v}, function (data) {
                var html = "<option value=0>-请选择-</option>";
                if(data.success){
                    for(var i = 0;i<data.elements.length;i++){
                        var element = data.elements[i];
                        html+="<option value='"+element.id+"'";
                        if(element.selected){
                            html+=" selected" + ">"+element.name+"</option>";
                        }else{
                            html+=">"+element.name+"</option>";
                        }
                    }
                }
                $('#parentId').html(html);
            });

        }
    }
}

function getImgOptionIndex() {
    for (var i = 0; i < form1.dataType.length; i++) {
        if (form1.dataType.options[i].value == "img") return i;
    }
    return -1;
}

function getselDirectory() {
    var selDirectory = "";
    var sltNodes = $$('input[type="checkbox"][name="selDirectory"]').select(function (node) {
        return node.checked
    });
    sltNodes.each(function (node) {
        selDirectory += "," + node.value;
    });
    if (selDirectory != "") selDirectory = selDirectory.substring(1);
    return selDirectory;
}

function addtr() {

    var delLink = "<a href='#' onclick='javascript:deltr(this)' class=\"btn  btn-warning btn-xs\" style=\"color:#FFF\">删除</a>";
    global.maxEnumId++;
    var newRow = "<tr><td><input type=text name=enumId" + global.maxEnumId + "></td><td><input type=text name=enumName" + global.maxEnumId + "></td><td style='text-align:center;'>" + delLink + "</td></tr>";

    $("#enumTab tr:last").after(newRow);

    /*
     var czuo="<a href=# onclick='javascript:deltr(event.srcElement.parentElement.parentElement.rowIndex)'>删除</a>";
     var wtab=document.getElementById("enumTab");
     var iRow=wtab.rows.length;
     global.maxEnumId++;
     wtab.insertRow();
     alert(iRow);
     for(j=0;j<wtab.rows[iRow-1].cells.length;j++)
     {
     wtab.rows[iRow].insertCell(j);
     //wtab.rows[iRow].cells[j].innerText="cell"+j;
     if(j==2)
     {
     wtab.rows[iRow].cells[j].innerHTML=czuo;
     wtab.rows[iRow].cells[j].align="center";
     }
     else if(j==0)
     wtab.rows[iRow].cells[j].innerHTML="<input type=text name=enumId"+global.maxEnumId+">";
     else if(j==1)
     wtab.rows[iRow].cells[j].innerHTML="<input type=text name=enumName"+global.maxEnumId+">";

     }*/

}

function onChangeData() {
    var dataType = form1.dataType.value;
    if (dataType == "date" || dataType == "time" || dataType == "datetime") {
        form1.maxLength.value = 50;
        form1.maxLength.readOnly = true;
        //alert(dataType);
    }
    else if (dataType == "img") {
        form1.maxLength.value = 200;
        form1.maxLength.readOnly = true;
    }
    else if (dataType == "link") {
        form1.maxLength.value = 600;
        form1.maxLength.readOnly = true;
    }
    else {
        form1.maxLength.value = "";
        form1.maxLength.readOnly = false;
    }

    var ojbEmumTR = document.getElementById("enumTR");
    ojbEmumTR.style.display = dataType == "enumeration" ? "" : "none";
}

function deltr(theObj) {
    var wtab = document.getElementById("enumTab");
    var vDisciplineID = 0;
    var vParentID = document.form1.parentId.value;
    var iRow = wtab.rows.length;
    //vParentID=vParentID.split("*")[0];
    if (iRow < 2)//(iRow<3 && (vDisciplineID<1 || vParentID != vDisciplineID))
    {
        //alert("请至少保留一个枚举元素。");
        return false;
    }

    if (theObj) {
        $(theObj).parent().parent().remove();
    } else {
        $("#enumTab tr:last").remove();//删除末行
    }

}

function checkNameExist(theObj) {

    //new Ajax.Request(global.nameAction,{asynchronous:true,evalScripts:true,onComplete:function(e){setNameExist(e)},parameters:'id='+theObj.form.id.value+'&value='+encodeURIComponent(theObj.value)});
    var url = baseUrl+"coreMgr/checkMetaNameExist";
    //var params = 'id=' + global.metaDefineId + '&value=' + encodeURIComponent(theObj.value);

    $.post(url,{id:global.metaDefineId,value:theObj.value},function(data){
        if(data.success){
            global.nameExist = true;
            alert("字段名称已存在，请重新输入！");
        }
    });
}

function setNameExist(data) {
    global.nameExist = data == "exist";
    if (global.nameExist) {
        alert("字段名称已存在，请重新输入！");
        document.form1.name.focus();
    }
}

function check() {
    try {

        if (document.form1.allClass[1].checked) {
            if (getListStr("selDirectory") == "") {
                alert("请至少选择一个类库！");
                return false;
            }
        }

        var bDeco = document.form1.elementType.value == "2";
        var vMeta_name = Jtrim(form1.name.value);
        var parentId = document.form1.parentId.value;
        //var arrParentInfo=vParentInfo.split("*");

        if (bDeco && parentId == 0) {
            alert("请选择元素！");
            document.form1.parentId.focus();
            return false;
        }

        if (vMeta_name == "") {
            alert("请输入字段名称！");
            document.form1.name.focus();
            return false;
        }

        if (global.nameExist) {
            alert("字段名称已存在，请重新输入！");
            document.form1.name.focus();
            return false;
        }

        /*if(vMeta_name.toLowerCase()=="aid" || vMeta_name.toLowerCase()=="progid" || vMeta_name.toLowerCase()=="id" || vMeta_name.toLowerCase()=="name")
         {
         alert("字段名称不能为aid,progid,id或name！");
         document.form1.name.focus();
         return false;
         }

         if((vMeta_name.toLowerCase()).substring(0,4)=="enum")
         {
         alert("字段名称不能以enum开头！");
         document.form1.name.focus();
         return false;
         }*/

        if (!checkMetaName("name", "字段名称", "100")) {
            return false;
        }
        if (document.form1.cnName.value == "") {
            alert("请输入字段中文的名称！");
            document.form1.cnName.focus();
            return false;
        }

        if (document.form1.dataType.value == "" && document.form1.elementType.value != "1") {
            alert("请选择字段的类型！");
            document.form1.dataType.focus();
            return false;
        }

        if ((form1.elementType.value != 1 || form1.elementType.value != 3) && document.form1.dataType.value == "enumeration") {
            var vLen, vId, vName;
            arrID = new Array();
            arrName = new Array();
            vLen = 0;

            for (i = 1; i <= global.maxEnumId; i++) {

                if (eval("form1.enumId" + i)) {
                    vId = eval("form1.enumId" + i + ".value");
                    vName = eval("form1.enumName" + i + ".value");

                    if (vId == "") {
                        alert("请输入枚举ID！");
                        eval("form1.enumId" + i + ".focus();")
                        return false;
                    }

                    if (!isNum2(vId)) {
                        alert("枚举ID请输入数字！");
                        eval("form1.enumId" + i + ".focus();")
                        return false;
                    }

                    if (vName == "") {
                        alert("请输入枚举名称！");
                        eval("form1.enumName" + i + ".focus();")
                        return false;
                    }

                    for (j = 0; j < vLen; j++) {
                        if (arrID[j] == vId) {
                            alert("枚举ID不能有重复值，请重新输入！");
                            eval("form1.enumId" + i + ".focus();")
                            return false;
                        }

                        if (arrName[j] == vName) {
                            alert("枚举名称不能有重复值，请重新输入！");
                            eval("form1.enumName" + i + ".focus();")
                            return false;
                        }
                    }

                    arrID[vLen] = vId;
                    arrName[vLen] = vName;
                    vLen++;
                }
            }
            form1.maxLength.value = 10;
        }
        else if (document.form1.dataType.value == "decorate" || document.form1.dataType.value == "decorate2") {
            form1.maxLength.value = 10;
        }
        else if (document.form1.elementType.value == "1" || document.form1.elementType.value == "3") {
            //form1.maxLength.value=10;
        }
        else {
            if (document.form1.maxLength.value == "") {
                alert("请输入字段长度！");
                document.form1.maxLength.focus();
                return false;
            }

            if (!isNum2(form1.maxLength.value)) {
                alert("字段长度请输入数字！");
                form1.maxLength.focus();
                return false;
            }

            if (form1.dataType.value != "number" && form1.maxLength.value < 2) {
                alert("非数字型字段长度请输入大于1数字！");
                form1.maxLength.focus();
                return false;
            }
        }

    }
    catch (e) {
        alert(e.message);
        return false;
    }

    form1.maxEnumId.value = global.maxEnumId;
    return true;
}
