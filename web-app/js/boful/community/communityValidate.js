function checkCommunity(name, description) {
    //清空所有提示
    $("#" + name + "Prompt").html('标题');
    $("#" + description + "Prompt").html('内容');
    var patrn=/^[0-9a-zA-Z\u4e00-\u9fa5+\.+\《》]+$/;
    if ($("#" + name).val().trim().length == 0) {
        $("#" + name + "Prompt").html('<span class="p_sent_w" >标题不能为空值!</span>');
        $("#" + name).focus();
        $("#" + name).select();
        return false;
    }
    else if (patrn.test($("#" + name).val()) == false) {
        $("#" + name + "Prompt").html('<span class="p_sent_w" >标题含有特殊字符</span>');
        $("#" + name).focus();
        $("#" + name).select();
        return false;
    }
    else if ($("#" + name).val().trim().length > 50) {
        var manyLength = (parseInt($("#" + name).val().trim().length) - 50);
        $("#" + name + "Prompt").html('<span class="p_sent_w" >标题超出了' + manyLength + '个字符!</span>');
        $("#" + name).focus();
        $("#" + name).select();
        return false;
    }
    else if ($("#" + name).val() == "标题必填，不得多于50个字。") {
        $("#" + name + "Prompt").html('<span  class="p_sent_w" >你还未输入标题!</span>');
        $("#" + name).focus();
        $("#" + name).select();
        return false;
    }
    else if ($("#" + description).val().trim().length == 0) {
        $("#" + description + "Prompt").html('<span  class="p_sent_w" >内容不能为空值!</span>');
        $("#" + description).focus();
        $("#" + description).select();
        return false;
    }
    return true;
}
function checkReply() {
    if ($('#replyName').val().trim().length == 0) {
        alert("标题不能为空值");
        $('#replyName').focus();
        $('#replyName').select();
        return false;
    }
    else if ($('#replyDescription').val().trim().length == 0) {
        alert("内容不能为空值");
        $('#replyDescription').focus();
        $('#replyDescription').select();
        return false;
    }
    else if ($('#replyName').val().trim().length > 50) {
        var manyLength = (parseInt($('#replyName').val().trim().length) - 50);
        alert("标题超出了" + manyLength + "个字符");
        return false;
    }
    return true;
}
function nameFocus(name) {
    if ($("#" + name).val() == "标题必填，不得多于50个字。") {
        $("#" + name).val("");
    }
}
function nameBlur(name) {
    if ($("#" + name).val() == "") {
        $("#" + name).val("标题必填，不得多于50个字。");
    }
}
