/**
 * Created by Administrator on 13-12-16.
 */
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
/**
 * 用户登陆过期处理
 */
$(document).ajaxError(function (event, request, settings) {
    if (request.responseText.indexOf("后台_登陆页面") != -1) {
        alert("由于长时间未操作，请重新登陆！！！");
        window.location.reload();
    }
});
var alertTabIndex = 20;
function myAlert(msg, title) {
    var dialogId = "alertDialog-" + (new Date().getTime() + parseInt(Math.random() * 1000));


    var html = "<div  id=\"" + dialogId + "\" style=\"display:none;\">" +
        "<div class=\"dialogMsg\" style=\"width:100%;height:100%;text-align:center;\"></div>" +
        "</div>";
    $("body").append(html);

    //$("#dialogMsg").empty().append(msg);
    //title: "Dialog Title"
    var alertDialog = $("#" + dialogId);
    alertDialog.find(".dialogMsg").empty().append(msg);
    if (title) {
        alertDialog.dialog({title: title.isEmpty() ? "提示" : title, modal: true});
    } else {
        alertDialog.dialog({title: "警告", modal: true});
    }

    alertDialog.parent().attr("tabindex", alertTabIndex++);
    alertDialog.dialog("open");
}
function myConfirm(msg, title, clickOk, clickCancel) {
    $("#confirmMsg").empty().append(msg);
    //title: "Dialog Title"
    var confirmDialog = $("#confirmDialog");
    if (title) {
        confirmDialog.dialog({title: title.isEmpty() ? "确认" : title});
    } else {
        confirmDialog.dialog({title: "确认"});
    }
    confirmDialog.dialog({buttons: {
        "确认": function () {
            if (clickOk) {
                clickOk();
            }
            confirmDialog.dialog("close");
        },
        "取消": function () {
            if (clickCancel) {
                clickCancel();
            }
            confirmDialog.dialog("close");
        }
    }});
    confirmDialog.dialog("open");
}

