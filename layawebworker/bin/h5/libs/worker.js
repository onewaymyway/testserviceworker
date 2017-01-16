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
      xhr.responseType = "arraybuffer";
      xhr.onload = function() {
        var data, png;
        data = new Uint8Array(xhr.response || xhr.mozResponseArrayBuffer);
		try
		{
			//new self.ImageData(22,22);
			//new self.Uint8ClampedArray();
			startTime=new Date().getTime();
			png = new PNG(data);
		    png.url=url;
			png.startTime=startTime;
		    pngLoaded(png);
		}catch(e)
		{
			pngFail(url,"parse fail"+e.toString()+":ya"+"img:"+self.Uint8ClampedArray);
		}
        
      };
	  xhr.onerror = function(e){
		pngFail(url,"loadFail");
	}
      xhr.send(null);
}
function pngFail(url,msg)
{
	var data={};
	data.url=url;
	data.imagedata=null;
	data.type="Image";
	data.msg=msg;
	postMessage(data);
}
function pngLoaded(png)
{
	var data={};
	data.url=png.url;
	//data.imagedata=png.getImageData();
	data.buffer=png.getImageDataBuffer();
	data.width=png.width;
	data.height=png.height;
	data.startTime;
	data.type="Image";
	//debugger;
	postMessage(data,[data.buffer.buffer]);
}