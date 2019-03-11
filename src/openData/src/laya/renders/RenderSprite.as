package laya.renders {
	import laya.display.Sprite;
	import laya.display.SpriteConst;
	import laya.display.css.CacheStyle;
	import laya.display.css.SpriteStyle;
	import laya.display.css.TextStyle;
	import laya.filters.Filter;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.LayaGLQuickRunner;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Pool;
	import laya.utils.RunDriver;
	import laya.utils.Stat;
	
	/**
	 * @private
	 * 精灵渲染器
	 */
	public class RenderSprite {
		/** @private */
		//public static const IMAGE:int = 0x01;
		/** @private */
		//public static const ALPHA:int = 0x02;
		/** @private */
		//public static const TRANSFORM:int = 0x04;
		/** @private */
		//public static const BLEND:int = 0x08;
		/** @private */
		//public static const CANVAS:int = 0x10;
		/** @private */
		//public static const FILTERS:int = 0x20;
		/** @private */
		//public static const MASK:int = 0x40;
		/** @private */
		//public static const CLIP:int = 0x80;
		/** @private */
		//public static const STYLE:int = 0x100;
		/** @private */
		//public static const GRAPHICS:int = 0x200;
		/** @private */
		//public static const CUSTOM:int = 0x400;
		/** @private */
		//public static const CHILDS:int = 0x800;
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
			LayaGLQuickRunner.__init__();
			var i:int, len:int;
			var initRender:RenderSprite;
			initRender = RunDriver.createRenderSprite(INIT, null);
			len = renders.length = SpriteConst.CHILDS * 2;
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
		
			//_initSame([SpriteConst.IMAGE, SpriteConst.GRAPHICS, SpriteConst.TRANSFORM, SpriteConst.ALPHA], RunDriver.createRenderSprite(SpriteConst.IMAGE, null));
			//
			//renders[SpriteConst.IMAGE | SpriteConst.GRAPHICS] = RunDriver.createRenderSprite(SpriteConst.IMAGE | SpriteConst.GRAPHICS, null);
			//
			//renders[SpriteConst.IMAGE | SpriteConst.TRANSFORM | SpriteConst.GRAPHICS] = RunDriver.createRenderSprite(SpriteConst.IMAGE | SpriteConst.TRANSFORM | SpriteConst.GRAPHICS, null);
		}
		
		private static function _initRenderFun(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var type:int = sprite._renderType;
			var r:RenderSprite = renders[type] = _getTypeRender(type);
			r._fun(sprite, context, x, y);
		}
		
		private static function _getTypeRender(type:int):RenderSprite {
			if (LayaGLQuickRunner.map[type]) return RunDriver.createRenderSprite(type, null);
			var rst:RenderSprite = null;
			var tType:int = SpriteConst.CHILDS;
			while (tType > 0) {
				if (tType & type)
					rst = RunDriver.createRenderSprite(tType, rst);
				tType = tType >> 1;
			}
			return rst;
		}
		

		
		public function RenderSprite(type:int, next:RenderSprite) {
			
			if (LayaGLQuickRunner.map[type]) {
				_fun = LayaGLQuickRunner.map[type];
				_next = NORENDER;
				return;
			}
			_next = next || NORENDER;
			switch (type) {
			case 0: 
				_fun = this._no;
				return;
			//case SpriteConst.IMAGE: 
			//_fun = this._image;
			//return;
			case SpriteConst.ALPHA: 
				_fun = this._alpha;
				return;
			case SpriteConst.TRANSFORM: 
				_fun = this._transform;
				return;
			case SpriteConst.BLEND: 
				_fun = this._blend;
				return;
			case SpriteConst.CANVAS: 
				_fun = this._canvas;
				return;
			case SpriteConst.MASK: 
				_fun = this._mask;
				return;
			case SpriteConst.CLIP: 
				_fun = this._clip;
				return;
			case SpriteConst.STYLE: 
				_fun = this._style;
				return;
			case SpriteConst.GRAPHICS: 
				_fun = this._graphics;
				return;
			case SpriteConst.CHILDS: 
				_fun = this._children;
				return;
			case SpriteConst.CUSTOM: 
				_fun = this._custom;
				return;
			case SpriteConst.TEXTURE: 
				_fun = this._texture;
				return;
			//case SpriteConst.IMAGE | SpriteConst.GRAPHICS: 
			//_fun = this._image2;
			//return;
			//case SpriteConst.IMAGE | SpriteConst.TRANSFORM | SpriteConst.GRAPHICS: 
			//_fun = this._image2;
			//return;
			case SpriteConst.FILTERS: 
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
		
		public function _style(sprite:Sprite, context:Context, x:Number, y:Number):void {
			//现在只有Text会走这里，Html已经不走这里了
			var style:TextStyle = sprite._style as TextStyle;
			if (style.render != null) style.render(sprite, context, x, y);
			var next:RenderSprite = this._next;
			next._fun.call(next, sprite, context, x, y);
		}
		
		public function _no(sprite:Sprite, context:Context, x:Number, y:Number):void {
		}
		
		//TODO:coverage
		public function _custom(sprite:Sprite, context:Context, x:Number, y:Number):void {
			sprite.customRender(context, x, y);
			_next._fun.call(_next, sprite, context, x-sprite.pivotX, y-sprite.pivotY);
		}
		
		public function _clip(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var next:RenderSprite = this._next;
			if (next == NORENDER) return;
			var r:Rectangle = sprite._style.scrollRect;
			context.save();
			context.clipRect(x, y, r.width, r.height);
			next._fun.call(next, sprite, context, x - r.x, y - r.y);
			context.restore();
		}
		
		//TODO:coverage
		public function _blend(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var style:SpriteStyle = sprite._style;
			if (style.blendMode) {
				context.globalCompositeOperation = style.blendMode;
			}
			var next:RenderSprite = this._next;
			next._fun.call(next, sprite, context, x, y);
			context.globalCompositeOperation = "source-over";
		}
		
		//TODO:coverage
		public function _mask(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var next:RenderSprite = this._next;
			next._fun.call(next, sprite, context, x, y);
			var mask:Sprite = sprite.mask;
			if (mask) {
				context.globalCompositeOperation = "destination-in";
				if (mask.numChildren > 0 || !mask.graphics._isOnlyOne()) {
					mask.cacheAs = "bitmap";
				}
				mask.render(context, x - sprite._style.pivotX, y - sprite._style.pivotY);
			}
			context.globalCompositeOperation = "source-over";
		}
		
		public function _texture(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var tex:Texture = sprite.texture;
			if(tex._getSource())
			context.drawTexture(tex, x-sprite.pivotX, y-sprite.pivotY, sprite._width || tex.width, sprite._height || tex.height);
			var next:RenderSprite = this._next;
			next._fun.call(next, sprite, context, x, y);
		}
		
		public function _graphics(sprite:Sprite, context:Context, x:Number, y:Number):void {
			sprite._graphics && sprite._graphics._render(sprite, context, x-sprite.pivotX, y-sprite.pivotY);
			var next:RenderSprite = this._next;
			next._fun.call(next, sprite, context, x, y);
		}
		
		//TODO:coverage
		public function _image(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var style:SpriteStyle = sprite._style;
			context.drawTexture2(x, y, style.pivotX, style.pivotY, sprite.transform, sprite._graphics._one);
		}
		
		//TODO:coverage
		public function _image2(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var style:SpriteStyle = sprite._style;
			context.drawTexture2(x, y, style.pivotX, style.pivotY, sprite.transform, sprite._graphics._one);
		}
		
		//TODO:coverage
		public function _alpha(sprite:Sprite, context:Context, x:Number, y:Number):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var style:SpriteStyle = sprite._style;
			var alpha:Number;
			if ((alpha = style.alpha) > 0.01 || sprite._needRepaint()) {
				var temp:Number = context.globalAlpha;
				context.globalAlpha *= alpha;
				var next:RenderSprite = this._next;
				next._fun.call(next, sprite, context, x, y);
				context.globalAlpha = temp;
			}
		}
		
		public function _transform(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var transform:Matrix = sprite.transform, _next:RenderSprite = this._next;
			var style:SpriteStyle = sprite._style;
			if (transform && _next != NORENDER) {
				context.save();
				context.transform(transform.a, transform.b, transform.c, transform.d, transform.tx + x, transform.ty + y);
				_next._fun.call(_next, sprite, context, 0, 0);
				context.restore();
			} else
				_next._fun.call(_next, sprite, context, x, y);
		}
		
		public function _children(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var style:SpriteStyle = sprite._style;
			var childs:Array = sprite._children, n:int = childs.length, ele:*;
			x = x - sprite.pivotX;
			y = y - sprite.pivotY;
			
			if (style.viewport) {
				var rect:Rectangle = style.viewport;
				var left:Number = rect.x;
				var top:Number = rect.y;
				var right:Number = rect.right;
				var bottom:Number = rect.bottom;
				var _x:Number, _y:Number;
				
				for (i = 0; i < n; ++i) {
					if ((ele = childs[i] as Sprite)._visible && ((_x = ele._x) < right && (_x + ele.width) > left && (_y = ele._y) < bottom && (_y + ele.height) > top)) {
						ele.render(context, x, y);
					}
				}
			} else {
				for (var i:int = 0; i < n; ++i)
					(ele = (childs[i] as Sprite))._visible && ele.render(context, x, y);
			}
		}
		
		public function _canvas(sprite:Sprite, context:Context, x:Number, y:Number):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var _cacheStyle:CacheStyle = sprite._cacheStyle;
			var _next:RenderSprite = this._next;
			
			if (!_cacheStyle.enableCanvasRender) {
				_next._fun.call(_next, sprite, context, x, y);
				return;
			}
			_cacheStyle.cacheAs === 'bitmap' ? (Stat.canvasBitmap++) : (Stat.canvasNormal++);
			if (sprite._needRepaint() || (!_cacheStyle.canvas)) {
				_canvas_repaint(sprite, context, x, y);
			} else {
				/*
				var src:RenderTexture = window.__scope_src;
				var out:RenderTexture = window.__scope_out;
				var spctx:WebGLContext2D = _cacheStyle.canvas.context as WebGLContext2D;
				if (src && out) {
					//window.mainctx._drawRenderTexture(out, 500, 300, out.width, out.height, null, 1.0, RenderTexture.defuv);	
					//window.mainctx._drawRenderTexture(src, 300, 300, src.width, src.height, null, 1.0, RenderTexture.flipyuv);	
					//window.mainctx._drawRenderTexture(spctx._targets, 300, 600, src.width, src.height, null, 1.0, RenderTexture.flipyuv);	
				}
				*/
				var tRec:Rectangle = _cacheStyle.cacheRect;
				context.drawCanvas(_cacheStyle.canvas, x + tRec.x, y + tRec.y, tRec.width, tRec.height);
			}
		
		}
		
		public function _canvas_repaint(sprite:Sprite, context:Context, x:Number, y:Number):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var _cacheStyle:CacheStyle = sprite._cacheStyle;
			var _next:RenderSprite = this._next;
			var tx:Context;
			var canvas:HTMLCanvas=_cacheStyle.canvas;
			var left:Number;
			var top:Number;
			var tRec:Rectangle;
			var tCacheType:String = _cacheStyle.cacheAs;
			
			var w:Number, h:Number;
			var scaleX:Number, scaleY:Number;
			
			var scaleInfo:Point;
			scaleInfo = _cacheStyle._calculateCacheRect(sprite, tCacheType, x, y);
			scaleX = scaleInfo.x;
			scaleY = scaleInfo.y;
				
			//显示对象实际的绘图区域
			tRec = _cacheStyle.cacheRect;
			
			//计算cache画布的大小
			w = tRec.width * scaleX;
			h = tRec.height * scaleY;
			left = tRec.x;
			top = tRec.y;
			
			if (Render.isWebGL && tCacheType === 'bitmap' && (w > 2048 || h > 2048)) {
				console.warn("cache bitmap size larger than 2048,cache ignored");
				_cacheStyle.releaseContext();
				_next._fun.call(_next, sprite, context, x, y);
				return;
			}
			if (!canvas) {
				_cacheStyle.createContext();
				canvas = _cacheStyle.canvas;
			}
			tx = canvas.context;
			
			//WebGL用
			tx.sprite = sprite;
			
			(canvas.width != w || canvas.height != h) && canvas.size(w, h);//asbitmap需要合理的大小，所以size放到前面
			
			if (tCacheType === 'bitmap') tx.asBitmap = true;
			else if (tCacheType === 'normal') tx.asBitmap = false;
			
			//清理画布。之前记录的submit会被全部清掉
			tx.clear();
			
			if (tCacheType === 'normal') {
				//记录需要touch的资源
				tx.touches = [];
			}
			
			//TODO:测试webgl下是否有缓存模糊
			if (scaleX != 1 || scaleY != 1) {
				var ctx:* = tx;
				ctx.save();
				ctx.scale(scaleX, scaleY);
				_next._fun.call(_next, sprite, tx, -left, -top);
				ctx.restore();
				sprite._applyFilters();
			} else {
				ctx = tx;
				_next._fun.call(_next, sprite, tx, -left, -top);
				sprite._applyFilters();
			}
			
			if (_cacheStyle.staticCache) _cacheStyle.reCache = false;
			Stat.canvasReCache++;
			
			context.drawCanvas(canvas, x + left, y + top, tRec.width, tRec.height);
		}
	}
}