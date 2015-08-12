var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}

$(function(){
   /* var PostData={flags:$("#showTableFlags").val()}
    var showTableId=$("#showTableId").val()
    //alert(PostData.flags)*/
    tableC("ipList","ip",0);
    tableC("consumerNameList","consumerName",0);
    tableC("userAgentList","userAgent",0);

})

function tableC(id,PostData,dataType){//userAgent
    jQuery("#"+id).jqGrid({
        url:baseUrl+'coreMgr/generalQueryValue',
        datatype:'json',
        colNames: [PostData, 'count'],
        colModel: [
            { name: PostData},
            { name: 'count',sortable:false}
        ],
        pager:'#'+PostData+'Pager',
        width:'1200',
        height:'200',
        rowNum:10,
        postData: {flags:PostData,searchDateType:dataType}
    })
}

function searchgeneral(dataType){
    var id="";
    var PostData="";
    var starDate=$("#startTime").val()
    var endDate=$("#endTime").val()
      for (var i= 0;i<=2;i++)
      {
          if(!$("#ui-accordion-accordion11-panel-"+i).is(":hidden")){
              if(i==0){
                  id="ipList";
                  PostData="ip";
              }
              if(i==1){
                  id="consumerNameList";
                  PostData="consumerName";
              }
              if(i==2){
                  id="userAgentList";
                  PostData="userAgent";
              }
              jQuery("#"+id).jqGrid('setGridParam',{ postData: {flags:PostData,searchDateType:dataType,startDate:starDate,endDate:endDate},page:1}).trigger("reloadGrid");
              //tableC(id,PostData,dataType)
          }
      }
}
function searchDate(){

    if($("#startTime").val().toString() == '起始日期'){
        alert("请选择起始日期");
        return false;
    }
    if($("#endTime").val().toString() == '结束日期'){
        alert("请选择结束日期");
        return false;
    }
    if (new Date(Date.parse($("#startTime").val().toString().replace(/-/g, "/"))) > new Date(Date.parse($("#endTime").val().toString().replace(/-/g, "/")))) {
        alert("起始日期不能大于结束日期");
        return false;
    }
    return true;
}
function searchDateTo(){
    if(searchDate())
    searchgeneral('4')
}
function ptd(id){
    var starDate=$("#startTime").val("起始日期")
    var endDate=$("#endTime").val("结束日期")
}
