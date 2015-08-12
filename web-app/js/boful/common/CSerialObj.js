
//serial类
function CSerialObj(id, programId,serialNo,name,playUrl,startTime,endTime,transcodeState,photo,state)
{
	//Enum Property
	this.id = id;
	this.programId = programId;
	this.serialNo = serialNo;
	this.name = name;
	this.playUrl = playUrl;
	this.startTime = startTime;
	this.endTime = endTime;
	this.transcodeState = transcodeState;
	this.photo = photo;
	this.state = state;
	this.subtitles = [];
}
