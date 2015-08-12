/***
 *判断浏览器
 */

/***
 * IE浏览器
 * @returns {boolean}
 */
function isIE(){
    if(navigator.appVersion.indexOf('MSIE')!=-1){
        return true;
    }else if((navigator.appVersion.indexOf('Windows')!=-1)&&(navigator.appVersion.indexOf('Trident')!=-1)){
        return true;
    }else{
        return false;
    }
}

