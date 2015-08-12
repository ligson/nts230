function subConsumerName(cellvalue, options, rowObject){
    if(rowObject.consumerName==null){
        return ""
    }
    return "<span title='"+rowObject.consumerName+"'>"+rowObject.consumerName.substr(0,20)+"</span>"
}
function subIp(cellvalue, options, rowObject){
    if(rowObject.ipStr==null){
        return ""
    }
    return "<span title='"+rowObject.ipStr+"'>"+rowObject.ipStr.substr(0,20)+"</span>"
}
function subControllerName(cellvalue, options, rowObject){
    if(rowObject.controllerName==null){
        return ""
    }
    return "<span title='"+rowObject.controllerName+"'>"+rowObject.controllerName.substr(0,20)+"</span>"
}
function subActionName(cellvalue, options, rowObject){
    if(rowObject.actionName==null){
        return ""
    }
    return "<span title='"+rowObject.actionName+"'>"+rowObject.actionName.substr(0,20)+"</span>"
}
function subRequestMethod(cellvalue, options, rowObject){
    if(rowObject.requestMethod==null){
        return ""
    }
    return "<span title='"+rowObject.requestMethod+"'>"+rowObject.requestMethod.substr(0,20)+"</span>"
}
function isAjaxSir(cellvalue,options,rowObject){
    var str=''
    if(rowObject.ajaxRequest){
        str='是'
    }else{
        str='否'
    }
    return "<span title='"+str+"'>"+str+"</span>"
}
function tableC(){//userAgent
    jQuery("#userStatisticeList").jqGrid({
        url:baseUrl+'coreMgr/userTo',
        datatype:'json',
        colNames: ['(ID)操作用户名', '用户IP', '用户访问contorller', '用户访问action', '返回状态码', '请求时间', '请求方式'],
        colModel: [
            { name: 'consumerName',formatter: subConsumerName},
            { name: 'ipStr',/*sortable:false,*/formatter: subIp},
            { name: 'controllerName',formatter: subControllerName},
            { name: 'actionName',formatter: subActionName},
            { name: 'statusCode',width:'60'},
            { name: 'dateCreated',width:'60'/*,formatter: isAjaxSir*/},
            { name: 'requestMethod',formatter: subRequestMethod}
        ],
        pager:'#userStatisticePager',
        width:'1200',
        height:'230',
        rowNum:10
        //postData: {searchDateType:dataType}
    })
}
$(function(){
    tableC();
    //添加时间控件
    $("#startTime").datepicker();
    $("#endTime").datepicker();
})

function searchgeneral(dataType){
    var id="";
    var PostData="";
    var starDate=$("#startTime").val()
    var endDate=$("#endTime").val()
    jQuery("#userStatisticeList").jqGrid('setGridParam',{ postData: {searchDateType:dataType,startDate:starDate,endDate:endDate},page:1}).trigger("reloadGrid");
    //tableC(id,PostData,dataType)
}
function searchDate(){

    if($("#startTime").val().toString() == '起始日期'){
        alert("请选择起始日期");
        return false;
    }
    if($("#endTime").val().toString() == '结束日期'){
        alert("请选择结束日期");
        return false;
    }
    if (new Date(Date.parse($("#startTime").val().toString().replace(/-/g, "/"))) > new Date(Date.parse($("#endTime").val().toString().replace(/-/g, "/")))) {
        alert("起始日期不能大于结束日期");
        return false;
    }
    return true;
}
function searchDateTo(){
    var starDate=$("#startTime").val();
    var endDate=$("#endTime").val();
    if(searchDate()){
        window.location.href = baseUrl + "coreMgr/userStatistics?startDate="+starDate+"&endDate="+endDate;
    }
}