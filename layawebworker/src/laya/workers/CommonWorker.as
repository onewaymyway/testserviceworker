package laya.workers 
{
	import laya.utils.Utils;
	/**
	 * ...
	 * @author ww
	 */
	public class CommonWorker 
	{
		
		public function CommonWorker() 
		{
			
		}	
		private var _fun:Function;
		public var work:Function;
		public function doWork(params:Array,callBack:Function):void
		{
			if (!WorkerUtils.StrWorkerEnable)
			{
				callBack(work.apply(this,params));
			}else
			{
				if (!_fun)
				{
					_fun = WorkerUtils.buildWorker(work);		
				}
				_fun.apply(this, params).done = callBack;
			}
		}
		

		public static function createByFun(fun:Function):CommonWorker
		{
			var cmWorker:CommonWorker;
			cmWorker = new CommonWorker();
			cmWorker.work = fun;
			return cmWorker;
		}
	}

}