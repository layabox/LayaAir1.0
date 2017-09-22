package laya.renders {
	import laya.display.Sprite;
	import laya.display.css.CSSStyle;
	import laya.display.css.Style;
	import laya.filters.Filter;
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.resource.HTMLCanvas;
	import laya.utils.Browser;
	import laya.utils.HTMLChar;
	import laya.utils.Pool;
	import laya.utils.RunDriver;
	import laya.utils.Stat;
	
	/**
	 * @private
	 * 精灵渲染器
	 */
	public class RenderSprite {
		/** @private */
		public static const IMAGE:int = 0x01;
		/** @private */
		public static const ALPHA:int = 0x02;
		/** @private */
		public static const TRANSFORM:int = 0x04;
		/** @private */
		public static const BLEND:int = 0x08;
		/** @private */
		public static const CANVAS:int = 0x10;
		/** @private */
		public static const FILTERS:int = 0x20;
		/** @private */
		public static const MASK:int = 0x40;
		/** @private */
		public static const CLIP:int = 0x80;
		/** @private */
		public static const STYLE:int = 0x100;
		/** @private */
		public static const GRAPHICS:int = 0x200;
		/** @private */
		public static const CUSTOM:int = 0x400;
		/** @private */
		public static const CHILDS:int = 0x800;
		/** @private */
		public static const INIT:int = 0x11111;
		/** @private */
		public static var renders:Array = [];
		/** @private */
		protected static var NORENDER:RenderSprite = /*[STATIC SAFE]*/ new RenderSprite(0, null);
		/** @private */
		public var _next:RenderSprite;
		/** @private */
		public var _fun:Function;
		
		public static function __init__():void {
			var i:int, len:int;
			var initRender:RenderSprite;
			initRender = RunDriver.createRenderSprite(INIT, null);
			len = renders.length = CHILDS * 2;
			for (i = 0; i < len; i++)
				renders[i] = initRender;
			
			renders[0] = RunDriver.createRenderSprite(0, null);
			
			function _initSame(value:Array, o:RenderSprite):void {
				var n:int = 0;
				for (var i:int = 0; i < value.length; i++) {
					n |= value[i];
					renders[n] = o;
				}
			}
			
			_initSame([IMAGE, GRAPHICS, TRANSFORM, ALPHA], new RenderSprite(IMAGE, null));
			
			renders[IMAGE | GRAPHICS] = RunDriver.createRenderSprite(IMAGE | GRAPHICS, null);
			
			renders[IMAGE | TRANSFORM | GRAPHICS] = new RenderSprite(IMAGE | TRANSFORM | GRAPHICS, null);
		}
		
		private static function _initRenderFun(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var type:int = sprite._renderType;
			var r:RenderSprite = renders[type] = _getTypeRender(type);
			r._fun(sprite, context, x, y);
		}
		
		private static function _getTypeRender(type:int):RenderSprite {
			var rst:RenderSprite = null;
			var tType:int = CHILDS;
			while (tType > 1) {
				if (tType & type)
					rst = RunDriver.createRenderSprite(tType, rst);
				tType = tType >> 1;
			}
			return rst;
		}
		
		public function RenderSprite(type:int, next:RenderSprite) {
			_next = next || NORENDER;
			switch (type) {
			case 0: 
				_fun = this._no;
				return;
			case IMAGE: 
				_fun = this._image;
				return;
			case ALPHA: 
				_fun = this._alpha;
				return;
			case TRANSFORM: 
				_fun = this._transform;
				return;
			case BLEND: 
				_fun = this._blend;
				return;
			case CANVAS: 
				_fun = this._canvas;
				return;
			case MASK: 
				_fun = this._mask;
				return;
			case CLIP: 
				_fun = this._clip;
				return;
			case STYLE: 
				_fun = this._style;
				return;
			case GRAPHICS: 
				_fun = this._graphics;
				return;
			case CHILDS: 
				_fun = this._childs;
				return;
			case CUSTOM: 
				_fun = this._custom;
				return;
			case IMAGE | GRAPHICS: 
				_fun = this._image2;
				return;
			case IMAGE | TRANSFORM | GRAPHICS: 
				_fun = this._image2;
				return;
			case FILTERS: 
				_fun = Filter._filter;
				return;
			case INIT: 
				_fun = _initRenderFun;
				return;
			}
			onCreate(type);
		}
		
		protected function onCreate(type:int):void {
		
		}
		
		public function _style(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			sprite._style.render(sprite, context, x, y);
			var next:RenderSprite = this._next;
			next._fun.call(next, sprite, context, x, y);
		}
		
		public function _no(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
		}
		
		public function _custom(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			sprite.customRender(context, x, y);
			var tf:Object = sprite._style._tf;
			_next._fun.call(_next, sprite, context, x - tf.translateX, y - tf.translateY);
		}
		
		public function _clip(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var next:RenderSprite = this._next;
			if (next == NORENDER) return;
			var r:Rectangle = sprite._style.scrollRect;
			context.ctx.save();
			context.ctx.clipRect(x, y, r.width, r.height);
			next._fun.call(next, sprite, context, x - r.x, y - r.y);
			context.ctx.restore();
		}
		
		public function _blend(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var style:Style = sprite._style;
			if (style.blendMode) {
				context.ctx.globalCompositeOperation = style.blendMode;
			}
			var next:RenderSprite = this._next;
			next._fun.call(next, sprite, context, x, y);
			context.ctx.globalCompositeOperation = "source-over";
		}
		
		public function _mask(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var next:RenderSprite = this._next;
			next._fun.call(next, sprite, context, x, y);
			var mask:Sprite = sprite.mask;
			if (mask) {
				context.ctx.globalCompositeOperation = "destination-in";
				if (mask.numChildren > 0 || !mask.graphics._isOnlyOne()) {
					mask.cacheAsBitmap = true;
				}
				mask.render(context, x-sprite.pivotX, y-sprite.pivotY);
			}
			context.ctx.globalCompositeOperation = "source-over";
		}
		
		public function _graphics(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var tf:Object = sprite._style._tf;
			sprite._graphics && sprite._graphics._render(sprite, context, x - tf.translateX, y - tf.translateY);
			var next:RenderSprite = this._next;
			next._fun.call(next, sprite, context, x, y);
		}
		
		public function _image(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var style:Style = sprite._style;
			context.ctx.drawTexture2(x, y, style._tf.translateX, style._tf.translateY, sprite.transform, style.alpha, style.blendMode, sprite._graphics._one);
		}
		
		public function _image2(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var tf:Object = sprite._style._tf;
			context.ctx.drawTexture2(x, y, tf.translateX, tf.translateY, sprite.transform, 1, null, sprite._graphics._one);
		}
		
		public function _alpha(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var style:Style = sprite._style;
			var alpha:Number;
			if ((alpha = style.alpha) > 0.01 || sprite._needRepaint()) {
				var temp:Number = context.ctx.globalAlpha;
				context.ctx.globalAlpha *= alpha;
				var next:RenderSprite = this._next;
				next._fun.call(next, sprite, context, x, y);
				context.ctx.globalAlpha = temp;
			}
		}
		
		public function _transform(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var transform:Matrix = sprite.transform, _next:RenderSprite = this._next;
			if (transform && _next != NORENDER) {
				context.save();
				context.transform(transform.a, transform.b, transform.c, transform.d, transform.tx + x, transform.ty + y);
				_next._fun.call(_next, sprite, context, 0, 0);
				context.restore();
			} else
				_next._fun.call(_next, sprite, context, x, y);
		}
		
		
		private function _childs(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			//'use strict';
			var style:* = sprite._style;
			var tf:*= style._tf;
			x = x -tf.translateX + style.paddingLeft;
			y = y -tf.translateY + style.paddingTop;
			/*[IF-FLASH]*/if (style.hasOwnProperty("_calculation")) {
			//[IF-JS]if (style._calculation) {
				var words:Vector.<HTMLChar> = sprite._getWords();
				if (words)
				{
					
					var tStyle:CSSStyle = style as CSSStyle;
					if (tStyle)
					{
						if (tStyle.stroke)
						{
							context.fillBorderWords(words, x, y, tStyle.font, tStyle.color,tStyle.strokeColor,tStyle.stroke);
						}else
						{
							context.fillWords(words, x, y, tStyle.font, tStyle.color,tStyle.underLine);
						}
					}
					
				}
			}
			
			var childs:Array = sprite._childs, n:int = childs.length, ele:*;
			if (sprite.viewport || (sprite.optimizeScrollRect && sprite._style.scrollRect)) {
				var rect:Rectangle = sprite.viewport || sprite._style.scrollRect;
				var left:Number = rect.x;
				var top:Number = rect.y;
				var right:Number = rect.right;
				var bottom:Number = rect.bottom;
				var _x:Number, _y:Number;
				
				for (i = 0; i < n; ++i) {
				/*[IF-FLASH]*/ if ((ele = childs[i] as Sprite).visible && ((_x = ele.x) < right && (_x + ele.width) > left && (_y = ele.y) < bottom && (_y + ele.height) > top)) {
				//[IF-JS] if ((ele = childs[i] as Sprite).visible && ((_x = ele._x) < right && (_x + ele.width) > left && (_y = ele._y) < bottom && (_y + ele.height) > top)) {
						ele.render(context, x, y);
					}
				}
			} else {
				for (var i:int = 0; i < n; ++i)
					(ele = (childs[i] as Sprite))._style.visible && ele.render(context, x, y);
			}			
		}
		
		//public function _childs(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			//if (sprite._childRenderMax)
			//{
				//_childs_max(sprite, context, x, y);
				//return;
			//}
			//var childs:Array = sprite._childs, n:int = childs.length, ele:*;
			//
			//for (var i:int = 0; i < n; ++i)			
				//(ele = (childs[i] as Sprite))._style.visible && ele.render(context, x, y);
		//}
		
		public function _canvas(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var _cacheCanvas:* = sprite._$P.cacheCanvas;
			if (!_cacheCanvas) {
				this._next._fun.call(this._next, sprite, context, x, y);
				return;
			}
			
			_cacheCanvas.type === 'bitmap' ? (Stat.canvasBitmap++) : (Stat.canvasNormal++);
			var tx:RenderContext = _cacheCanvas.ctx;
			
			if (sprite._needRepaint() || !tx)
			{
				_canvas_repaint(sprite,context, x, y);
			}
			else
			{
				var tRec:Rectangle = _cacheCanvas._cacheRec;
				context.drawCanvas(tx.canvas, x + tRec.x, y + tRec.y, tRec.width, tRec.height);
			}
		}
		
		private function _canvas_repaint(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var _cacheCanvas:* = sprite._$P.cacheCanvas;
			var _next:RenderSprite = this._next;
			if (!_cacheCanvas) {
				_next._fun.call(_next, sprite, tx, x, y);
				return;
			}
			var tx:RenderContext = _cacheCanvas.ctx;
			var _repaint:Boolean = sprite._needRepaint() || (!tx);
			var canvas:HTMLCanvas;
			var left:Number;
			var top:Number;
			var tRec:Rectangle;
			var tCacheType:String = _cacheCanvas.type;
			
			tCacheType === 'bitmap' ? (Stat.canvasBitmap++) : (Stat.canvasNormal++);
			if (_repaint) {
				if (!_cacheCanvas._cacheRec)
					_cacheCanvas._cacheRec = new Rectangle();
				var w:Number, h:Number;
				if (!Render.isWebGL || tCacheType === "bitmap")
				{
					tRec = sprite.getSelfBounds();
					tRec.x = tRec.x - sprite.pivotX;				
					tRec.y = tRec.y - sprite.pivotY;
					tRec.x = tRec.x - 16;
					tRec.y = tRec.y - 16;
					tRec.width = tRec.width + 32;
					tRec.height = tRec.height + 32;
					tRec.x = Math.floor(tRec.x + x) - x;
					tRec.y = Math.floor(tRec.y + y) - y;
					tRec.width = Math.floor(tRec.width);
					tRec.height = Math.floor(tRec.height);
					_cacheCanvas._cacheRec.copyFrom(tRec);
				}else
				{
					_cacheCanvas._cacheRec.setTo(-sprite.pivotX,-sprite.pivotY,1,1);
				}
				
				tRec = _cacheCanvas._cacheRec;
				var scaleX:Number = Render.isWebGL ? 1 : Browser.pixelRatio * Laya.stage.clientScaleX;
				var scaleY:Number = Render.isWebGL ? 1 : Browser.pixelRatio * Laya.stage.clientScaleY;
				
				if (!Render.isWebGL) {//||_cacheCanvas.type === 'bitmap'
					var chainScaleX:Number = 1;
					var chainScaleY:Number = 1;
					var tar:Sprite;
					tar = sprite;
					while (tar && tar != Laya.stage) {
						chainScaleX *= tar.scaleX;
						chainScaleY *= tar.scaleY;
						tar = tar.parent as Sprite;
					}
					if (Render.isWebGL) {
						if (chainScaleX < 1) scaleX *= chainScaleX;
						if (chainScaleY < 1) scaleY *= chainScaleY;
					} else {
						if (chainScaleX > 1) scaleX *= chainScaleX;
						if (chainScaleY > 1) scaleY *= chainScaleY;
					}
					
				}
				if (sprite.scrollRect)
				{
					var scrollRect:Rectangle = sprite.scrollRect;
					tRec.x -= scrollRect.x;
					tRec.y -= scrollRect.y;
				}
				w = tRec.width * scaleX;
				h = tRec.height * scaleY;
				left = tRec.x;
				top = tRec.y;
				
				if (Render.isWebGL && tCacheType === 'bitmap' && (w > 2048 || h > 2048)) {
					console.warn("cache bitmap size larger than 2048,cache ignored");
					if (_cacheCanvas.ctx) {
						Pool.recover("RenderContext", _cacheCanvas.ctx);
						_cacheCanvas.ctx.canvas.size(0, 0);
						_cacheCanvas.ctx = null;
					}
					_next._fun.call(_next, sprite, context, x, y);
					return;
				}
				if (!tx) {
				    tx = _cacheCanvas.ctx = Pool.getItem("RenderContext") || new RenderContext(w, h, HTMLCanvas.create(HTMLCanvas.TYPEAUTO));
				}
				tx.ctx.sprite = sprite;
		
				
				canvas = tx.canvas;
				canvas.clear();
				(canvas.width != w || canvas.height != h) && canvas.size(w, h);
				if (tCacheType === 'bitmap') canvas.context.asBitmap = true;
				else if(tCacheType === 'normal')canvas.context.asBitmap = false;
				
				var t:*;
				//TODO:测试webgl下是否有缓存模糊问题
				if (scaleX != 1 || scaleY != 1) {
					var ctx:* = RenderContext(tx).ctx;
					ctx.save();
					ctx.scale(scaleX, scaleY);
					if (!Render.isConchWebGL && Render.isConchApp) {
						t = sprite._$P.cf;
						t && ctx.setFilterMatrix && ctx.setFilterMatrix(t._mat, t._alpha);
					}
					_next._fun.call(_next, sprite, tx, -left, -top);
					ctx.restore();
					if (!Render.isConchApp || Render.isConchWebGL) sprite._applyFilters();
				} else {
					ctx = RenderContext(tx).ctx;
					if (!Render.isConchWebGL && Render.isConchApp) {
						t = sprite._$P.cf;
						t && ctx.setFilterMatrix && ctx.setFilterMatrix(t._mat, t._alpha);
					}
					_next._fun.call(_next, sprite, tx, -left, -top);
					if (!Render.isConchApp || Render.isConchWebGL) sprite._applyFilters();
				}
				
				if (sprite._$P.staticCache) _cacheCanvas.reCache = false;
				Stat.canvasReCache++;
			} else {
				tRec = _cacheCanvas._cacheRec;
				left = tRec.x;
				top = tRec.y;
				canvas = tx.canvas;
			}
			context.drawCanvas(canvas, x + left, y + top, tRec.width, tRec.height);
			//trace(x + left, y + top,tRec.width,tRec.height);
		}
	}
}