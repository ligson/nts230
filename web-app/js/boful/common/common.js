var gCurHeadItem = null;
function setCurHeadItem(theObj) {

    if (gCurHeadItem == null) gCurHeadItem = document.getElementById("defaultHeadItem");
    if (gCurHeadItem) gCurHeadItem.className = "";
    alert(gCurHeadItem.className);
    theObj.className = "curItem";
    gCurHeadItem = theObj;
    alert(gCurHeadItem.className);
}
//用来改变页码显示图片的方法 参数是每页显示最大值max
function changePageImg(page) {
    if (page != 10 && page != 50 && page != 100 && page != 200) {
        page = 10;
    }
    eval("document.getElementById('Img" + page + "').src = '/images/skin/grkj_amount_" + page + "_on.gif' ");

}

function getAbsoluteLeft(ob) {
    if (!ob) {
        return null;
    }
    var mendingOb = ob;
    var mendingLeft = mendingOb.offsetLeft;
    while (mendingOb != null && mendingOb.offsetParent != null && mendingOb.offsetParent.tagName != "BODY") {
        mendingLeft += mendingOb.offsetParent.offsetLeft;
        mendingOb = mendingOb.offsetParent;
    }
    return mendingLeft;
}

// get absolute TOP position
function getAbsoluteTop(ob) {
    if (!ob) {
        return null;
    }
    var mendingOb = ob;
    var mendingTop = mendingOb.offsetTop;
    while (mendingOb != null && mendingOb.offsetParent != null && mendingOb.offsetParent.tagName != "BODY") {
        mendingTop += mendingOb.offsetParent.offsetTop;
        mendingOb = mendingOb.offsetParent;
    }
    return mendingTop;
}

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

function selectPage(opt) {
    if (isAnony) {
        if (opt == 4) {
            alert("匿名用户不能进入个人空间，请先登录");
            return;
        }
        else if (opt == 6) {
            alert("匿名用户不能进入学习社区，请先登录");
            return;
        }
    }

    document.pageForm.selectPage.value = opt;
    document.parent.pageForm.action = "/index/main";
    document.pageForm.submit();
}

/*2012-7-4 addBy 崔雅鑫 开始*/
//去掉字符串左右两边的空格
String.prototype.trim = function () {
    var str = this,
        str = str.replace(/^\s\s*/, ''),
        ws = /\s/,
        i = str.length;
    while (ws.test(str.charAt(--i)));
    return str.slice(0, i + 1);
};

//判断长度是否合格 
// 
//引数 s   传入的字符串 
// n   限制的长度n以下 
// 
// 返回值 false   NG 
//           true    OK
function widthCheck(s, n) {
    var w = 0;
    for (var i = 0; i < s.length; i++) {
        var c = s.charCodeAt(i);
        //单字节加1
        if ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xff9f)) {
            w++;
        }
        else {
            w += 2;
        }
    }
    if (w > n) {
        return false;
    }
    return true;
}

//验证网址
function checkURL(val) {
    var urlreg = /^((https|http|ftp|rtsp|mms)?:\/\/)+[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
    var url = val;
    if (!urlreg.test(url)) {
        return false
    } else {
        return true;
    }
}

//验证图片格式
function checkImg(url) {
    var AllImgExt = ".jpg|.jpeg|.gif|.bmp|.png|"; //全部图片格式类型
    var fileExt = url.substr(url.lastIndexOf(".")).toLowerCase();
    if (AllImgExt.indexOf(fileExt + "|") == -1) {
        return "该文件类型不允许上传!请上传" + AllImgExt + "类型的文件.";
    }
    return '';
}//验证邮箱
function checkEmail(val) {
    var reg = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/; //全部图片格式类型
    var val = val;
    if (!reg.test(val)) {
        return false;
    } else {
        return true;
    }
}


/*2012-7-4 addBy 崔雅鑫 结束*/