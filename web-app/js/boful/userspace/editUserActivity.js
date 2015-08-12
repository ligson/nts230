/**
 * Created by Administrator on 14-1-2.
 */
$(function () {
    $("#startTime").datepicker();
    $("#endTime").datepicker();
});
function selectTag(showContent, selfObj) {
    // 操作标签
    var tag = document.getElementById("tags").getElementsByTagName("li");
    var taglength = tag.length;
    for (i = 0; i < taglength; i++) {
        tag[i].className = "";
    }
    selfObj.parentNode.className = "selectTag";
// 操作内容
    for (i = 0; j = document.getElementById("tagContent" + i); i++) {
        j.style.display = "none";
    }
    document.getElementById(showContent).style.display = "block";

}
function showToLower(obj) {
    var request_url = baseUrl + "community/queryCategoryTwo"; // 需要获取内容的url
    var request_pars = "category1=" + obj.value;//请求参数

    $.ajax({
        url: request_url,
        data: request_pars,
        error: function (data) {
            $("#category2").empty().append(data);
        },
        success: function (data) {
            $("#category2").empty().append(data);
        }
    })
}

function loading() {
}

function done() {
}

function reportError(request) {
    alert(request);
}
function updateUserActivity() {
    //清空所有提示
    var namePrompt = $("#namePrompt");
    namePrompt.html('');
    var name = $("#name");
    var shortNamePrompt = $("#shortNamePrompt");
    shortNamePrompt.html('');
    var startTimePrompt = $("#startTimePrompt");
    startTimePrompt.html('');
    var endTimePrompt = $("#endTimePrompt");
    endTimePrompt.html('');
    var descriptionPrompt = $("#descriptionPrompt");
    descriptionPrompt.html('');
    var description = $("#description");

    var shortName = $("#shortName");

    var endTime = $("#endTime");
    var startTime = $("#startTime");
    if (name.val().trim().length == 0) {
        var html = "<span style='color:red;'>标题不能为空值</span>";
        namePrompt.empty().append(html);
        name.focus();
        name.select();
        return false;
    }
    else if (name.val().trim().length > 50) {
        var manyLength1 = (parseInt(name.val().trim().length) - 50);
        namePrompt.html('<span style="color:red;">标题超出了' + manyLength1 + '个字符</span>');
        name.focus();
        name.select();
        return false;
    }
    else if (name.val() == "标题必填，不得多于50个字。") {
        namePrompt.html('&nbsp;<span style="color:red;">你还未输入标题</span>');
        name.focus();
        name.select();
        return false;
    }
    else if (shortName.val().trim().length == 0) {
        shortNamePrompt.html('&nbsp;<span style="color:red;">简称不能为空值</span>');
        shortName.focus();
        shortName.select();
        return false;
    }
    else if (shortName.val().trim().length > 50) {
        var manyLength = (parseInt(shortName.value.trim().length) - 50);
        shortNamePrompt.html('&nbsp;<span style="color:red;">简称超出了' + manyLength + '个字符</span>');
        shortName.focus();
        shortName.select();
        return false;
    }
    else if (shortName.val() == "简称必填，不得多于50个字。") {
        shortNamePrompt.html('&nbsp;<span style="color:red;">你还未输入简称</span>');
        shortName.focus();
        shortName.select();
        return false;
    }
    else if (startTime.val().trim().length == 0) {
        startTimePrompt.html('&nbsp;<span style="color:red;">开始时间不能为空</span>');
        startTime.focus();
        startTime.select();
        return false;
    }

    else if (endTime.val().trim().length == 0) {
        endTimePrompt.html('&nbsp;<span style="color:red;">结束时间不能为空</span>');
        endTime.focus();
        endTime.select();
        return false;
    }
    else if (new Date(startTime.val()) > new Date(endTime.val())) {
        endTimePrompt.html('&nbsp;<span style="color:red;">开始时间不能大于结束时间</span>');
        endTime.focus();
        endTime.select();
        return false;
    }
    else if (description.val().trim().length == 0) {
        descriptionPrompt.htm('&nbsp;<span style="color:red;">内容不能为空值</span>');
        description.focus();
        description.select();
        return false;
    }
    updateUserActivityForm.action = baseUrl + "my/updateUserActivity";
    updateUserActivityForm.submit();
    return true;
}