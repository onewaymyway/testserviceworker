package  
{
	import laya.display.Sprite;
	/**
	 * ...
	 * @author ww
	 */
	public class TestServiceWorker 
	{
		
		public function TestServiceWorker() 
		{
			Laya.init(1000, 900);
			test();
		}
		private function test():void
		{
			var sp:Sprite;
			sp = new Sprite();
			sp.graphics.drawRect(0, 0, 100, 100, "#ff0000");
			Laya.stage.addChild(sp);
		}
	}

}