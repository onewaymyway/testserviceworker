package {
	import laya.debug.tools.TimeTool;
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.Event;
	import laya.net.URL;
	import laya.renders.Render;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	import laya.ui.Image;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.workers.CommonWorker;
	import laya.workers.ImageLoader;
	import laya.workers.ImageLoaderWorker;
	import laya.workers.WorkerUtils;
	
	/**
	 * ...
	 * @author ww
	 */
	public class TestWorker {
		
		public function TestWorker() {
			//WebGL.enable();
			Laya.init(1000, 900);
			Stat.show();
			msgTxt = new Text();
			msgTxt.size(1000, 600);
			msgTxt.color = "#00ff00";
			msgTxt.zOrder = 100;
			msgTxt.fontSize = 30;
			msgTxt.mouseEnabled = false;
			Laya.stage.addChild(msgTxt);
			showInfo("hello");
			showInfo("Webgl:" + Render.isWebGL);
			//showInfo("WorkerLoader:" + ImageLoader.hookImageLoader());
			showInfo("workerEnable:" + WorkerUtils.WorkerEnable);
			showInfo("StrWorkerEnable:"+WorkerUtils.StrWorkerEnable);
			try
			{
				new Browser.window.ImageData(22, 22);
				showInfo("create ImageData success");
			}catch (e:*)
			{
				showInfo("create ImageData fail:" + e.toString());
				showInfo("create ImageData fail:"+Browser.window.ImageData.length);
			}
			try
			{
				new Browser.window.Blob(["hahahah"]);
				showInfo("create Blob success");
				
			}catch (e:*)
			{
				showInfo("create Blob fail:" + e.toString());
				showInfo("create Blob fail:"+Browser.window.Blob);
			}
			ImageLoaderWorker.init();
			ImageLoaderWorker.I.on(ImageLoaderWorker.IMAGE_ERR, this, showInfo);
			Laya.stage.bgColor = "#ffffff";
			test();
			//ImageLoader.hookImageLoader();
			//Laya.stage.on(Event.CLICK, this, onClick);
			testCommonWorker();
			testAni();
			testImageDecode();
		}
		
		private var _sp:Sprite;
		private function testAni():void
		{
			_sp = new Sprite();
			_sp.graphics.drawRect(0, 0, 100, 50, "#ff0000");
			_sp.pos(200, 200);
			Laya.stage.addChild(_sp);
			Laya.timer.frameLoop(1, this, loopFun);
		}
		private function loopFun():void
		{
			_sp.rotation += 1;
		}
		private var cmWorker:CommonWorker;
		private function testCommonWorker():void
		{
			cmWorker = CommonWorker.createByFun(work);
			
			//Laya.stage.on(Event.CLICK, this, onDown);
			
			var tBtn:Sprite;
			tBtn = createTxtBtn("CalMainThread");
			tBtn.pos(50, 500);
			Laya.stage.addChild(tBtn);
			tBtn.on(Event.CLICK, this, onBtnClick,[tBtn]);
			
			tBtn = createTxtBtn("CalWorker");
			tBtn.pos(200, 500);
			Laya.stage.addChild(tBtn);
			tBtn.on(Event.CLICK, this, onBtnClick, [tBtn]);
			
			var tBtn:Sprite;
			tBtn = createTxtBtn("WorkerLoader");
			tBtn.pos(50, 600);
			Laya.stage.addChild(tBtn);
			tBtn.on(Event.CLICK, this, onBtnClick,[tBtn]);
			
			tBtn = createTxtBtn("MainLoader");
			tBtn.pos(200, 600);
			Laya.stage.addChild(tBtn);
			tBtn.on(Event.CLICK, this, onBtnClick, [tBtn]);
			
		}
		
		private function onBtnClick(btn:Sprite):void
		{
			switch(btn.name)
			{
				case "CalMainThread":
					showInfo("CalMainThread");
					TimeTool.getTime("test");
					callBack(work(testLen));
					break;
				case "CalWorker":
					showInfo("CalWorker");
					TimeTool.getTime("test");
					cmWorker.doWork([testLen], callBack.bind(this));
					break;
				case "WorkerLoader":
					testImageWorkerLoad("res/monster_tongbilinghou.png");
					break;
				case "MainLoader":
					testMainLoader("res/monster_tongbilinghou1.png");
					break;
					
			}
		}
		
		public var testLen:int=999999999;
		private function onDown():void
		{
			var len:int = 999999999;
			cmWorker.doWork([testLen], callBack.bind(this));
			//callBack(work(len));
			
			
		}
		private function createTxtBtn(txt:String):Sprite
		{
			var sp:Sprite;
			sp = new Sprite();
			sp.graphics.drawRect(0, 0, 100, 50, "#ff0000");
			sp.graphics.fillText(txt, 50, 0, null, "#ffff00", "center");
			sp.size(100, 50);
			sp.name = txt;
			return sp;
		}
		public function work(len:int):*
		{
			var rst:Number;
			rst = 1;
			var i:int;
			for (i = 1; i < len; i++)
			{
				//trace("hihi:", i);
				rst += i;
			}
			return rst;
		}
		private function callBack(rst:*):void
		{
			trace("work callBack", rst);
			showInfo("work callBack:" + rst);
			showInfo("time:" + TimeTool.getTime("test"));
		}
		private var msgTxt:Text;
		
		private function showInfo(info:String):void {
			if (!msgTxt)
				return;
			msgTxt.text += "\n" + info;
			trace(info);
		}
		private function onClick():void
		{
			addAImage("res/monster_tongbilinghou.png");
			//addAImage("res/monster_tongbilinghou1.png");
			//addAImage("res/monster_tongbilinghou2.png");
			//addAImage("res/monster_tongbilinghou3.png");
			//addAImage("res/monster_tongbilinghou4.png");
		}
		private function test():void {
			//testDecodePNG();
			//testWorker();
			//testImageWorker();
			//testHookedLoader();
		}
		private function testHookedLoader():void
		{
			ImageLoader.hookImageLoader();
			addAImage("res/monster_tongbilinghou.png");
			//addAImage("res/image33.png");
		}
		private function addAImage(path:String):void
		{
			var image:Image;
			image = new Image();
			image.skin = path;
			image.pos(800*Math.random(), 800*Math.random());
			Laya.stage.addChild(image);
		}
		private function testImageWorker():void
		{
			var tUrl:String;
			tUrl = URL.formatURL("res/image.png");
			ImageLoaderWorker.I.loadImage(tUrl);
		}
		private function testWorker():void {
			var worker:Worker = new Browser.window.Worker("libs/worker.js");
			worker.postMessage("hello world"); //向worker发送数据
			worker.onmessage = function(evt) { //接收worker传过来的数据函数
				console.log(evt.data); //输出worker发送来的数据
			}
		}
		
		private function testImageDecode():void
		{
			//testImageWorkerLoad("res/monster_tongbilinghou.png");
		}
		private function testImageWorkerLoad(path:String):void
		{
			var tUrl:String;
			tUrl = URL.formatURL(path);
			showInfo("ImageLoaderBeginLoad");
			TimeTool.getTime("ImageLoader");
			ImageLoaderWorker.I.on(tUrl, this, imageLoaded);
			ImageLoaderWorker.I.loadImage(tUrl);
		}
		private function imageLoaded(canvas:HTMLCanvas):void
		{
			var tex:Texture;
			tex = new Texture(canvas);
			Laya.stage.graphics.drawTexture(tex, 100, 100);
			showInfo("complete:"+TimeTool.getTime("ImageLoader"));
		}
		private function testMainLoader(path:String):void
		{
			showInfo("ImageLoaderBeginLoad");
			
			Laya.loader.load(path, Handler.create(this, testMainLoaded));
		}
		private function testMainLoaded(tex:Texture):void
		{
			//debugger;
			Laya.stage.graphics.drawTexture(tex, 300, 300);
			var canvas:HTMLCanvas = new HTMLCanvas("2D");
			var ctx:*;
			ctx = canvas.source.getContext("2d");
			TimeTool.getTime("MainLoader");
			ctx.drawImage(tex.source, 0, 0, tex.width, tex.height);
			var info:* = ctx.getImageData(0, 0, tex.width, tex.height);
			showInfo("complete:" + TimeTool.getTime("MainLoader"));
			
		}
	}

}