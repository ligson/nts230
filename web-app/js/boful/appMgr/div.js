function hideWnd(nodeId) {
    var editDiv = document.getElementById(nodeId);
    if (editDiv) editDiv.style.display = "none";
}

function showWnd(nodeId) {
    var editDiv = document.getElementById(nodeId);
    if (editDiv) editDiv.style.display = "block";
}

function setDivPos(divObj, h, w) {
    var scrollTop = 0;
    if (document.documentElement && document.documentElement.scrollTop) {
        scrollTop = document.documentElement.scrollTop;
    } else if (document.body) {
        scrollTop = document.body.scrollTop;
    }
    //divObj.style.left =( (screen.width-w)/2-100)+"px";//��Ϊ���˿��
    //divObj.style.top = (scrollTop+(screen.height-h)/2-100)+"px";

    divObj.style.left = ((document.body.clientWidth - divObj.clientWidth) / 2 - 100) + "px";
    divObj.style.top = (scrollTop + (document.body.clientHeight - divObj.clientHeight) / 2 - 120) + "px";
}

function setDivCenter(divObj) {
    var scrollTop = 0;
    if (document.documentElement && document.documentElement.scrollTop) {
        scrollTop = document.documentElement.scrollTop;
    } else if (document.body) {
        scrollTop = document.body.scrollTop;
    }
    //divObj.style.left =( (screen.width-w)/2-100)+"px";//��Ϊ���˿��
    //divObj.style.top = (scrollTop+(screen.height-h)/2-100)+"px";

    var ww = $(window).width();
    var wh = $(window).height();

    var divObj2 = $("#" + divObj.id);

    var left = ww / 2 - divObj2.width() / 2;

    if (left > 0) {
        divObj2.css("left", left);
    }

    var top = wh / 2 - divObj2.height() / 2;
    if (top > 0) {
        divObj2.css("top", wh / 2 - divObj2.height() / 2);
    }


    //divObj.style.left=((document.body.clientWidth-divObj.clientWidth)/2)+"px";
    //divObj.style.top=(scrollTop+(window.screen.height-divObj.clientHeight)/2)+"px";
}