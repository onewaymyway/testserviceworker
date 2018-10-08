package  
{
	import laya.debug.tools.DebugTxt;
	import laya.debug.tools.enginehook.SpriteRenderHook;
	import laya.debug.tools.JsonTool;
	import laya.display.Sprite;
	import laya.utils.Browser;
	import laya.workers.WorkerUtils;
	/**
	 * ...
	 * @author ww
	 */
	public class TestWorkParam 
	{
		
		public function TestWorkParam() 
		{
			Laya.init(1000, 900);
			DebugTxt.init();
			test();
		}
		private var tWorker:Worker;
		private function test():void
		{
			
			tWorker = WorkerUtils.createWorkerByUrl("testworker/testworker.js");
			var tData:Object;
			tData = new Sprite();
			//tData = { a:"abc", b:333 };
			//tData = new TestData();
			tData = new TestData2();
			//trace(tData);
			//trace(JSON.stringify(tData));
			DebugTxt.dTrace("worker created");
			var createImageBitmapOK:Boolean;
			createImageBitmapOK = Browser.window.createImageBitmap?true:false;
			DebugTxt.dTrace("createImageBitmapOK",createImageBitmapOK);
			tWorker.postMessage( { } );
			postData();
			postData();
			postData();
			tWorker.onmessage = function(evt:*):void { 
				//接收worker传过来的数据函数
				DebugTxt.dTrace("get data");
				DebugTxt.dTrace(JSON.stringify(evt.data));
			}
		}
		private var tI:int = 0;
		private var data:Object={};
		private function postData():void
		{
			tI++;
			data.id = tI;
			tWorker.postMessage(data);
		}
	}

}