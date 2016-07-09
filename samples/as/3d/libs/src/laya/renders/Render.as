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
		public static const NODE:int = 0x01;
		public static const WEBGL:int = 0x02;
		public static const CONCH:int = 0x04;
		
		/*[IF-FLASH-BEGIN]*/
		/**是否是Flash模式*/
		public static var isFlash:Boolean = true;
		/*[IF-FLASH-END]*/
		/** @private */
		public static var ConchRenderType:int = 0;
		/**是否是WebGL模式*/
		public static var isWebGL:Boolean = false;
		/** 表示是否是 3D 模式。*/
		public static var is3DMode:Boolean;
		/**是否是加速器 只读*/
		public static function get isConchApp():Boolean {
			return (ConchRenderType&CONCH)==CONCH;
		}
		/**加速器模式下设置是否是节点模式*/
		public static function get isConchNode():Boolean{
			return (ConchRenderType & 5) == 5;
		}
		
		public static function set isConchNode(b:Boolean):void {
			if (b)
			{
				ConchRenderType |= NODE;
			}
			else
			{
				ConchRenderType &= ~NODE;
			}
		}
		/**加速器模式下设置是否是WebGL模式*/
		public static function get isConchWebGL():Boolean{
			return (ConchRenderType & WEBGL) == WEBGL;
		}
		
		public static function set isConchWebGL(b:Boolean):void {
			if (b)
			{
				ConchRenderType |= WEBGL;
			}
			else
			{
				ConchRenderType &= ~WEBGL;
			}
		}
		
		
		
		public static var optimizeTextureMemory:Function = function(url:String, texture:*):Boolean
		{
			return true;
		}
		__JS__("Render.ConchRenderType|=(!window.conch?0:0x04);");
		/**
		 * 初始化引擎。
		 * @param	width 游戏窗口宽度。
		 * @param	height	游戏窗口高度。
		 */
		public function Render(width:Number, height:Number) {
			//_mainCanvas = HTMLCanvas.create('2D');
			
			var style:* = _mainCanvas.source.style;
			style.position = 'absolute';
			style.top = style.left = "0px";
			style.background = "#000000";
			
			_mainCanvas.source.id = "layaCanvas";
			var isWebGl:Boolean = Render.isWebGL;
			isWebGl && WebGL.init(_mainCanvas, width, height);
			Browser.container.appendChild(_mainCanvas.source);
			_context = new RenderContext(width, height, isWebGl ? null : _mainCanvas);
			_context.ctx.setIsMainContext();
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
		
		/** 渲染使用的原生画布引用。 */
		public static function get canvas():* {
			return _mainCanvas.source;
		}
	}
}