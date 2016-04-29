package laya.system {
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.filters.ColorFilterAction;
	import laya.filters.IFilterAction;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.HTMLCanvas;
	
	/**
	 * @private
	 */
	public class System {
		/**
		 * 
		 */
		public static var isConchApp:Boolean = false;
		/**
		 * 滤镜动作集。
		 */
		public static var FILTER_ACTIONS:Array = [];
		/**
		 * 用于创建 RenderSprite 对象。
		 */
		public static var createRenderSprite:Function = /*[STATIC SAFE]*/ function(type:int, next:RenderSprite):RenderSprite {
			return new RenderSprite(type, next);
		}
		/**
		 * 用于创建 WebGL 纹理。
		 */
		public static var createGLTextur:Function = null;
		/**
		 * 用于创建 WebGLContext2D 对象。
		 */
		public static var createWebGLContext2D:Function = null;
		/**
		 * 用于改变 WebGL宽高信息。
		 */
		public static var changeWebGLSize:Function = /*[STATIC SAFE]*/ function(w:Number, h:Number):void {
		}
		/**
		 * 用于创建 Graphics 对象。
		 */
		public static var createGraphics:Function =/*[STATIC SAFE]*/ function():Graphics {
			return new Graphics();
		}
		/**
		 * 用于创建滤镜动作。
		 */
		public static var createFilterAction:Function =/*[STATIC SAFE]*/ function(type:int):IFilterAction {
			return new ColorFilterAction();
		}
		/**
		 * 绘制到画布。
		 */
		public static var drawToCanvas:Function =/*[STATIC SAFE]*/ function(sprite:Sprite, _renderType:int, canvasWidth:Number, canvasHeight:Number, offsetX:Number, offsetY:Number):* {
			var canvas:HTMLCanvas = new HTMLCanvas("2D");
			var context:RenderContext = new RenderContext(canvasWidth, canvasHeight, canvas);
			RenderSprite.renders[_renderType]._fun(sprite, context, offsetX, offsetY);
			return canvas;
		}
		
		/**
		 * 替换指定名称的定义。用来动态更改类的定义。
		 * @param	name 属性名。
		 * @param	classObj 属性值。
		 */
		public static function changeDefinition(name:String, classObj:*):void {
			Laya[name] = classObj;
			var str:String = name + "=classObj";
			__JS__("eval(str)");
		}
		
		/**
		 * 添加至图集的处理函数。
		 */
		public static var addToAtlas:Function;
		
		/**
		 * 创建2D例子模型的处理函数。
		 */
		public static var createParticleTemplate2D:Function;
		
		/**
		 * @private
		 * 初始化。
		 */
		public static function __init__():void {
			isConchApp = __JS__("window.conch ? true : false;");
			if (isConchApp) {
				__JS__("conch.disableConchResManager()");
				__JS__("conch.disableConchAutoRestoreLostedDevice()");
			}
		}
	}
}