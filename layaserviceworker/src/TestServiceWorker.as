package {
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.net.Loader;
	import laya.net.URL;
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
			msgTxt.zOrder = 100;
			Laya.alertGlobalError = true;
			Laya.stage.addChild(msgTxt);
			showInfo("hello");
			//Laya.timer.frameOnce(1, this, initServiceWorker);
			initServiceWorker();
			
		
		}
		private var msgTxt:Text;
		
		private function showInfo(info:String):void {
			if (!msgTxt)
				return;
			msgTxt.text += "\n" + info;
			trace(info);
		}
		private function initServiceWorker():void {
			showInfo("try initServiceWorker");
			ServiceWorkerTools.I.on(ServiceWorkerTools.ON_MESSAGE, this, onMessage);
			ServiceWorkerTools.I.on(ServiceWorkerTools.WORK_INFO, this, onInfo);
			ServiceWorkerTools.I.register(new Handler(this, serviceWorkerInited));
		}
		
		private function onInfo(info:String):void {
			showInfo(info);
		}
		
		private function onMessage(event:*):void {
			showInfo("onMessage:");
			showInfo(JSON.stringify(event.data));
		}
		
		private function serviceWorkerInited():void {
			showInfo("serviceWorkerEnabled:"+ServiceWorkerTools.I.workerEnabled);
			showInfo("serviceWorkerInited from client");
			showInfo("load fileconfig.json");
			Laya.loader.load("fileconfig.json"+"?v="+Math.random(),new Handler(this,onFileVerFile),null,Loader.JSON)
		}
		private function onFileVerFile(data:Object):void
		{
			showInfo("fileconfig.json loaded");
			URL.version = data;
			test();
		}
		
		
		private function test():void {
			
			var imgs:Array = ["res/tt/clip_num.png", "res/pics/g1.png", "res/pics/g2.png", "res/pics/g3.png", "res/pics/g4.png", "res/pics/gg1.png", "res/pics/gg2.png", "res/image.png", "res/image.png", "res/image.png", "res/btn_close.png", "res/clip_num.png"];
			//imgs = ["res/image.png", "res/btn_close.png", "res/pics/g1.png", "res/pics/g2.png"];
			var i:int, len:int;
			len = imgs.length;
			var xCount:int = 6;
			var tX:Number;
			var tY:Number;
			for (i = 0; i < len; i++) {
				
				//img.skin = imgs[i];
				tX = (i % xCount) * 150;
				tY = Math.floor(i / xCount) * 200;
				//Laya.timer.once(1000 * i, this, createI, [tX, tY, imgs[i]], false);
				createI(tX,tY,imgs[i]);
			}
		
		}
		
		private function createI(tX, tY, skin):void {
			
			var img:Image;
			img = new Image();
			img.pos(tX, tY);
			img.skin = skin;
			Laya.stage.addChild(img);
		}
	
	}

}