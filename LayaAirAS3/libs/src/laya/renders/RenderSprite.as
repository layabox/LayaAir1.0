package laya.renders {
	import laya.display.css.CSSStyle;
	import laya.display.css.Style;
	import laya.display.Sprite;
	import laya.filters.Filter;
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.resource.HTMLCanvas;
	import laya.system.System;
	import laya.utils.Stat;
	
	/**
	 * ...
	 * @author laya
	 */
	public class RenderSprite {
		//绘制顺序：单图片、变形、画布、graphics、子对象
		
		public static const IMAGE:int = 0x01;
		public static const FILTERS:int = 0x02;
		public static const ALPHA:int = 0x04;
		public static const TRANSFORM:int = 0x08;
		public static const CANVAS:int = 0x10;
		public static const BLEND:int = 0x20;
		public static const CLIP:int = 0x40;
		public static const STYLE:int = 0x80;
		public static const GRAPHICS:int = 0x100;
		public static const CUSTOM:int = 0x200;
		public static const ENABLERENDERMERGE:int = 0x400;		
		public static const CHILDS:int = 0x800;
		
		public static const INIT:int = 0x11111;
		
		public static var renders:Array = [];
		
		protected static var NORENDER:RenderSprite = /*[STATIC SAFE]*/ new RenderSprite(0, null);
		
		public static function __init__():void {

			var i:int, len:int;
			var initRender:RenderSprite;
			initRender = System.createRenderSprite(INIT, null);
			len = renders.length = CHILDS * 2;
			for (i = 0; i < len; i++)
				renders[i] = initRender;
			
			renders[0] = System.createRenderSprite(0, null);
			
			function _initSame(value:Array, o:RenderSprite):void {
				var n:int = 0;
				for (var i:int = 0; i < value.length; i++) {
					n |= value[i];
					renders[n] = o;
				}
			}
			
			_initSame([IMAGE, GRAPHICS, TRANSFORM, ALPHA], new RenderSprite(IMAGE, null));
			
			renders[IMAGE | GRAPHICS] = System.createRenderSprite(IMAGE | GRAPHICS, null);
			
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
					rst = System.createRenderSprite(tType, rst);
				tType = tType >> 1;
			}
			return rst;
		
		}

		public var _next:RenderSprite;
		public var _fun:Function;
		
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
			case CLIP: 
				_fun = this._clip;
				return;
			case STYLE: 
				_fun = this._style;
				return;
			case GRAPHICS: 
				_fun = this._graphics;
				return;
			case ENABLERENDERMERGE:
				_fun = this._enableRenderMerge;
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
			var style:Style = sprite._style;
			_next._fun.call(_next, sprite, context, x - style.translateX, y - style.translateY);
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

		public function _enableRenderMerge(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var next:RenderSprite = this._next;
			if (next == NORENDER) return;
			context.ctx.save();
			context.ctx.enableMerge = true;
			next._fun.call(next, sprite, context, x, y);
			context.ctx.restore();
		}
		
		public function _blend(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var style:Style = sprite._style;
			if (style.blendMode) {
				context.ctx.globalCompositeOperation = style.blendMode;
			}
			var next:RenderSprite = this._next;
			next._fun.call(next, sprite, context, x, y);
			var mask:Sprite = sprite.mask;
			if (mask) {
				context.ctx.globalCompositeOperation = "destination-in";
				if (mask.numChildren > 0 || !mask.graphics._isOnlyOne()) {
					mask.cacheAsBitmap = true;
				}
				mask.render(context, x, y);
			}
			context.ctx.globalCompositeOperation = "source-over";
		}
		
		public function _graphics(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var style:Style = sprite._style;
			sprite._graphics && sprite._graphics._render(sprite, context, x - style.translateX, y - style.translateY);
			var next:RenderSprite = this._next;
			next._fun.call(next, sprite, context, x, y);
		}
		
		public function _image(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			if (sprite._graphics._isOnlyOne()) {
				var style:Style = sprite._style;
				context.ctx.drawTexture2(x, y, style.translateX, style.translateY, sprite.transform, style.alpha, style.blendMode, sprite._graphics._one);
			} else {
				_graphics(sprite, context, x, y);
				sprite._renderType &= ~RenderSprite.IMAGE;
			}
		}
		
		public function _image2(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			if (sprite._graphics._isOnlyOne()) {
				var style:Style = sprite._style;
				context.ctx.drawTexture2(x, y, style.translateX, style.translateY, sprite.transform, 1, null, sprite._graphics._one);
			} else {
				_graphics(sprite, context, x, y);
				sprite._renderType &= ~RenderSprite.IMAGE;
			}
		}
		
		public function _alpha(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var style:Style = sprite._style;
			var alpha:Number;
			if ((alpha = style.alpha) > 0.01) {
				var temp:Number = context.ctx.globalAlpha;
				context.ctx.globalAlpha *= alpha;
				var next:RenderSprite = this._next;
				next._fun.call(next, sprite, context, x, y);
				context.ctx.globalAlpha =temp;
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
		
		public function _childs(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			//'use strict';
			var style:Style = sprite._style;
			x += -style.translateX + style.paddingLeft;
			y += -style.translateY + style.paddingTop;
			var words:Vector.<Object> = sprite._getWords();
			words && context.fillWords(words, x, y, (style as CSSStyle).font, (style as CSSStyle).color);
			
			var childs:Array = sprite._childs, n:int = childs.length, ele:Sprite;
			if (!sprite.optimizeFloat || sprite.scrollRect == null) 
			{
				for (var i:int = 0; i < n; ++i) 
					(ele = (childs[i] as Sprite))._style.visible && ele.render(context, x, y);
			} 
			else 
			{
				var rect:Rectangle = sprite.scrollRect;
				for (i = 0; i < n; ++i) {
					ele = childs[i] as Sprite;
					if (ele._style.visible && rect.intersects(Rectangle.TEMP.setTo(ele.x, ele.y, ele.width, ele.height)))
						ele.render(context, x, y);
				}				
			}
		}
		
		public function _canvas(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var _cacheCanvas:* = sprite._$P.cacheCanvas;
			var _next:RenderSprite = this._next;
			if (!_cacheCanvas) {
				_next._fun.call(_next, sprite, tx, x, y);
				return;
			}
			var tx:RenderContext = _cacheCanvas.ctx;
			var _repaint:Boolean = sprite.isRepaint()  || (!tx) || tx.ctx._repaint;
			var canvas:HTMLCanvas;
			var left:Number;
			var top:Number;
			var tRec:Rectangle;
			
			_cacheCanvas.type === 'bitmap'?(Stat.canvasBitmap++):(Stat.canvasNormal++);
						
			if (_repaint)
			{
				left = - sprite.pivotX;
				top = - sprite.pivotY;
				if (!_cacheCanvas._cacheRec)
					_cacheCanvas._cacheRec = new Rectangle();
				var w:Number = sprite.width, h:Number = sprite.height;	
				if (sprite.autoSize || w === 0 || h === 0) 
				{			
					tRec = sprite.getSelfBounds();
					tRec.x -= sprite.pivotX;
					tRec.y -= sprite.pivotY;
					//tRec.x -= 10;
					//tRec.y -= 10;
					tRec.width += 20;
					tRec.height += 20;
					_cacheCanvas._cacheRec.copyFrom(tRec);		
					tRec = _cacheCanvas._cacheRec;		
				}else
				{
					tRec = _cacheCanvas._cacheRec.setTo(left, top, w, h);
				}
				w = tRec.width;
				h = tRec.height;
				left = tRec.x;
				top = tRec.y;
				if (!tx) {
					tx = _cacheCanvas.ctx = new RenderContext(w, h, new HTMLCanvas(HTMLCanvas.TYPEAUTO));
				}
				
				canvas= tx.canvas;
				if (_cacheCanvas.type === 'bitmap') canvas.asBitmap=true;
				
				canvas.clear();
				(canvas.width != w || canvas.height != h) && canvas.size(w, h);
				_next._fun.call(_next, sprite, tx, -left, -top);
				sprite.applyFilters();
				if (sprite._$P.isStatic) _cacheCanvas.reCache = false;
				//trace("[reCache]",sprite);
				Stat.canvasReCache++;
			}else
			{
				tRec=_cacheCanvas._cacheRec;
				left = tRec.x;
				top = tRec.y;
				canvas= tx.canvas;
			}		
			
			context.drawCanvas(canvas, x + left, y + top, canvas.width, canvas.height);
		}
	}
}