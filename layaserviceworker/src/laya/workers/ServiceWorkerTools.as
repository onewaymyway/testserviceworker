package laya.workers {
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ServiceWorkerTools {
		public static function get isServiceWorkerSupport():Boolean {
			return 'serviceWorker' in Browser.window.navigator;
		}
		public static var I:ServiceWorkerTools = new ServiceWorkerTools();
		
		public var messageChannel:*;
		
		public function ServiceWorkerTools() {
			__JS__("this.messageChannel = new MessageChannel();");
			messageChannel.port1.onmessage = function(event) {
				_onMessage(event);
			};
		}
		private function _onMessage(event:*):void
		{
			trace("onMessage:", event);
			if (event && event.data)
			{
				switch(event.data.msg)
				{
					case "reloadSuccess":
						_workDoneCall();
						break;
					case "reloadFail":
						_workDoneCall();
						break;
				}
			}
		}
		public function sendMessage(message) {
			
			if (!isServiceWorkerSupport)
				return;
			if (Browser.window.navigator.serviceWorker.controller) {
				Browser.window.navigator.serviceWorker.controller.postMessage(message,[messageChannel.port2]);
			}
			else {
				trace("service worker not installed");
			}
		}
		private var _workDoneHandler:Handler;
		private function _workDoneCall():void
		{
			if (_workDoneHandler)
			{
				var tHandler:Handler;
				tHandler = _workDoneHandler;
				_workDoneHandler = null;
				_workDoneHandler.run();
				
			}
		}
		public function register(workerPath:String, option:Object = null,workDoneHandler:Handler=null, forceUpdate:Boolean = true):* {
			if (!option) {
				option = {scope: './'};
			}
			var navigator:* = Browser.window.navigator;
			if ('serviceWorker' in navigator) {
				navigator.serviceWorker.register(workerPath, option).then(function(worker) {
						if (worker && forceUpdate) {
							worker.update();
						}
						// Registration was successful. Now, check to see whether the service worker is controlling the page.
						if (navigator.serviceWorker.controller) {
							// If .controller is set, then this page is being actively controlled by the service worker.
							trace('This funky font has been cached by the controlling service worker.');
							sendMessage({"cmd": "reloadConfig"});
						}
						else {
							trace('Please reload this page to allow the service worker to handle network operations.');
							_workDoneCall();
						}
					}).catch(function(error) {
						// Something went wrong during registration. The service-worker.js file
						// might be unavailable or contain a syntax error.
						trace(error);
						_workDoneCall();
					});
			}
			else {
				// The current browser doesn't support service workers.
				trace('Service workers are not supported in the current browser.');
				_workDoneCall();
			}
		}
	}

}