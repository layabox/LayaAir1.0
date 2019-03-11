package laya.net {
	import laya.events.EventDispatcher;
	import laya.renders.Render;
	import laya.resource.HTMLCanvas;
	import laya.utils.Browser;
	
	/**
	 * @private
	 * Worker Image加载器
	 */
	public class WorkerLoader extends EventDispatcher {
		
		/**单例*/
		public static var I:WorkerLoader;
		/**worker.js的路径 */
		public static var workerPath:String = "libs/workerloader.js";
		
		/**@private */
		private static var _preLoadFun:Function;
		/**@private */
		private static var _enable:Boolean = false;
		/**@private */
		private static var _tryEnabled:Boolean = false;
		
		/**使用的Worker对象。*/
		public var worker:Worker;
		/**@private */
		protected var _useWorkerLoader:Boolean;
		
		public function WorkerLoader() {
			worker = new Browser.window.Worker(workerPath);
			worker.onmessage = function(evt:*):void {
				//接收worker传过来的数据函数
				workerMessage(evt.data);
			}
		}
		
		/**
		 * 尝试使用Work加载Image
		 * @return 是否启动成功
		 */
		public static function __init__():Boolean {
			if (_preLoadFun != null) return false;
			if (!Browser.window.Worker) return false;
			_preLoadFun = Loader["prototype"]["_loadImage"];
			Loader["prototype"]["_loadImage"] = WorkerLoader["prototype"]["_loadImage"];
			if (!I) I = new WorkerLoader();
			return true;
		}
		
		/**
		 * 是否支持worker
		 * @return 是否支持worker
		 */
		public static function workerSupported():Boolean {
			return Browser.window.Worker ? true : false;
		}
		
		/**
		 * 尝试启用WorkerLoader,只有第一次调用有效
		 */
		public static function enableWorkerLoader():void {
			if (!_tryEnabled) {
				enable = true;
				_tryEnabled = true;
			}
		}
		
		/**
		 * 是否启用。
		 */
		public static function set enable(value:Boolean):void {
			if (_enable != value) {
				_enable = value;
				if (value && _preLoadFun == null) _enable = __init__();
			}
		}
		
		public static function get enable():Boolean {
			return _enable;
		}
		
		/**
		 * @private
		 */
		private function workerMessage(data:*):void {
			if (data) {
				switch (data.type) {
				case "Image": 
					imageLoaded(data);
					break;
				case "Disable": 
					enable = false;
					break;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function imageLoaded(data:*):void {
			if (!data.dataType || data.dataType != "imageBitmap") {
				event(data.url, null);
				return;
			}
			
			//TODO:
			var canvas:HTMLCanvas = new HTMLCanvas(true);
			var ctx:* = canvas.source.getContext("2d");
			
			switch (data.dataType) {
			case "imageBitmap": 
				var imageData:* = data.imageBitmap;
				canvas.size(imageData.width, imageData.height);
				ctx.drawImage(imageData, 0, 0);
				break;
			}
			trace("load:", data.url);
			if (Render.isWebGL) {
				//避免被计算两次
				canvas._setGPUMemory(0);
				__JS__("var tex=new laya.webgl.resource.Texture2D();");
				__JS__("tex.loadImageSource(canvas)");
				__JS__("canvas=tex");
				
			}
			event(data.url, canvas);
		}
		
		/**
		 * 加载图片
		 * @param	url 图片地址
		 */
		public function loadImage(url:String):void {
			worker.postMessage(url);
		}
		
		/**
		 * @private
		 * 加载图片资源。
		 * @param	url 资源地址。
		 */
		protected function _loadImage(url:String):void {
			var _this:Loader = this as Loader;
			if (!_useWorkerLoader || !_enable) {
				_preLoadFun.call(_this, url);
				return;
			}
			url = URL.formatURL(url);
			function clear():void {
				WorkerLoader.I.off(url, _this, onload);
			}
			
			var onload:Function = function(image:*):void {
				clear();
				if (image) {
					_this["onLoaded"](image);
				} else {
					//失败之后使用原版的加载函数加载重试
					_preLoadFun.call(_this, url);
				}
			};
			WorkerLoader.I.on(url, _this, onload);
			WorkerLoader.I.loadImage(url);
		}
	}
}