function myConfirmPars(msg, title, clickOk, clickCancel, pars) {
    $("#confirmMsg").empty().append(msg);
    //title: "Dialog Title"
    var confirmDialog = $("#confirmDialog");
    if (title) {
        confirmDialog.dialog({title: title.isEmpty() ? "确认" : title});
    } else {
        confirmDialog.dialog({title: "确认"});
    }
    confirmDialog.dialog({buttons: {
        "确认": function () {
            if (clickOk) {
                clickOk(pars);
            }
            confirmDialog.dialog("close");
        },
        "取消": function () {
            if (clickCancel) {
                clickCancel();
            }
            confirmDialog.dialog("close");
        }
    }});
    confirmDialog.dialog("open");
}
function initPaneScrollbar(pane, $Pane) {
    var scrollingContent = $Pane.find("div.scrolling-content:first");
    var height = "100%";
    if (pane == "west") {
        var westHeight = $(".ui-layout-west").height();
        height = westHeight - 57;
    } else if (pane == "center") {
        var mainNav = $(".x_daohang");
        height = $(".ui-layout-center").height() - mainNav.height();
    }
    // re/init the pseudo-scrollbar
    scrollingContent.jScrollPane({
        scrollbarMargin: 0	// spacing between text and scrollbar
        , scrollbarWidth: 8, arrowSize: 16, showArrows: true
    })
        // REMOVE the *fixed width & height* just set on jScrollPaneContainer
        .parent(".jScrollPaneContainer").css({
            width: '100%', height: height
        })
    ;
};
var myLayout = null;
function setMainLayout() {

    //左边
    var sidebar = $("#sidebar");
    //右边
    var mainDiv = $("#main");
    //中间
    var content = $("#content");

    //header
    var header = $("#header");
    //footer
    var footer = $("#footer");

    //右边上边导航
    var mainNav = $(".x_daohang");
    //右边内容
    var mainContent = $(".programMgrMain");

    var middleHeight = 768 - 91 - 61 - 160;
    myLayout = $("body").layout({
        // applyDefaultStyles:true,
        defaults: {
            autoResize: true,
            minSize: 50,
            slidable: false,
            paneClass: "pane" 		// default = 'ui-layout-pane'
            , resizerClass: "resizer"	// default = 'ui-layout-resizer'
            , togglerClass: "toggler"	// default = 'ui-layout-toggler'
            , buttonClass: "button"	// default = 'ui-layout-button'
            , contentSelector: ".content"	// inner div to auto-size so only it scrolls, not the entire pane!
            , contentIgnoreSelector: "span"		// 'paneSelector' for content to 'ignore' when measuring room for content
            , togglerLength_open: 35			// WIDTH of toggler on north/south edges - HEIGHT on east/west edges
            , togglerLength_closed: 35			// "100%" OR -1 = full height
            , hideTogglerOnSlide: true		// hide the toggler when pane is 'slid open'
            , togglerTip_open: "Close This Pane", togglerTip_closed: "Open This Pane", resizerTip: "Resize This Pane"
            //	effect defaults - overridden on some panes
            , fxName: "slide"		// none, slide, drop, scale
            , fxSpeed_open: 750, fxSpeed_close: 1500, fxSettings_open: { easing: "easeInQuint" }, fxSettings_close: { easing: "easeOutQuint" }
        },
        north: {
            paneSelector: ".ui-layout-north",
            resizable: false,
            size: 91,
            minWidth: 1024,
            minHeight: 91,
            slidable: false,
            spacing_open: -1			// cosmetic spacing
            , togglerLength_open: -1			// HIDE the toggler button
            , togglerLength_closed: -1			// "100%" OR -1 = full width of pane
            //	override default effect
            , fxName: "none"
        },

        south: {
            paneSelector: ".ui-layout-south",
            resizable: false,
            size: 61,
            minHeight: 61,
            minWidth: 1024,
            slidable: false,
            spacing_open: -1			// cosmetic spacing
            , togglerLength_open: -1			// HIDE the toggler button
            , togglerLength_closed: -1			// "100%" OR -1 = full width of pane
            //	override default effect
            , fxName: "none"
        },
        west: {
            paneSelector: ".ui-layout-west",
            resizable: false,
            closable: true,
            size: 200,
            minWidth: 200,
            minHeight: middleHeight,
            slidable: false,
            // minHeight: 500,
            spacing_closed: 21			// wider space when closed
            , togglerLength_closed: 21			// make toggler 'square' - 21x21
            , togglerAlign_closed: "top"		// align to top of resizer
            , togglerLength_open: 0			// NONE - using custom togglers INSIDE west-pane
            , togglerTip_open: "Close West Pane", togglerTip_closed: "Open West Pane", resizerTip_open: "Resize West Pane", slideTrigger_open: "click" 	// default
            , initClosed: false
            //	add 'bounce' option to default 'slide' effect
            , fxSettings_open: { easing: "easeOutBounce" },
            //autoResize: false,
            showOverflowOnHover: true,
            onresize: function () {
                var westHeight = $(".ui-layout-west").height();
                var sideBarTitleHeight = $(".sidebar_title").height();

                $(".ui-layout-west").find(".scrolling-content").css("height", westHeight - 57);
                initPaneScrollbar('west', myLayout.panes.west);
            }
        },
        center: {
            paneSelector: ".ui-layout-center",
            minWidth: 500,
            minHeight: middleHeight,
            onresize: function () {
                mainContent.css("height", $(".ui-layout-center").height() - mainNav.height());
                // initPaneScrollbar('center', myLayout.panes.center);
            }
            //minWidth:500,
            //minHeight: 500
        }


    });

    $(".sidebar_title").click(function () {
        myLayout.toggle("west");
    });
    mainContent.css("height", $(".ui-layout-center").height() - mainNav.height());
    myLayout.resizeAll();
    var westHeight = $(".ui-layout-west").height();

    var sideBarTitleHeight = $(".sidebar_title").height();

    $(".ui-layout-west").find(".scrolling-content").css("height", westHeight - 57);

    initPaneScrollbar('west', myLayout.panes.west);
    //initPaneScrollbar( 'east', myLayout.panes.east );
    //initPaneScrollbar('center', myLayout.panes.center);

    //alert("init ....................................ui.");
}

$(function () {
    $(window).load(function () {
        //  alert("load comp......");
        $("#boful_ui_shaded").hide();
    });
    //resizeMainUI();
    setMainLayout();
    $("#menu").menu();
});
