package laya.display.css {
	import laya.display.Sprite;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.utils.Browser;
	import laya.utils.Pool;
	
	/**
	 * @private
	 * 存储cache相关
	 */
	public class CacheStyle {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static const EMPTY:CacheStyle =/*[STATIC SAFE]*/ new CacheStyle();
		/**当前实际的cache状态*/
		public var cacheAs:String;
		/**是否开启canvas渲染*/
		public var enableCanvasRender:Boolean;
		/**用户设的cacheAs类型*/
		public var userSetCache:String;
		/**是否需要为滤镜cache*/
		public var cacheForFilters:Boolean;
		/**是否为静态缓存*/
		public var staticCache:Boolean;
		/**是否需要刷新缓存*/
		public var reCache:Boolean;
		/**mask对象*/
		public var mask:Sprite;
		/**作为mask时的父对象*/
		public var maskParent:Sprite;
		/**滤镜数据*/
		public var filters:Array;
		/**当前缓存区域*/
		public var cacheRect:Rectangle;
		/**当前使用的canvas*/
		public var canvas:HTMLCanvas;
		//TODO:webgl是否还需要
		/**滤镜数据*/
		public var filterCache:*;
		//TODO:webgl是否还需要
		/**是否有发光滤镜*/
		public var hasGlowFilter:Boolean;
		
		public function CacheStyle() {
			reset();
		}
		
		/**
		 * 是否需要Bitmap缓存
		 * @return
		 */
		public function needBitmapCache():Boolean {
			return cacheForFilters || !!mask;
		}
		
		/**
		 * 是否需要开启canvas渲染
		 */
		public function needEnableCanvasRender():Boolean {
			return userSetCache != "none" || cacheForFilters || !!mask;
		}
		
		/**
		 * 释放cache的资源
		 */
		public function releaseContext():void {
			if (canvas && (canvas as Object).size) {
				Pool.recover("CacheCanvas", canvas);
				canvas.size(0, 0);
			}
			canvas = null;
		}
		
		public function createContext():void {
			if (!canvas)
			{
				canvas = Pool.getItem("CacheCanvas") || new HTMLCanvas(!Render.isWebGL);
				var tx:Context = canvas.context;
				if (!tx)
				{
					tx=canvas.getContext('2d');	//如果是webGL的话，这个会返回WebGLContext2D
				}			
			}
		}
		/**
		 * 释放滤镜资源
		 */
		public function releaseFilterCache():void {
			var fc:* = filterCache;
			if (fc) {
				fc.destroy();
				fc.recycle();
				filterCache = null;
			}
		}
		
		/**
		 * 回收
		 */
		public function recover():void {
			if (this === EMPTY) return;
			Pool.recover("SpriteCache", reset());
		}
		
		/**
		 * 重置
		 */
		public function reset():CacheStyle {
			releaseContext();
			releaseFilterCache();
			cacheAs = "none";
			enableCanvasRender = false;
			userSetCache = "none";
			cacheForFilters = false;
			staticCache = false;
			reCache = true;
			mask = null;
			maskParent = null;
			filterCache = null;
			filters = null;
			hasGlowFilter = false;
			if(cacheRect) cacheRect.recover();
			cacheRect = null;
			return this
		}
		
		/**
		 * 创建一个SpriteCache
		 */
		public static function create():CacheStyle {
			return Pool.getItemByClass("SpriteCache", CacheStyle);
		}
		
		private static var _scaleInfo:Point = new Point();
		public static const CANVAS_EXTEND_EDGE:int = 16;
		public function _calculateCacheRect(sprite:Sprite, tCacheType:String,x:Number,y:Number):Point
		{
			var bWebGL:Boolean = false;
			if ( Render.isWebGL )
			{
				bWebGL = true;
			}
			var _cacheStyle:CacheStyle = sprite._cacheStyle;
			if (!_cacheStyle.cacheRect)
				_cacheStyle.cacheRect = Rectangle.create();
			var tRec:Rectangle;
			
			//计算显示对象的绘图区域
			if (!bWebGL || tCacheType === "bitmap") {
				tRec = sprite.getSelfBounds();				
				tRec.width = tRec.width + CANVAS_EXTEND_EDGE*2;
				tRec.height = tRec.height + CANVAS_EXTEND_EDGE*2;
				tRec.x = tRec.x-sprite.pivotX;
				tRec.y = tRec.y-sprite.pivotY;
				tRec.x = tRec.x - CANVAS_EXTEND_EDGE;
				tRec.y = tRec.y - CANVAS_EXTEND_EDGE;
				tRec.x = Math.floor(tRec.x + x) - x;
				tRec.y = Math.floor(tRec.y + y) - y;
				tRec.width = Math.floor(tRec.width);
				tRec.height = Math.floor(tRec.height);
				_cacheStyle.cacheRect.copyFrom(tRec);
			} else {
				_cacheStyle.cacheRect.setTo(-sprite._style.pivotX, -sprite._style.pivotY, 1, 1);
			}
			tRec = _cacheStyle.cacheRect;
			
			
			//计算显示对象的全局缩放,解决模糊问题
			var scaleX:Number = bWebGL ? 1 : Browser.pixelRatio * Laya.stage.clientScaleX;
			var scaleY:Number = bWebGL ? 1 : Browser.pixelRatio * Laya.stage.clientScaleY;
			
			if (!bWebGL) {
				var chainScaleX:Number = 1;
				var chainScaleY:Number = 1;
				var tar:Sprite;
				tar = sprite;
				while (tar && tar != Laya.stage) {
					chainScaleX *= tar.scaleX;
					chainScaleY *= tar.scaleY;
					tar = tar.parent as Sprite;
				}
				if (chainScaleX > 1) scaleX *= chainScaleX;
				if (chainScaleY > 1) scaleY *= chainScaleY;
			}
			//处理显示对象的scrollRect偏移
			if (sprite._style.scrollRect) {
				var scrollRect:Rectangle = sprite._style.scrollRect;
				tRec.x -= scrollRect.x;
				tRec.y -= scrollRect.y;
			}
			_scaleInfo.setTo(scaleX, scaleY);
			
			return _scaleInfo;
		}
	}
}