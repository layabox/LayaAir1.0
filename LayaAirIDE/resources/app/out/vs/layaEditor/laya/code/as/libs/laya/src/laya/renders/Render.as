package laya.renders {
	import laya.resource.HTMLCanvas;
	import laya.utils.Browser;
	import laya.utils.RunDriver;
	
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
		
		/*[IF-FLASH-BEGIN]*/
		/**是否是Flash模式*/
		public static var isFlash:Boolean = true;
		/*[IF-FLASH-END]*/
		/**是否是加速器模式*/
		public static var isConchApp:Boolean = false;
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
			_mainCanvas = HTMLCanvas.create('2D');
			
			var style:* = _mainCanvas.source.style;
			style.position = 'absolute';
			style.top = style.left = "0px";
			style.background = "#000000";
			
			_mainCanvas.source.id = "layaCanvas";
			var isWebGl:Boolean = Render.isWebGL;
			isWebGl && WebGL.init(canvas, width, height);
			Browser.document.body.appendChild(_mainCanvas.source);
			_context = new RenderContext(width, height, isWebGl ? null : _mainCanvas);
			
			Browser.window.requestAnimationFrame(loop);
			
			function loop():void {
				Laya.stage._loop();
				Browser.window.requestAnimationFrame(loop);
			}
		}
		
		/** 目前使用的渲染器。*/
		public static function get context():RenderContext {
			return _context;
		}
		
		/** 渲染使用的画布引用。 */
		public static function get canvas():* {
			return _mainCanvas;
		}
	}
}