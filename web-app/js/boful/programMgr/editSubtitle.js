
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
function addSubtitle(serialId,serialNo,urlType,programId){
    var url=baseUrl+"programMgr/editSubtitle";
    var pars={serialId:serialId,serialNo:serialNo,urlTYpe:urlType,programId:programId};
    $.ajax({
       url:url,
       data:pars,
       type:'post',
       success:function(data){
           $("#editSubtitle").html(data)
       }
    })
}