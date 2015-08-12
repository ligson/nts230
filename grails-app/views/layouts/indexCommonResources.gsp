<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-3-18
  Time: 下午12:20
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="icon" type="image/x-icon" href="${resource(dir: 'skin/'+frontTheme()+'/pc/front/images', file: 'boful_logo.ico')}"/>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/'+frontTheme()+'/pc/front/css', file: 'index_base_second.css')}"/>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/'+frontTheme()+'/pc/front/css', file: 'skin.css')}"/>
<r:require modules="jquery,jquery-cookie,jquery.lazyload"/>
<g:if test="${(controllerName == 'my') || (controllerName == 'communityMgr')}">
    <r:require modules="jquery-ui"/>
</g:if>
<r:layoutResources/>
<r:layoutResources/>
<script type="text/javascript" src="${resource(dir: 'js/dialog/js', file: 'jquery.leanModal.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/boful/index', file: 'index_base.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/boful/index', file: 'modernizr.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/boful/index', file: 'programCategoryMenu.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/boful/index', file: 'programCategoryTree.js')}"></script>


