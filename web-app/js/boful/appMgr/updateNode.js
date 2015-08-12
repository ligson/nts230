//url 是ajax的url,update是模板或html标签的id,params是参数
function updateTemplate(url, update, params) {
    //new Ajax.Updater({success: update, failure: 'error'}, url, {asynchronous: true, evalScripts: true, parameters: params});
    $.ajax({url: url, type: "post", data: params, async: true, success: function(data){
        $("#"+update).empty().append(data);
    }, error: function () {
        alert("error");
    }});

}