package {
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.ui.Image;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.workers.ServiceWorkerTools;
	
	/**
	 * ...
	 * @author ww
	 */
	public class TestServiceWorker {
		//https://onewaymyway.github.io/testserviceworker/layaserviceworker/bin/h5/index.html
		//https://onewaymyway.github.io/testserviceworker/layaserviceworker/bin/h5/service-worker.js
		public function TestServiceWorker() {
			Laya.init(1000, 900);
			msgTxt = new Text();
			msgTxt.size(1000, 600);
			msgTxt.color = "#00ff00";
			Laya.stage.addChild(msgTxt);
			showInfo("hello");
			initServiceWorker();

		}
		private function initServiceWorker():void {
			showInfo("try initServiceWorker");
			ServiceWorkerTools.I.register('./service-worker.js',new Handler(this,serviceWorkerInited));
		}
		private function serviceWorkerInited():void
		{
			showInfo("serviceWorkerInited from client");
			test();
		}
		private var msgTxt:Text;
		
		private function showInfo(info:String):void {
			if (!msgTxt)
				return;
			msgTxt.text += "\n" + info;
			trace(info);
		}
		
		private function test():void {
			//var sp:Sprite;
			//sp = new Sprite();
			//sp.graphics.drawRect(0, 0, 100, 100, "#ff0000");
			//Laya.stage.addChild(sp);
			var img:Image;
			img = new Image();
			img.skin = "res/image.png";
			img.pos(200, 200);
			Laya.stage.addChild(img);
			
			var img:Image;
			img = new Image();
			img.skin = "res/btn_close.png";
			img.pos(500, 200);
			Laya.stage.addChild(img);
		
		}
		
		
	
	}

}