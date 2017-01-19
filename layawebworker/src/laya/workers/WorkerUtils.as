package laya.workers {
	import laya.utils.Browser;
	
	/**
	 * ...
	 * @author ww
	 */
	public class WorkerUtils {
		
		public function WorkerUtils() {
		
		}
		public static var WorkerEnable:Boolean = Browser.window.Worker;
		private static var _strWorkerEnabeStatu:int = -1;
		public static function get StrWorkerEnable():Boolean
		{
			if (_strWorkerEnabeStatu == -1)
			{
				try
				{
					createWorkerByStr('console.log("strWorkerEnable")');
					_strWorkerEnabeStatu = 1;
				}
				catch (e:*)
				{
					_strWorkerEnabeStatu = 0;
				}
			}
			return _strWorkerEnabeStatu == 1;
		}
		
		public static function createWorkerByStr(codes:String):Worker {
			var worker_blob:* = new Browser.window.Blob([codes]);
			var worker:* = new Browser.window.Worker(Browser.window.URL.createObjectURL(worker_blob));
			return worker;
		}
		
		public static function createWorkerByUrl(url:String):Worker {
			var worker:* = new Browser.window.Worker(url);
			return worker;
		}
		public static var ImageData:*= Browser.window.ImageData;
		public static var global = Browser.window;
		public static function serializeArgs(args):Array {
			"use strict";

			var typedArray = ["Int8Array", "Uint8Array", "Uint8ClampedArray", "Int16Array", "Uint16Array", "Int32Array", "Uint32Array", "Float32Array", "Float64Array"];
			var serializedArgs = [];
			var transferable = [];
			
			for (var i = 0; i < args.length; i++) {
				if (args[i] instanceof Error) {
					var obj = {type: "Error", value: {name: args[i].name}};
					var keys = Object.getOwnPropertyNames(args[i]);
					for (var k = 0; k < keys.length; k++) {
						obj.value[keys[k]] = args[i][keys[k]];
					}
					serializedArgs.push(obj);
				}
				else if (args[i] instanceof DataView) {
					transferable.push(args[i].buffer);
					serializedArgs.push({type: "DataView", value: args[i].buffer});
				}
				else {
					if (args[i] instanceof ArrayBuffer) {
						transferable.push(args[i]);
					}
					else if ("ImageData" in global && args[i] instanceof global.ImageData) {
						transferable.push(args[i].data.buffer);
					}
					else {
						for (var t = 0; t < typedArray.length; t++) {
							if (args[i] instanceof global[typedArray[t]]) {
								transferable.push(args[i].buffer);
								break;
							}
						}
					}			
					serializedArgs.push({type: "arg", value: args[i]});
				}
			}
			
			return {args: serializedArgs, transferable: transferable};
		}
		
		public static function unserializeArgs(serializedArgs):Array {
			"use strict";
			
			var args = [];
			
			for (var i = 0; i < serializedArgs.length; i++) {
				
				switch (serializedArgs[i].type) {
					case "arg": 
						args.push(serializedArgs[i].value);
						break;
					case "Error": 
						var obj = new Error();
						for (var key in serializedArgs[i].value) {
							obj[key] = serializedArgs[i].value[key];
						}
						args.push(obj);
						break;
					case "DataView": 
						args.push(new DataView(serializedArgs[i].value));
				}
			}
			
			return args;
		}
		
		public static function workerMainFunction(workerFunction:Function, serializeArgs:Function, unserializeArgs:Function):void {
			"use strict";
			var thread = {
				terminate: function () {
					_postMessage("threadify-terminated", []);
					global.close();
				},
				
				error: function () {
					_postMessage("threadify-error", arguments);
				},
				
				"return": function () {
					_postMessage("threadify-return", arguments);
					thread.terminate();
				}
			};
			
			function _postMessage(name, args) {
				var serialized = serializeArgs(args || []);
				
				var data = {
					name: name,
					args: serialized.args
				};
				
				global.postMessage(data, serialized.transferable);
			}
			
			function _onMessage(event) {
				var data = event.data || {};
				var args = unserializeArgs(data.args || []);
				
				switch (data.name) {
					case "threadify-start":
						var result;
						try {
							result = workerFunction.apply(thread, args);
						} catch (error) {
							thread.error(error);
							thread.terminate();
						}
						if (result !== undefined) {
							_postMessage("threadify-return", [result]);
							thread.terminate();
						}else
						{
							_postMessage("threadify-return", []);
						}
				}
			}
			
			global.addEventListener("message", _onMessage, false);
		}
				
		private static var _workerMainStr:String;
		public static function getWorkTemplete():String
		{
			var reg:RegExp = new RegExp("WorkerUtils.", "g");
			if(!_workerMainStr)
			_workerMainStr=[
					"var global=this;(",
					workerMainFunction.toString().replace(reg,""),
					")(",
					"#{##}#",
					",",
					serializeArgs.toString().replace(reg,""),
					",",
					unserializeArgs.toString().replace(reg,""),
					");"
				].join("\n");
			return _workerMainStr;
		}
		public static function buildWorker(workerFunction):Function {
			var workerStr:String;

			workerStr = getWorkTemplete().replace("#{##}#",workerFunction.toString());
			
			var workerBlob = new Browser.window.Blob(
				[
					workerStr
				],
				{
					type: "application/javascript"
				}
			);
			var workerUrl = Browser.window.URL.createObjectURL(workerBlob);
			
			return function () {
			var args = [];
			for (var i = 0 ; i < arguments.length ; i++) {
			args.push(arguments[i]);
			}
			return new WorkerJob(workerUrl, args);
			};
		}
	}

}