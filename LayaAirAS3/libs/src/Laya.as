package {
	import laya.asyn.Asyn;
	import laya.asyn.Deferred;
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
	import laya.resource.ResourceManager;
	import laya.utils.Browser;
	import laya.utils.Timer;
	
	/**
	 * 全局引用入口
	 * @author yung
	 */
	public dynamic class Laya {
		/*[COMPILER OPTIONS:normal]*/
		/**舞台信息*/
		public static var stage:Stage = null;
		/**时间管理器*/
		public static var timer:Timer = new Timer();
		/**加载管理器*/
		public static var loader:LoaderManager = new LoaderManager();
		/**Render类*/
		public static var render:Render;
		/**引擎版本*/
		public static var version:String = "0.9.7";
		/**是否是3d模式*/
		public static var is3DMode:Boolean;
		
		/**
		 * 初始化引擎
		 * @param	width 游戏窗口宽度
		 * @param	height	游戏窗口高度
		 * @param	插件列表，比如WebGL
		 */
		public static function init(width:Number, height:Number, ... plugins):void {
			for (var i:int = 0, n:int = plugins.length; i < n; i++) {
				if (plugins[i].enable) plugins[i].enable();
			}
			Font.__init__();
			Style.__init__();
			ResourceManager.__init__();
			stage = new Stage();
			
			var location:* = Browser.window.location;
			URL.rootPath = URL.basePath = URL.getPath(location.protocal == "file:" ? location.pathname : location.href);
			
			initAsyn();
			render = new Render(width, height);
			stage.size(width, height);
			
			RenderSprite.__init__();
			KeyBoardManager.__init__();
			MouseManager.instance.__init__();		
		}
		
		/**初始化异步函数调用*/
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
		
		/**是否捕获全局错误并弹出提示*/
		public static function set alertGlobalError(value:Boolean):void {
			var erralert:int = 0;
			if (value) {
				Browser.window.onerror = function(msg:String, url:String, line:String,column:String,detail:*):void {
					if (erralert++ < 5 && detail) 
						alert("出错啦，请把此信息截图给研发商\n"+msg+"\n"+detail.stack);
				}
			} else {
				Browser.window.onerror = null;
			}
		}
	}
}