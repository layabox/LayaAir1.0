package laya.utils {
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.renders.Render;
	import laya.renders.RenderSprite;
	import laya.resource.HTMLCanvas;
	
	/**
	 * @private
	 */
	public class RunDriver {
		//TODO:去掉
		
		public static var getIncludeStr:Function = function(name:String):String {
			return null;
		}
		
		//TODO:coverage
		public static var createShaderCondition:Function = function(conditionScript:String):Function {
			var fn:String = "(function() {return " + conditionScript + ";})";
			return Laya._runScript(fn);//生成条件判断函数
		}
		private static var hanzi:RegExp = new RegExp("^[\u4E00-\u9FA5]$");
		private static var fontMap:Array = [];
		public static var measureText:Function = function(txt:String, font:String):* {
			var isChinese:Boolean = hanzi.test(txt);
			if (isChinese && fontMap[font]) {
				return fontMap[font];
			}
			
			var ctx:* = Browser.context;
			ctx.font = font;
			
			var r:* = ctx.measureText(txt);
			if (isChinese) fontMap[font] = r;
			return r;
		}
		
		/**
		 * @private
		 * 绘制到画布。
		 */
		public static var drawToCanvas:Function =/*[STATIC SAFE]*/ function(sprite:Sprite, _renderType:int, canvasWidth:Number, canvasHeight:Number, offsetX:Number, offsetY:Number):* {
			//把参数强转成int
			canvasWidth |= 0;	canvasHeight |= 0;	offsetX |= 0;	offsetY |= 0;
			var canvas:HTMLCanvas = new HTMLCanvas();
			var ctx:* = canvas.getContext('2d');
			canvas.size(canvasWidth, canvasHeight);
			RenderSprite.renders[_renderType]._fun(sprite, ctx, offsetX, offsetY);
			return canvas;
		}
		
		/**
		 * @private
		 * 初始化渲染器。缺省是canvas渲染，如果WebGL enable之后，webgl会替换这个函数。
		 */
		public static var initRender:Function = function(canvas:HTMLCanvas, w:int, h:int):Boolean { 
			Render._context = canvas.getContext('2d');
			canvas.size(w, h);
			return true; 
		};
		
		/**
		 * 创建2D例子模型的处理函数。
		 */
		public static var createParticleTemplate2D:Function;
		/**
		 * 用于改变 WebGL宽高信息。
		 */
		public static var changeWebGLSize:Function = /*[STATIC SAFE]*/ function(w:Number, h:Number):void {
		}
		
		/**
		 * 用于创建 RenderSprite 对象。
		 */
		//TODO:coverage
		public static var createRenderSprite:Function = /*[STATIC SAFE]*/ function(type:int, next:RenderSprite):RenderSprite {
			return new RenderSprite(type, next);
		}
		
		/** @private */
		//TODO:coverage
		public static var clear:Function = function(value:String):void {
			if ( !Render.isConchApp )
			{
				Render._context.clear();
			}
		};
		
		/** @private */
		//TODO:coverage
		public static var getTexturePixels:Function = function(value:*, x:Number, y:Number, width:Number, height:Number):Array {
			return null;
		};
		
		/** @private */
		//TODO:coverage
		public static var skinAniSprite:Function = function():* {
			return null;
		}
		
		/**
		 * 清空纹理函数。
		 */
		//TODO:coverage
		public static var cancelLoadByUrl:Function = function(url:String):void {
		};
		
		public static var  enableNative:Function;
	}

}