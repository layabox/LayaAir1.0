package laya.system {
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.filters.ColorFilterAction;
	import laya.filters.IFilterAction;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.HTMLCanvas;
	/**
	 * ...
	 * @author laya
	 */
	public class System 
	{
		public static var isConchApp:Boolean = false;
		public static var FILTER_ACTIONS:Array = [];
		public static var createRenderSprite:Function = /*[STATIC SAFE]*/ function(type:int, next:RenderSprite):RenderSprite {
			return new RenderSprite(type, next);
		}
		public static var createGLTextur:Function = null;
		public static var createWebGLContext2D:Function = null;
		public static var changeWebGLSize:Function = /*[STATIC SAFE]*/ function(w:Number, h:Number):void {
		}
		public static var createGraphics:Function =/*[STATIC SAFE]*/ function():Graphics {
			return new Graphics();
		}
		public static var createFilterAction:Function =/*[STATIC SAFE]*/ function(type:int):IFilterAction {
			return new ColorFilterAction();
		}
		
		public  static  var  drawToCanvas:Function=/*[STATIC SAFE]*/ function(sprite:Sprite,_renderType:int,canvasWidth:Number, canvasHeight:Number, offsetX:Number, offsetY:Number):*
		{
			var canvas:HTMLCanvas = new HTMLCanvas("2D");
			var context:RenderContext = new RenderContext(canvasWidth, canvasHeight, canvas);
			RenderSprite.renders[_renderType]._fun(sprite, context, offsetX, offsetY);
			return canvas;
		}
		
		/**替换函数定义，用来动态更改类的定义*/
		public static function changeDefinition(name:String,classObj:*):void {
			Laya[name] = classObj;
			var str:String = name+"=classObj";
			__JS__("eval(str)");
		}
		
		public  static var  addToAtlas:Function;
		
		public static var createParticleTemplate2D:Function;
		
		public static function __init__():void
		{
			isConchApp = __JS__( "window.conch ? true : false;" );
		}
	}
}