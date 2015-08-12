<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>网络教学资源发布系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

    <style type="text/css">
    .questionTab {
        width: 700px;
        margin: 10px;
    }

    .button {
        padding: 2px 4px 2px 4px;
        cursor: hand
    }

    td {
        text-align: left;
    }
    </style>


    <script LANGUAGE="javascript" type="text/javascript">

        //全局变量
        var gQuestionIndex = 1;	//问题索引
        var gOptionIndex = 1;	//选项索引


        //产生选项，参数是问题索引
        function createOption(index) {
            var tabObj = $("#QuestionTable" + index);
            var html = "<tr>";
            html += '<td>选项：</td>';
            html += '<td><input type="text" name="optionText_' + index + '_' + gOptionIndex + '" style="width:400px;">&nbsp;<input type="button" class="button" onClick="delOption(this)" value="删除选项"></td>';
            html += "</tr>";
            tabObj.append(html);
            gOptionIndex++;
        }

        function createQuestion() {
            var tabObj = document.createElement("table");
            tabObj.id = "QuestionTable" + gQuestionIndex;
            tabObj.className = "questionTab";

            var trObj0 = tabObj.insertRow();
            trObj0.insertCell(0);
            trObj0.insertCell(1);

            trObj0.cells[0].innerHTML = '问题：';
            trObj0.cells[1].innerHTML = '<textarea name="questionText_' + gQuestionIndex + '" style="width:500px;height:30px;" ></textarea>&nbsp;<input type="button" class="button" onClick="delQuestion(' + gQuestionIndex + ')" value="删除问题">';

            var trObj1 = tabObj.insertRow();
            trObj1.insertCell(0);
            trObj1.insertCell(1);

            trObj1.cells[0].innerHTML = '问题类型：';
            trObj1.cells[1].innerHTML = '<input type="radio" name="type_' + gQuestionIndex + '" value="1" checked>单选<input type="radio" name="type_' + gQuestionIndex + '" value="2">多选</textarea>';

            var trObj2 = tabObj.insertRow();
            trObj2.insertCell(0);
            trObj2.insertCell(1);

            trObj2.cells[0].innerHTML = '选项：';
            trObj2.cells[1].innerHTML = '<input type="text" name="optionText_' + gQuestionIndex + '_0" style="width:400px;">&nbsp;<input type="button"  class="button" onClick="createOption(' + gQuestionIndex + ')"  value="添加选项" />';

            $("#QuestionDiv").append(tabObj);

            setQuestionTitles();

            gQuestionIndex++;

        }

        function check() {
            var theInput = null;
            if (form1.name.value == "") {
                alert("问卷名称不能为空，请重新输入。");
                form1.name.focus();
                return false;
            }

            for (var i = 0; i < form1.elements.length; i++) {
                theInput = form1.elements[i];
                if ((theInput.name.indexOf("questionText_") != -1 || theInput.name.indexOf("optionText_") != -1) && Jtrim(theInput.value) == "") {
                    alert("输入框不能为空，请重新输入。");
                    theInput.focus();
                    return false;
                }
            }

            form1.maxQuestionIndex.value = gQuestionIndex;
            form1.maxOptionIndex.value = gOptionIndex;

            return true;
        }

        //设置问题标题:问题1，问题2等
        function setQuestionTitles() {
            var questionDivObj = $("#QuestionDiv");
            var tdObj = null;//问题1等所在td

            for (var i = 0; i < questionDivObj.children().length; i++) {
                //tdObj = questionDivObj.childNodes[i].childNodes[0].childNodes[0].childNodes[0];
                tdObj = $($($(questionDivObj.children()[i]).children()[0]).children()[0]).children()[0];
                tdObj.innerHTML = "问题" + (i + 1) + "：";
            }
        }

        //删除问题，参数：问题索引号
        function delQuestion(index) {
            var tabObj = $("#QuestionTable" + index);
            tabObj.remove();
            setQuestionTitles();
        }

        //删除选项
        function delOption(theObj) {
            var trObj = theObj.parentNode.parentNode;
            trObj.parentNode.removeChild(trObj);
        }

    </script>

</head>

<body>
<div class="x_daohang">
    <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'qnaire', action: 'list')}">调查问卷</a>>><a
        href="${createLink(controller: 'qnaire', action: 'list')}">问卷管理</a>>> 添加问卷
</div>

<div class="body" style="width:95%;background:#FFF;">
    <g:form action="saveQnaire" method="post" name="form1" onsubmit="return check();">
        <input type="hidden" name="maxQuestionIndex" id="maxQuestionIndex" value="1">
        <input type="hidden" name="maxOptionIndex" id="maxOptionIndex" value="1">
        <g:if test="${flash.message}">
            <div class="errors">&nbsp;${flash.message}</div>
        </g:if>
        <g:hasErrors bean="${qnaire}">
            <div class="errors">
                <g:renderErrors bean="${qnaire}" as="list"/>
            </div>
        </g:hasErrors>
        <g:hasErrors bean="${qnairequestion}">
            <div class="errors">
                <g:renderErrors bean="${qnairequestion}" as="list"/>
            </div>
        </g:hasErrors>
        <g:hasErrors bean="${qnaireoption}">
            <div class="errors">
                <g:renderErrors bean="${qnaireoption}" as="list"/>
            </div>
        </g:hasErrors>

        <div class="nav" style="height:20px; padding-left:140px; font-size:16px;"><h4>问卷</h4></div>

        <div class="dialog">
            <table class="questionTab">
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="name">问卷名称：</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: qnaire, field: 'name', 'errors')}">
                        <g:textField name="name" size="70" value="${qnaire?.name}"/>
                    </td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="description">问卷描述：</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: qnaire, field: 'description', 'errors')}">
                        <g:textArea name="description" style="width:550px;height:50px;" value="${qnaire?.description}"/>
                    </td>
                </tr>
            </table>
        </div>

        <div class="nav" style="height:20px; padding-left:140px; font-size:16px;">
            <h4>问题列表</h4>
        </div>

        <div class="dialog" id="QuestionDiv">
            <table class="questionTab" id="QuestionTable0">
                <tr>
                    <td>问题：</td>
                    <td>
                        <textarea name="questionText_0" style="width:500px;height:30px;"></textarea>
                    </td>
                </tr>
                <tr>
                    <td>问题类型：</td>
                    <td>
                        <input type="radio" name="type_0" value="1" checked>单选<input type="radio" name="type_0"
                                                                                     value="2">多选
                    </td>
                </tr>
                <tr>
                    <td>选项：</td>
                    <td>
                        <input type="text" name="optionText_0_0" style="width:400px;">&nbsp;<input type="button"
                                                                                                   class="button"
                                                                                                   onClick="createOption(0)"
                                                                                                   value="添加选项"/>
                    </td>
                </tr>
            </table>
        </div>
        <input name="AddAnswer" type="button" style=" margin-left:140px;" class="button" onClick="createQuestion()"
               value="添加问题"/>

        <div class="buttons" style="padding-bottom:5px; padding-right:20px;">
            <input type="submit" class="save" value="提交"/>
        </div>
    </g:form>
</div>
</body>
</html>