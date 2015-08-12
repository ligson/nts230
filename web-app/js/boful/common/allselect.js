function checkAll(allObj, checkBoxName) {
    var checkBoxs = document.getElementsByName(checkBoxName);
    for (var i = 0; i < checkBoxs.length; i++) {
        checkBoxs[i].checked = allObj.checked;
    }
}

function checkboxAll(checkboxId) {
    var checkBoxs = document.getElementsByName(checkboxId);
    for (var i = 0; i < checkBoxs.length; i++) {
        checkBoxs[i].checked = "checked";

    }
}
function unCheckboxAll(checkboxId) {
    var checkBoxs = document.getElementsByName(checkboxId);
    for (var i = 0; i < checkBoxs.length; i++) {
        checkBoxs[i].checked = "";

    }
}

function unCheckAll(allObjName) {
    var allObj = document.getElementsByName(allObjName)[0];
    if (allObj && allObj.checked) {
        allObj.checked = false;
    }

    return false;
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

/***************2012-7-6 addBy ������*******************/
function checkAllByButton(flag, checkBoxName) {
    var checkBoxs = document.getElementsByName(checkBoxName);
    for (var i = 0; i < checkBoxs.length; i++) {
        checkBoxs[i].checked = flag;
    }
}
