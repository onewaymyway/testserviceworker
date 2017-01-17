importScripts("zlib.js","png.js");

onmessage =function (evt){
  
  var data = evt.data;//通过evt.data获得发送来的数据
  switch(data.type)
  {
	  case "load":
		  //loadImage(data);
		  loadImage2(data);
		  break;
  }
}
var canUseImageData=false;
testCanImageData();
function testCanImageData()
{
	try
	{
		cc=new ImageData(20,20);
		canUseImageData=true;
	}catch(e)
	{
		
	}
	//canUseImageData=false;
}
function loadImage(data)
{
	PNG.load(data.url,pngLoaded);
}
function loadImage2(data)
{
	var url=data.url;
	var xhr,
    _this = this;
      xhr = new XMLHttpRequest;
      xhr.open("GET", url, true);
	  //showMsgToMain("loadImage2");
	  xhr.responseType = "arraybuffer";
      
      xhr.onload = function() {
		var response=xhr.response || xhr.mozResponseArrayBuffer;
		//showMsgToMain("onload:");
		
        var data, png;
        data = new Uint8Array(response);
		if(self.createImageBitmap)
		{
			doCreateImageBitmap(data,url);
			return;
		}
		try
		{
			//new self.ImageData(22,22);
			//new self.Uint8ClampedArray();
			//startTime=getTimeNow();
			png = new PNG(data);
		    png.url=url;
			//png.startTime=startTime;
			//png.decodeEndTime=getTimeNow();
			//png.decodeTime=png.decodeEndTime-startTime;
		    pngLoaded(png);
		}catch(e)
		{
			pngFail(url,"parse fail"+e.toString()+":ya");
		}
        
      };
	  xhr.onerror = function(e){
		pngFail(url,"loadFail");
	}
      xhr.send(null);
}
function doCreateImageBitmap(response,url)
{
	try
	{
		//showMsgToMain("hihidoCreateImageBitmap");
		//showMsgToMain("doCreateImageBitmap:"+response);
		//var startTime=getTimeNow();
		//showMsgToMain("new self.Blob");
		response = new self.Blob([response],{type:"image/png"});
		self.createImageBitmap(response).then(function(imageBitmap) {
			//showMsgToMain("imageBitmapCreated:");
			var data={};
	        data.url=url;
			data.imageBitmap=imageBitmap;
			data.dataType="imageBitmap";
			//data.startTime=startTime;
	        //data.decodeTime=getTimeNow()-startTime;
			//data.sendTime=getTimeNow();
			data.type="Image";
			postMessage(data,[data.imageBitmap]);
        }).catch(
		function(e)
		{
			showMsgToMain("cache:"+e);
			pngFail(url,"parse fail"+e+":ya");
		}
		)
	}catch(e)
	{
		pngFail(url,"parse fail"+e.toString()+":ya");
	}
}
function getTimeNow()
{
	return new Date().getTime();
}
function pngFail(url,msg)
{
	var data={};
	data.url=url;
	data.imagedata=null;
	data.type="Image";
	data.msg=msg;
	console.log(msg);
	postMessage(data);
}
function showMsgToMain(msg)
{
	var data={};
	data.type="Msg";
	data.msg=msg;
	postMessage(data);
}
function pngLoaded(png)
{
	var data={};
	data.url=png.url;
	if(canUseImageData)
	{
		data.imagedata=png.getImageData();
		data.dataType="imagedata";
	}else
	{
		data.buffer=png.getImageDataBuffer();
		data.dataType="buffer";
	}
	//
	
	data.width=png.width;
	data.height=png.height;
	data.getBufferTime=getTimeNow()-png.decodeEndTime;
	//data.startTime=png.startTime;
	//data.decodeTime=png.decodeTime;
	//data.sendTime=getTimeNow();
	data.type="Image";
	//debugger;
	if(canUseImageData)
	{
		postMessage(data,[data.imagedata.data.buffer]);
	}else
	{
		postMessage(data,[data.buffer.buffer]);
	}
	
}