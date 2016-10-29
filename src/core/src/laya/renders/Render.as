package laya.renders {
	import laya.events.Event;
	import laya.resource.HTMLCanvas;
	import laya.utils.Browser;
	
	/**
	 * @private
	 * <code>Render</code> 是渲染管理类。它是一个单例，可以使用 Laya.render 访问。
	 */
	public class Render {
		/** @private */
		public static var _context:RenderContext;
		/** @private */
		public static var _mainCanvas:HTMLCanvas;
		/** @private */
		public static var WebGL:*;
		/**@private */
		public static const NODE:int = 0x01;
		/**@private */
		public static const WEBGL:int = 0x02;
		/**@private */
		public static const CONCH:int = 0x04;
		
		/*[IF-FLASH-BEGIN]*/
		/**是否是Flash模式*/
		public static var isFlash:Boolean = true;
		/*[IF-FLASH-END]*/
		__JS__("window.ConchRenderType=window.ConchRenderType||1");
		/**是否是WebGL模式*/
		public static var isWebGL:Boolean = false;
		/** 表示是否是 3D 模式。*/
		public static var is3DMode:Boolean;
		
		/**是否是加速器 只读*/
		public static function get isConchApp():Boolean {
			return __JS__("(window.ConchRenderType & 0x04) == 0x04");
		}
		
		/**加速器模式下设置是否是节点模式 如果是否就是非节点模式 默认为canvas模式 如果设置了isConchWebGL则是webGL模式*/
		public static function get isConchNode():Boolean {
			return __JS__("(window.ConchRenderType & 5) == 5");
		}
		
		public static function set isConchNode(b:Boolean):void {
			if (b) {
				__JS__("window.ConchRenderType |= 0x01");
			} else {
				__JS__("window.ConchRenderType &= ~ 0x01");
			}
		}
		
		/**加速器模式下设置是否是WebGL模式*/
		public static function get isConchWebGL():Boolean {
			return __JS__("window.ConchRenderType==6");
		}
		
		public static function set isConchWebGL(b:Boolean):void {
			if (b) {
				isConchNode = false;
				__JS__("window.ConchRenderType |= 0x02");
			} else {
				__JS__("window.ConchRenderType &= ~ 0x02");
			}
		}
		
		/**@private */
		public static var optimizeTextureMemory:Function = function(url:String, texture:*):Boolean {
			return true;
		}
		__JS__("window.ConchRenderType|=(!window.conch?0:0x04);");
		
		/**
		 * 初始化引擎。
		 * @param	width 游戏窗口宽度。
		 * @param	height	游戏窗口高度。
		 */
		public function Render(width:Number, height:Number) {
			var style:* = _mainCanvas.source.style;
			style.position = 'absolute';
			style.top = style.left = "0px";
			style.background = "#000000";
			
			_mainCanvas.source.id = _mainCanvas.source.id || "layaCanvas";
			var isWebGl:Boolean = Render.isWebGL;
			isWebGl && WebGL.init(_mainCanvas, width, height);
			if (_mainCanvas.source.nodeName || Render.isConchApp) {
				Browser.container.appendChild(_mainCanvas.source);
			}
			_context = new RenderContext(width, height, isWebGl ? null : _mainCanvas);
			_context.ctx.setIsMainContext();
			
			Browser.window.requestAnimationFrame(loop);
			
			function loop():void {
				Laya.stage._loop();
				Browser.window.requestAnimationFrame(loop);
			}
			/*[IF-FLASH]*/
			Browser.window.stageIn.addEventListener("enterFrame", _enterFrame);
			Laya.stage.on(Event.BLUR, this, _onBlur);
			Laya.stage.on(Event.FOCUS, this, _onFocus);
		}
		
		/**@private */
		private function _onFocus():void {
			Browser.window.clearInterval(_timeId);
		}
		/**@private */
		private var _timeId:int = 0;
		
		/**@private */
		private function _onBlur():void {
			_timeId = Browser.window.setInterval(this._enterFrame, 1000);
		}
		
		/**@private */
		private function _enterFrame(e:* = null):void {
			Laya.stage._loop();
		}
		
		/** 目前使用的渲染器。*/
		public static function get context():RenderContext {
			return _context;
		}
		
		/** 渲染使用的原生画布引用。 */
		public static function get canvas():* {
			return _mainCanvas.source;
		}
	}
}