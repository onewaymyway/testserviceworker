package {
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.ui.Image;
	import laya.utils.Browser;
	
	/**
	 * ...
	 * @author ww
	 */
	public class TestServiceWorker {
		//https://onewaymyway.github.io/testserviceworker/layaserviceworker/bin/h5/index.html
		public function TestServiceWorker() {
			Laya.init(1000, 900);
			msgTxt = new Text();
			msgTxt.size(1000, 600);
			msgTxt.color = "#00ff00";
			Laya.stage.addChild(msgTxt);
			showInfo("hello");
			initServiceWorker();
			test();
		}
		private var msgTxt:Text;
		
		private function showInfo(info:String):void {
			if (!msgTxt)
				return;
			msgTxt.text += "\n" + info;
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
		
		}
		
		private function initServiceWorker():void {
			showInfo("try initServiceWorker");
			var navigator:*;
			navigator = Browser.window.navigator;
			if ('serviceWorker' in navigator) {
				navigator.serviceWorker.register('./service-worker.js', { scope: './' } ).then(function(worker) {
					if (worker)
					{
						worker.update();
					}
					// Registration was successful. Now, check to see whether the service worker is controlling the page.
						if (navigator.serviceWorker.controller) {
							// If .controller is set, then this page is being actively controlled by the service worker.
							showInfo('This funky font has been cached by the controlling service worker.');
						}
						else {
							// If .controller isn't set, then prompt the user to reload the page so that the service worker can take
							// control. Until that happens, the service worker's fetch handler won't be used.
							showInfo('Please reload this page to allow the service worker to handle network operations.');
						}
					}).catch(function(error) {
						// Something went wrong during registration. The service-worker.js file
						// might be unavailable or contain a syntax error.
						showInfo(error);
					});
			}
			else {
				// The current browser doesn't support service workers.
				showInfo('Service workers are not supported in the current browser.');
			}
		}
	
	}

}