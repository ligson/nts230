function subRequestReferer(cellvalue, options, rowObject){
    if(rowObject.requestReferer==null){
      return ""
    }
    return "<span title='"+rowObject.requestReferer+"'>"+rowObject.requestReferer.substr(0,20)+"</span>"
}
function subRequestUrl(cellvalue, options, rowObject){
    if(rowObject.requestUrl==null){
        return ""
    }
    return "<span title='"+rowObject.requestUrl+"'>"+rowObject.requestUrl.substr(0,20)+"</span>"
}
function subRequestContentType(cellvalue, options, rowObject){
    if(rowObject.requestContentType==null){
        return ""
    }
    return "<span title='"+rowObject.requestContentType+"'>"+rowObject.requestContentType.substr(0,20)+"</span>"
}
function subResponseContentType(cellvalue, options, rowObject){
    if(rowObject.responseContentType==null){
        return ""
    }
    return "<span title='"+rowObject.responseContentType+"'>"+rowObject.responseContentType.substr(0,20)+"</span>"
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
    jQuery("#accessList").jqGrid({
        url:baseUrl+'coreMgr/accessTo',
        datatype:'json',
        colNames: ['请求链接来源', '请求url', '请求类型', '响应类型', '响应时间', '是否AJAX请求', '用户浏览器', '操作系统'],
        colModel: [
            { name: 'requestReferer',formatter: subRequestReferer},
            { name: 'requestUrl'/*,sortable:false*/,formatter: subRequestUrl},
            { name: 'requestContentType',formatter: subRequestContentType},
            { name: 'responseContentType',formatter: subResponseContentType},
            { name: 'responseTime',width:'60'},
            { name: 'ajaxRequest',width:'60',formatter: isAjaxSir},
            { name: 'browser'/*,formatter: userAgent*/,sortable:false},
            { name: 'OS'/*,formatter: subtringName*/,sortable:false}
        ],
        pager:'#accessPager',
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
    jQuery("#accessList").jqGrid('setGridParam',{ postData: {searchDateType:dataType,startDate:starDate,endDate:endDate},page:1}).trigger("reloadGrid");

/*    var startTime;
    var endTime;
    var today = new Date();
    if('0'==dataType) { //当天
        today.setMinutes(0);
        today.setSeconds(0);
        startTime = today.setHours(0);
        today.setMinutes(59);
        today.setSeconds(59);
        endTime = today.setHours(23);
    } else if('1'==dataType){ //昨天
        var yesDay = new Date(new Date().setDate(today.getDate()-1));
        yesDay.setMinutes(0);
        yesDay.setSeconds(0);
        startTime = yesDay.setHours(0);
        yesDay.setMinutes(59);
        yesDay.setSeconds(59);
        endTime = yesDay.setHours(23);
    } else if('2'==dataType){ //最近7天
        var weekDay = new Date(new Date().setDate(today.getDate()-6));
        weekDay.setMinutes(0);
        weekDay.setSeconds(0);
        startTime = weekDay.setHours(0);
        weekDay.setMinutes(59);
        weekDay.setSeconds(59);
        endTime = weekDay.setHours(23);
    } else if('3'==dataType){ //最近30天
        var monthDay = new Date(new Date().setDate(today.getDate()-29));
        monthDay.setMinutes(0);
        monthDay.setSeconds(0);
        startTime = monthDay.setHours(0);
        monthDay.setMinutes(59);
        monthDay.setSeconds(59);
        endTime = monthDay.setHours(23);
    } else if('4'==dataType){
        var sTime = new Date($("#startTime").val());
        var eTime = new Date($("#endTime").val());
        sTime.setMinutes(0);
        sTime.setSeconds(0);
        startTime = sTime.setHours(0);
        eTime.setMinutes(59);
        eTime.setSeconds(59);
        endTime = eTime.setHours(23);
    }*/
    /*$.post(baseUrl + "programMgr/programStatisticsData", {
        startTime: startTime,
        endTime: endTime
    }, function (data) {
        option.series[0].data = data;
        $('#programStatistics').highcharts(option);
    });

    $.post(baseUrl+"programMgr/programMonthStatisticsData", {
        startTime: startTime,
        endTime: endTime
    }, function (data) {
        lineOption.xAxis.categories = data.month;
        lineOption.series = data.series;
        $('#programYearStatistics').highcharts(lineOption);
    });*/


     //tableC(id,PostData,dataType)
}
/*function searchDate(){

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
}*/
function searchDateTo(){
    var starDate=$("#startTime").val();
    var endDate=$("#endTime").val();
    if(starDate.toString() == '起始日期'){
        myAlert("请选择起始日期");
    }else if(endDate.toString() == '结束日期'){
        myAlert("请选择结束日期");
    }else if (startTime > endTime) {
        myAlert("起始日期大于结束日期!");
    } else {
        window.location.href = baseUrl + "coreMgr/accessStatistics?startDate="+starDate+"&endDate="+endDate;
    }
    /*if(searchDate())
        searchgeneral('4')*/
}


