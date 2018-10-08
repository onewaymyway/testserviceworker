onmessage =function (evt){
  
  var data = evt.data;//通过evt.data获得发送来的数据
  myTrace(data.id);
  //myTrace(WebAssembly);
  //if(WebAssembly)
  //{
	  //showMsgToMain("WebAssembly Enabled")
  //}else
  //{
	  //showMsgToMain("WebAssembly NOT_FOUND")
  //}
  
  if(self.createImageBitmap)
  {
	  showMsgToMain("createImageBitmap Enabled")
  }else
  {
	  showMsgToMain("createImageBitmap NOT_FOUND")
  }
}

var enableTrace=true;
function myTrace(msg)
{
	if(!enableTrace) return;
	console.log(msg)
}
function showMsgToMain(msg)
{
	var data={};
	data.type="Msg";
	data.msg=msg;
	postMessage(data);
}