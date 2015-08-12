String.prototype.trim = function () {
    return this.replace(/(^\s*)|(\s*$)/g, "");
};
String.prototype.isEmpty = function () {
    return this.trim() == "";
};
String.prototype.isEmail = function () {
    var pattern = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
    return pattern.test(this);
};

String.prototype.isIPv4 = function () {
    var exp = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
    return exp.test(this);
};

String.prototype.isIPv6 = function () {
    var exp = /^([\da-fA-F]{1,4}:){7}[\da-fA-F]{1,4}$/;
    return exp.test(this);
};
//验证域名
String.prototype.isDomainName = function () {
    var exp = /^(([0-9a-z_!~*'()-]+\.)*([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\.[a-z]{2,6})$/;
    return exp.test(this);
}

String.prototype.isURL = function () {
    var strRegex = "^((https|http|ftp|rtsp|mms)?://)"
        + "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?" //ftp的user@
        + "(([0-9]{1,3}\\.){3}[0-9]{1,3}" // IP形式的URL- 199.194.52.184
        + "|" // 允许IP和DOMAIN（域名）
        + "([0-9a-z_!~*'()-]+\\.)*" // 域名- www.
        + "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\." // 二级域名
        + "[a-z]{2,6})" // first level domain- .com or .museum
        + "(:[0-9]{1,4})?" // 端口- :80
        + "((/?)|" // a slash isn't required if there is no file name
        + "(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";
    var re = new RegExp(strRegex);
    return re.test(this);
};


//测试是否是数字
String.prototype.isNumeric = function () {
    var tmpFloat = parseFloat(this);
    if (isNaN(tmpFloat))
        return false;
    var tmpLen = this.length - tmpFloat.toString().length;
    return tmpFloat + "0".Repeat(tmpLen) == this;
};
//测试是否是整数
String.prototype.isInt = function () {
    if (this == "NaN")
        return false;
    return this == parseInt(this).toString();
};


String.prototype.cut = function (maxLen) {
    if (this == null || this == undefined) {
        return "";
    }
    if (this.length > maxLen) {
        return this.substring(0, maxLen) + "...";
    } else {
        return this;
    }
};

//逆序
String.prototype.reverse = function () {
    return this.split("").reverse().join("");
};


// 合并多个空白为一个空白
String.prototype.resetBlank = function () {
    return this.replace(/s+/g, " ");
};
// 除去左边空白
/**
 * @return {string}
 */
String.prototype.LTrim = function () {
    return this.replace(/^s+/g, "");
};
// 除去右边空白
/**
 * @return {string}
 */
String.prototype.RTrim = function () {
    return this.replace(/s+$/g, "");
};

// 保留数字
String.prototype.getNum = function () {
    return this.replace(/[^d]/g, "");
};
// 保留字母
String.prototype.getEn = function () {
    return this.replace(/[^A-Za-z]/g, "");
};
// 保留中文
String.prototype.getCn = function () {
    return this.replace(/[^u4e00-u9fa5uf900-ufa2d]/g, "");
};
// 得到字节长度
String.prototype.getRealLength = function () {
    return this.replace(/[^x00-xff]/g, "--").length;
};
// 从左截取指定长度的字串
String.prototype.left = function (n) {
    return this.slice(0, n);
};
// 从右截取指定长度的字串
String.prototype.right = function (n) {
    return this.slice(this.length - n);
};
// HTML编码
String.prototype.HTMLEncode = function () {
    var re = this;
    var q1 = [ /x26/g, /x3C/g, /x3E/g, /x20/g ];
    var q2 = [ "&", "<", ">", " " ];
    for (var i = 0; i < q1.length; i++)
        re = re.replace(q1[i], q2[i]);
    return re;
};
// Unicode转化
String.prototype.ascW = function () {
    var strText = "";
    for (var i = 0; i < this.length; i++)
        strText += "&#" + this.charCodeAt(i) + ";";
    return strText;
};