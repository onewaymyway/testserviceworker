package laya.workers 
{
	import laya.utils.Utils;

	/**
	 * ...
	 * @author ww
	 */
	public class WorkerJob 
	{
		
		private var _worker:Worker;
		private var callbacks = {	
			done: null,
			failed: null,
			terminated: null
		};
		
		private var results = {
			done: null,
			failed: null,
			terminated: null
		};
		
		public function WorkerJob(workerUrl, args) 
		{
			
			_worker = WorkerUtils.createWorkerByUrl(workerUrl);
			
			work(args);
		}
		
		public function get done():Function
		{
			return callbacks.done;
	    }
		public function set done(fn:Function):void {
			callbacks.done = fn;
			_callCallbacks();
		}
		
		
		public function get failed():Function
		{
			return callbacks.failed;
		}
		public function set failed(fn:Function):void {
			callbacks.failed = fn;
			_callCallbacks();
		}
		
		public function get terminated():Function
		{
			return callbacks.terminated;
		}
		public function set terminated(fn:Function):void {
			callbacks.terminated = fn;
			_callCallbacks();
		}
		
		private function work(args:Array):void
		{
			var _this = this;
			this.terminate = terminate;		
			_worker.addEventListener("message", Utils.bind(_onMessage,this), false);
			_worker.addEventListener("error",Utils.bind( _onError,this), false);
			
			_postMessage("threadify-start", args);
	    }
		
		private function _onError(error) {
			results.failed = [error];
			_callCallbacks();
			terminate();
		}
		
		private function _callCallbacks() {
			for (var cb in callbacks) {
				if (callbacks[cb] && results[cb]) {
					callbacks[cb].apply(this, results[cb]);
					results[cb] = null;
				}
			}
		}
		
		private function terminate() {
			_worker.terminate();
			results.terminated = [];
			_callCallbacks();
		}
		private function _postMessage(name, args) {
			var serialized = WorkerUtils.serializeArgs(args || []);
			
			var data = {
				name: name,
				args: serialized.args
			};
			
			_worker.postMessage(data, serialized.transferable);
		}
		private function _onMessage(event) {
			var data = event.data || {};
			var args = WorkerUtils.unserializeArgs(data.args || []);
			
			switch (data.name) {
				case "threadify-return":
					results.done = args;
					break;
				case "threadify-error":
					results.failed = args;
					break;
				case "threadify-terminated":
					results.terminated = [];
			}
			_callCallbacks();
		}
	}
	
}