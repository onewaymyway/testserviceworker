package  
{
	import laya.net.URL;
	import laya.net.WorkerLoader;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	/**
	 * ...
	 * @author ww
	 */
	public class TestWorkerMemory 
	{
		
		public function TestWorkerMemory() 
		{
			WebGL.enable();
			Laya.init(1000, 900);
			WorkerLoader.workerPath = "libs/workertest.js";
			WorkerLoader.enable = true;
			test();
			//Laya.stage.on(Event.CLICK, this, tryDestroy);
			//Laya.timer.loop(1000, this, testLoad);
			//Laya.timer.loop(1000, this, testLoad);
			//testLoad();
		}
		private var pic:String = "res/clip_num.png";
		private function test():void
		{
			pic = "res/Itemsheet.png";
			//pic = "res/comp.png";
			Laya.loader.load(pic,new Handler(this,loaded));
		}
		private function loaded():void
		{
			Laya.timer.once(100, this, tryDestroy);
		}
		private function tryDestroy():void
		{
			Laya.loader.clearRes(pic);
			
			i++;
			if (i > 30) 
			{
				trace("testdone");
				return;
			}
			Laya.timer.once(100, this, test);
		}
		private var i:int = 0;
		private function testLoad():void
		{
			i++;
			if (i > 30) 
			{
				//WorkerLoader.I.worker.terminate();
				//terminate()
				return;
			}
			pic = "res/Itemsheet.png";
			pic = "res/comp.png";
			pic = URL.formatURL(pic);
			WorkerLoader.I.loadImage(pic);
		}
		
	}

}