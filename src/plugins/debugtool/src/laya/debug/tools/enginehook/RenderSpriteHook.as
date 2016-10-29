package laya.debug.tools.enginehook 
{
	import laya.display.Sprite;
	import laya.display.css.CSSStyle;
	import laya.display.css.Style;
	import laya.filters.Filter;
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.HTMLCanvas;
	import laya.utils.Browser;
	import laya.utils.Pool;
	import laya.utils.RunDriver;
	import laya.utils.Stat;
	import laya.debug.tools.CacheAnalyser;
	/**
	 * ...
	 * @author ww
	 */
	public class RenderSpriteHook 
	{
		/** @private */
		public static const IMAGE:int = 0x01;
		/** @private */
		public static const FILTERS:int = 0x02;
		/** @private */
		public static const ALPHA:int = 0x04;
		/** @private */
		public static const TRANSFORM:int = 0x08;
		/** @private */
		public static const CANVAS:int = 0x10;
		/** @private */
		public static const BLEND:int = 0x20;
		/** @private */
		public static const CLIP:int = 0x40;
		/** @private */
		public static const STYLE:int = 0x80;
		/** @private */
		public static const GRAPHICS:int = 0x100;
		/** @private */
		public static const CUSTOM:int = 0x200;
		/** @private */
		public static const ENABLERENDERMERGE:int = 0x400;
		/** @private */
		public static const CHILDS:int = 0x800;
		/** @private */
		public static const INIT:int = 0x11111;
		/** @private */
		public static var renders:Array = [];
		/** @private */
		
		/** @private */
		public var _next:RenderSprite;
		/** @private */
		public var _fun:Function;
		public var _oldCanvas:Function;
		public function RenderSpriteHook() 
		{
			
		}
		public static var I:RenderSpriteHook;
		public static function init():void
		{
			I = new RenderSpriteHook();
			RunDriver.createRenderSprite = I.createRenderSprite;
		}
		public function createRenderSprite(type:int, next:RenderSprite):RenderSprite 
		{
			var rst:RenderSprite;
			rst = new RenderSprite(type, next);
			if (type == RenderSprite.CANVAS)
			{
				rst["_oldCanvas"] = rst._fun;
				rst._fun = I._canvas;
			}
			return rst;
		}
		public function _canvas(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			if (!SpriteRenderForVisibleAnalyse.allowRendering) return;
			//trace("hooked canvas");
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var _cacheCanvas:* = sprite._$P.cacheCanvas;
			var _next:RenderSprite = this._next;
			if (!_cacheCanvas||SpriteRenderForVisibleAnalyse.isVisibleTesting) {
				_next._fun.call(_next, sprite, context, x, y);
				return;
			}
			
			var preTime:int;
			preTime = Browser.now();
			var tx:RenderContext = _cacheCanvas.ctx;
			var _repaint:Boolean = sprite._needRepaint() || (!tx);
			_oldCanvas(sprite, context, x, y);
			if (Config.showCanvasMark) 
			{
				
			}
			if (_repaint)
			{
				CacheAnalyser.I.reCacheCanvas(sprite,Browser.now()-preTime);
			}else
			{
				CacheAnalyser.I.renderCanvas(sprite,Browser.now()-preTime);
			}
			
			//trace(x + left, y + top,tRec.width,tRec.height);
		}
	}

}