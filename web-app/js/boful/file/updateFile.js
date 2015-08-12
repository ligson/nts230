var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if ('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
var i = 0;
var api_gallery = [];
var api_titles = [];
var api_descriptions = [];
//鼠标移动显示下载分享等
function mousIn() {
    $("table").delegate("tr[name=userFile]", "mouseenter", function (e) {
        e.stopPropagation();
        var itemType = $(this).attr("name").toString();
        var currentItemId = 0;
        if (itemType == "userFile") {
            currentItemId = $(this).attr("id").toString().replace("userFileDiv_", "");
        } else {
            currentItemId = $(this).attr("id").toString().replace("categoryDiv_", "");
        }

        var curentChkBox = $("#checkBox_" + currentItemId);

        $(this).find(".shar_tools").css("display", "block");
        //if(isShow){
        if (!curentChkBox.prop("checked")) {
            $(this).css("background-color", "#E3FCE4");
        }

        //}


    });
}
function removeSelect(objId) {
    var item = $("#" + objId);
    var itemType = item.attr("name");
    var currentItemId = 0;
    if (itemType == "userFile") {
        currentItemId = item.attr("id").toString().replace("userFileDiv_", "");
    } else {
        currentItemId = item.attr("id").toString().replace("categoryDiv_", "");
    }

    /*var check = $("#checkBox_" + currentItemId).prop("checked");



     if (!check) {
     item.css("backgroundColor", "#FFFFFF");
     }*/

}
//鼠标移动显示下载分享等
function mousOu() {
    $("table").delegate("tr[name=userFile]", "mouseleave", function (e) {
        e.stopPropagation();

        var trId = $(this).attr("id").toString();
        var fileItemId = trId.replace("userFileDiv_", "");
        //console.log(fileItemId)
        if ($("checkBox_" + fileItemId).attr("checked") == "checked") {
            showTrBg(fileItemId);
        } else {
            $(this).find(".shar_tools").css("display", "none");
            $(this).css("background-color", "#FFFFFF");
        }
    });
}

$(function () {
    /*$("#userFileDiv div[name=fileSize]").each(function(){
     var div=convertHumanUnit($(this).text().trim());
     $(this).empty().text(div);
     });*/
    mousIn();
    mousOu();
    var isFlag = isIE();
    var uploadListDialog = $("#uploadListDialog");
    uploadListDialog.dialog({autoOpen: false, height: 450, width: 710, dialogClass: "no-close", position: ['right', 'bottom'], close: function () {
        if (isFlag) {
            uploadListDialog.parent().hide();
        } else {
            uploadListDialog.dialog("close");
        }

    }, buttons: {
        "关闭": function () {
            if (isFlag) {
                uploadListDialog.parent().hide();
            } else {
                uploadListDialog.dialog("close");
            }
            /*var sharingForm = $("#panel panel-primary");
             var select = sharingForm.find("select");
             if ($($(select).find("option:selected")).val()) {
             sharingForm.submit();
             }*/
        }
    }});
    if (isFlag) {
        $(".no-close .ui-dialog-titlebar-close").css("display", "none");
    }
    $("#uploadpanle").click(function () {
        if (isFlag) {
            uploadListDialog.parent().show();
        }
        uploadListDialog.dialog("open");
    });


    var pars = {'page': i, 'showCount': 10};
    $('#loadingDiv table').scrollPagination({
        'contentPage': baseUrl + 'my/autoLoadingFile', // 抓取的url
        'contentData': pars, // 这些变量可以通过请求, for example: children().size() to 知道哪个页面
        'scrollTarget': $(window), //滚动完整的窗口
        'heightOffset': 10, // 它将请求当滚动页面结束前10像素
        'beforeLoad': function () { // 加载函数之前,您可以显示预紧器div
            pars.categoryId = $("#categoryId").val();
            var maxCount = $("#maxCount").val();
            var recycle = $("#recycle").val();
            var fileCount;
            if (recycle == 'recycle') {
                fileCount = $('#recycleFileDiv tr').length;
            } else {
                fileCount = $('#userFileDiv tr').length;
            }


            var pageCount = Math.ceil(maxCount / pars.showCount);
            var searchName = $("#searchName").val();
            var recycle = $("#recycle").val();
            pars.page = ++i;
            pars.maxCount = maxCount;
            pars.fileCount = fileCount;
            pars.searchName = searchName;
            pars.isRecycle = recycle;
            $('#loading').fadeIn();
        },
        'afterLoad': function (elementsLoaded) { // 加载内容之后,您可以使用这个函数来激活你的新元素
            $('#loading').fadeOut();
            var i = 0;
            $(elementsLoaded).fadeInWithDelay();
            var maxCount = $("#maxCount").val();
            var index;
            var recycle = $("#recycle").val();
            if (recycle == 'recycle') {
                index = $("#recycleFileDiv tr").length + $("#loadingDiv tr").length;
            } else {
                index = $("#userFileDiv tr").length + $("#loadingDiv tr").length;
            }
            $("#fileCount").val(index);
            if (index >= maxCount) { // 资源总个数，显示完后提示结束
                $('#nomoreresults').fadeIn();
                $('#loadingDiv table').stopScrollPagination();
            }
        }
    });
    $("#createfolder").click(function () {
        var index = $(".append_folder tr").length;
        if (index == 1) {
            alert("一次只能创建一个文件夹");
        } else {
            var appendDiv = "";
            appendDiv += "<tr><td width=\"40\"><div class='row mysharinglist_line' id='news_folder'>" +
                "<div class='col-md-1 mysharinglist_cent'><input name='checklist' class='checklist' style='margin-top: 8px;'type='checkbox'/></div></td>";
            appendDiv += "<td width=\"370\"><div class='col-md-6' ><span class='myshar_listico share_class_files_icon'  ></span>" +
                "<input class='form-control f_controlsty'   type='text' value='' id='fileValue'><a class='glyphicon glyphicon-ok btn-sm bt1_ie7 wy_sty3' onclick='add_file()'></a>" +
                "<button class='btn-link glyphicon glyphicon-remove btn-sm removeie7 wy_sty2' onclick='dele_folder()' ></button></div></td>"
            appendDiv += "<td width=\"120\"><div class='col-md-2 mysharinglist_cent'></div></td>";
            appendDiv += "<td width=\"100\"><div class='col-md-1 mysharinglist_cent'>--</div></td>";
            appendDiv += "<td><div class='col-md-2 mysharinglist_cent'>--</div></td></tr>"
            $(".append_folder").append(appendDiv);
        }

    });
    $("#sharingFileDialog").dialog({autoOpen: false, width: 700, height: 350, buttons: {
        "分享": function () {
            specialSharing()
        }
    }});
    $("#playViewDialog").dialog({autoOpen: false, width: 1000, height: 600, close: function () {
        $("#playViewDialog").empty();
    }, buttons: {
        "关闭": function () {
            $("#playViewDialog").dialog("close");
            $("#playViewDialog").empty();
        }
    }});

    $("#fileSharViewDialog").dialog({autoOpen: false, width: 600, height: 380, close: function () {
        $("#fileSharViewDialog").empty();
    }, buttons: {
        "关闭": function () {
            $("#fileSharViewDialog").dialog("close");
            $("#fileSharViewDialog").empty();
        }
    }});
    $("#categoryDialog").dialog({autoOpen: false, width: 400, height: 600, buttons: {
        "移动": function () {
            var s = "";
            var checkBoxArray = $('input[name="checkFileList"]:checked');
            $(checkBoxArray).each(function (i) {
                s += $(this).val();
                if (i < $(checkBoxArray).size() - 1) {
                    s += ','
                }
            });
//            alert(s)
            $("#fileId").val(s);
            if (s == "") {
                alert("请至少选择一个文件");
                return false;
            }
            var zid = $("#zid").val();
            var fileId = $("#fileId").val();
            if (fileId != '') {
                $.post(baseUrl + "userFile/updateFileCategory", {categoryId: zid, fId: fileId}, function (data) {
                    if (data.success) {
                        $("#categoryDialog").dialog("close");
                        var idArray = fileId.split(',');
                        for (var i = 0; i < idArray.length; i++) {
                            $("#userFileDiv_" + idArray[i]).remove();
                        }

                    } else {
                        alert(data.msg);
                    }

                })

            }
        }
    }});
    $("#fileRoleDialog").dialog({autoOpen: false, width: 700, height: 500});
    $("#deleteFileOrCategory").click(function () {
        if ((!hasChecked("checkFileList")) && (!hasChecked("checkCategoryList"))) {
            alert("请至少选择一条!");
            return false;
        } else {
            var fileIdList = getCheckBoxListStr("checkFileList");
            var categoryIdList = getCheckBoxListStr("checkCategoryList");
            if (fileIdList.length > 0) {
                $(document).queue(function () {
                    deleteFile(fileIdList);
                });
            }
            if (categoryIdList.length > 0) {
                $(document).queue(function () {
                    deleteCategory(categoryIdList);
                });
            }
        }
    });

    $("#sharing").click(function () {
        if ((!hasChecked("checkFileList"))) {
            alert("请至少选择一条!");
            return false;
        } else {
            var url = baseUrl + "userSpecial/queryAllCommunity";
            $.post(url, function (data) {
                var communityList = data.communityList;
                var commDiv = "";
                if (communityList && communityList.length > 0) {
                    for (var i = 0; i < communityList.length; i++) {
                        commDiv += "<p onclick=\"showBoard(" + communityList[i].id + ");showBg(this)\">" + communityList[i].name + "</p>";
                    }
                } else {
                    commDiv += "<span>请先创建或者加入一个社区</span>"
                }

                $("#communityDiv").empty().append(commDiv);
                $("#sharingFileDialog").dialog("open");
            });

            /*$.post(baseUrl + "userFile/sharingFile", {idList: fileIdList, canPublic: 'true'}, function (data) {
             if (!data.success) {
             alert("更改失败");
             } else {
             alert(data.msg);
             }
             });*/
        }
    });

    /*$("table").delegate("tr[name=userFile]","mousemove",function(e){
     e.stopPropagation();
     $("#categoryId").val('');
     $("#categoryName").val('');
     var inputId;
     var inputHash;
     var inputName;
     var index1=$("#userFileDiv tr").index(this);
     var index2=$("#recycleFileDiv tr").index(this);
     var index3=$("#loadingDiv tr").index(this);
     if(index1!=-1){
     inputId =$("#userFileDiv #fid")[index1];
     inputHash =$("#userFileDiv #hash")[index1];
     inputName = $("#userFileDiv #fname")[index1];
     }
     if(index2!=-1){
     inputId =$("#recycleFileDiv #fid")[index2];
     inputHash =$("#recycleFileDiv #hash")[index2];
     inputName = $("#recycleFileDiv #fname")[index2];
     }
     if(index3!=-1){
     inputId =$("#loadingDiv #fid")[index3];
     inputHash =$("#loadingDiv #hash")[index3];
     inputName = $("#loadingDiv #fname")[index3];
     }
     var id = inputId.value;
     var hash = inputHash.value;
     var fname = inputName.value;
     $("#fileId").empty().val(id);
     $("#fileHash").empty().val(hash);
     $("#fileName").empty().val(fname);
     });
     */
    /*$("table").delegate("tr[name=category]","mousemove",function(e){
     e.stopPropagation();
     $("#fileId").empty().val('');
     $("#fileHash").empty().val('');
     $("#fileName").empty().val('');
     var index=$("#categoryDiv tr").index(this);
     var inputId = $("#categoryDiv #cId")[index];
     var inputName = $("#categoryDiv #cName")[index];
     var id = inputId.value;
     var cName = inputName.value;
     $("#categoryId").val(id);
     $("#categoryName").val(cName);
     });*/

    /*$("#scrollpagboful").click(function(e){
     if($(e.target).is(".allselect")){
     alert('aaaa')
     }
     })*/

    $("div").delegate("input[name=allselect]", "click", function (e) {
        e.stopPropagation();
        var ss = $(".allselect").prop("checked");
        $(".shar_sellectlist input[name=checkCategoryList]").each(function () {
            if (ss) {
                checkboxAll("checkCategoryList");
            } else {
                unCheckboxAll("checkCategoryList");
                $("#scrollpagboful tr").css("backgroundColor", "#FFFFFF");
            }
        });
        $(".shar_sellectlist input[name=checkFileList]").each(function () {
            if (ss) {
                checkboxAll("checkFileList");
            } else {
                unCheckboxAll("checkFileList");
            }
        });
    });

    $("div").delegate("a[name=download]", "click", function (e) {
        e.stopPropagation();
        /**确保该事件只执行一次,不会再被分派到其他节点**/
        downloadFile();
    });
    $("div").delegate("a[name=sharingFile]", "click", function (e) {
        e.stopPropagation();
        sharingFile('true');
    });
    $("div").delegate("a[name=deleteFile]", "click", function (e) {
        e.stopPropagation();
        var fileId = $("#fileId").val();
        deleteFile(fileId);
    });

    $("#searchBtn").click(function () {
        var searchName = $("#searchName").val();
        var parentId = $("#parentId").val();
        var url = baseUrl + "userFile/queryAllFileAndCategorys";
        var pars = {name: searchName, parentId: parentId, search: 'search'};
        appendDiv(url, pars, 'search');
    });

    $("#allFileBtn").click(function () {
        var url = baseUrl + "userFile/queryAllFileAndCategorys";
        var pars = {};
        appendDiv(url, pars);
    });

    $("#recycleBtn").click(function () {
        var url = baseUrl + "userFile/recycleBin";
        var pars = {};
        appendDiv(url, pars, 'recycle');
    });

    if ($("#role").val() != "0") {
        $("#showMaxSize").empty().append(convertHumanUnit($("#maxSpaceSize").val()));
        $("#showUseSize").empty().append(convertHumanUnit($("#useSpaceSize").val()));
        $("#spaceSizeDiv").show();
    }
});
function showTrBg(obj) {

    $("#userFileDiv_" + obj).css("background-color", "#4DB652");
}

function fileItemOut(id) {
    var checkBoxArray = $('input[name="checkFileList"]:checked');
    for (var i = 0; i < checkBoxArray.length; i++) {
        var chkid = $(checkBoxArray[i]).attr("id");
        var itemId = chkid.replace("checkBox_", "");
        showTrBg(itemId);
    }
}

function userFilebtn(event, id, name, hash, path, tag) {


    showTrBg(id);

    //var isCheck = $("#checkBox_"+id).prop("checked");
    if (event.target) {
        var targetId = event.target.id;
        if (!(targetId && targetId.indexOf("checkBox_") >= 0)) {
            if (event.button == 0) {
                $("#checkBox_" + id).click();
            }

        }
        if (event.buttons == 2) {
            if (!$("#checkBox_" + id).prop("checked")) {
                $("#checkBox_" + id).click();
            }
        }
    }


    var item = $("#userFileDiv_" + id);
    var categoryItem = $("#categoryDiv_" + id);
    var currentItemId = 0;
    if (item) {
        var itemType = item.attr("name");
        if (itemType == "userFile") {
            currentItemId = item.attr("id").toString().replace("userFileDiv_", "");
        }
    } else if (categoryItem) {
        var categoryName = categoryItem.attr('name');
        if (categoryName == 'category') {
            currentItemId = item.attr("id").toString().replace("categoryDiv_", "");
        }
    }

    //alert(tag)
    var check = $("#checkBox_" + currentItemId).prop("checked");


    if (!check) {
        item.css("backgroundColor", "#FFFFFF");
    }


    //$("#checkBox_" + id).attr("checked", true);
    var checkBoxArray = $('input[name="checkFileList"]:checked');
    if ($(checkBoxArray).size() <= 1)
        $("#fileId").empty().val('');
//    $("#categoryId").val('');
    $("#fileHash").empty().val('');
    $("#fileName").empty().val('');
    $("#filePath").empty().val('');

    if (tag == "category") {
        $("#categoryId").val(id);
        $("#categoryName").val(name);
    } else if (tag == "file") {
        if ($(checkBoxArray).size() <= 1)
            $("#fileId").empty().val(id);
        $("#fileHash").empty().val(hash);
        $("#fileName").empty().val(name);
        $("#filePath").empty().val(path);
    }


    if ($('input[class=checklist]:checked').length > 0) {
        updateFileConext();
    }

}

function updateFileConext() {
    var data = [];
    var checkBoxArray = $('input[class="checklist"]:checked');
    if (checkBoxArray.length > 1) {
        data = [
            /*	{header: 'Compressed Menu'}, */
            //   {text: '打开', href: '#',id:'openDiv()'},
            /*{text: '制作专辑', href: '#',id:'createSpecial()'},*/
            {text: '删除', href: '#', id: 'deleteDel()'},
            {text: '分享', href: '#', id: "sharingFile('true')"},
            /*{text: '不公开', href: '#',id:"sharingFile('false')"},*/
            {text: '移动', href: '#', id: 'moveFile()'}
        ];
    } else {
        data = [
            /*	{header: 'Compressed Menu'}, */
            {text: '打开', href: '#', id: 'openDiv()'},
            {text: '下载', href: '#', id: 'downloadFile()'},
            {text: '修改', href: '#', id: 'executeUpdate()'},
            {text: '增加标签', href: '#', id: 'addTag()'},
            {text: '查看详情', href: '#', id: 'showUserFile()'},
            {divider: true},
            /*{text: '制作专辑', href: '#',id:'createSpecial()'},*/
            {text: '重命名', href: '#', id: 'rename()'},
            {text: '删除', href: '#', id: 'deleteDel()'},
            {text: '权限设置', href: '#', id: 'roleSet()'},
            {divider: true},
            {text: '分享', href: '#', id: "sharingFile('true')"},
            /*{text: '不公开', href: '#',id:"sharingFile('false')"},*/
            {text: '移动', href: '#', id: 'moveFile()'}
        ];
    }

    context.destroy("#userFileDiv");
    context.destroy("#loadingDiv");
    context.attach("#userFileDiv", data);
    context.attach("#loadingDiv", data);

}
/**
 * 查看文件详情
 */
function showUserFile() {
    var fileId = $("#fileId").val();
    $.post(baseUrl + "userFile/queryUserFileById", {id: fileId}, function (data) {
        $("#fileSharViewDialog").empty();
        var table = $("<table>", {});
        var tr = $("<tr>", {});
        var td = $("<td>", {});
        var appendDiv = "";
        if (data.userFile.canPublic) {
            data.userFile.canPublic = "是";
        } else {
            data.userFile.canPublic = "否";
        }
        if (data.userFile.allowDownload) {
            data.userFile.allowDownload = "是";
        } else {
            data.userFile.allowDownload = "否";
        }
        if (data.userFile.allowRemark) {
            data.userFile.allowRemark = "是";
        } else {
            data.userFile.allowRemark = "否";
        }
        if (data.userFile.description == null) {
            data.userFile.description = "暂无描述！";
        }
        var tags = data.tags;
        var tagsText = "";
        for (var i = 0; i < tags.length; i++) {
            tagsText += tags[i].name + " ";
        }
        appendDiv += "<tr><td style='width: 90px; text-align: right; font-weight: bold'>名称：</td><td style='text-align: left;'>" + data.userFile.name + "</td></tr>";
        appendDiv += "<tr><td style='width: 90px;text-align: right;font-weight: bold'>描述：</td><td style='text-align: left;'>" + data.userFile.description + "</td></tr>";
        appendDiv += "<tr><td style='width: 90px;text-align: right;font-weight: bold'>公开状态：</td><td style='text-align: left;'>" + data.userFile.canPublic + "</td></tr>";
        appendDiv += "<tr><td style='width: 90px;text-align: right;font-weight: bold'>允许下载：</td><td style='text-align: left;'>" + data.userFile.allowDownload + "</td></tr>";
        appendDiv += "<tr><td style='width: 90px;text-align: right;font-weight: bold'>允许回复：</td><td style='text-align: left;'>" + data.userFile.allowRemark + "</td></tr>";
        appendDiv += "<tr><td style='width: 90px;text-align: right;font-weight: bold'>文件标签：</td><td style='text-align: left;'>" + tagsText + "</td></tr>";
        $("<table class='table' style='margin-top: 20px;'>").append(appendDiv).appendTo("#fileSharViewDialog");
        $("#fileSharViewDialog").dialog("open");
    })
}
function categoryFileId(id, name, hash, tag) {
    /*$("#fileId").empty().val('');
     $("#fileHash").empty().val('');
     $("#fileName").empty().val('');*/

    if (tag == "category") {
        /*$("#categoryId").val(id);
         $("#categoryName").val(name);*/
        $("#categoryDiv_" + id).css("background-color", "#E3FCE4");
        $("#categoryDiv_" + id).css("cursor", "pointer");
    } else if (tag == "file") {
        /*$("#fileId").empty().val(id);
         $("#fileHash").empty().val(hash);
         $("#fileName").empty().val(name);*/
//  2014-07-15号注释：我的文件分享下载按钮闪速
//        $("#userFileDiv_" + id).find(".shar_tools").css("display", "block");
//        $("#userFileDiv_" + id).css("background-color", "#E3FCE4");
    }


}
function fileOut(id) {
    fileItemOut()
//    2014-07-15号注释：我的文件分享下载按钮闪速
    //$("#userFileDiv_" + id).find(".shar_tools").css("display", "none");


//    var a=$("#checkBox_"+id).attr("checked");
//    //alert(a);
//    console.log(a)
//    if(a=="checked"){
//        //console.log("1")
//        return false;
//    }
//    $("#div_" + id).css("background-color", "#00FF00");
}
function folderOut(id) {
    $("#categoryDiv_" + id).css("background-color", "#FFFFFF");
}
function dele_folder() {
    $(".append_folder tr").remove();
}
function resetDel() {
    var fileId = $("#fileId").val();
    var categoryId = $("#categoryId").val();
    if (fileId != '') {
        deleteFile(fileId, 'reset');
    } else if (categoryId != '') {
        deleteCategory(categoryId, 'reset');
    }
}
function fileRole() {
    var fileId = $("#fileId").val();
    var isDownload = $("#fileRoleDialog").find('input:radio[name=isDownload]:checked').val();
    var isPublic = $("#fileRoleDialog").find('input:radio[name=isPublic]:checked').val();
    var isRemark = $("#fileRoleDialog").find('input:radio[name=isRemark]:checked').val();
    if (fileId != '') {
        $.post(baseUrl + "userFile/fileStateSet", {id: fileId, isDownload: isDownload, isPublic: isPublic, isRemark: isRemark}, function (data) {
            alert(data.msg);
            $("#fileRoleDialog").dialog("close");
        })
    }
}
function roleSet() {
    var fileId = $("#fileId").val();
    var categoryId = $("#categoryId").val();
    if (fileId != '') {
        $.post(baseUrl + "userFile/queryUserFileById", {id: fileId}, function (data) {
            var userFile = data.userFile;
            var tags = data.tags;
            if (userFile != null) {
                var appendDiv = "";
                appendDiv += "下载&nbsp;&nbsp;:&nbsp;&nbsp;<input type='radio' value='1' name='isDownload'/>能&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' value='0' name='isDownload'/>否<br/>";
                appendDiv += "点播&nbsp;&nbsp;:&nbsp;&nbsp;<input type='radio' value='1' name='isPublic'/>能&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' value='0' name='isPublic'/>否<br/>";
                appendDiv += "评论&nbsp;&nbsp;:&nbsp;&nbsp;<input type='radio' value='1' name='isRemark'/>能&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' value='0' name='isRemark'/>否<br/>";
                appendDiv += "<input type='button' value='设置' onclick='fileRole()'/>";
                $("#fileRoleDialog").empty().append(appendDiv);
                if (userFile.allowDownload == true) {
                    $("#fileRoleDialog input[name=isDownload]:eq(0)").attr("checked", true);
                    $("#fileRoleDialog input[name=isDownload]:eq(1)").attr("checked", false);
                } else {
                    $("#fileRoleDialog input[name=isDownload]:eq(0)").attr("checked", false);
                    $("#fileRoleDialog input[name=isDownload]:eq(1)").attr("checked", true);
                }
                if (userFile.canPublic == true) {
                    $("#fileRoleDialog input[name=isPublic]:eq(0)").attr("checked", true);
                    $("#fileRoleDialog input[name=isPublic]:eq(1)").attr("checked", false);
                } else {
                    $("#fileRoleDialog input[name=isPublic]:eq(0)").attr("checked", false);
                    $("#fileRoleDialog input[name=isPublic]:eq(1)").attr("checked", true);
                }
                if (userFile.allowRemark == true) {
                    $("#fileRoleDialog input[name=isRemark]:eq(0)").attr("checked", true);
                    $("#fileRoleDialog input[name=isRemark]:eq(1)").attr("checked", false);
                } else {
                    $("#fileRoleDialog input[name=isRemark]:eq(0)").attr("checked", false);
                    $("#fileRoleDialog input[name=isRemark]:eq(1)").attr("checked", true);
                }
                $("#fileRoleDialog").dialog("open");
            }
        })
    } else if (categoryId != '') {
        rename();
    }

}
function openDiv() {
    var fileId = $("#fileId").val();
    var categoryId = $("#categoryId").val();
    if (fileId != '') {
        var fileHash = $("#fileHash").val();
        var fileName = $("#fileName").val();
        var filePath = $("#filePath").val();
        playBtn(fileName, filePath, fileHash);
    } else if (categoryId != '') {
        checkCategory(categoryId);
    }

}
function updateFile(tag) {
    var newName = $("#userFileDiv_" + tag).find("span[id=spanFile1]").find("input").val();
    $.post(baseUrl + "userFile/updateUserFile", {id: tag, name: newName}, function (data) {
        if (data.success) {
            var userFile = data.userFile;
            var name = $("#name").val();
            var appendDiv = "<a title=\"" + userFile.name + "\" onclick=\"playBtn('" + userFile.name + "','" + userFile.filePath + "','" + userFile.fileHash + "')\">" + userFile.name + "</a>";
            $("#userFileDiv_" + tag).find("span[id=spanFile]").empty().append(appendDiv);
            $("#userFileDiv_" + tag).find("span[id=spanFile1]").css("display", "none");
            $("#userFileDiv_" + tag).find("span[id=spanFile]").css("display", "block");
        } else {
            alert("修改失败");
        }
    });
}
function updateCate(tag) {
    var newName = $("#categoryDiv_" + tag).find("span[id=spanCate1]").find("input").val();
    $.post(baseUrl + "userFile/updateCategory", {id: tag, name: newName}, function (data) {
        if (data.success) {
            var userCategory = data.userCategory;
            var appendDiv = "<a onclick=\"checkCategory('" + userCategory.id + "')\">" + userCategory.name + "</a>";
            $("#categoryDiv_" + tag).find("span[id=spanCate]").empty().append(appendDiv);
            $("#categoryDiv_" + tag).find("span[id=spanCate]").css("display", "block");
            $("#categoryDiv_" + tag).find("span[id=spanCate1]").css("display", "none");
        } else {
            alert("修改失败");
        }
    });
}
function resetCate(tag) {
    $("#categoryDiv_" + tag).find("span[id=spanCate]").css("display", "block");
    $("#categoryDiv_" + tag).find("span[id=spanCate1]").css("display", "none");
}
function resetFile(tag) {
    $("#userFileDiv_" + tag).find("span[id=spanFile1]").css("display", "none");
    $("#userFileDiv_" + tag).find("span[id=spanFile]").css("display", "block");
}
function rename() {
    var fileId = $("#fileId").val();
    var categoryId = $("#categoryId").val();
    if (fileId != '') {
        $("#userFileDiv_" + fileId).find("span[id=spanFile]").css("display", "none");
        $("#userFileDiv_" + fileId).find("span[id=spanFile1]").css("display", "block");
    } else if (categoryId != '') {
        $("#categoryDiv_" + categoryId).find("span[id=spanCate1]").css("display", "block");
        $("#categoryDiv_" + categoryId).find("span[id=spanCate]").css("display", "none");
    }

}

function deleteDel() {
    $("#deleteFileOrCategory").click();
    /*  var s="";
     var checkBoxArray=$('input[name="checkList"]:checked');
     var fileIds = "";
     var categoryIds = "";

     $(checkBoxArray).each(function(i){
     $(this).pa
     s+=$(this).val();
     if(i<$(checkBoxArray).size()-1){
     s+=','
     }
     });


     var fileId = $("#fileId").val();
     var categoryId = $("#categoryId").val();
     if (fileId != '') {
     deleteFile(fileId);
     } else if (categoryId != '') {
     deleteCategory(categoryId);
     }*/
}
/**************专辑制作开始************************/
/*function createSpecial() {
 var fileId = $("#fileId").val();
 if (fileId) {
 $.post(baseUrl + "userFile/queryUserFileById", {id: fileId}, function (data) {
 var userFile = data.userFile;
 if (userFile != null) {
 var appendDiv = "";
 appendDiv += "<input id='cateId' type='hidden' value='" + userFile.id + "'>"
 appendDiv += "<table width=\"600\">" +
 "<tr><td>专辑名称</td><td><input name='specialName'></td></tr>";
 appendDiv += "<tr><td>专辑描述</td><td><textarea name=\"specialDesc\" cols=\"100\" rows=\"5\"></textarea></td></tr>";
 appendDiv += "<tr><td>专辑标签</td><td><textarea cols=\"100\" rows=\"2\" name=\"specialTag\">";
 appendDiv += "</textarea>(多标签以空格区分)</td></tr>";
 appendDiv += "<tr><td colspan=\"2\" align=\"text\"><input type=\"button\" onclick='executeSpecialBtn()' value=\"提交\"></td></tr>" +
 "</table>";

 $("#scrollpagboful").empty().append(appendDiv);
 }
 })
 }
 }
 function executeSpecialBtn() {
 var cateId = $("#scrollpagboful").find("input[id=cateId]").val()
 var specialName = $("#scrollpagboful").find("input[name=specialName]").val();
 var specialDesc = $("#scrollpagboful").find("textarea[name=specialDesc]").val();
 var specialTag = $("#scrollpagboful").find("textarea[name=specialTag]").val();
 var tagApp = "";
 if (specialTag.indexOf(" ")) {
 var tags = specialTag.split(" ");
 for (var i = 0; i < tags.length; i++) {
 tagApp += tags[i] + ",";
 }
 } else {
 tagApp = specialTag;
 }
 var pars = {cateId: cateId, specialName: specialName, specialDesc: specialDesc, specialTag: tagApp};
 $.post(baseUrl + "userSpecial/saveUserSpecial", pars, function (data) {
 if (data.success) {
 mySpecial();
 } else {
 alert(data.msg);
 }
 })
 }
 function updateSpecialFileBtn(tag) {

 }
 function updateSpecialBtn(tag) {
 $.post(baseUrl + "userSpecial/querySpecialById", {id: tag}, function (data) {
 var special = data.special;
 var fileList = data.fileList;
 var tags = data.tags;
 if (special != null) {
 var appendDiv = "";
 appendDiv += "<table width=\"600\">" +
 "<tr><td>专辑名称</td><td><input name='specialName' value='" + special.name + "'></td></tr>";
 appendDiv += "<tr><td>专辑描述</td><td><textarea name=\"specialDesc\" cols=\"100\" rows=\"5\">" + special.description + "</textarea></td></tr>";
 appendDiv += "<tr><td>专辑标签</td><td><textarea cols=\"100\" rows=\"2\" name=\"specialTag\">";
 for (var i = 0; i < tags.length; i++) {
 appendDiv += tags[i].name + " ";
 }
 appendDiv += "</textarea>(多标签以空格区分)</td></tr>";
 appendDiv += "<tr><td colspan=\"2\">子文件列表：</td></tr>";
 appendDiv += "<tr><td colspan=\"2\">";
 appendDiv += "<table style='border: 1px solid #dddddd' width='100%'><tr><td width='300' height='30'>文件名</td><td width='200'>上传日期</td><td width='200'>操作</td></tr>";
 for (var i = 0; i < fileList.length; i++) {
 appendDiv += "<tr><td height='30'>" + fileList[i].name + "</td><td>" + new Date(fileList[i].createdDate).toLocaleString() + "</td><td><input type='button' value='编辑' onclick='updateSpecialFileBtn(" + fileList[i].id + ")'/></td></tr>";
 }
 appendDiv += "</table></td></tr>";
 appendDiv += "<tr><td colspan=\"2\" align=\"text\"><input type=\"button\" onclick='executeSpecialBtn()' value=\"提交\"></td></tr>";
 appendDiv += "</table>";

 $("#scrollpagboful").empty().append(appendDiv);
 }
 })
 }

 function mySpecial() {
 $.post(baseUrl + "userSpecial/querySpecial", function (data) {
 var specialList = data.specialList;
 if (specialList.length > 0) {
 var topDiv = $("#topDiv");
 var scrollpagboful = $("#scrollpagboful");
 scrollpagboful.empty();
 topDiv.empty().append("<a>当前位置：我的专辑 ></a><span name=\"app\"></span>");
 var specialApp = "";
 specialApp += "<div id=\"specialDiv\"><table style='border: 1px solid #dddddd' width='100%'>";
 specialApp += "<tr><td width='300' height='30'>专辑名称</td><td width='150'>文件数</td><td width='200'>制作时间</td><td>操作</td></tr>";
 for (var i = 0; i < specialList.length; i++) {
 specialApp += "<tr><td height='30'>" + specialList[i].name + "</td><td>" + specialList[i].planSize + "</td><td>" + new Date(specialList[i].createdDate).toLocaleString() + "</td>";
 specialApp += "<td><input type='button' value='编辑' onclick='updateSpecialBtn(" + specialList[i].id + ")'/></td>";
 }
 specialApp += "</tr></table></div>";
 scrollpagboful.append(specialApp);
 }
 });
 }*/
/*****************专辑制作结束*********************/
function addTag() {
    var fileId = $("#fileId").val();
    var categoryId = $("#categoryId").val();
    if (fileId != '') {
        $.post(baseUrl + "userFile/queryUserFileById", {id: fileId}, function (data) {
            var userFile = data.userFile;
            var tags = data.tags;
            if (userFile != null) {
                var appendDiv = "";
                appendDiv += "<input id='cateId' type='hidden' value='" + userFile.id + "'>"
                appendDiv += "<table width=\"750\" >" +
                    "<tr style='padding: 10px; height:30px;'><td width=\"80\" align='center' height='40' style='font-weight: bold'>名称:&nbsp;&nbsp;</td><td>" + userFile.name + "</td></tr>";
                appendDiv += "<tr><td width=\"80\" align='center' height='40' style='font-weight: bold'>标签:&nbsp;&nbsp;</td><td><textarea class='form-control' width='400' cols=\"60\" rows=\"1\" id=\"cateTag\">";
                for (var i = 0; i < tags.length; i++) {
                    appendDiv += tags[i].name + " ";
                }
                appendDiv += "</textarea><span style='color: red'>(多标签以空格区分!)</span></td></tr>";
                appendDiv += "<tr style='padding: 10px; height:60px;'><td></td><td colspan=\"2\"><input type=\"button\" onclick='executeBtn()' class='btn btn-success' value=\"提交\"></td></tr>" +
                    "</table>";

                $("#scrollpagboful #content").empty().append(appendDiv);
                $("#loadingDiv table").hide();
                $("#scrollpagboful>table").hide();
            }
        })
    } else if (categoryId != '') {
        rename();
    }
}
/*************修改我的文件开始*******************/
function executeBtn() {
    var cateId = $("#cateId").val();
    var cateName = $("#cateName").val();
    var cateDesc = $("#cateDesc").val();
    var cateTag = $("#cateTag").val();
    var tagApp = "";
    if (cateTag.indexOf(" ")) {
        var tags = cateTag.split(" ");
        for (var i = 0; i < tags.length; i++) {
            tagApp += tags[i] + ",";
        }
    } else {
        tagApp = cateTag;
    }
    var pars = {id: cateId, name: cateName, desc: cateDesc, tags: tagApp};
    $.post(baseUrl + "userFile/executeUpdate", pars, function (data) {
        if (data.success) {
            var url = baseUrl + "userFile/queryAllFileAndCategorys";
            var cId = $("#categoryId").val();
            if (cId == "") {
                var pars = {parentId: cId};
                appendDiv(url, pars);
            } else {
                var pars = {parentId: cId, search: 'search'};
                appendDiv(url, pars, 'check');
            }
        } else {
            alert(data.msg);
        }
    })
}
function executeUpdate() {
    var fileId = $("#fileId").val();
    var categoryId = $("#categoryId").val();
    if (fileId != '') {
        $.post(baseUrl + "userFile/queryUserFileById", {id: fileId}, function (data) {
            var userFile = data.userFile;
            var tags = data.tags;
            if (userFile != null) {
                var appendDiv = "";
                appendDiv += "<input id='cateId' type='hidden' value='" + userFile.id + "'>";
                appendDiv += "<table width=\"750\">" +
                    "<tr style='height: 50px; padding: 10px 0;'><td width=\"80\" align='center' style='font-weight: bold'>名称</td><td><input   class='form-control' width='400' id=\"cateName\" value='" + userFile.name + "'></td></tr>";
                if (userFile.description != null) {
                    appendDiv += "<tr  style='height: 120px; padding: 10px 0;'><td width=\"80\" align='center' style='font-weight: bold'>描述</td><td><textarea id=\"cateDesc\"   class='form-control' width='400'  cols=\"15\" rows=\"5\">" + userFile.description + "</textarea></td></tr>";
                } else {
                    appendDiv += "<tr  style='height: 120px; padding: 10px 0;'><td  width=\"80\" align='center' style='font-weight: bold'>描述</td><td><textarea id=\"cateDesc\"   class='form-control' width='400'   cols=\"15\" rows=\"5\"></textarea></td></tr>";
                }

                appendDiv += "<tr  style='height: 50px; padding: 10px 0;'><td width=\"80\" align='center' style='font-weight: bold'>标签</td><td><textarea  class='form-control' width='400' cols=\"100\" rows=\"2\" id=\"cateTag\">";
                for (var i = 0; i < tags.length; i++) {
                    appendDiv += tags[i].name + " ";
                }
                appendDiv += "</textarea>(多标签以空格区分)</td></tr>";
                appendDiv += "<tr  style='height: 50px; padding: 10px 0;'><td></td><td colspan=\"2\" align=\"text\"><input type=\"button\"   class='btn btn-success'  onclick='executeBtn()' value=\"提交\"></td></tr>" +
                    "</table>";
                $("#scrollpagboful #content").empty().append(appendDiv);
                $("#loadingDiv table").hide();
                $("#scrollpagboful>table").hide();
            }
        })
    } else if (categoryId != '') {
        rename();
    }
}
function deleteFile(tag, isFlag) {
    $.post(baseUrl + "userFile/deleteUserFile", {idList: tag, reset: isFlag}, function (data) {
        if (data.success) {
            var ids = data.ids;
            for (var i = 0; i < ids.length; i++) {
                $("#userFileDiv_" + ids[i]).remove();
            }
            if (data.useSize > -1) {
                $("#useSpaceSize").val(data.useSize);
            }
        } else {
            alert("删除失败");
        }
        $(document).dequeue();
    });
}
/*************修改我的文件结束*******************/
function deleteCategory(tag, isFlag) {
    $.post(baseUrl + "userFile/deleteUserCategory", {idList: tag, reset: isFlag}, function (data) {
        if (data.success) {
            var ids = data.ids;
            for (var i = 0; i < ids.length; i++) {
                $("#categoryDiv_" + ids[i]).remove();
            }
            if (data.useSize > -1) {
                $("#useSpaceSize").val(data.useSize);
            }
        } else {
            alert("删除失败");
        }
        $(document).dequeue();
    })
}
function showBg(obj) {
    $("#communityDiv > p").css("background-color", "")
    $(obj).css("background-color", 'rgb(227, 252, 228)')
}
function showBg2(obj) {
    $("#boardDiv > p").css("background-color", "")
    $(obj).css("background-color", 'rgb(227, 252, 228)')
}
function sharingFile(tag) {
    var fileId = $("#fileId").val();
    var url = baseUrl + "userSpecial/queryAllCommunity";
    $.post(url, function (data) {
        var communityList = data.communityList;
        var commDiv = "";
        for (var i = 0; i < communityList.length; i++) {
            commDiv += "<p onclick=\"showBoard(" + communityList[i].id + ");showBg(this)\">" + communityList[i].name + "</p>";
        }
        $("#communityDiv").empty().append(commDiv);
        $("#sharingFileDialog").dialog("open");
    });
    /*$.post(baseUrl + "userFile/sharingFile", {idList: fileId, canPublic: tag}, function (data) {
     if (!data.success) {
     alert("更改失败");
     } else {
     alert(data.msg);
     }
     });*/
}
function downloadFile() {
    var fileId = $("#fileId").val();
    var categoryId = $("#categoryId").val();
    if (fileId != '') {
        var fileHash = $("#fileHash").val();
        var fileName = $("#fileName").val();
        window.location.href = baseUrl + "userFile/downloadFile?id=" + fileId;
    } else if (categoryId != '') {
        alert("文件夹目前还不能下载");
    }

}

function playBtn(fileName, filePath, fileHash) {

    $(".ui-dialog-title").html(fileName);
    var appendDiv = "";
    if (checkFileType(filePath) == '3') {
        api_gallery = [];
        api_titles = [];
        api_descriptions = [];
        var parentId = $("#parentId").val();
        var fileId = $("#fileId").val();
        $.post(baseUrl + "userFile/queryAllUserFile", {parentId: parentId, fileId: fileId}, function (data) {
            for (var i = 0; i < data.length; i++) {
                api_gallery[i] = data[i].filePath;
                if (data[i].desc == null) {
                    api_titles[i] = ""
                } else {
                    api_titles[i] = data[i].desc;
                }

                api_descriptions[i] = data[i].name;
            }
            $.prettyPhoto.open(api_gallery, api_titles, api_descriptions);
            return false
        });
    } else if (checkFileType(filePath) == '1') {
        appendDiv += "<div id=\"boful_video_player\" style=\"width:100%;height:100%;\"></div>";
        $("#playViewDialog").empty().append(appendDiv);
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            var playList = data.fileUrl;
            playList = typeof (playList) == "string" ? eval(playList) : playList;
            jwplayerInit("boful_video_player", playList, "900", "450", true, false);
            $("#playViewDialog").dialog("open");
        }, "json");
    } else if (checkFileType(filePath) == '2') {
        appendDiv += "<div class=\"playdocumment_left_show\" id=\"document_player\" style=\"height: 600px\"></div>";
        $("#playViewDialog").empty().append(appendDiv);
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            flexpaperInit("document_player", data.fileUrl, baseUrl);
            $("#playViewDialog").dialog("open");
        });
    } else if (checkFileType(filePath) == '4') {
        appendDiv += "<div id=\"boful_video_player\" style=\"width:100%;height:20%;\"></div>";
        $("#playViewDialog").empty().append(appendDiv);
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            var playList = data.fileUrl;
            playList = typeof (playList) == "string" ? eval(playList) : playList;
            jwplayerInit("boful_video_player", playList, "900", "20", true, true);
            $("#playViewDialog").dialog("open").height(20);
        });
    } else if (checkFileType(filePath) == '5') {
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            var strHtml = "<div id=\"boful_video_player\" style=\"width:100%;height:100%;\">";
            strHtml = strHtml + "</div>";
            $("#playViewDialog").empty().append(strHtml);

            initSWF(data.fileUrl, "boful_video_player", "900", "450");
            $("#playViewDialog").dialog("open");

//            var playList = data.fileUrl;
//
//            strHtml = strHtml + "<object style=\"overflow:hidden;z-index:90;width:100%;height:100%;\" classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0\" width=\"900\" height=\"450\" align=\"middle\"\>";
//            strHtml = strHtml + "<embed src=\""+playList+"\" quality=\"high\" width=\"900\" height=\"450\"  type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" /\>";
//            strHtml = strHtml + "</object\>";
        });
    } else {
        var fileId = $("#fileId").val();
        if (fileId != '') {
            var fileHash = $("#fileHash").val();
            var fileName = $("#fileName").val();
            window.location.href = baseUrl + "userFile/downloadFile?id=" + fileId;
        }
    }

}
function returnPrevious(tag) {
    var parentId = $("#parentId").val();
    var pars = {};
    var url = baseUrl + "userFile/queryAllFileAndCategorys";
    if (tag == 'recycle') {
        pars = {parentId: parentId, recycle: 'recycle'};
    } else {
        pars = {parentId: parentId};
    }
    appendDiv(url, pars, tag);
}
function add_file() {
    var fileValue = $("#fileValue").val();
    var patrn = /^[0-9a-zA-Z\u4e00-\u9fa5+\.+\《》]+$/;
    if (fileValue == '') {
        alert("文件夹名称不能为空!");
    } else if (patrn.test(fileValue) == false) {
        alert("文件夹名称含有特殊字符!");
    } else {
        var parentId = $("#parentId").val();
        $.post(baseUrl + "userFile/saveUserCategory", {fileName: fileValue, parentId: parentId}, function (data) {
            if (data.success) {
                var userCategory = data.userCategory;
                if (userCategory != null) {
                    var append_folder = $(".append_folder");
                    var categoryDiv = $("#categoryDiv");
                    append_folder.empty();
                    var appendCate = "";
                    appendCate += "<tr onmousedown=\"userFilebtn(event, 'c_" + userCategory.id + "','" + userCategory.name + "','null','category')\" onmousemove=\"categoryFileId(" + userCategory.id + ",'" + userCategory.name + "','null','null','category')\" id=\"categoryDiv_" + userCategory.id + "\"  name=\"category\">";
                    appendCate += "<td width=\"40\"><input type=\"hidden\" id=\"cId\" value=\"" + userCategory.id + "\"/><input type=\"hidden\" id=\"cName\" value=\"" + userCategory.name + "\"/>" +
                        "<div class=\"col-md-1 mysharinglist_cent\" style=\"width: 40px;\"><input id=\"checkBox_c_" + userCategory.id + "\" name=\"checkCategoryList\" class=\"checklist\"  type=\"checkbox\" value=\"" + userCategory.id + "\" /></div></td>";
                    appendCate += "<td width=\"370\"><div style=\"line-height: 28px;\" ondblclick=\"checkCategory('" + userCategory.id + "')\"><span class='myshar_listico share_class_files_icon'></span>" +
                        "<span id=\"spanCate\">" + userCategory.name + "</span><span id=\"spanCate1\" style=\"display: none\">" +
                        "<input class='form-control f_controlsty' value=\"" + userCategory.name + "\" id=\"updateCName\"/><a class='glyphicon glyphicon-ok btn-sm bt1_ie7 wy_sty3' onclick=\"updateCate(" + userCategory.id + ")\"></a>" +
                        "<button class='btn-link glyphicon glyphicon-remove btn-sm removeie7 wy_sty2' onclick=\"resetCate(" + userCategory.id + ")\"></button></span></div></td>";
                    appendCate += "<td width=\"120\"><div><div class=\"shar_tools\">" +
                        "<a style=\"float: left;\"><span  class=\"glyphicon glyphicon-cloud-download btn-sm downloadie7\" style=\"padding: 0;margin: 0 5px;\"></span></a>" +
                        "<a style=\"float: left;\"><span class=\"glyphicon glyphicon-share btn-sm shareie7\" style=\"padding: 0;margin: 0 8px;\"></span></a>" +
                        "<a style=\"float: left;\"> <span  class=\"glyphicon glyphicon-remove btn-sm removeie7\" style=\"padding: 0;margin: 0 5px;\"></span></a></div></div></td>";
                    appendCate += "<td width=\"100\"><div class=\"col-md-1 mysharinglist_cent\" style=\"width: 100px; text-align: left\">--</div></td>";
                    appendCate += "<td><div class=\"col-md-2 mysharinglist_cent\">" + userCategory.createdDate.substr(0, userCategory.createdDate.indexOf('T')) + "</div></td></tr>";
                    categoryDiv.prepend(appendCate);
                    var setting = {
                        async: {
                            autoParam: ["id=parentId"],
                            enable: true,
                            url: baseUrl + "userFile/userCategoryList"
                        },
                        callback: {
                            onAsyncSuccess: zTreeOnAsyncSuccess,
                            onClick: zTreeOnClick
                        },
                        edit: {
                            enable: false,
                            showRemoveBtn: false,
                            showRenameBtn: false
                        }
                    };
                    $.fn.zTree.init($("#zTree"), setting);
                }

            } else {
                alert(data.msg);
            }
        })
    }

}
function check_Files() {
    var url = baseUrl + "userFile/queryAllFileAndCategorys";
    $("#parentId").val('');
    var parentId = $("#parentId").val();
    var pars = {parentId: parentId};
    appendDiv(url, pars);
}
function checkCategory(tag) {
    $("#categoryId").val(tag);
    var url = baseUrl + "userFile/checkCategory";
    var pars = {id: tag};
    appendDiv(url, pars);
}
function optionCategory() {
    var firstName = $("#firstName").val();
    var fileId = $("#fileId").val();
    $.post(baseUrl + "userFile/updateFileCategory", {categoryId: firstName, fId: fileId}, function (data) {
        if (data.success) {
            var newCate = data.newCate;
            var oldCate = data.oldCate;
            if (newCate != oldCate) {
                $("#userFileDiv_" + fileId).remove();
            }
            $("#categoryDialog").dialog('close');
        }
        alert(data.msg);
    })
}
function moveFile() {


    var fileId = $("#fileId").val();
    var categoryId = $("#categoryId").val();
    if (fileId != '')$("#categoryDialog").dialog('open');
}
function searchCategory(tag) {
    var url = baseUrl + "userFile/queryAllFileAndCategorys";
    var pars = {parentId: tag, search: 'search'};
    appendDiv(url, pars, 'check');
}
function appendDiv(url, pars, tag, id) {
    i = 0;
    $.post(url, pars, function (data) {
        var userCategory = data.userCategory;
        var topDiv = $("#topDiv");
        var name = $("#name").val();
        var scrollpagboful = $("#scrollpagboful #content");
        if ($("#loadingDiv table").css("display") == "none") {
            $("#loadingDiv table").show();
        }
        if ($("#scrollpagboful table").css("display") == "none") {
            $("#scrollpagboful table").show();
        }
        $("#loadingDiv table").empty();
        $('#loadingDiv table').attr('scrollpagination', 'enabled');
        var parentId = $("#parentId");
        if (userCategory != null) {
            parentId.empty().val(userCategory.id);
            if (tag == 'recycle') {
                topDiv.find('a').empty().append("<a onclick=\"returnPrevious('recycle')\">返回上一级</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a onclick='check_Files()'>全部文件</a>&nbsp;&nbsp;&nbsp;>&nbsp;&nbsp;&nbsp;");
            } else {
                topDiv.find('a').empty().append("<a onclick=\"returnPrevious('res')\">返回上一级</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a onclick='check_Files()'>全部文件</a>&nbsp;&nbsp;&nbsp;>&nbsp;&nbsp;&nbsp;");
            }

            var appLen = topDiv.find('span[name=app]').find('span').length;

            if (tag == 'res') {
                if (appLen > 0) {
                    /*(topDiv.find('span[name=app]').find('span')[appLen - 1]).remove();*/
                    var n = appLen - 1;
                    $("#topDiv span span:eq(" + n + ")").remove();
                    appLen = topDiv.find('span[name=app]').find('span').length;
                    if (appLen > 3) {
                        for (var i = appLen - 3; i < appLen; i++) {
                            $("#topDiv span span:eq(" + i + ")").show();
                        }
                    }
                    if (n == appLen - 1) {
                        $("#topDiv span span")[n].remove();
                    }
                }
                $("#categoryId").val(userCategory.id);
            } else if (tag != 'search') {
                if (tag == 'check') {
                    var index = $("#topDiv span span").length;
                    var n = pars.parentId;
                    var xx = $("#topDiv span span").index($("#categoryTitle_" + n));
//                    if (xx > 3) {
//                        for (var i = xx - 3; i < xx; i++) {
//                            $("#topDiv span span:eq(" + i + ")").show();
//                        }
//                    }
//                    for (var i = index - 1; i > xx; i--) {
//                        $("#topDiv span span:eq(" + i + ")").empty();
//                    }
                    for (var i = index - 1; i > xx; i--) {
                        $("#topDiv span span:eq(" + i + ")").remove();
                    }
                } else {
                    var index = $("#topDiv span span").length;
                    if (index > 3) {
                        for (var i = 1; i <= index - 3; i++) {
                            $("#topDiv span span:eq(" + i + ")").hide();
                        }
                    }
                    topDiv.find('span[name=app]').append("<span onclick=\"searchCategory(" + userCategory.id + ")\" id='categoryTitle_" + userCategory.id + "'>" + userCategory.name + "&nbsp;&gt;</span>");
                }
                $("#categoryId").val(userCategory.id);
            }

        } else {
            parentId.val("");
            if (tag == 'recycle') {
                topDiv.empty().append("<a>当前位置：回收站 ></a><span name=\"app\"></span>");
                $("#categoryId").val("");
            } else {
                topDiv.empty().append("<a>当前位置：我的文件 ></a><span name=\"app\"></span>");
                $("#categoryId").val("");
            }

        }

        /*var titleDiv = "<table><tr><td><div class=\"col-md-1 mysharinglist_cent\" style=\"width: 40px;\" ><input type=\"checkbox\" name=\"allselect\" class=\"allselect\" /></div>" +
         "</td><td><div class=\"col-md-6 \" style=\"overflow: hidden\">资源名称</div></td>" +
         "<td><div class=\"col-md-2\" style=\"width: 120px;\"></div></td>" +
         "<td><div class=\"col-md-1 mysharinglist_cent\" style=\"width: 100px; text-align: left\" >大小</div></td>" +
         "<td><div class=\"col-md-2 mysharinglist_cent\" >上传时间</div></td></tr></table>";*/
        var outDiv = "<table class=\"append_folder\"></table>";
        var fileList = data.fileList;
        var childCategorys = data.childCategorys;
        var total = data.total;
        $("#fileCount").val(fileList.length);
        if (total)$("#maxCount").val(total);
        var categoryDiv = "";
        if (tag == 'recycle') {
            categoryDiv += "<div id=\"recycleCateDiv\"><table>";
        } else {
            categoryDiv += "<div id=\"categoryDiv\"><table>";
        }

        if (childCategorys != null) {
            for (var i = 0; i < childCategorys.length; i++) {

                categoryDiv += "<tr onmousedown=\"userFilebtn(event, 'c_" + childCategorys[i].id + "','" + childCategorys[i].name + "','null','null','category')\" onmousemove=\"categoryFileId(" + childCategorys[i].id + ",'" + childCategorys[i].name + "','null','category')\" id=\"categoryDiv_" + childCategorys[i].id + "\" onmouseout=\"folderOut(" + childCategorys[i].id + ")\"  name=\"category\">";
                categoryDiv += "<td width=\"40\"><input type=\"hidden\" id=\"cId\" value=\"" + childCategorys[i].id + "\"/><input type=\"hidden\" id=\"cName\" value=\"" + childCategorys[i].name + "\"/>" +
                    "<div class=\"col-md-1 mysharinglist_cent\" style=\"width: 40px;\"><input id=\"checkBox_c_" + childCategorys[i].id + "\" name=\"checkCategoryList\" class=\"checklist\"  type=\"checkbox\" value=\"" + childCategorys[i].id + "\" /></div></td>";
                if (tag == 'recycle') {
                    categoryDiv += "<td width=\"370\"><div style=\"line-height: 28px;\"><span class='myshar_listico share_class_files_icon'></span>";
                } else {
                    categoryDiv += "<td width=\"370\"><div style=\"line-height: 28px;\" ondblclick=\"checkCategory('" + childCategorys[i].id + "')\"><span class='myshar_listico share_class_files_icon'></span>";
                }
                categoryDiv += "<span id=\"spanCate\">";
                categoryDiv += childCategorys[i].name;
                categoryDiv += "</span><span id=\"spanCate1\" style=\"display: none\">" +
                    "<input class='form-control f_controlsty' value=\"" + childCategorys[i].name + "\" id=\"updateCName\"/><a class='glyphicon glyphicon-ok btn-sm bt1_ie7 wy_sty3' onclick=\"updateCate(" + childCategorys[i].id + ")\"></a>" +
                    "<button class='btn-link glyphicon glyphicon-remove btn-sm removeie7 wy_sty2' onclick=\"resetCate(" + childCategorys[i].id + ")\"></button></span></div></td>";
                categoryDiv += "<td width=\"120\"><div><div class=\"shar_tools\">" +
                    "<a style=\"float: left;\"><span  class=\"glyphicon glyphicon-cloud-download btn-sm downloadie7\" style=\"padding: 0;margin: 0 5px;\"></span></a>" +
                    "<a style=\"float: left;\"><span class=\"glyphicon glyphicon-share btn-sm shareie7\" style=\"padding: 0;margin: 0 8px;\"></span></a>" +
                    "<a style=\"float: left;\"> <span  class=\"glyphicon glyphicon-remove btn-sm removeie7\" style=\"padding: 0;margin: 0 5px;\"></span></a></div></div></td>";
                categoryDiv += "<td width=\"100\"><div class=\"col-md-1 mysharinglist_cent\" style=\"width: 100px; text-align: left\">--</div></td>";
                categoryDiv += "<td><div class=\"col-md-2 mysharinglist_cent\">" + childCategorys[i].createdDate.substr(0, childCategorys[i].createdDate.indexOf('T')) + "</div></td></tr>";
            }
        }
        categoryDiv += "</table></div>";
        var fileDiv = "";
        if (tag == 'recycle') {
            fileDiv += "<div id=\"recycleFileDiv\"><input type='hidden' id=\"recycle\" value='recycle'/><table>";
        } else {
            fileDiv += "<div id=\"userFileDiv\"><table>";
        }
        for (var i = 0; i < fileList.length; i++) {
            fileDiv += "<tr onmousedown=\"userFilebtn(event," + fileList[i].id + ",'" + fileList[i].name + "','" + fileList[i].fileHash + "','" + fileList[i].filePath + "','file')\" onmousemove=\"categoryFileId(" + fileList[i].id + ",'" + fileList[i].name + "','" + fileList[i].fileHash + "','file')\" onmouseout=\"fileOut(" + fileList[i].id + ")\" id=\"userFileDiv_" + fileList[i].id + "\" name=\"userFile\"><td width=\"40\"><input value=\"" + fileList[i].fileHash + "\" id=\"hash\" type=\"hidden\"/>" +
                "<input value=\"" + fileList[i].name + "\" id=\"fname\" type=\"hidden\"/><input value=\"" + fileList[i].id + "\" id=\"fid\" type=\"hidden\"/>" +
                "<div class=\"col-md-1 mysharinglist_cent\" style=\"width: 40px;\"><input id=\"checkBox_" + fileList[i].id + "\" name=\"checkFileList\" class=\"checklist\"  type=\"checkbox\" value=\"" + fileList[i].id + "\" /></div></td>";
            fileDiv += "<td width=\"370\"><div style=\"overflow: hidden;line-height: 28px;\">";
            if (checkFileType(fileList[i].filePath) == 1) {
                fileDiv += "<span class=\"myshar_listico share_class_icon\" ></span>";
            } else if (checkFileType(fileList[i].filePath) == 2) {
                fileDiv += "<span class=\"myshar_listico share_class_icon2\" ></span>";
            } else if (checkFileType(fileList[i].filePath) == 3) {
                fileDiv += "<span class=\"myshar_listico share_class_icon1\" ></span>";
            } else if (checkFileType(fileList[i].filePath) == 4) {
                fileDiv += "<span class=\"myshar_listico share_class_icon3\" ></span>";
            } else if (checkFileType(fileList[i].filePath) == 5) {
                fileDiv += "<span class=\"myshar_listico share_class_icon\" ></span>";
            } else {
                fileDiv += "<span class=\"myshar_listico share_class_icon4\" ></span>";
            }
            fileDiv += "<span id=\"spanFile\"><a title=\"" + fileList[i].name + "\" onclick=\"playBtn('" + fileList[i].name + "','" + fileList[i].fileType + "','" + fileList[i].fileHash + "')\">" + fileList[i].name.substr(0, 30) + "</a>" +
                "</span><span id=\"spanFile1\" style=\"display: none\">" +
                "<input class='form-control f_controlsty' value=\"" + fileList[i].name + "\" id=\"updateName\"/><a class='glyphicon glyphicon-ok btn-sm bt1_ie7 wy_sty3' onclick=\"updateFile(" + fileList[i].id + ")\"></a>" +
                "<button class='btn-link glyphicon glyphicon-remove btn-sm removeie7 wy_sty2' onclick=\"resetFile(" + fileList[i].id + ")\"></button>" +
                "</span></div></td>";
            fileDiv += "<td width=\"120\"><div><div class=\"shar_tools\">" +
                "<a class=\"state_display\" title=\"下载\" name=\"download\"><span  class=\"glyphicon glyphicon-cloud-download btn-sm downloadie7\" style=\"padding: 0;margin: 0 5px;\"></span></a>" +
                "<a class=\"state_display\" title=\"分享\" name=\"sharingFile\"><span class=\"glyphicon glyphicon-share btn-sm shareie7\" style=\"padding: 0;margin: 0 8px;\"></span></a>" +
                "<a class=\"state_display\" title=\"删除\" name=\"deleteFile\"> <span  class=\"glyphicon glyphicon-remove btn-sm removeie7\" style=\"padding: 0;margin: 0 5px;\"></span></a>" +
                "</div></div></td>";
            fileDiv += "<td width=\"100\"><div class=\"col-md-1 mysharinglist_cent\" style=\"width: 100px; text-align: left\"  name=\"fileSize\">" + convertHumanUnit(fileList[i].fileSize) + "</div></td>";
            fileDiv += "<td><div class=\"col-md-2 mysharinglist_cent\">" + fileList[i].createdDate.substr(0, fileList[i].createdDate.indexOf('T')) + "</div></td></tr>";
        }
        fileDiv += "</table>";
        /*fileDiv += "</div><div id=\"loadingDiv\"><table scrollpagination=\"enabled\"></table></div>";*/
        scrollpagboful.empty().append(outDiv + categoryDiv + fileDiv);
        mousIn();
        mousOu();
    })
}
function showBoard(tag) {
    var url = baseUrl + "userSpecial/queryAllBoards";
    $.post(url, {id: tag}, function (data) {
        var boardList = data.boardList;
        var boardDiv = "";
        if (boardList && boardList.length > 0) {
            for (var i = 0; i < boardList.length; i++) {
                boardDiv += "<p onclick=\"queryBoardId(" + boardList[i].id + ");showBg2(this)\">" + boardList[i].name + "</p>";
            }
        } else {
            boardDiv += "<span>该社区没有小组或者您还没有成为该社区下小组的成员!</span>";
        }
        $("#boardDiv").empty().append(boardDiv);
    });
}
function queryBoardId(tag) {
    $("#boardId").val(tag);
}

//共享专辑到社区板块
function specialSharing() {
    var boardId = $("#boardId").val();
    var fileIdList = getCheckBoxListStr("checkFileList");
    var fileId = $("#fileId").val();
    if (fileIdList == '') {
        fileIdList = fileId;
    }
    ;
    if (boardId == "") {
        alert("请先选择需要共享到的小组!");
        return false;
    }
    var canDownload = $("#sharingSetDiv input[name=canDownload]:checked").val();
    var shareRange = $("#sharingSetDiv select[name=shareRange]").val();
    var url = baseUrl + "userSpecial/userFileSharing";
    $.post(url, {boardId: boardId, fileIdList: fileIdList, canDownload: canDownload, shareRange: shareRange}, function (data) {
        if (data.success) {
            alert(data.msg);
            $("#sharingFileDialog").dialog("close");
        } else {
            alert(data.msg);
        }
    });
}