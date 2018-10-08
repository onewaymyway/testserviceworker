package {
	import laya.debug.tools.TimeTool;
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.Event;
	import laya.net.URL;
	import laya.net.WorkerLoader;
	import laya.renders.Render;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	import laya.ui.Image;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.workers.CommonWorker;
	import laya.workers.WorkerUtils;
	
	/**
	 * ...
	 * @author ww
	 */
	public class TestWorker {
		
		public function TestWorker() {
			//WebGL.enable();
			//Config.workerLoader = true;
			Laya.init(1000, 900);
			Stat.show();
			msgTxt = new Text();
			msgTxt.size(1000, 600);
			msgTxt.color = "#00ff00";
			msgTxt.zOrder = 100;
			msgTxt.fontSize = 30;
			msgTxt.mouseEnabled = false;
			Laya.stage.addChild(msgTxt);
			showInfo("hello33");
			showInfo("Webgl:" + Render.isWebGL);
			//showInfo("WorkerLoader:" + WorkerLoader.__init__());
			showInfo("workerEnable:" + WorkerUtils.WorkerEnable);
			showInfo("StrWorkerEnable:" + WorkerUtils.StrWorkerEnable);
			WorkerLoader.workerPath = "libs/worker.js?v=333";
			try {
				new Browser.window.ImageData(22, 22);
				showInfo("create ImageData success");
			}
			catch (e:*) {
				showInfo("create ImageData fail:" + e.toString());
				showInfo("create ImageData fail:" + Browser.window.ImageData.length);
			}
			try {
				new Browser.window.Blob(["hahahah"]);
				showInfo("create Blob success");
				
			}
			catch (e:*) {
				showInfo("create Blob fail:" + e.toString());
				showInfo("create Blob fail:" + Browser.window.Blob);
			}
			
			WorkerLoader.I = new WorkerLoader();
			Laya.stage.bgColor = "#ffffff";
			test();
			//ImageLoader.hookImageLoader();
			//Laya.stage.on(Event.CLICK, this, onClick);
			testCommonWorker();
			testAni();
			testImageDecode();
			if (WorkerLoader.I)
				WorkerLoader.I.on(WorkerLoader.IMAGE_MSG, this, showInfo);
			
			//testCreateImageBitmap("res/monster_tongbilinghou.png");
			//testCreateImageBitmap("res/btn_close.png");
			//testCreateImageBitmap("res/image.jpg");
			//testCreateImageBitmap2("res/monster_tongbilinghou.png");
			//testFetch("res/btn_close.png");
			//testFetch("res/monster_tongbilinghou.png");
			//testFetch("res/image.jpg");
			//testFetch("res/btn_close.png");
			//testFetch("res/button2.png");
			//testCreateImageBitmap("res/button1.png")
			//testCreateImageBitmap("res/monster_tongbilinghou.png")
			//testBase64();
		}
		
		private var _sp:Sprite;
		
		private function testAni():void {
			_sp = new Sprite();
			_sp.graphics.drawRect(0, 0, 100, 50, "#ff0000");
			_sp.pos(200, 200);
			Laya.stage.addChild(_sp);
			Laya.timer.frameLoop(1, this, loopFun);
		}
		
		private function loopFun():void {
			_sp.rotation += 1;
		}
		private var cmWorker:CommonWorker;
		
		private function testCommonWorker():void {
			cmWorker = CommonWorker.createByFun(work);
			
			//Laya.stage.on(Event.CLICK, this, onDown);
			
			var tBtn:Sprite;
			tBtn = createTxtBtn("CalMainThread");
			tBtn.pos(50, 500);
			Laya.stage.addChild(tBtn);
			tBtn.on(Event.CLICK, this, onBtnClick, [tBtn]);
			
			tBtn = createTxtBtn("CalWorker");
			tBtn.pos(200, 500);
			Laya.stage.addChild(tBtn);
			tBtn.on(Event.CLICK, this, onBtnClick, [tBtn]);
			
			var tBtn:Sprite;
			tBtn = createTxtBtn("WorkerLoader");
			tBtn.pos(50, 600);
			Laya.stage.addChild(tBtn);
			tBtn.on(Event.CLICK, this, onBtnClick, [tBtn]);
			
			tBtn = createTxtBtn("MainLoader");
			tBtn.pos(200, 600);
			Laya.stage.addChild(tBtn);
			tBtn.on(Event.CLICK, this, onBtnClick, [tBtn]);
		
		}
		
		private function onBtnClick(btn:Sprite):void {
			switch (btn.name) {
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
					//testImageWorkerLoad("res/image.jpg");
					break;
				case "MainLoader": 
					testMainLoader("res/monster_tongbilinghou1.png");
					break;
			
			}
		}
		
		public var testLen:int = 999999999;
		
		private function onDown():void {
			var len:int = 999999999;
			cmWorker.doWork([testLen], callBack.bind(this));
			//callBack(work(len));
		
		}
		
		private function createTxtBtn(txt:String):Sprite {
			var sp:Sprite;
			sp = new Sprite();
			sp.graphics.drawRect(0, 0, 100, 50, "#ff0000");
			sp.graphics.fillText(txt, 50, 0, null, "#ffff00", "center");
			sp.size(100, 50);
			sp.name = txt;
			return sp;
		}
		
		public function work(len:int):* {
			var rst:Number;
			rst = 1;
			var i:int;
			for (i = 1; i < len; i++) {
				//trace("hihi:", i);
				rst += i;
			}
			return rst;
		}
		
		private function callBack(rst:*):void {
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
		
		private function onClick():void {
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
		
		private function testHookedLoader():void {
			addAImage("res/monster_tongbilinghou.png");
			//addAImage("res/image33.png");
		}
		
		private function addAImage(path:String):void {
			var image:Image;
			image = new Image();
			image.skin = path;
			image.pos(800 * Math.random(), 800 * Math.random());
			Laya.stage.addChild(image);
		}
		
		private function testImageWorker():void {
			var tUrl:String;
			tUrl = URL.formatURL("res/image.png");
			WorkerLoader.I.loadImage(tUrl);
		}
		
		private function testWorker():void {
			var worker:Worker = new Browser.window.Worker("libs/worker.js");
			worker.postMessage("hello world"); //向worker发送数据
			worker.onmessage = function(evt) { //接收worker传过来的数据函数
				console.log(evt.data); //输出worker发送来的数据
			}
		}
		
		private function testImageDecode():void {
			//testImageWorkerLoad("res/monster_tongbilinghou.png");
		}
		
		private function testImageWorkerLoad(path:String):void {
			var tUrl:String;
			tUrl = URL.formatURL(path);
			showInfo("ImageLoaderBeginLoad");
			TimeTool.getTime("ImageLoader");
			WorkerLoader.I.on(tUrl, this, imageLoaded);
			WorkerLoader.I.loadImage(tUrl);
		}
		
		private function imageLoaded(canvas:HTMLCanvas):void {
			if (!canvas) {
				showInfo("ImageLoader Fail");
				return;
			}
			var tex:Texture;
			tex = new Texture(canvas);
			Laya.stage.graphics.drawTexture(tex, 100, 100);
			showInfo("complete:" + TimeTool.getTime("ImageLoader"));
		}
		
		private function testMainLoader(path:String):void {
			showInfo("ImageLoaderBeginLoad");
			
			Laya.loader.load(path, Handler.create(this, testMainLoaded));
		}
		
		private function testMainLoaded(tex:Texture):void {
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
		
		private function testCreateImageBitmap(url:String):void {
			var xhr = new Browser.window.XMLHttpRequest;
			xhr.open("GET", url, true);
			
			xhr.responseType = "arraybuffer";
			
			xhr.onload = function() {
				var response = xhr.response || xhr.mozResponseArrayBuffer;
				//response.type = "image/png";
				response = new Browser.window.Blob([new Uint8Array(response)],{type:"image/png"});
				try {
					Browser.window.createImageBitmap(response).then(function(imageBitmap) {
							showInfo("imageBitmapCreated:", imageBitmap);
							showImageBitmap(imageBitmap);
						}, function(e) {
							showInfo("createImageBitmap failed11");
						}).catch(function(e) {
							showInfo("createImageBitmap failed");
						})
				}
				catch (e) {
					showInfo("createImageBitmap failed");
				}
			
			}
			xhr.send(null);
		}
		
		private function testCreateImageBitmap2(url:String):void {
			var image = new Browser.window.Image();
			
			image.onload = function() {
				try {
					Browser.window.createImageBitmap(image).then(function(imageBitmap) {
							showInfo("imageBitmapCreated:", imageBitmap);
						}, function(e) {
							showInfo("failed11");
						}).catch(function(e) {
							showInfo("failed");
						})
				}
				catch (e) {
					showInfo("failed");
				}
			
			}
			image.src = url;
		}
		
		private function testFetch(url:String):void {
			//return testFetch2(url);
			//return;
			url = URL.formatURL(url);
			Browser.window.fetch(url).then(function(response) {
				
					return response.blob()
				})
				
				// Turn it into an ImageBitmap.
				.then(function(blobData) {
					return Browser.window.createImageBitmap(blobData);
				}).then(function(imageBitmap) {
					showInfo("imageBitmapCreated:" + imageBitmap);
					showImageBitmap(imageBitmap);
				}).catch(function(e) {
					debugger;
				})
		}
		
		public function showImageBitmap(imageBitmap):void {
			var canvas:HTMLCanvas = new Laya.HTMLCanvas("2D");
			canvas.size(imageBitmap.width, imageBitmap.height);
			var ctx:*;
			ctx = canvas.source.getContext("2d");
			ctx.drawImage(imageBitmap, 0, 0);
			var tex:Texture;
			tex = new Texture(canvas);
			Laya.stage.graphics.drawTexture(tex, 0, 0);
		}
		private var strPng:String = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGIAAABRCAYAAAApS3MNAAABSUlEQVR4Xu3a0QmFMADFUJ1JXM0h3moPZ6qg4AoNeLqAIenFn65jjLE40w2sQkxvcAMI0eggRKSDEEJUDEQ4/COEiBiIYFiEEBEDEQyLECJiIIJhEUJEDEQwLEKIiIEIhkUIETEQwbAIISIGIhgWIUTEQATDIoSIGIhgWIQQEQMRDIsQImIggnEvYvv9IzjfxDiP/XlgJsTcCyDEXP/v14UQImIggmERQkQMRDAsQoiIgQiGRQgRMRDBsAghIgYiGBYhRMRABMMihIgYiGBYhBARAxEMixAiYiCCYRFCRAxEMCxCiIiBCMa7iAjPpzG8fY3kF0KIiIEIhkUIETEQwbAIISIGIhgWIUTEQATDIoSIGIhgWIQQEQMRDIsQImIggmERQkQMRDAsQoiIgQiGRQgRMRDBsAghIgYiGBYhRMRABMMihIgYiGBcGJiOHTRZjZAAAAAASUVORK5CYII=";
		private function testBase64() {
		
			var blobData;
			blobData = dataURLtoBlob(strPng);
			trace(blobData);
			Browser.window.createImageBitmap(blobData).then(function(imageBitmap) {
							showInfo("imageBitmapCreated:", imageBitmap);
							showImageBitmap(imageBitmap);
						}, function(e) {
							showInfo("createImageBitmap failed11");
						}).catch(function(e) {
							showInfo("createImageBitmap failed");
						})
		}
		private static var Blob:Class = Browser.window.Blob;
		private function atob(p:*):*
		{
			return Browser.window.atob(p);
		}
		private function dataURLtoBlob(dataurl) {
			var arr = dataurl.split(','), mime = arr[0].match(/:(.*?);/)[1], bstr = atob(arr[1]), n = bstr.length, u8arr = new Uint8Array(n);
			while (n--) {
				u8arr[n] = bstr.charCodeAt(n);
			}
			return new Blob([u8arr], {type: mime});
		}
	
	}