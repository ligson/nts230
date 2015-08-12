<%@ page import="java.sql.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@taglib prefix="g" uri="http://grails.codehaus.org/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>最新资源</title>

    <style type="text/css">
        .main {
            width: 660px;
            height: 278px;
            padding: 5px;
        }

        .main .item {
            width: 210px;
            height: 87px;
            float: left;
            padding: 2px;
        }

        .main .item .item_left {
            width: 65px;
            height: 80px;
            float: left;
        }

        .main .item .item_right a {
            text-decoration: none;
        }

        .main .item .item_right {
            width: 125px;
            height: 80px;
            float: left;
            padding-left: 10px;
        }

        .main .item .item_right p {
            padding: 0;
            margin: 0;
        }

        .main .item .item_right h3 {
            padding: 0;
            margin: 0;
            font-size: 12px;
            padding-bottom: 5px;
        }

        .ceateDate {
            font-size: 12px;
        }
    </style>
    <script type="text/javascript" src="/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript">
        $(function () {
            var imgs = $(".posterImg");
            for (var i = 0; i < imgs.length; i++) {
                var img = imgs[i];
                var imgId = img.id;
                var imgWidth = img.width;
                var imgHeight = img.height;
                var id = imgId.replace("p_", "");
                $.post(baseUrl + "/ntsService/posterImg?r=" + Math.random(), {id: id, size: imgWidth + "x" + imgHeight}, function (data) {
                    $("#p_" + data.id).attr("src", data.src);
                    alert(data.src);
                });
            }
        });
    </script>
</head>
<%
    ResultSet result = null;
    Connection connection = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://192.168.1.201:3306/rmsyin?useUnicode=true&characterEncoding=utf8", "root", "bfrootpassword");
        PreparedStatement ps = connection.prepareStatement("SELECT id,name,date_created FROM program WHERE other_option=128 and state=5 ORDER BY date_created DESC limit 0,9");
        result = ps.executeQuery();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<body>
<div class="main">

    <%
        if (result != null) {
            try {
                while (result.next()) {
                    long id = result.getLong("id");
                    String name = result.getString("name");
                    Date createDate = result.getDate("date_created");

    %>

    <div class="item">
        <div class="item_left">

            <a href="<%="/program/showProgram/" + id%>" target="_blank"><img id="p_<%=id%>" class="posterImg"
                                                                                 height=60
                                                                                 alt=""
                                                                                 src=''
                                                                                 width=80
                                                                                 border=0
                                                                                 onerror="this.src = '/images/defaultPoster.jpg'">
            </a>
        </div>

        <div class="item_right">
            <h3 title=""><a
                    href='<%="/program/showProgram/" + id%>' target="_blank"><%=name%>
            </a>
            </h3>

            <p title="" class="ceateDate">
                [<%=createDate%>]
            </p>

        </div>
    </div>
    <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
    <div style="text-align:right;width:660px"><a href="http://ura.tust.edu.cn/" target="_blank"><img border="0"
                                                                                                     src="http://urp.tust.edu.cn/images/more.jpg"/></a>
    </div>
</div>


</body>
</html>
