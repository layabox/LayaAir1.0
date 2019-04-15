package {
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.MouseManager;
	import laya.net.LoaderManager;
	import laya.net.URL;
	import laya.renders.Render;
	import laya.renders.RenderSprite;
	import laya.resource.Context;
	import laya.runtime.ICPlatformClass;
	import laya.runtime.IMarket;
	import laya.utils.Browser;
	import laya.utils.CacheManger;
	import laya.utils.RunDriver;
	import laya.utils.Timer;
	import laya.utils.WeakObject;
	
	/**
	 * <code>Laya</code> 是全局对象的引用入口集。
	 * Laya类引用了一些常用的全局对象，比如Laya.stage：舞台，Laya.timer：时间管理器，Laya.loader：加载管理器，使用时注意大小写。
	 */
	public dynamic class Laya {
		/*[COMPILER OPTIONS:normal]*/
		/** 舞台对象的引用。*/
		public static var stage:Stage = null;
		/**@private 系统时钟管理器，引擎内部使用*/
		public static var systemTimer:Timer = null;
		/**@private 组件的start时钟管理器*/
		public static var startTimer:Timer = null;
		/**@private 组件的物理时钟管理器*/
		public static var physicsTimer:Timer = null;
		/**@private 组件的update时钟管理器*/
		public static var updateTimer:Timer = null;
		/**@private 组件的lateUpdate时钟管理器*/
		public static var lateTimer:Timer = null;
		/**游戏主时针，同时也是管理场景，动画，缓动等效果时钟，通过控制本时针缩放，达到快进慢播效果*/
		public static var timer:Timer = null;
		/** 加载管理器的引用。*/
		public static var loader:LoaderManager = null;
		/** 当前引擎版本。*/
		public static var version:String = "2.0.0";
		/**@private Render 类的引用。*/
		public static var render:Render;
		/**@private */
		public static var _currentStage:Sprite;
		/**@private Market对象 只有加速器模式下才有值*/
		public static var conchMarket:IMarket = __JS__("window.conch?conchMarket:null");
		/**@private PlatformClass类，只有加速器模式下才有值 */
		public static var PlatformClass:ICPlatformClass = __JS__("window.PlatformClass");
		/**@private */
		private static var _isinit:Boolean = false;
		/**是否是微信小游戏子域，默认为false**/
		public static var isWXOpenDataContext:Boolean = false;
		/**微信小游戏是否需要在主域中自动将加载的文本数据自动传递到子域，默认 false**/
		public static var isWXPosMsg:Boolean = false;
		
		/**
		 * 初始化引擎。使用引擎需要先初始化引擎，否则可能会报错。
		 * @param	width 初始化的游戏窗口宽度，又称设计宽度。
		 * @param	height	初始化的游戏窗口高度，又称设计高度。
		 * @param	plugins 插件列表，比如 WebGL（使用WebGL方式渲染）。
		 * @return	返回原生canvas引用，方便对canvas属性进行修改
		 */
		public static function init(width:Number, height:Number, ... plugins):* {
			if (_isinit) return;
			_isinit = true;
			ArrayBuffer.prototype.slice || (ArrayBuffer.prototype.slice = _arrayBufferSlice);
			
			Browser.__init__();
			
			if (!Render.isConchApp) {
				Context.__init__();
			}
			systemTimer = new Timer(false);
			startTimer = new Timer(false);
			physicsTimer = new Timer(false);
			updateTimer = new Timer(false);
			lateTimer = new Timer(false);
			timer = new Timer(false);
			
			loader = new LoaderManager();
			WeakObject.__init__();
			
			var isWebGLEnabled:Boolean = false;
			for (var i:int = 0, n:int = plugins.length; i < n; i++) {
				if (plugins[i] && plugins[i].enable) {
					plugins[i].enable();
					if (typeof plugins[i] === "WebGL") isWebGLEnabled = true;
				}
			}
			//必须在webgl.enable之后
			if (Render.isConchApp) {
				if (!isWebGLEnabled) __JS__("laya.webgl.WebGL.enable()");
				RunDriver.enableNative();
			}
			CacheManger.beginCheck();
			_currentStage = stage = new Stage();
			_getUrlPath();
			render = new Render(0, 0);
			stage.size(width, height);
			window.stage = stage;
			RenderSprite.__init__();
			MouseManager.instance.__init__(stage, Render.canvas);
			return Render.canvas;
		}
		
		/**@private */
		private static function _getUrlPath():void {
			var location:* = Browser.window.location;
			var pathName:String = location.pathname;
			// 索引为2的字符如果是':'就是windows file协议
			pathName = pathName.charAt(2) == ':' ? pathName.substring(1) : pathName;
			URL.rootPath = URL.basePath = URL.getPath(location.protocol == "file:" ? pathName : location.protocol + "//" + location.host + location.pathname);
		}
		
		/**@private */
		private static function _arrayBufferSlice(start:int, end:int):ArrayBuffer {
			var arr:* = __JS__("this");
			var arrU8List:Uint8Array = new Uint8Array(arr, start, end - start);
			var newU8List:Uint8Array = new Uint8Array(arrU8List.length);
			newU8List.set(arrU8List);
			return newU8List.buffer;
		}
		
		/**
		 * 表示是否捕获全局错误并弹出提示。默认为false。
		 * 适用于移动设备等不方便调试的时候，设置为true后，如有未知错误，可以弹窗抛出详细错误堆栈。
		 */
		public static function set alertGlobalError(value:Boolean):void {
			var erralert:int = 0;
			if (value) {
				Browser.window.onerror = function(msg:String, url:String, line:String, column:String, detail:*):void {
					if (erralert++ < 5 && detail)
						alert("出错啦，请把此信息截图给研发商\n" + msg + "\n" + detail.stack);
				}
			} else {
				Browser.window.onerror = null;
			}
		}
		
		private static var _evcode:String = "eva" + "l";
		
		/**@private */
		public static function _runScript(script:String):* {
			return Browser.window[_evcode](script);
		}
		
		/**
		 * 开启DebugPanel
		 * @param	debugJsPath laya.debugtool.js文件路径
		 */
		public static function enableDebugPanel(debugJsPath:String = "libs/laya.debugtool.js"):void {
			if (!Laya["DebugPanel"]) {
				var script:* = Browser.createElement("script");
				script.onload = function():void {
					Laya["DebugPanel"].enable();
				}
				script.src = debugJsPath;
				Browser.document.body.appendChild(script);
			} else {
				Laya["DebugPanel"].enable();
			}
		}
	}
}