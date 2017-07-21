package laya.map {
	import laya.display.Sprite;
	import laya.renders.Render;
	import laya.utils.Browser;
	
	/**
	 * 地图的每层都会分块渲染处理
	 * 本类就是地图的块数据
	 * @author ...
	 */
	public class GridSprite extends Sprite {
		
		/**相对于地图X轴的坐标*/
		public var relativeX:Number = 0;
		/**相对于地图Y轴的坐标*/
		public var relativeY:Number = 0;
		/**是否用于对象层的独立物件*/
		public var isAloneObject:Boolean = false;
		/**当前GRID中是否有动画*/
		public var isHaveAnimation:Boolean = false;
		/**当前GRID包含的动画*/
		public var aniSpriteArray:Array;
		/**当前GRID包含多少个TILE(包含动画)*/
		public var drawImageNum:int = 0;
		
		private var _map:TiledMap = null;//当前地图对象的引用
		
		/**
		 * 传入必要的参数，用于裁剪，跟确认此对象类型
		 * @param	map	把地图的引用传进来，参与一些裁剪计算
		 * @param	objectKey true:表示当前GridSprite是个活动对象，可以控制，false:地图层的组成块
		 */
		public function initData(map:TiledMap, objectKey:Boolean = false):void {
			_map = map;
			isAloneObject = objectKey;
		}
		
		/**@private */
		override public function _setDisplay(value:Boolean):void {
			if (!value) {
				var cc:* = _$P.cacheCanvas;
				//如果从显示列表移除，则销毁cache缓存
				if (cc && cc.ctx) {
					cc.ctx.canvas.destroy();
					//cc.ctx.canvas.clear();
					cc.ctx = null;
				}
				var fc:* = _$P._filterCache;
				//fc && (fc.destroy(), fc.recycle(), this._set$P('_filterCache', null));
				if (fc) {
					fc.destroy();
					fc.recycle();
					this._set$P('_filterCache', null);
				}
				_$P._isHaveGlowFilter && this._set$P('_isHaveGlowFilter', false);
			}
			super._setDisplay(value);
		}
		
		/**
		 * 把一个动画对象绑定到当前GridSprite
		 * @param	sprite 动画的显示对象
		 */
		public function addAniSprite(sprite:TileAniSprite):void {
			if (aniSpriteArray == null) {
				aniSpriteArray = [];
			}
			aniSpriteArray.push(sprite);
		}
		
		/**
		 * 显示当前GridSprite，并把上面的动画全部显示
		 */
		public function show():void {
			if (!this.visible) {
				this.visible = true;
				if (!isAloneObject)
				{
					var tParent:MapLayer;
					tParent = parent as MapLayer;
					if (tParent)
					{
						tParent.showGridSprite(this);
					}
				}
				if (!Render.isWebGL&&_map.autoCache)
				{
					this.cacheAs = _map.autoCacheType;
				}
				if (aniSpriteArray == null) {
					return;
				}
				var tAniSprite:TileAniSprite;
				for (var i:int = 0; i < aniSpriteArray.length; i++) {
					tAniSprite = aniSpriteArray[i];
					tAniSprite.show();
				}
			}
		}
		
		/**
		 * 隐藏当前GridSprite，并把上面绑定的动画全部移除
		 */
		public function hide():void {
			if (this.visible) {
				this.visible = false;
				if (!isAloneObject)
				{
					var tParent:MapLayer;
					tParent = parent as MapLayer;
					if (tParent)
					{
						tParent.hideGridSprite(this);
					}
				}
				if (!Render.isWebGL&&_map.autoCache)
				{
					this.cacheAs = "none";
				}
				if (aniSpriteArray == null) {
					return;
				}
				var tAniSprite:TileAniSprite;
				for (var i:int = 0; i < aniSpriteArray.length; i++) {
					tAniSprite = aniSpriteArray[i];
					tAniSprite.hide();
				}
			}
		}
		
		/**
		 * 刷新坐标，当我们自己控制一个GridSprite移动时，需要调用此函数，手动刷新
		 */
		public function updatePos():void {
			if (isAloneObject) {
				if (_map) {
					this.x = this.relativeX;
					this.y = this.relativeY;
				}
				if (this.x < 0 || this.x > _map.viewPortWidth || this.y < 0 || this.y > _map.viewPortHeight) {
					hide();
				} else {
					show();
				}
			} else {
				if (_map) {
					this.x = this.relativeX;
					this.y = this.relativeY;
				}
			}
		}
		
		/**
		 * 重置当前对象的所有属性
		 */
		public function clearAll():void {
			if (_map) {
				_map = null;
			}
			this.visible = false;
			if (aniSpriteArray == null) {
				return;
			}
			var tAniSprite:TileAniSprite;
			for (var i:int = 0; i < aniSpriteArray.length; i++) {
				tAniSprite = aniSpriteArray[i];
				tAniSprite.clearAll();
			}
			this.destroy();
			relativeX = 0;
			relativeY = 0;
			isHaveAnimation = false;
			aniSpriteArray = null;
			drawImageNum = 0;
		}
	
	}

}