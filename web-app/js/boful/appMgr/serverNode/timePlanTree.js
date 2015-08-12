
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
$(function(){
    $("input[name=startTime]").datepicker();
    $("input[name=endTime]").datepicker();

    $("#timePlanDialog").dialog({autoOpen:false,width:480,height:480,buttons:{
        "确认":function(){
            var name = $("#addTimePlan input[name=name]").val();
            if(name == ""){
                alert("时间计划名称不能为空!");
            }else{
                $("#timePlanDialog form[name=addTimePlan]").submit();
                $("#timePlanDialog").dialog("close");
            }

        },
        "关闭":function(){
            $("#timePlanDialog").dialog("close");
        }
    }});
    $("#addTimePlanBtn").click(function(){
        $("#timePlanDialog").dialog("open");
    })
});

function deleteTimePlan(tag){
    var url = baseUrl+"programMgr/deleteTimePlan?id="+tag;
    if(confirm("确定删除吗?")){
        window.location.href=url;
    }
}
