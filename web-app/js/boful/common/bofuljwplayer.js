var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if ('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}

function isIE() { //ie?
    if (!!window.ActiveXObject || "ActiveXObject" in window)
        return true;
    else
        return false;
}

function jwplayerInit(div, playlist, width, height, autostart, showeq) {
    var primary = "flash";
    var sUserAgent = navigator.userAgent;
    if ((sUserAgent.toLowerCase().indexOf("trident") > -1 && sUserAgent.indexOf("rv") > -1) || sUserAgent.indexOf("MSIE") > -1) {
        primary = "flash";
    }
    jwplayer.key = "ktWIk7l3bcd4z5Qe3GGwiYbMPu3Tu3Mhk2ifmbTkqLI=";
    jwplayer("" + div).setup({
        playlist: playlist,
        startparam: "start",
        autostart: autostart,
        fallback: false,
        abouttext: '关于 邦丰播放器',
        aboutlink: 'http://www.boful.com',
        analytics: {
            enabled: false
        },
        primary: primary,
        width: width,
        height: height,
        showeq: showeq,
        logo: {
            file: baseUrl + "js/jwplayer/img/boful_paly.png",
            link: "http://www.boful.com"

        }
    });
}
