package  
{

	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.Event;
	import laya.filters.ColorFilter;
	import laya.filters.GlowFilter;
	import laya.net.Loader;
	import laya.net.WorkerLoader;
	import laya.ui.Button;
	import laya.ui.Image;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	/**
	 * ...
	 * @author ww
	 */
	public class TestWorker2 
	{
		
		public function TestWorker2() 
		{
			WebGL.enable();
			Laya.init(1000, 900);
			msgTxt = new Text();
			msgTxt.size(1000, 600);
			msgTxt.color = "#00ff00";
			msgTxt.zOrder = 100;
			msgTxt.fontSize = 30;
			msgTxt.mouseEnabled = false;
			Laya.stage.addChild(msgTxt);
			Laya.stage.bgColor = "#ffff00";
			initScene();
			//WorkerLoader.workerPath = "libs/worker.js";
			//WorkerLoader.enable = true;
			//WorkerLoader.I.on(WorkerLoader.IMAGE_MSG, this, showInfo);
			//Laya.loader.load([{url:"res/comp.json",type:Loader.ATLAS},{url:"res/MainBottom.json",type:Loader.ATLAS}], new Handler(this, test),null,Loader.ATLAS);
		}
		
		public function initScene():void
		{
			var sp:Sprite;
			sp = new Sprite();
			sp.graphics.drawRect(0, 0, 200, 100, "#ff0000");
			sp.mouseThrough = true;
			sp.pos(100, 100);
			Laya.stage.addChild(sp);
			sp.on(Event.MOUSE_DOWN, this, onClick, ["libs/worker.js"]);
			
			sp = new Sprite();
			sp.graphics.drawRect(0, 0, 200, 100, "#ff0000");
			sp.mouseThrough = true;
			sp.pos(100, 300);
			Laya.stage.addChild(sp);
			sp.on(Event.MOUSE_DOWN, this, onClick, ["libs/worker2.js"]);
		}
		public var tUrl:String;
		private function onClick(worker:String):void
		{
			WorkerLoader.workerPath = worker;
			WorkerLoader.enable = true;
			WorkerLoader.I.on(WorkerLoader.IMAGE_MSG, this, showInfo);
			var urls:Array;
			urls = [];
			//urls = [ { url:"res/comp.json", type:Loader.ATLAS }, { url:"res/MainBottom.json", type:Loader.ATLAS }, { url:"res/monster_tongbilinghou.png", type:Loader.IMAGE } ];
			//urls.push( { url:"res/baidu_search.png", type:Loader.IMAGE } );
			
			
			tUrl = "https://www.baidu.com/s?wd=%E7%BE%8E%E5%A5%B3%E5%9B%BE%E7%89%87%E5%BA%93&rsv_idx=2&tn=baiduhome_pg&usm=3&ie=utf-8&rsv_cq=%E5%9B%BE%E7%89%87&rsv_dl=0_right_recommends_merge_20826&euri=2853269";
			tUrl = "res/0.png";
			tUrl = "res/btn_close.png";
			//tUrl = "http://42.62.12.38/missBeauty/ui/skill1huode/art_jinenghuan.png";
			//tUrl = "abc.png";
			urls.push({ url:tUrl, type:Loader.IMAGE } );
			Laya.loader.load(urls, new Handler(this, test),null);
		}
		private var msgTxt:Text;
		
		private function showInfo(info:String):void {
			if (!msgTxt)
				return;
			msgTxt.text += "\n" + info;
			trace(info);
		}
		
		private function showTests():void
		{
			var sp:Sprite;
			sp = new Sprite();
			sp.pos(200, 200);
			//sp.graphics.drawTexture(Loader.getRes("comp/Task_box.png"));
			//sp.graphics.drawTexture(Loader.getRes("MainBottom/btn_MainBottom_toCity.png"));
			sp.graphics.drawTexture(Loader.getRes("res/0.png"));
			Laya.stage.addChild(sp);
			//sp.filters = [new GlowFilter("#ff0000")];
			//sp.filters = [ColorFilter.GRAY];
			
			//var btn:Button;
			//btn = new Button();
			//btn.stateNum = 2;
			//btn.scale(0.5, 0.5);
			//btn.skin = "MainBottom/btn_MainBottom_toCity.png";
			//btn.pos(400, 400);
			Laya.stage.addChild(btn);
		}
		private function testPng8():void
		{
			var img:Image;
			img = new Image();
			//img.skin = "res/baidu_search.png";
			img.skin = tUrl;
			img.pos(400, 200);
			Laya.stage.addChild(img);
		}
		private function test():void
		{
			trace("test");
			//showTests();
			
			testPng8();
			
		}
	}

}