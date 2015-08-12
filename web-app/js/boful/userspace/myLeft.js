//判断左侧菜单的功能链接来让某菜单为选中状态
if (location.href.indexOf('myInfo') != -1 || location.href.indexOf('myPhoto') != -1) {
    document.getElementById('myleft1').className = "nav-top-item no-submenu current";
}
else if (location.href.indexOf('program/create') != -1) {
    document.getElementById('myleft2').className = "nav-top-item no-submenu current";
}
else if (location.href.indexOf('myManageProgram') != -1 || location.href.indexOf('myRecommendProgramList') != -1 || location.href.indexOf('myProgramList') != -1 || location.href.indexOf('myCollectProgramList') != -1 || location.href.indexOf('myTagList') != -1) {
    document.getElementById('myleft3').className = "nav-top-item no-submenu current";
}
else if (location.href.indexOf('myHistoryProgramList') != -1) {
    document.getElementById('myleft4').className = "nav-top-item no-submenu current";
}
else if (location.href.indexOf('myQnaireList') != -1 || location.href.indexOf('qnairePage') != -1) {
    document.getElementById('myleft5').className = "nav-top-item no-submenu current";
}
else if (location.href.indexOf('myMessageList') != -1) {
    document.getElementById('myleft6').className = "nav-top-item no-submenu current";
}
else if (location.href.indexOf('myCreatedStudyCircle') != -1 || location.href.indexOf('mySynergicStudyCircle') != -1 || location.href.indexOf('mySubscriptionStudyCircle') != -1 || location.href.indexOf('studyCircle/edit') != -1) {
    document.getElementById('myleft7').className = "nav-top-item no-submenu current";
}
else if (location.href.indexOf('myCommunity') != -1 || location.href.indexOf('myJoinCommunity') != -1) {
    document.getElementById('myleft8').className = "nav-top-item no-submenu current";
}
else if (location.href.indexOf('userActivity') != -1) {
    document.getElementById('myleft9').className = "nav-top-item no-submenu current";
}
else if (location.href.indexOf('myGroupList') != -1) {
    document.getElementById('myleft10').className = "nav-top-item no-submenu current";
}