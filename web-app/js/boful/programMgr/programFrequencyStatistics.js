/**
 * Created by xuzhuo on 14-5-5.
 */
/**
 * 资源统计报表
 */
$(document).ready(function () {
    var option = {
        chart: {
            type: 'column',
            margin: [ 50, 50, 100, 70]
        },
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
                data: [],
                dataLabels: {
                    enabled: true,
                    color: '#FFFFFF',
                    style: {
                        textShadow: '0 0 3px black'
                    }
                }

            }
        ]

    }
    $.post("programFrequencyStatisticsFrom", {
    }, function (data) {
        option.xAxis.categories = data.categories;
        option.series[0].data = data.data;
        $('#programFrequencyStatisticsId').highcharts(option);
    });
    //给今天，本周，本月绑定事件
    $(".program_statistics_content .statistics_time .t_present span").bind("click", function () {
        var startTime = null;
        var now = new Date();
        now.setHours(0);
        now.setMinutes(0);
        now.setSeconds(0);
        now.setMilliseconds(0);
        if ("t_today" == this.className) {
            startTime = now.getTime();
        } else if ("t_weak" == this.className) {
            //本周第一天
            startTime = now.getTime() - (now.getDay() * 24 * 60 * 60 * 1000);
        } else if ("t_month" == this.className) {
            //本月第一天
            now.setDate(1);
            startTime = now.getTime();
        }
        $.post("programFrequencyStatisticsFrom", {
            startTime: startTime
        }, function (data) {
            $('#programFrequencyStatisticsId').highcharts().xAxis[0].setCategories(data.categories);
            $('#programFrequencyStatisticsId').highcharts().series[0].setData(data.data);
        })
    })
    //添加时间控件
    $("#startTime").datepicker();
    $("#endTime").datepicker();
})
//查询按钮查询数据
function searchDate() {
    var startTime = new Date($(".program_statistics_content .statistics_time .t_chose input")[0].value).setHours(0);
    var endTime = new Date($(".program_statistics_content .statistics_time .t_chose input")[1].value).setHours(0);
    if (isNaN(startTime) || isNaN(endTime) || startTime > endTime) {
        $("#startTime").focus();
        $("#startTime").select();
    } else {
        $.post("programFrequencyStatisticsFrom", {
            startTime: startTime,
            endTime: endTime
        }, function (data) {
            $('#programFrequencyStatisticsId').highcharts().xAxis[0].setCategories(data.categories);
            $('#programFrequencyStatisticsId').highcharts().series[0].setData(data.data);
        })
    }
}