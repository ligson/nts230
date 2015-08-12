<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>play</title>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'jwplayer/jwplayer.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/CSerialObj.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'embedPlay.js')}"></script>
<script type="text/javascript">
var startTime = "${CTools.nullToBlank(params?.startTime)}";
var endTime = "${CTools.nullToBlank(params?.endTime)}";

<g:embedSerialData programId="${params.programId}" serialId="${params.serialId}" />
	
</script>
</head>
    <body onload="init();">
        <div id="player"></div>

    </body>
</html>
