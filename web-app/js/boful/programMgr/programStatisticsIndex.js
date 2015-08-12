/**
 * Created by xuzhuo on 14-5-4.
 */
/**
 * 打开资源统计页面，加载资源数据
 */
$(document).ready(function () {
    var option = {
        chart: {
            type: 'column',
            margin: [ 50, 50, 100, 70]
        },
        credits: {
            position: {
                align: 'right',
            }
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
    $.post("programStatisticsIndexData", {
        statisticsCategory: "frequency"
    }, function (data) {
        option.xAxis.categories = data.categories;
        option.series[0].data = data.data;
        $('#programFrequencyRankId').highcharts(option);
    });
    $.post("programStatisticsIndexData", {
        statisticsCategory: "viewNum"
    }, function (data) {
        option.title.text = "资源浏览排行榜";
        option.xAxis.categories = data.categories;
        option.series[0].data = data.data;
        $('#programViewNumRankId').highcharts(option);
    });
    $.post("programStatisticsIndexData", {
        statisticsCategory: "downloadNum"
    }, function (data) {
        option.title.text = "资源下载排行榜";
        option.xAxis.categories = data.categories;
        option.series[0].data = data.data;
        $('#programDownloadNumRankId').highcharts(option);
    });
    $.post("programStatisticsIndexData", {
        statisticsCategory: "recommendNum"
    }, function (data) {
        option.title.text = "资源推荐排行榜";
        option.xAxis.categories = data.categories;
        option.series[0].data = data.data;
        $('#programRecommendNumRankId').highcharts(option);
    });
    $.post("programStatisticsIndexData", {
        statisticsCategory: "collectNum"
    }, function (data) {
        option.title.text = "资源收藏排行榜";
        option.xAxis.categories = data.categories;
        option.series[0].data = data.data;
        $('#programCollectNumRankId').highcharts(option);
    })

    //div拖动
    //获取所有排行榜div
    var moveDiv = $(".statistics_index_content .datasheet_play_box")
    var i = 0;
    for (var i = 0; i < moveDiv.size(); i++) {
        //设置窗口移动
        moveDiv.eq(i).draggable({
            addClasses: false,
            containment: 'parent'
        });
        //设置图层初始值
        moveDiv[i].style.zIndex = i + 1;
        //获取cookie
        var moveDivCookie = $.cookie(moveDiv[i].id)
        if (moveDivCookie && moveDivCookie.split(",").length == 3) {
            moveDiv[i].style.left = moveDivCookie.split(",")[0] + "px";       //设置左偏移
            moveDiv[i].style.top = moveDivCookie.split(",")[1] + "px";        //设置上偏移
            moveDiv[i].style.zIndex = moveDivCookie.split(",")[2];          //设置层次
        }
    }
    //移动div时，获取div位置始终cookie
    $('.statistics_index_content .datasheet_play_box').bind('dragstop', function (event, ui) {
        //把当前移动div left，top 和zindex（图层）保存在cookie中
        $.cookie(this.id, ui.position.left + "," + ui.position.top + "," + this.style.zIndex, {path: window.document.location.pathname})
    });
    //当移动时，把当前移动div显示在最上层
    $('.statistics_index_content .datasheet_play_box').bind('dragstart', function (event, ui) {
        var moveDiv = $(".statistics_index_content .datasheet_play_box")
        for (var i = 0; i < moveDiv.size(); i++) {
            moveDiv[i].style.zIndex = "";
        }
        this.style.zIndex = 5;
    });
})
//还原div样式
function reduceDiv() {
    var moveDiv = $(".statistics_index_content .datasheet_play_box")
    var i = 0;
    for (var i = 0; i < moveDiv.size(); i++) {
        //设置窗口移动
        moveDiv.eq(i).draggable({
            addClasses: false,
            containment: 'parent'
        });
        //删除cookie
        $.cookie(moveDiv[i].id, null, {path: window.document.location.pathname});
        //还原
        moveDiv[i].style.left = "0px";       //设置左偏移
        moveDiv[i].style.top = "0";        //设置上偏移
        moveDiv[i].style.zIndex = 0;
    }
}