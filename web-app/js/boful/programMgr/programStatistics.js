/**
 * Created by xuzhuo on 14-5-5.
 */
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}

var option = {
    chart: {
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false
    },
    title: {
        text: '资源统计'
    },
    tooltip: {
        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    },
    plotOptions: {
        pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
                enabled: true,
                color: '#000000',
                connectorColor: '#000000',
                format: '<b>{point.name}</b>: {point.percentage:.1f} %'
            }
        }
    },
    series: [
        {
            type: 'pie',
            name: '占有',
            data: [

            ]
        }
    ]
};

var lineOption = {
    title: {
        text: '资源量统计'
    },
    xAxis: {
        categories: []
    },
    yAxis: {
        title: {
            text: '资源数量'
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
        layout: 'vertical',
        align: 'right',
        verticalAlign: 'middle',
        borderWidth: 0
    },
    series: []
};

//页面打开生成报表
$(document).ready(function () {
    //资源总数统计
    $.post(baseUrl+"programMgr/programStatisticsData", {
    }, function (data) {
        option.series[0].data = data;
        $('#programStatistics').highcharts(option);
    });
    //年统计数据
    /*$.post(baseUrl+"programMgr/programYearStatisticsData", {
     }, function (data) {
        $('#programYearStatistics').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: ''
            },
            xAxis: {
                categories: data.year,
                labels: {
                    rotation: -45,
                    align: 'right'
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: '资源数量'
                }
            },
            legend: {
                enabled: false
            },
            tooltip: {
                pointFormat: '<b>{point.y} 次</b>'
            },
            series: [
                {
                    data: data.count,
                    dataLabels: {
                        enabled: true,
                        color: '#FFFFFF',
                        style: {
                            textShadow: '0 0 3px black'
                        }
                    }
                }
            ]
        });
     });*/

    $.post(baseUrl + "programMgr/programMonthStatisticsData", {
    }, function (data) {
        lineOption.xAxis.categories = data.month;
        lineOption.series = data.series;
        $('#programYearStatistics').highcharts(lineOption);
    });


    //添加时间控件
    $("#startTime").datepicker();
    $("#endTime").datepicker();
});
/**
 * 依据月份查询数据
 */
function searchData() {
    var startTime = new Date($("#startTime").val()).setHours(0);
    var endTime = new Date($("#endTime").val()).setHours(0);
    if (isNaN(startTime) || isNaN(endTime) || startTime > endTime) {
        $("#startTime").focus();
        $("#startTime").select();
    } else {
        $.post(baseUrl + "programMgr/programStatisticsData", {
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
        });
    }
}

