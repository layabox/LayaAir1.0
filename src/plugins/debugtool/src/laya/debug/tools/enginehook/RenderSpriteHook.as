package laya.debug.tools.enginehook 
{
	import laya.debug.tools.CacheAnalyser;
	import laya.display.Sprite;
	import laya.display.css.CacheStyle;
	import laya.renders.RenderSprite;
	import laya.resource.Context;
	import laya.utils.Browser;

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
		public static var _oldCanvas:Function;
		public function RenderSpriteHook() 
		{
			
		}
		public static var I:RenderSpriteHook;
		public static var _preCreateFun:Function;
		public static function init():void
		{
			if (_oldCanvas) return;
			//I = new RenderSpriteHook();
			//_preCreateFun = RunDriver.createRenderSprite;
			//RunDriver.createRenderSprite = I.createRenderSprite;
			_oldCanvas=RenderSprite["prototype"]["_canvas"];
			RenderSprite["prototype"]["_canvas"] = RenderSpriteHook["prototype"]["_canvas"];
		}

		public function _canvas(sprite:Sprite, context:Context, x:Number, y:Number):void {
			//trace("hooked canvas");
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var _cacheStyle:CacheStyle = sprite._cacheStyle;
			var _next:RenderSprite = this._next;
			var _repaint:Boolean ;
			if (!_cacheStyle.enableCanvasRender) {
				_oldCanvas.call(this,sprite, context, x, y);
				return;
			}

			if (sprite._needRepaint() || (!_cacheStyle.canvas)) {
				_repaint = true;
			}else
			{
				_repaint = false;
			}
			
			
			var preTime:int;
			preTime = Browser.now();
			
			_oldCanvas.call(this,sprite, context, x, y);

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