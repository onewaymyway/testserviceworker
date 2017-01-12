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
			Laya.timer.frameOnce(1, this, initServiceWorker);
			//initServiceWorker();
		
		}
		
		private function initServiceWorker():void {
			showInfo("try initServiceWorker");
			ServiceWorkerTools.I.on(ServiceWorkerTools.ON_MESSAGE, this, onMessage);
			ServiceWorkerTools.I.register(new Handler(this, serviceWorkerInited));
		}
		
		private function onMessage(event:*):void
		{
			showInfo("onMessage:");
			showInfo(JSON.stringify(event.data));
		}
		private function serviceWorkerInited():void {
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
			
			var imgs:Array = ["res/tt/clip_num.png", "res/pics/g1.png", "res/pics/g2.png", "res/pics/g3.png", "res/pics/g4.png", "res/pics/gg1.png", "res/pics/gg2.png", "res/image.png", "res/image.png", "res/image.png", "res/btn_close.png", "res/clip_num.png"];
			
			var i:int, len:int;
			len = imgs.length;
			var xCount:int = 6;
			var tX:Number;
			var tY:Number;
			for (i = 0; i < len; i++) {
				var img:Image;
				img = new Image();
				img.skin = imgs[i];
				tX = (i % xCount) * 150;
				tY = Math.floor(i/xCount) * 200;
				img.pos(tX, tY);
				Laya.stage.addChild(img);
			}
			
		}
	
	}

}