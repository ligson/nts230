/**
 * Created by xuzhuo on 14-4-4.
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
 * 收藏
 * @param id
 * @param name
 */
function collectionProgram(id, name) {
    if (name == "" || name == 'anonymity') {
        alert("请先登录!");
        return;
    }
    var collection_program = document.getElementById("collection_program");
    $.post(baseUrl+"program/collectProgram", {id: id}, function (data) {
        if (data.success == true) {
            collection_program.style.backgroundColor = "#999";
            collection_program.style.color = "#ffffff";
            collection_program.innerText = "已收藏";
            collection_program.onclick = "";
        }
        alert(data.msg);
    })

}
/**
 *推荐
 */
function recommendProgram(id, name) {
    if (name == "" || name == 'anonymity') {
        alert("请先登录!");
        return;
    }
    var recommend_Program = document.getElementById("recommend_Program");
    $.post(baseUrl+"program/recommendProgram", {id: id}, function (data) {
        if (data.success == true) {
            recommend_Program.style.backgroundColor = "#999";
            recommend_Program.style.color = "#ffffff";
            recommend_Program.innerText = "已推荐";
            recommend_Program.onclick = "";
        }
        alert(data.msg);
    })
}