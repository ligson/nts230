<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>网络教学资源发布系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" href="${createLinkTo(dir: 'skin/blue/pc/admin/css', file: 'main.css')}"/>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" type=text/css
          rel=stylesheet>

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

    .x_daohang_fon {
        height: 30px;
        text-align: left;
        color: #FFF;
        display: block;
        overflow: hidden;

    }

    .x_daohang_fon a {
        color: #FFF;
        width: 70px;
        height: 30px;
    }
    </style>

    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
    <script LANGUAGE="javascript">

        //全局变量
        var gQuestionIndex = ${qnaire?.qnaireQuestions?.size()};	//问题索引,设了一个最大值
        var gOptionIndex = 200;	//选项索引,设了一个最大值，一个问题不可能会有200个选项


        //简写document.getElementById
        function $(name) {
            return document.getElementById(name);
        }

        //产生选项，参数是问题索引
        function createOption(index) {
            var tabObj = $("QuestionTable" + index);
            var trObj = tabObj.insertRow();
            trObj.insertCell(0);
            trObj.insertCell(1);

            trObj.cells[0].innerHTML = '选项：';
            trObj.cells[1].innerHTML = '<input type="text" name="optionText_' + index + '_' + gOptionIndex + '" style="width:400px;">&nbsp;<input type="button" class="button" onClick="delOption(this)" value="删除选项">';

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

            $("QuestionDiv").appendChild(tabObj);

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
                    alert("该输入框不能为空，请重新输入。");
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
            var questionDivObj = $("QuestionDiv");
            var tdObj = null;//问题1等所在td

            for (var i = 0; i < questionDivObj.childNodes.length; i++) {
                tdObj = questionDivObj.childNodes[i].childNodes[0].childNodes[0].childNodes[0];
                tdObj.innerHTML = "问题" + (i + 1) + "：";
            }
        }

        //删除问题，参数：问题索引号
        function delQuestion(index) {
            var tabObj = $("QuestionTable" + index);
            tabObj.parentNode.removeChild(tabObj);
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
    <p class="x_daohang_fon">当前位置：<a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'qnaire', action: 'qnaireList')}">调查问卷</a>>><a
            href="${createLink(controller: 'qnaire', action: 'list')}">问卷管理</a>>> 编辑问卷</p>
</div>

<div class="body" style="width:95%">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${qnaire}">
        <div class="errors">
            <g:renderErrors bean="${qnaire}" as="list"/>
        </div>
    </g:hasErrors>
    <g:form action="updateQnaire" method="post" name="form1" onsubmit="return check();">
        <g:hiddenField name="id" value="${qnaire?.id}"/>
        <g:hiddenField name="version" value="${qnaire?.version}"/>
        <input type="hidden" name="maxQuestionIndex" id="maxQuestionIndex" value="1">
        <input type="hidden" name="maxOptionIndex" id="maxOptionIndex" value="1">

        <div class="nav" style="height:20px; padding-left:40px; font-size:16px;"><h4>问卷</h4></div>

        <div class="dialog">
            <table class="questionTab">

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="name"><g:message code="qnaire.name.label" default="问卷名称："/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: qnaire, field: 'name', 'errors')}">
                        <g:textField name="name" size="70" value="${qnaire?.name}"/>
                    </td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="description"><g:message code="qnaire.description.label" default="问卷描述："/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: qnaire, field: 'description', 'errors')}">
                        <g:textArea name="description" style="width:550px;height:50px;" value="${qnaire?.description}"/>
                    </td>
                </tr>

            </table>
        </div>

        <div class="nav" style="height:20px; padding-left:40px; font-size:16px;">
            <h4>问题列表</h4>
        </div>

        <div class="dialog" id="QuestionDiv">
            <g:each in="${qnaire?.qnaireQuestions ?}" var="question" status="i">
                <table class="questionTab" id="QuestionTable${i}">
                <tr>
                    <td valign="top" class="name">问题${i + 1}：</td>
                    <td valign="top">
                        <textarea name="questionText_${i}"
                                  style="width:500px;height:60px;">${question?.question}</textarea>&nbsp;
                        <input type="button" class="button" onClick="delQuestion(${i})" value="删除问题">
                    </td>
                </tr>
                <tr class="prop">
                    <td>
                        问题类型：
                    </td>
                    <td>
                        <input type="radio" name="type_${i}" value="1" ${question?.type == 1 ? "checked" : ""}>单选
                        <input type="radio" name="type_${i}" value="2" ${question?.type == 2 ? "checked" : ""}>多选
                    </td>
                </tr>

                <g:each in="${question?.qnaireOptions ?}" var="option" status="j">
                    <tr>
                        <td>选项：</td>
                        <td>
                            <input type="text" name="optionText_${i}_${j}" style="width:400px;"
                                   value="${option.optionText}">&nbsp;
                            <g:if test="${j == 0}">
                                <input type="button" class="button" onClick="createOption(${i})" value="添加选项"/>
                            </g:if>
                            <g:else>
                                <input type="button" class="button" onClick="delOption(this)" value="删除选项">
                            </g:else>
                        </td>
                    </tr>
                </g:each>

                </tbody>
            </table>
            </g:each>
        </div>
        <input name="AddAnswer" type="button" style=" margin-left:140px;" class="button" onClick="createQuestion()"
               value="添加问题"/>

        <div>
            <input style="float:right;width:60px;height:24px;" class="button" type="submit" class="save" value="提交"/>
        </div>
    </g:form>
</div>
</body>
</html>
