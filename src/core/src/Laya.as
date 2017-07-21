package {
	import laya.display.Graphics;
	import laya.display.Input;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.css.Font;
	import laya.display.css.Style;
	import laya.events.KeyBoardManager;
	import laya.events.MouseManager;
	import laya.media.SoundManager;
	import laya.net.LoaderManager;
	import laya.net.LocalStorage;
	import laya.net.URL;
	import laya.renders.Render;
	import laya.renders.RenderSprite;
	import laya.resource.Context;
	import laya.resource.ResourceManager;
	import laya.runtime.ICPlatformClass;
	import laya.runtime.IMarket;
	import laya.utils.Browser;
	import laya.utils.CacheManger;
	import laya.utils.Timer;
	
	/**
	 * <code>Laya</code> 是全局对象的引用入口集。
	 * Laya类引用了一些常用的全局对象，比如Laya.stage：舞台，Laya.timer：时间管理器，Laya.loader：加载管理器，使用时注意大小写。
	 */
	public dynamic class Laya {
		/*[COMPILER OPTIONS:normal]*/
		/** 舞台对象的引用。*/
		public static var stage:Stage = null;
		/** 时间管理器的引用。*/
		public static var timer:Timer = null;
		/** 加载管理器的引用。*/
		public static var loader:LoaderManager = null;
		/** 当前引擎版本。*/
		public static var version:String = "1.7.8beta";
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
		
		/**
		 * 初始化引擎。使用引擎需要先初始化引擎，否则可能会报错。
		 * @param	width 初始化的游戏窗口宽度，又称设计宽度。
		 * @param	height	初始化的游戏窗口高度，又称设计高度。
		 * @param	plugins 插件列表，比如 WebGL（使用WebGL方式渲染）。
		 * @return	返回原生canvas引用，方便对canvas属性进行修改
		 */
		public static function init(width:Number, height:Number, ... plugins):* {
			if (_isinit) return;
			ArrayBuffer.prototype.slice || (ArrayBuffer.prototype.slice = _arrayBufferSlice);
			_isinit = true;
			Browser.__init__();
			Context.__init__();
			Graphics.__init__();
			timer = new Timer();
			loader = new LoaderManager();
			/*[IF-FLASH]*/
			width = Browser.clientWidth;
			/*[IF-FLASH]*/
			height = Browser.clientHeight;
			
			for (var i:int = 0, n:int = plugins.length; i < n; i++) {
				if (plugins[i].enable) plugins[i].enable();
			}
			Font.__init__();
			Style.__init__();
			ResourceManager.__init__();
			CacheManger.beginCheck();
			_currentStage = stage = new Stage();
			stage.conchModel && stage.conchModel.setRootNode();
			var location:* = Browser.window.location;
			var pathName:String = location.pathname;
			// 索引为2的字符如果是':'就是windows file协议
			pathName = pathName.charAt(2) == ':' ? pathName.substring(1) : pathName;
			URL.rootPath = URL.basePath = URL.getPath(location.protocol == "file:" ? pathName : location.protocol + "//" + location.host + location.pathname);
			
			/*[IF-FLASH]*/
			render = new Render(50, 50);
			//[IF-JS]render = new Render(0, 0);
			stage.size(width, height);
			RenderSprite.__init__();
			KeyBoardManager.__init__();
			MouseManager.instance.__init__(stage, Render.canvas);
			Input.__init__();
			SoundManager.autoStopMusic = true;
			LocalStorage.__init__();
			return Render.canvas;
		}
		
		/**@private */
		private static function _arrayBufferSlice(start:int, end:int):ArrayBuffer {
			var arr:*= __JS__("this");
			var arrU8List:Uint8Array = new Uint8Array(arr,start,end-start);
			var newU8List:Uint8Array=new Uint8Array(arrU8List.length);
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
	}
}