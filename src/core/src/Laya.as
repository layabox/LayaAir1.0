package {
	import laya.asyn.Asyn;
	import laya.asyn.Deferred;
	import laya.display.Graphics;
	import laya.display.Input;
	import laya.display.css.Font;
	import laya.display.css.Style;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.events.KeyBoardManager;
	import laya.events.MouseManager;
	import laya.net.Loader;
	import laya.net.LoaderManager;
	import laya.net.URL;
	import laya.renders.Render;
	import laya.renders.RenderSprite;
	import laya.resource.Context;
	import laya.resource.ResourceManager;
	import laya.utils.Browser;
	import laya.utils.Timer;
	
	/**
	 * <code>Laya</code> 是全局对象的引用入口集。
	 */
	public dynamic class Laya {
		/*[COMPILER OPTIONS:normal]*/
		/** 舞台对象的引用。*/
		public static var stage:Stage = null;
		/** 时间管理器的引用。*/
		public static var timer:Timer =  null;
		/** 加载管理器的引用。*/
		public static var loader:LoaderManager = null;
		/** Render 类的引用。*/
		public static var render:Render;
		/** 引擎版本。*/
		public static var version:String = "1.0.3";
		
		/**
		 * 初始化引擎。
		 * @param	width 游戏窗口宽度。
		 * @param	height	游戏窗口高度。
		 * @param	插件列表，比如 WebGL。
		 * @return	返回原生canvas，方便控制
		 */
		public static function init(width:Number, height:Number, ... plugins):* {
			Browser.__init__();
			Context.__init__();
			Graphics.__init__();
			timer = new Timer();
			loader = new LoaderManager();
			/*[IF-FLASH]*/width = Browser.clientWidth; height = Browser.clientHeight;
			
			for (var i:int = 0, n:int = plugins.length; i < n; i++) {
				if (plugins[i].enable) plugins[i].enable();
			}
			Font.__init__();
			Style.__init__();
			ResourceManager.__init__();
			stage = new Stage();
			stage.model&&stage.model.setRootNode();
			var location:* = Browser.window.location;
			var pathName:String = location.pathname;
			// 索引为2的字符如果是':'就是windows file协议
			pathName = pathName.charAt(2) == ':' ? pathName.substring(1) : pathName;
			URL.rootPath = URL.basePath = URL.getPath(location.protocol == "file:" ? pathName : location.origin + pathName);

			initAsyn();
			//render = new Render(width, height);
			render = new Render(50, 50);
			stage.size(width, height);
			
			RenderSprite.__init__();
			KeyBoardManager.__init__();
			MouseManager.instance.__init__();
			Input.__init__();
			return Render.canvas;
		}
		
		/**@private 初始化异步函数调用。 */
		protected static function initAsyn():void {
			Asyn.loadDo = function(url:String, type:String, d:Deferred):Deferred {
				var l:Loader = new Loader();
				if (d) {
					l.once(Event.COMPLETE, null, function(data:*):void {
						d.callback(data);
					});
					l.once(Event.ERROR, null, function(err:String):void {
					});
				}
				l.load(url, type);
				return d;
			}
			
			Asyn.onceTimer = function(delay:int, d:Deferred):void {
				Laya.timer.once(delay, d, d.callback);
			}
			Asyn.onceEvent = function(type:String, listener:*):void {
				Laya.stage.once(type, null, listener);
			}
			Laya.timer.frameLoop(1, null, Asyn._loop_);
		}
		
		/**
		 * 表示是否捕获全局错误并弹出提示。
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