var flashvars = {};
var params = {
    quality: "high",
    type: "application/x-shockwave-flash",
    bgcolor: "#000000"
};
var attributes = {};

function initSWF(url, div, width, height) {
    //swfobject.embedSWF(url, "" + div, width, height, "6", flashvars, params, attributes);
    swfobject.embedSWF(url, "" + div, width, height, "9.0.0", null, null, {wmode: "transparent"});
}