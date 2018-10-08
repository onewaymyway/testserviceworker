package  
{
	import laya.events.Event;
	import laya.net.WorkerLoader;
	import laya.webgl.WebGL;
	/**
	 * ...
	 * @author ww
	 */
	public class TestWorkerDestroy 
	{
		
		public function TestWorkerDestroy() 
		{
			//WebGL.enable();
			Laya.init(1000, 900);
			WorkerLoader.workerPath = "libs/worker.js";
			WorkerLoader.enable = true;
			test();
			Laya.stage.on(Event.CLICK, this, tryDestroy);
		}
		private var pic:String = "res/clip_num.png";
		private function test():void
		{
			pic = "res/Itemsheet.png";
			Laya.loader.load(pic);
		}
		private function tryDestroy():void
		{
			debugger;
			Laya.loader.clearRes(pic);
		}
	}

}