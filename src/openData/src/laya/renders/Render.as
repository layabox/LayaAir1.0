package laya.renders {
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.utils.Browser;
	import laya.utils.RunDriver;
	
	/**
	 * @private
	 * <code>Render</code> 是渲染管理类。它是一个单例，可以使用 Laya.render 访问。
	 */
	public class Render {
		/** @private */
		public static var _context:Context;
		/** @private 主画布。canvas和webgl渲染都用这个画布*/
		public static var _mainCanvas:HTMLCanvas;
		
		/**是否是加速器 只读*/
		public static var isConchApp:Boolean=__JS__("(window.conch != null)");
		/**是否是WebGL模式*/
		public static var isWebGL:Boolean = false;
		/** 表示是否是 3D 模式。*/
		public static var is3DMode:Boolean;
		
		/**
		 * 初始化引擎。
		 * @param	width 游戏窗口宽度。
		 * @param	height	游戏窗口高度。
		 */
		public function Render(width:Number, height:Number) {
			//创建主画布。改到Browser中了，因为为了runtime，主画布必须是第一个
			_mainCanvas.source.id = "layaCanvas";
			_mainCanvas.source.width = width;
			_mainCanvas.source.height = height;
			Browser.container.appendChild(_mainCanvas.source);
			RunDriver.initRender(_mainCanvas, width, height);
			Browser.window.requestAnimationFrame(loop);
			function loop(stamp:Number):void {
				Laya.stage._loop();
				Browser.window.requestAnimationFrame(loop);
			}
			Laya.stage.on("visibilitychange", this, _onVisibilitychange);
		}
		
		/**@private */
		private var _timeId:int = 0;
		
		/**@private */
		private function _onVisibilitychange():void {
			if (!Laya.stage.isVisibility) {
				_timeId = Browser.window.setInterval(this._enterFrame, 1000);
			} else if (_timeId != 0) {
				Browser.window.clearInterval(_timeId);
			}
		}
		
		/**@private */
		private function _enterFrame(e:* = null):void {
			Laya.stage._loop();
		}
		
		/** 目前使用的渲染器。*/
		public static function get context():Context {
			return _context;
		}
		
		/** 渲染使用的原生画布引用。 */
		public static function get canvas():* {
			return _mainCanvas.source;
		}
	}
}