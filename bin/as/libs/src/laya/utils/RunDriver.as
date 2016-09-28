package laya.utils {
	import laya.display.Sprite;
	import laya.filters.ColorFilterAction;
	import laya.filters.IFilterAction;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.HTMLCanvas;
	import laya.display.Graphics;
	import laya.resource.Texture;
	
	/**
	 * @private
	 */
	public class RunDriver {
		/**
		 * 滤镜动作集。
		 */
		public static var FILTER_ACTIONS:Array = [];
		private static var pixelRatio:int =-1;
		
		/*[FILEINDEX:10000000]*/
		private static var _charSizeTestDiv:*;
		
		public static var now:Function = function():Number {
			return __JS__('Date.now()');
		}
		
		public static var getWindow:Function = function():* {
			return __JS__('window');
		}
		
		public static var newWebGLContext:Function = function(canvas:*, webGLName:String):* {
			return canvas.getContext(webGLName, {stencil: true, alpha: false, antialias: Config.isAntialias, premultipliedAlpha: false});
		}
		
		public static var getPixelRatio:Function = function():Number {
			if (pixelRatio < 0) {
				var ctx:* = Browser.context;
				var backingStore:Number = ctx.backingStorePixelRatio || ctx.webkitBackingStorePixelRatio || ctx.mozBackingStorePixelRatio || ctx.msBackingStorePixelRatio || ctx.oBackingStorePixelRatio || ctx.backingStorePixelRatio || 1;
				pixelRatio = (Browser.window.devicePixelRatio || 1) / backingStore;
			}
			return pixelRatio;
		}
		
		public static var getIncludeStr:Function = function(name:String):String {
			return null;
		}
		
		public static var createShaderCondition:Function = function(conditionScript:String):Function {
			var fn:String = "(function() {return " + conditionScript + ";})";
			return Browser.window.eval(fn);//生成条件判断函数
		}
		
		public static var measureText:Function = function(txt:String, font:String):* {
			if (Render.isConchApp) {
				var ctx:* = __JS__("ConchTextCanvas");
				ctx.font = font;
				return ctx.measureText(txt);
			}
			if (_charSizeTestDiv == null) {
				_charSizeTestDiv = Browser.createElement('div');
				_charSizeTestDiv.style.cssText = "z-index:10000000;padding:0px;position: absolute;left:0px;visibility:hidden;top:0px;background:white";
				Browser.container.appendChild(_charSizeTestDiv);
			}
			_charSizeTestDiv.style.font = font;
			_charSizeTestDiv.innerText = txt == " " ? "i" : txt;
			return {width: _charSizeTestDiv.offsetWidth, height: _charSizeTestDiv.offsetHeight};
		}
		
		/**
		 * 开始函数。
		 */
		public static var beginFlush:Function = function():void {
		}
		
		public static var endFinish:Function = function():void {
			/*[IF-FLASH]*/
			Render.context.ctx.finish();
		}
		
		/**
		 * 添加至图集的处理函数。
		 */
		public static var addToAtlas:Function;
		
		public static var flashFlushImage:Function = function(atlasWebGLCanvas:*):void {
		}
		
		/**
		 * 绘制到画布。
		 */
		public static var drawToCanvas:Function =/*[STATIC SAFE]*/ function(sprite:Sprite, _renderType:int, canvasWidth:Number, canvasHeight:Number, offsetX:Number, offsetY:Number):* {
			var canvas:HTMLCanvas = HTMLCanvas.create("2D");
			var context:RenderContext = new RenderContext(canvasWidth, canvasHeight, canvas);
			RenderSprite.renders[_renderType]._fun(sprite, context, offsetX, offsetY);
			return canvas;
		}
		
		/**
		 * 创建2D例子模型的处理函数。
		 */
		public static var createParticleTemplate2D:Function;
		
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
		 * 用于创建 RenderSprite 对象。
		 */
		public static var createRenderSprite:Function = /*[STATIC SAFE]*/ function(type:int, next:RenderSprite):RenderSprite {
			return new RenderSprite(type, next);
		}
		
		/**
		 * 用于创建滤镜动作。
		 */
		public static var createFilterAction:Function =/*[STATIC SAFE]*/ function(type:int):IFilterAction {
			return new ColorFilterAction();
		}
		
		/**
		 * 用于创建 Graphics 对象。
		 */
		public static var createGraphics:Function =/*[STATIC SAFE]*/ function():Graphics {
			return new Graphics();
		}
		
		/** @private */
		public static var clear:Function = function(value:String):void {
			Render._context.ctx.clear();
		};
		
		/**
		 * 清空纹理函数。
		 */
		public static var clearAtlas:Function = function(value:String):void {
		};
		
		/** @private */
		public static var addTextureToAtlas:Function = function(value:Texture):void {
		};
		
		/** @private */
		public static var getTexturePixels:Function = function(value:Texture, x:Number, y:Number, width:Number, height:Number):Array {
			return null;
		};
		
		/** @private */
		public static var fillTextureShader:Function = function(value:Texture, x:Number, y:Number, width:Number, height:Number):* {
			return null;
		}
		
		/** @private */
		public static var skinAniSprite:Function = function():*{
			return null;
		}
	
	}

}