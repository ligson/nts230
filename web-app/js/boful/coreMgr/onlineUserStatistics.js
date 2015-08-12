
var option = {
    title: {
        text: ''
    },
    xAxis: {
        categories: [],
        labels: {
            rotation: -45,
            align: 'right'
        }
    },
    yAxis: {
        title: {
            text: '在线用户数'
        },
        plotLines: [
            {
                value: 0,
                width: 1,
                color: '#808080'
            }
        ]
    },
    legend: {
        layout: 'horizontal',
        align: 'center',
        verticalAlign: 'bottom',
        borderWidth: 0
    },
    series: []
};

$(function(){
    //添加时间控件
    $("#startTime").datepicker();
    $("#endTime").datepicker();

    //当日在线人数统计
    $.post(baseUrl+"coreMgr/onlineUserStatisticsData", {searchDateType:0}, function (data) {
        if(data.success) {
            option.xAxis.categories = data.xAxis;
            option.series = data.series;
            option.title.text="当日在线人数统计";
            // 设置折线图宽度x
            $('#onlineUserStatistics').css("width", "100%");
            $('#onlineUserStatistics').highcharts(option);
        } else {
            alert(data.msg);
        }
    });
})

function searchDateTo(searchDateType){
    switch(searchDateType) {
        case 0:
            option.title.text="当日在线人数统计";
            break;
        case 1:
            option.title.text="昨日在线人数统计";
            break;
        case 2:
            option.title.text="最近7日在线人数统计";
            break;
        case 3:
            option.title.text="最近30日在线人数统计";
            break;
        case 4:
            if($("#startTime").val().toString() == '起始日期'){
                alert("请选择起始日期");
                return;
            }
            if($("#endTime").val().toString() == '结束日期'){
                alert("请选择结束日期");
                return;
            }
            if (new Date(Date.parse($("#startTime").val().toString().replace(/-/g, "/"))) > new Date(Date.parse($("#endTime").val().toString().replace(/-/g, "/")))) {
                alert("起始日期不能大于结束日期");
                return;
            }
            option.title.text="在线人数统计";
            break;
        default:
            return;
    }
    $.post(baseUrl+"coreMgr/onlineUserStatisticsData", {searchDateType:searchDateType,startDate:$("#startTime").val(),endDate:$("#endTime").val()}, function (data) {
        if(data.success) {
            option.xAxis.categories = data.xAxis;
            option.series = data.series;
            // 设置折线图宽度
            var col = data.xAxis.length;
            if(col < 10) {
                $('#onlineUserStatistics').css("width", "500px");
            } else if(col <30){
                $('#onlineUserStatistics').css("width", (500+(col-10)*30)+"px");
            } else {
                $('#onlineUserStatistics').css("width", "100%");
            }
            $('#onlineUserStatistics').highcharts(option);
        } else {
            alert(data.msg);
        }
    });
}