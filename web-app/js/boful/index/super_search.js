/**
 * Created by tianqiulian on 15-1-22.
 */
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if ('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
$(function () {
    $("#keyInput").bind("input propertychange", function () {
        var key = $(this).val();
        if (!(key + "").isEmpty()) {
            $.post(baseUrl + "program/suggest", {key: key}, function (data) {
                var suggestion = $(".f_inp_remin");
                suggestion.hide();
                if (data.list != null && !(data.list + "").isEmpty() && data.list.length > 0) {
                    suggestion.empty();
                    for (var i = 0; i < data.list.length; i++) {
                        suggestion.append("<a name='suggestionLink' href='" + baseUrl + "program/superSearch?key=" + data.list[i] + "'>" + data.list[i] + "</a>");
                    }
                    suggestion.show();
                }
            });
        }
    });

    $("body").click(function (event) {
        if (event.target.name != "suggestionLink" && event.target.id != "keyInput") {
            var suggestion = $(".f_inp_remin");
            suggestion.hide();
        }
    });

//            $("#keyInput").blur(function (event) {
//                var suggestion = $(".f_inp_remin");
//                suggestion.hide();
//            });

//            // 获取URL中的参数
//            var reg = new RegExp("(^|&)programCategoryId=([^&]*)(&|$)");
//            var params = window.location.search.substr(1).match(reg);
//            var programCategoryId = null;
//            if(params != null){
//                programCategoryId = unescape(params[2]);
//            }
//    var programCategoryId = "${params.programCategoryId}";

    if (programCategoryId == "" || programCategoryId == null || programCategoryId == "1") {
        for (var i = 0; i < programCategoryTree.length; i++) {
//                    $("#programCategoryList").append("<a href='/program/superSearch?programCategoryId="+programCategoryTree[i].id+"'>"+programCategoryTree[i].name+"</a>");
            $("#programCategoryList").append("<a href='javascript:void(0);' onclick='searchDataByCategoryId(" + programCategoryTree[i].id + ")'>" + programCategoryTree[i].name + "</a>");
        }
    } else {
        var categoryObjArray = new Array();
        var childCategoryList;
        for (var i = 0; i < programCategoryTree.length; i++) {
            if (findProgramCategory(programCategoryTree[i], programCategoryId)) {
                break;
            }
        }
        categoryObjArray.reverse();
        for (var i = 0; i < categoryObjArray.length; i++) {
            var html = "";
            html += '<div class="boful_resources_search_second_left">';
            html += '<img src="/skin/blue/pc/front/images/boful_resources_search_body_center.png">';
            html += '</div>';
            html += '<div class="boful_resources_search_second">';

            var categoryId = categoryObjArray[i].id;

            var childList = new Array();
            if (i == 0) {
                childList = programCategoryTree;
            } else if (i <= (categoryObjArray.length - 1)) {
                childList = categoryObjArray[i - 1].childCategoryList;
            }

            if (childList.length > 1) {
                html += '<div class="boful_resources_search_start_list category_nav_sub">';
                html += '<p>';
                for (var j = 0; j < childList.length; j++) {
                    if (categoryId == childList[j].id) {
                        continue;
                    }
//                            html+='<a href="/program/superSearch?programCategoryId='+childList[j].id+'">'+childList[j].name+'</a>';
                    html += '<a href="javascript:void(0);" onclick="searchDataByCategoryId(' + childList[j].id + ')">' + childList[j].name + '</a>';
                }
                html += '</p>';
                html += '</div>';
            }

            html += '<div class="category_nav">';
//                    html+='<a class="boful_resources_search_stat_name"  href="/program/superSearch?programCategoryId='+categoryId+'">'+categoryObjArray[i].name+'</a>';
            html += '<a class="boful_resources_search_stat_name"  href="javascript:void(0);" onclick="searchDataByCategoryId(' + categoryId + ')">' + categoryObjArray[i].name + '</a>';
            html += '<a class="boful_resources_search_stat_more" href="#"><span class="boful_resources_search_stat_more_mark"></span></a>';
            html += '</div>';
            html += '</div>';
            $("#programCategoryNavi").append($(html));
        }

        if (childCategoryList.length > 0) {
            for (var i = 0; i < childCategoryList.length; i++) {
//                        $("#programCategoryList").append("<a href='/program/superSearch?programCategoryId="+childCategoryList[i].id+"'>"+childCategoryList[i].name+"</a>");
                $("#programCategoryList").append("<a href='javascript:void(0);' onclick='searchDataByCategoryId(" + childCategoryList[i].id + ")'>" + childCategoryList[i].name + "</a>");
            }
        } else {
            $("#programCategoryListDiv").hide();
        }
    }

    function findProgramCategory(category, id) {
        if (category.id == id) {
            categoryObjArray.push(category);
            childCategoryList = category.childCategoryList;
            return true;
        }
        var categoryList = category.childCategoryList;
        for (var i = 0; i < categoryList.length; i++) {
            if (findProgramCategory(categoryList[i], programCategoryId)) {
                categoryObjArray.push(category);
                return true;
            }
        }

        return false;
    }

    $(".category_nav").mouseenter(function () {
        $(".category_nav_sub").hide();
        $(this).prev(".category_nav_sub").fadeIn();
    });
    $(".boful_resources_search_second").mouseleave(function () {
        $(".category_nav_sub").hide();
    });
});

function searchDataByCategoryId(categoryId) {
    if (!categoryId) {
        categoryId = 1;
    }
    $("#searchForm").append("<input type='hidden' name='programCategoryId' value='" + categoryId + "' >");
    $("#searchForm").submit();
}

function searchDataByFacet(facetField, facetValue, flg) {
    if (programCategoryId) {
        $("#searchForm").append("<input type='hidden' name='programCategoryId' value='" + programCategoryId + "' >");
    }
    if (otherOption) {
        $("#searchForm").append("<input type='hidden' name='otherOption' value='" + otherOption + "' >");
    }
    if (orderBy) {
        $("#searchForm").append("<input type='hidden' name='orderBy' value='" + orderBy + "' >");
        if (order) {
            $("#searchForm").append("<input type='hidden' name='order' value='" + order + "' >");
        } else {
            $("#searchForm").append("<input type='hidden' name='order' value='desc' >");
        }
    }

    if (facetFieldParams && facetValueParams) {
        var fieldList = facetFieldParams.split(',');
        var valueList = facetValueParams.split(',');
        for (var i = 0; i < fieldList.length; i++) {
            if(facetField == fieldList[i] && flg == '0') {

            } else {
                $("#searchForm").append("<input type='hidden' name='" + fieldList[i] + "' value='" + valueList[i] + "' >");
            }
        }
    }

    if (flg == '0') {
        $("#searchForm").append("<input type='hidden' name='" + facetField + "' value='" + facetValue + "' >");
    } else {
        $("#searchForm").find("input[name='" + facetField + "']").remove();
    }

    $("#searchForm").submit();
}

function searchDataByOtherOption(otherOption, flg) {
    if (programCategoryId) {
        $("#searchForm").append("<input type='hidden' name='programCategoryId' value='" + programCategoryId + "' >");
    }

    if (facetFieldParams && facetValueParams) {
        var fieldList = facetFieldParams.split(',');
        var valueList = facetValueParams.split(',');
        for (var i = 0; i < fieldList.length; i++) {
            $("#searchForm").append("<input type='hidden' name='" + fieldList[i] + "' value='" + valueList[i] + "' >");
        }
    }

    if (orderBy) {
        $("#searchForm").append("<input type='hidden' name='orderBy' value='" + orderBy + "' >");
        if (order) {
            $("#searchForm").append("<input type='hidden' name='order' value='" + order + "' >");
        } else {
            $("#searchForm").append("<input type='hidden' name='order' value='desc' >");
        }
    }

    if (flg == '0') {
        $("#searchForm").append("<input type='hidden' name='otherOption' value='" + otherOption + "' >");
    } else {
        $("#searchForm").find("input[name='otherOption']").remove();
    }
    $("#searchForm").submit();
}


function searchDataByOrder(orderBy, order) {
    if (programCategoryId) {
        $("#searchForm").append("<input type='hidden' name='programCategoryId' value='" + programCategoryId + "' >");
    }

    if (facetFieldParams && facetValueParams) {
        var fieldList = facetFieldParams.split(',');
        var valueList = facetValueParams.split(',');
        for (var i = 0; i < fieldList.length; i++) {
            $("#searchForm").append("<input type='hidden' name='" + fieldList[i] + "' value='" + valueList[i] + "' >");
        }
    }

    if (otherOption) {
        $("#searchForm").append("<input type='hidden' name='otherOption' value='" + otherOption + "' >");
    }

    if (orderBy) {
        $("#searchForm").append("<input type='hidden' name='orderBy' value='" + orderBy + "' >");
        if (order) {
            $("#searchForm").append("<input type='hidden' name='order' value='" + order + "' >");
        } else {
            $("#searchForm").append("<input type='hidden' name='order' value='desc' >");
        }
    }
    $("#searchForm").submit();
}
