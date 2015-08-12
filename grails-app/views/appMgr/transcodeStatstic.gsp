<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-3-8
  Time: 下午8:26
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>转码统计</title>
    <link href="${createLinkTo(dir: 'skin/blue/pc/front/css', file: 'admin_transcodestatstic.css')}" rel="stylesheet"
          type="text/css">
    <r:require module="highcharts"/>
    <script type="text/javascript">

        $(function () {
            var chart;
            var totalMoney = 10000;
            $(document).ready(function () {
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'pie_chart',
                        plotBackgroundColor: '#268acb',//背景颜色
                        plotBorderWidth: 0,
                        plotShadow: false
                    },
                    title: {
                        text: '总共:$' + totalMoney,
                        verticalAlign: 'bottom',
                        y: -60
                    },
                    tooltip: {//鼠标移动到每个饼图显示的内容
                        pointFormat: '{point.name}: <b>{point.percentage}%</b>',
                        percentageDecimals: 1,
                        formatter: function () {
                            return this.point.name + ':' + totalMoney * this.point.percentage / 100;
                        }
                    },
                    plotOptions: {
                        pie: {
                            size: '60%',
                            borderWidth: 0,
                            allowPointSelect: true,
                            cursor: 'pointer',
                            dataLabels: {
                                enabled: true,
                                color: '#fff',
                                distance: -50,//通过设置这个属性，将每个小饼图的显示名称和每个饼图重叠
                                style: {
                                    fontSize: '12px',
                                    lineHeight: '10px'
                                },
                                formatter: function (index) {
                                    return  '<span style="color:#fff; font-size: 12px; font-weight: bold; font-family:"新宋体";font-weight:bold">' + this.point.name + '</span>';
                                }
                            },
                            padding: 20
                        }
                    },
                    series: [
                        {//设置每小个饼图的颜色、名称、百分比
                            type: 'pie',
                            name: null,
                            data: [
                                {name: '已转码', y: 65},
                                {name: '未转码', y: 20},
                                {name: '正在转码', y: 10},
                                {name: '转码失败', y: 5}
                            ]
                        }
                    ]
                });
            });

        });

    </script>
</head>

<body>
<div class="x_daohang">
    <p style="font-size:12px">当前位置：<a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a
            href="${createLink(controller: 'appMgr', action: 'transcodeStatstic')}">转码管理</a>>>转码统计</p>
</div>

<div class="transcodecat">
    <div class="transcodecat_left">
        <ul>
            <h2 style="margin-top: 30%;">资源状态统计信息</h2>
            <li>已转码：20个</li>
            <li>未转吗：40个</li>
            <li>正在进行：50个</li>
        </ul>
    </div>

    <div class="transcodecat_right">
        <div class="codecat" style=" margin-top: 10px;    height:460px;overflow: hidden;">
            <div id="pie_chart" style="width:100%; height:100%;"></div>
        </div>

        %{--     <div class="codecat_title">图形标题</div>--}%
    </div>
</div>
</body>
</html>