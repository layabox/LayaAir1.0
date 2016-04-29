package laya.renders {
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
		/** @private */
		public static var clear:Function =/*[STATIC SAFE]*/ function(value:String):void {
			_context.ctx.clear();
		};
		
		/**
		 * 清空纹理函数。
		 */
		public static var clearAtlas:Function =/*[STATIC SAFE]*/ function(value:String):void {
		};
		
		/**
		 * 完成函数。
		 */
		public static var finish:Function =/*[STATIC SAFE]*/ function():void {
		};
		
		/**
		 * 初始化引擎。
		 * @param	width 游戏窗口宽度。
		 * @param	height	游戏窗口高度。
		 */
		public function Render(width:Number, height:Number) {
			_mainCanvas = new HTMLCanvas('2D');
			var style:* = _mainCanvas.source.style;
			style.position = 'absolute';
			style.top = style.left = "0px";
			style.background = "#000000";
			_mainCanvas.source.id = "layaCanvas";
			var isWebGl:Boolean = WebGL != null;
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
		
		/** 是否是 WebGl 模式。*/
		public static function get isWebGl():Boolean {
			return WebGL != null;
		}
		
		/** 渲染使用的画布引用。 */
		public static function get canvas():* {
			return _mainCanvas;
		}
	}
}