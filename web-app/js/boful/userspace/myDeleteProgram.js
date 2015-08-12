

function deleteUserActivityList(pId) {
    if(pId !="") {
        if(confirm("您确定要删除吗?")) {
            var url = baseUrl + "my/myDelete?idList=" + pId;
            window.location.href = url;
        }
    } else {
        if (!hasChecked("idList")) {
            alert("至少选择一条需要删除的资源!");
            return;
        }
        var idList = getCheckBoxListStr("idList");
        if(confirm("您确定要都删除吗?")){
            var url = baseUrl + "my/myDelete?idList=" + idList;
            window.location.href = url;
        }
    }
}

function programSet(pId){
    if(pId !="") {
        if(confirm("您确定要还原吗?")) {
            var url = baseUrl + "my/myRestoreProgram?idList=" + pId;
            window.location.href = url;
        }
    } else {
        if (!hasChecked("idList")) {
            alert("至少选择一条需要还原的资源!");
            return;
        }
        var idList = getCheckBoxListStr("idList");
        if(confirm("您确定要都还原吗?")){
            var url = baseUrl + "my/myRestoreProgram?idList=" + idList;
            window.location.href = url;
        }
    }
}

function hasChecked(checkBoxName) {
    var checkBoxs = document.getElementsByName(checkBoxName);
    for (var i = 0; i < checkBoxs.length; i++) {
        if (checkBoxs[i].checked) {
            return true;
        }
    }

    return false;
}

function getCheckBoxListStr(checkBoxName) {
    var strList = "";
    var checkBoxs = document.getElementsByName(checkBoxName);
    for (var i = 0; i < checkBoxs.length; i++) {
        if (checkBoxs[i].checked) {
            strList += "," + checkBoxs[i].value;
        }
    }

    if (strList != "") strList = strList.substring(1);

    return strList;
}