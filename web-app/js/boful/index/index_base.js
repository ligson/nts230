/**
 * Created by ligson on 14-3-9.
 */

$(function () {
    //logo图片加载
    $.post(baseUrl + "mobileApp/webLogeUrl", function (data) {
        if (data.success) {
            if (data.webLogeUrl) {
                $("#webBofulLogo").find("img").eq(0).attr("src", data.webLogeUrl);
            }
        }
    });
    $("#search_input").click(function () {
        $("#search_input").val('');
    });
    $(".imgLazy").lazyload({
        effect: "fadeIn"
    });

    var navItems = $(".nav_items").find(".nav_item");
    navItems.click(function () {
        $.cookie("index_nav_id", null, {path: "/"});
        $.cookie("index_nav_id", $(this).attr("id"), {path: "/"});
    });
    var navId = $.cookie("index_nav_id");
    if (navId) {
//        $("#" + navId).find("a").css("color", "#53A93F");
        $("#" + navId).find("a").addClass("currentnav");
    }

    $("#returnTop").click(function () {
        $("body,html").animate({scrollTop: 0}, 1000);
        return false;
    });

    $(".boful_footer_code_small1").click(function () {

        var footerCode = $("#footerCode");
        if (footerCode.css("display") == "block") {
            footerCode.hide("slow");
        } else {
            footerCode.show("slow");
        }

    });
    //显示隐藏用户名下面的菜单
    //这里获取class属性，因为获取id，在其他页面会获取不到
    var user_meau_sub_list = $(".user_meau_sub_list");
    var user_name = $(".head_portrait");
    user_name.bind('mouseover', function (e) {
        user_meau_sub_list.show();
        user_meau_sub_list.css("left", $(".head_portrait").offset().left - 35);
    });

    //20140721添加导航栏选中状态设置
    var userSubList = $(".user_meau_sub_list").find("a");
    userSubList.click(function () {
        $.cookie("index_nav_id", null, {path: "/"});
        $.cookie("index_nav_id", $(this).attr("id"), {path: "/"});
    });
    var subId = $.cookie("index_nav_id");
    if (subId) {
        $("#" + subId).css("color", "#53A93F");
    }

    $(".wrap").mouseleave(function () {
        $(".user_meau_sub_list").hide();
    });
    /*之前的*/
    /*    var user_meau_sub_list = $(".user_meau_sub_list");
     var show_my = $("#show_my");

     show_my.mousemove(function () {
     $(".user_meau_sub_list").show();
     if (user_meau_sub_list.css("display") == "block") {
     user_meau_sub_list.css("left", show_my.offset().left);
     }
     });
     $(".wrap").mouseleave(function () {
     $(".user_meau_sub_list").hide();
     });*/
    $("#searchSelectBtn").mouseover(function () {
        $("#searchMenu").slideDown();
    });

    $(".wrap").mouseleave(function () {
        $("#searchMenu").slideUp();
    });
    $("#searchMenu").find("div").click(function () {
        var bg = $($(this).find("span")[0]).css("backgroundImage");
        var name = $($(this).find("span")[0]).attr("lang");
        $("#searchSelectCondition").val(name);
        $($("#searchSelectBtn").find("span")).css("backgroundImage", bg);
        $("#searchMenu").slideUp();

        $("#searchSelectCondition").val($($(this).find("span")[0]).attr("lang"));
    });

    $('a[rel*=leanModal]').leanModal({ top: 200, closeButton: ".modal_close" });
    //显示评分星星
    /*var programIds = $("input[name='programId']")//得到所有program
     for(var i=0; i<programIds.size(); i++){
     var programId = programIds[i].value;
     var serialLinkValue = $("#serialLink"+programId).val()/2;
     var serialLinkShowDiv = $("div[name='serialLinkShow"+programId+"']");
     serialLinkShowDiv.raty({readOnly: true, score: serialLinkValue});
     }*/
    $("#boful_username").click(function () {
        $(this).val('');
    })
});

function resizeIndexBaseUI() {
    var toolbar = $(".boful_toolbar");
    var bofulLogo = $(".boful_logo");
    var headerNav = $(".header_nav");
    var footer = $(".boful_footer");
    var copyRight = $(".foot_copyright");
    var win = $(window);
    if (win.width() >= 1024) {
        toolbar.css("width", win.width());
        bofulLogo.css("width", win.width());
        headerNav.css("width", win.width());
        footer.css("width", win.width());
        copyRight.css("width", win.width());
    } else {
        toolbar.css("width", 1024);
        bofulLogo.css("width", 1024);
        headerNav.css("width", 1024);
        footer.css("width", 1024);
        copyRight.css("width", 1024);
    }
}

$(function () {
    resizeIndexBaseUI();
    $(window).resize(function () {
        resizeIndexBaseUI();
    });

    var posterArray = $(".program_poster");
    $.each(posterArray, function (index, data) {
//        var posterId = $(data).attr("programId");
//        var posterSize = $(data).attr("size");
//        loadPoster(posterId, posterSize, $(data));
        var posterName = $(data).attr("posterName");
        loadPoster(posterName, $(data));
    })
});

//function loadPoster(programId, size, target) {
//    $.post(baseUrl + "ntsService/posterImg", {id: programId, size: size}, function (data) {
//        target.attr("data-original", data.src);
//        target.attr("src", data.src);
//    });
//}

function loadPoster(programName, target) {
    var src;
    if(programName == "boful_default_img.png") {
        src = baseUrl + "images/poster/"+programName;
    }else{
        src = baseUrl + "/skin/blue/pc/front/images/"+programName;
    }
    target.attr("data-original", src);
    target.attr("src", src);
}


//用户登录回车提交 2014-04-24
document.onkeydown = function (event) {
    if ($("#signup").is(':hidden')) {
        return;
    } else {
        e = event ? event : (window.event ? window.event : null);
        if (e.keyCode == 13) {
            document.getElementById("checkLoginButton").click();
        }
    }

};

//检测HTML5css3
$(function(){
    if (canvasSupported() && (Modernizr.borderradius) && (Modernizr.csstransforms)) {
        $('#html5css3').css("display", "none");
    } else {
        $('#html5css3').css("display", "block");

    }
});

function canvasSupported() {
    var canvas = document.createElement('canvas');
    return (canvas.getContext && canvas.getContext('2d'));
}
