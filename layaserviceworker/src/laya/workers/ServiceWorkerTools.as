package laya.workers {
	import laya.events.EventDispatcher;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ServiceWorkerTools extends EventDispatcher {
		public static function get isServiceWorkerSupport():Boolean {
			return 'serviceWorker' in Browser.window.navigator;
		}
		public static var I:ServiceWorkerTools = new ServiceWorkerTools();
		public static const ON_MESSAGE:String = "onmessage";
		public static const WORK_INFO:String = "work_info";
		public var messageChannel:*;
		
		public function ServiceWorkerTools() {
			__JS__("this.messageChannel = new MessageChannel();");
			messageChannel.port1.onmessage = function(event:*) {
				_onMessage(event);
			};
		}
		private function _onMessage(event:*):void
		{
			//trace("onMessage:", event);
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
			this.event(ON_MESSAGE, event);
			
		}
		private function _traceWorkInfo(info:String):void
		{
			trace(info);
			this.event(WORK_INFO, info);
		}
		public function sendMessage(message:*) {
			
			if (!isServiceWorkerSupport)
				return;
			if (Browser.window.navigator.serviceWorker.controller) {
				Browser.window.navigator.serviceWorker.controller.postMessage(message,[messageChannel.port2]);
			}
			else {
				_traceWorkInfo("service worker not installed");
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
				tHandler.run();
				
			}
		}
		public function register(workDoneHandler:Handler=null,workerPath:String="./service-worker.js", option:Object = null, forceUpdate:Boolean = true):* {
			if (!option) {
				option = {scope: './'};
			}
			this._workDoneHandler = workDoneHandler;
			var navigator:* = Browser.window.navigator;
			if ('serviceWorker' in navigator) {
				navigator.serviceWorker.register(workerPath, option).then(function(worker:*) {
						if (worker && forceUpdate) {
							//worker.update();
						}
						// Registration was successful. Now, check to see whether the service worker is controlling the page.
						if (navigator.serviceWorker.controller) {
							// If .controller is set, then this page is being actively controlled by the service worker.
							_traceWorkInfo('service worker is working');
							sendMessage({"cmd": "reloadConfig"});
						}
						else {
							_traceWorkInfo('starting service worker');
							_workDoneCall();
						}
					}).catch(function(error:*) {
						// Something went wrong during registration. The service-worker.js file
						// might be unavailable or contain a syntax error.
						trace(error);
						_workDoneCall();
					});
			}
			else {
				// The current browser doesn't support service workers.
				_traceWorkInfo('Service workers are not supported in the current browser.');
				_workDoneCall();
			}
		}
	}

}