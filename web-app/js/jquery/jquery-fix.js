/**
 * Created with IntelliJ IDEA.
 * User: ligson
 * Date: 13-12-3
 * Time: 上午9:21
 * To change this template use File | Settings | File Templates.
 */
if(!$.browser){
    $.browser={};
}
$.browser.mozilla=/firefox/.test(navigator.userAgent.toLowerCase());
$.browser.webkit=/webkit/.test(navigator.userAgent.toLowerCase());
$.browser.opera=/opera/.test(navigator.userAgent.toLowerCase());
$.browser.msie=/msie/.test(navigator.userAgent.toLowerCase());