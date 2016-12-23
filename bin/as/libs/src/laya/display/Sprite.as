package laya.display {
	import laya.display.css.CSSStyle;
	import laya.display.css.Style;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.filters.ColorFilter;
	import laya.filters.Filter;
	import laya.maths.GrahamScan;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	import laya.utils.Dragging;
	import laya.utils.HTMLChar;
	import laya.utils.Handler;
	import laya.utils.Pool;
	import laya.utils.RunDriver;
	import laya.utils.Stat;
	import laya.utils.Utils;
	
	/**在显示对象上按下后调度。
	 * @eventType Event.MOUSE_DOWN
	 * */
	[Event(name = "mousedown", type = "laya.events.Event")]
	/**在显示对象抬起后调度。
	 * @eventType Event.MOUSE_UP
	 * */
	[Event(name = "mouseup", type = "laya.events.Event")]
	/**鼠标在对象身上进行移动后调度
	 * @eventType Event.MOUSE_MOVE
	 * */
	[Event(name = "mousemove", type = "laya.events.Event")]
	/**鼠标经过对象后调度。
	 * @eventType Event.MOUSE_OVER
	 * */
	[Event(name = "mouseover", type = "laya.events.Event")]
	/**鼠标离开对象后调度。
	 * @eventType Event.MOUSE_OUT
	 * */
	[Event(name = "mouseout", type = "laya.events.Event")]
	/**鼠标点击对象后调度。
	 * @eventType Event.CLICK
	 * */
	[Event(name = "click", type = "laya.events.Event")]
	/**开始拖动后调度。
	 * @eventType Event.DRAG_START
	 * */
	[Event(name = "dragstart", type = "laya.events.Event")]
	/**拖动中调度。
	 * @eventType Event.DRAG_MOVE
	 * */
	[Event(name = "dragmove", type = "laya.events.Event")]
	/**拖动结束后调度。
	 * @eventType Event.DRAG_END
	 * */
	[Event(name = "dragend", type = "laya.events.Event")]
	
	/**
	 * <p> <code>Sprite</code> 类是基本显示列表构造块：一个可显示图形并且也可包含子项的显示列表节点。</p>
	 *
	 * @example 以下示例代码，创建了一个 <code>Text</code> 实例。
	 * <listing version="3.0">
	 * package
	 * {
	 * 	import laya.display.Sprite;
	 * 	import laya.events.Event;
	 *
	 * 	public class Sprite_Example
	 * 	{
	 * 		private var sprite:Sprite;
	 * 		private var shape:Sprite
	 * 		public function Sprite_Example()
	 * 		{
	 * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 * 			onInit();
	 * 		}
	 * 		private function onInit():void
	 * 		{
	 * 			sprite = new Sprite();//创建一个 Sprite 类的实例对象 sprite 。
	 * 			sprite.loadImage("resource/ui/bg.png");//加载并显示图片。
	 * 			sprite.x = 200;//设置 sprite 对象相对于父容器的水平方向坐标值。
	 * 			sprite.y = 200;//设置 sprite 对象相对于父容器的垂直方向坐标值。
	 * 			sprite.pivotX = 0;//设置 sprite 对象的水平方法轴心点坐标。
	 * 			sprite.pivotY = 0;//设置 sprite 对象的垂直方法轴心点坐标。
	 * 			Laya.stage.addChild(sprite);//将此 sprite 对象添加到显示列表。
	 * 			sprite.on(Event.CLICK, this, onClickSprite);//给 sprite 对象添加点击事件侦听。
	
	 * 			shape = new Sprite();//创建一个 Sprite 类的实例对象 sprite 。
	 * 			shape.graphics.drawRect(0, 0, 100, 100, "#ccff00", "#ff0000", 2);//绘制一个有边框的填充矩形。
	 * 			shape.x = 400;//设置 shape 对象相对于父容器的水平方向坐标值。
	 * 			shape.y = 200;//设置 shape 对象相对于父容器的垂直方向坐标值。
	 * 			shape.width = 100;//设置 shape 对象的宽度。
	 * 			shape.height = 100;//设置 shape 对象的高度。
	 * 			shape.pivotX = 50;//设置 shape 对象的水平方法轴心点坐标。
	 * 			shape.pivotY = 50;//设置 shape 对象的垂直方法轴心点坐标。
	 * 			Laya.stage.addChild(shape);//将此 shape 对象添加到显示列表。
	 * 			shape.on(Event.CLICK, this, onClickShape);//给 shape 对象添加点击事件侦听。
	 * 		}
	 * 		private function onClickSprite():void
	 * 		{
	 * 			trace("点击 sprite 对象。");
	 * 			sprite.rotation += 5;//旋转 sprite 对象。
	 * 		}
	 * 		private function onClickShape():void
	 * 		{
	 * 			trace("点击 shape 对象。");
	 * 			shape.rotation += 5;//旋转 shape 对象。
	 * 		}
	 * 	}
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * var sprite;
	 * var shape;
	 * Sprite_Example();
	 * function Sprite_Example()
	 * {
	 *     Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *     Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *     onInit();
	 * }
	 * function onInit()
	 * {
	 *     sprite = new laya.display.Sprite();//创建一个 Sprite 类的实例对象 sprite 。
	 *     sprite.loadImage("resource/ui/bg.png");//加载并显示图片。
	 *     sprite.x = 200;//设置 sprite 对象相对于父容器的水平方向坐标值。
	 *     sprite.y = 200;//设置 sprite 对象相对于父容器的垂直方向坐标值。
	 *     sprite.pivotX = 0;//设置 sprite 对象的水平方法轴心点坐标。
	 *     sprite.pivotY = 0;//设置 sprite 对象的垂直方法轴心点坐标。
	 *     Laya.stage.addChild(sprite);//将此 sprite 对象添加到显示列表。
	 *     sprite.on(Event.CLICK, this, onClickSprite);//给 sprite 对象添加点击事件侦听。
	
	 *     shape = new laya.display.Sprite();//创建一个 Sprite 类的实例对象 sprite 。
	 *     shape.graphics.drawRect(0, 0, 100, 100, "#ccff00", "#ff0000", 2);//绘制一个有边框的填充矩形。
	 *     shape.x = 400;//设置 shape 对象相对于父容器的水平方向坐标值。
	 *     shape.y = 200;//设置 shape 对象相对于父容器的垂直方向坐标值。
	 *     shape.width = 100;//设置 shape 对象的宽度。
	 *     shape.height = 100;//设置 shape 对象的高度。
	 *     shape.pivotX = 50;//设置 shape 对象的水平方法轴心点坐标。
	 *     shape.pivotY = 50;//设置 shape 对象的垂直方法轴心点坐标。
	 *     Laya.stage.addChild(shape);//将此 shape 对象添加到显示列表。
	 *     shape.on(laya.events.Event.CLICK, this, onClickShape);//给 shape 对象添加点击事件侦听。
	 * }
	 * function onClickSprite()
	 * {
	 *     console.log("点击 sprite 对象。");
	 *     sprite.rotation += 5;//旋转 sprite 对象。
	 * }
	 * function onClickShape()
	 * {
	 *     console.log("点击 shape 对象。");
	 *     shape.rotation += 5;//旋转 shape 对象。
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * import Sprite = laya.display.Sprite;
	 * class Sprite_Example {
	 *     private sprite: Sprite;
	 *     private shape: Sprite
	 *     public Sprite_Example() {
	 *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         this.onInit();
	 *     }
	 *     private onInit(): void {
	 *         this.sprite = new Sprite();//创建一个 Sprite 类的实例对象 sprite 。
	 *         this.sprite.loadImage("resource/ui/bg.png");//加载并显示图片。
	 *         this.sprite.x = 200;//设置 sprite 对象相对于父容器的水平方向坐标值。
	 *         this.sprite.y = 200;//设置 sprite 对象相对于父容器的垂直方向坐标值。
	 *         this.sprite.pivotX = 0;//设置 sprite 对象的水平方法轴心点坐标。
	 *         this.sprite.pivotY = 0;//设置 sprite 对象的垂直方法轴心点坐标。
	 *         Laya.stage.addChild(this.sprite);//将此 sprite 对象添加到显示列表。
	 *         this.sprite.on(laya.events.Event.CLICK, this, this.onClickSprite);//给 sprite 对象添加点击事件侦听。
	
	 *         this.shape = new Sprite();//创建一个 Sprite 类的实例对象 sprite 。
	 *         this.shape.graphics.drawRect(0, 0, 100, 100, "#ccff00", "#ff0000", 2);//绘制一个有边框的填充矩形。
	 *         this.shape.x = 400;//设置 shape 对象相对于父容器的水平方向坐标值。
	 *         this.shape.y = 200;//设置 shape 对象相对于父容器的垂直方向坐标值。
	 *         this.shape.width = 100;//设置 shape 对象的宽度。
	 *         this.shape.height = 100;//设置 shape 对象的高度。
	 *         this.shape.pivotX = 50;//设置 shape 对象的水平方法轴心点坐标。
	 *         this.shape.pivotY = 50;//设置 shape 对象的垂直方法轴心点坐标。
	 *         Laya.stage.addChild(this.shape);//将此 shape 对象添加到显示列表。
	 *         this.shape.on(laya.events.Event.CLICK, this, this.onClickShape);//给 shape 对象添加点击事件侦听。
	 *     }
	 *     private onClickSprite(): void {
	 *         console.log("点击 sprite 对象。");
	 *         this.sprite.rotation += 5;//旋转 sprite 对象。
	 *     }
	 *     private onClickShape(): void {
	 *         console.log("点击 shape 对象。");
	 *         this.shape.rotation += 5;//旋转 shape 对象。
	 *     }
	 * }
	 * </listing>
	 */
	public class Sprite extends Node implements ILayout {
		/** @private */
		protected static const CHG_VIEW:int = 0x10;
		protected static const CHG_SCALE:int = 0x100;
		protected static const CHG_TEXTURE:int = 0x1000;
		/** @private */
		public static var CustomList:Array = [];
		/**指定当mouseEnabled=true时，是否可穿透。默认值为false，如果设置为true，则点击空白区域可以穿透过去。*/
		public var mouseThrough:Boolean = false;
		/** @private 矩阵变换信息。*/
		protected var _transform:Matrix;
		/** @private */
		protected var _tfChanged:Boolean;
		/** @private */
		protected var _x:Number = 0;
		/** @private */
		protected var _y:Number = 0;
		/** @private */
		public var _width:Number = 0;
		/** @private */
		public var _height:Number = 0;
		/** @private */
		protected var _repaint:int = 1;
		/** @private */
		protected var _changeType:int = 0;
		
		/** @private 鼠标状态，0:auto,1:mouseEnabled=false,2:mouseEnabled=true。*/
		protected var _mouseEnableState:int = 0;
		/** @private Z排序，数值越大越靠前。*/
		public var _zOrder:Number = 0;
		
		//以下变量为系统调用，请不要直接使用
		/** @private */
		public var _style:Style = Style.EMPTY;
		/** @private */
		public var _graphics:Graphics;
		/** @private */
		public var _renderType:int = 0;
		/**
		 * 指定是否自动计算宽高数据。默认值为 false 。
		 * 自动计算计算量较大，对性能有一定影响。
		 * 在手动设置宽高属性之后该属性不起作用。
		 */
		public var autoSize:Boolean = false;
		/**
		 * 指定鼠标碰撞检测是否优先检测自己。默认为false
		 * 鼠标碰撞检测是优先检测子对象，然后冒泡到父对象，如果hitTestPrior=true
		 * 鼠标碰撞优先检测本对象，本对象被击中后，才进一步检测子对象。
		 * 对于已知大小的容器（特别是根容器），设置此值为true，能减少节点碰撞，提高性能。默认为false
		 */
		public var hitTestPrior:Boolean = false;
		/**视口大小，视口外的东西，将不被渲染*/
		public var viewport:Rectangle = null;
		/** @private */
		private var _optimizeScrollRect:Boolean = false;
		/**@private */
		private var _texture:Texture = null;
		
		override public function createConchModel():* 
		{
			return __JS__("new ConchNode()");
		}
		
		public function get optimizeScrollRect():Boolean {
			return _optimizeScrollRect;
		}
		
		/**
		 * <p>指定是否对使用了 scrollRect 的显示对象进行优化处理。</p>
		 * <p>默认为false(不优化)。</p>
		 * <p>当值为ture时：将对此对象使用了scrollRect 设定的显示区域以外的显示内容不进行渲染，以提高性能。</p>
		 */
		public function set optimizeScrollRect(b:Boolean):void {
			if (_optimizeScrollRect != b) {
				_optimizeScrollRect = b;
				conchModel && conchModel.optimizeScrollRect(b);
			}
		}
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			this._style && this._style.destroy();
			this._transform = null;
			this._style = null;
			this._graphics = null;
		}
		
		/**根据zOrder进行重新排序。*/
		public function updateZOrder():void {
			Utils.updateOrder(_childs) && repaint();
		}
		
		/**
		 * 指定显示对象是否缓存为静态图像。功能同cacheAs的normal模式。
		 */
		public function get cacheAsBitmap():Boolean {
			return cacheAs !== "none";
		}
		
		public function set cacheAsBitmap(value:Boolean):void {
			cacheAs = value ? (_$P["hasFilter"] ? "none" : "normal") : "none";
		}
		
		/**
		 * 开启自定义渲染，只有开启自定义渲染，才能使用customRender函数渲染
		 */
		public function set customRenderEnable(b:Boolean):void {
			if (b) {
				_renderType |= RenderSprite.CUSTOM;
				if (Render.isConchNode) {
					Sprite.CustomList.push(this);
					var canvas:HTMLCanvas = new HTMLCanvas("2d");
					canvas._setContext(__JS__("new CanvasRenderingContext2D()"));
					__JS__("this.customContext = new RenderContext(0, 0, canvas)");
					canvas.context.setCanvasType && canvas.context.setCanvasType(2);
					conchModel.custom(canvas.context);
				}
			}
		}
		
		/**
		 * <p>指定显示对象是否缓存为静态图像，cacheAs时，子对象发生变化，会自动重新缓存，同时也可以手动调用reCache方法更新缓存。</p>
		 * 建议把不经常变化的复杂内容缓存为静态图像，能极大提高渲染性能，有"none"，"normal"和"bitmap"三个值可选。
		 * <li>默认为"none"，不做任何缓存。</li>
		 * <li>当值为"normal"时，canvas下进行画布缓存，webgl模式下进行命令缓存。</li>
		 * <li>当值为"bitmap"时，canvas下进行依然是画布缓存，webgl模式下使用renderTarget缓存。</li>
		 * webgl下renderTarget缓存模式有最大2048大小限制，会额外增加内存开销，不断重绘时开销比较大，但是会减少drawcall，渲染性能最高。
		 * webgl下命令缓存模式只会减少节点遍历及命令组织，不会减少drawcall，性能中等。
		 */
		public function get cacheAs():String {
			return _$P.cacheCanvas == null ? "none" : _$P.cacheCanvas.type;
		}
		
		public function set cacheAs(value:String):void {
			var cacheCanvas:* = _$P.cacheCanvas;
			if (value === (cacheCanvas ? cacheCanvas.type : "none")) return;
			if (value !== "none") {
				cacheCanvas || (cacheCanvas = _set$P("cacheCanvas", Pool.getItemByClass("cacheCanvas", Object)));
				cacheCanvas.type = value;
				cacheCanvas.reCache = true;
				_renderType |= RenderSprite.CANVAS;
				if (value == "bitmap") conchModel && conchModel.cacheAs(1);
				_set$P("cacheForFilters", false);
			} else {
				if (_$P["hasFilter"]) {
					_set$P("cacheForFilters", true);
				} else {
					if (cacheCanvas) Pool.recover("cacheCanvas", cacheCanvas);
					_$P.cacheCanvas = null;
					_renderType &= ~RenderSprite.CANVAS;
					conchModel && conchModel.cacheAs(0);
				}
				
			}
			repaint();
		}
		
		/**设置cacheAs为非空时此值才有效，staticCache=true时，子对象变化时不会自动更新缓存，只能通过调用reCache方法手动刷新。*/
		public function get staticCache():Boolean {
			return _$P.staticCache;
		}
		
		public function set staticCache(value:Boolean):void {
			_set$P("staticCache", value);
			if (!value && _$P.cacheCanvas) {
				_$P.cacheCanvas.reCache = true;
			}
		}
		
		/**在设置cacheAs或staticCache=true的情况下，调用此方法会重新刷新缓存。*/
		public function reCache():void {
			if (_$P.cacheCanvas) _$P.cacheCanvas.reCache = true;
		}
		
		/**表示显示对象相对于父容器的水平方向坐标值。*/
		public function get x():Number {
			return this._x;
		}
		
		public function set x(value:Number):void {
			if (this._x !== value) {
				if (this.destroyed) return;
				this._x = value;
				conchModel && conchModel.pos(value, this._y);
				var p:Sprite = _parent as Sprite;
				p && p._repaint === 0 && (p._repaint = 1, p.parentRepaint());
				this._$P.maskParent && _$P.maskParent._repaint === 0 && (_$P.maskParent._repaint = 1, _$P.maskParent.parentRepaint());
			}
		}
		
		/**表示显示对象相对于父容器的垂直方向坐标值。*/
		public function get y():Number {
			return this._y;
		}
		
		public function set y(value:Number):void {
			if (this._y !== value) {
				if (this.destroyed) return;
				this._y = value;
				conchModel && conchModel.pos(this._x, value);
				var p:Sprite = _parent as Sprite;
				p && p._repaint === 0 && (p._repaint = 1, p.parentRepaint());
				this._$P.maskParent && _$P.maskParent._repaint === 0 && (_$P.maskParent._repaint = 1, _$P.maskParent.parentRepaint());
			}
		}
		
		/**
		 * 表示显示对象的宽度，以像素为单位。
		 */
		public function get width():Number {
			if (!autoSize) return this._width;
			return getSelfBounds().width;
		}
		
		public function set width(value:Number):void {
			this._width !== value && (this._width = value, conchModel && conchModel.size(value, this._height), repaint());
		}
		
		/**
		 * 表示显示对象的高度，以像素为单位。
		 */
		public function get height():Number {
			if (!autoSize) return this._height;
			return getSelfBounds().height;
		}
		
		public function set height(value:Number):void {
			this._height !== value && (this._height = value, conchModel && conchModel.size(this._width, value), repaint());
		}
		
		/**
		 * 设置bounds大小，如果有设置，则不再通过getBounds计算
		 * @param	bound bounds矩形区域
		 */
		public function setBounds(bound:Rectangle):void {
			_set$P("uBounds", bound);
		}
		
		/**
		 * 获取本对象在父容器坐标系的矩形显示区域。
		 * <p><b>注意：</b>计算量较大，尽量少用。</p>
		 * @return 矩形区域。
		 */
		public function getBounds():Rectangle {
			if (!_$P.mBounds) _set$P("mBounds", new Rectangle());
			return Rectangle._getWrapRec(_boundPointsToParent(), _$P.mBounds);
		}
		
		/**
		 * 获取本对象在自己坐标系的矩形显示区域。
		 * <p><b>注意：</b>计算量较大，尽量少用。</p>
		 * @return 矩形区域。
		 */
		public function getSelfBounds():Rectangle {
			if (!_$P.mBounds) _set$P("mBounds", new Rectangle());
			return Rectangle._getWrapRec(_getBoundPointsM(false), _$P.mBounds);
		/*
		   if (this.autoSize) return Rectangle._getWrapRec(_getBoundPointsM(false), Rectangle.TEMP);
		   Rectangle.TEMP.x = Rectangle.TEMP.y = 0;
		   Rectangle.TEMP.width = _width;
		   Rectangle.TEMP.height = _height;
		   return Rectangle.TEMP;*/
		}
		
		/**
		 * @private
		 * 获取本对象在父容器坐标系的显示区域多边形顶点列表。
		 * 当显示对象链中有旋转时，返回多边形顶点列表，无旋转时返回矩形的四个顶点。
		 * @param ifRotate 之前的对象链中是否有旋转。
		 * @return 顶点列表。结构：[x1,y1,x2,y2,x3,y3,...]。
		 */
		public function _boundPointsToParent(ifRotate:Boolean = false):Array {
			var pX:Number = 0, pY:Number = 0;
			if (_style) {
				pX = _style._tf.translateX;
				pY = _style._tf.translateY;
				ifRotate = ifRotate || (_style._tf.rotate !== 0);
				if (_style.scrollRect) {
					pX += _style.scrollRect.x;
					pY += _style.scrollRect.y;
				}
			}
			var pList:Array = _getBoundPointsM(ifRotate);
			if (!pList || pList.length < 1) return pList;
			
			if (pList.length != 8) {
				//				trace("beforeLen:"+pList.length);
				pList = ifRotate ? GrahamScan.scanPList(pList) : Rectangle._getWrapRec(pList, Rectangle.TEMP)._getBoundPoints();
					//				pList = true ? GrahamScan.scanPList(pList) : Rectangle.getWrapRec(pList,Rectangle.temp).getBoundPoints();
					//				trace("afterLen:"+pList.length);
			}
			
			if (!transform) {
				Utils.transPointList(pList, this.x - pX, this.y - pY);
				return pList;
			}
			var tPoint:Point = Point.TEMP;
			var i:int, len:int = pList.length;
			for (i = 0; i < len; i += 2) {
				tPoint.x = pList[i];
				tPoint.y = pList[i + 1];
				toParentPoint(tPoint);
				pList[i] = tPoint.x;
				pList[i + 1] = tPoint.y;
			}
			return pList;
		}
		
		/**
		 * 返回此实例中的绘图对象（ <code>Graphics</code> ）的显示区域。
		 * @return 一个 Rectangle 对象，表示获取到的显示区域。
		 */
		public function getGraphicBounds():Rectangle {
			if (!this._graphics) return Rectangle.TEMP.setTo(0, 0, 0, 0);
			return this._graphics.getBounds();
		}
		
		/**
		 * @private
		 * 获取自己坐标系的显示区域多边形顶点列表
		 * @param ifRotate 当前的显示对象链是否由旋转
		 * @return 顶点列表。结构：[x1,y1,x2,y2,x3,y3,...]。
		 */
		public function _getBoundPointsM(ifRotate:Boolean = false):Array {
			if (_$P.uBounds) return _$P.uBounds._getBoundPoints();
			if (!_$P.temBM) _set$P("temBM", []);
			if (this.scrollRect) {
				var rst:Array = Utils.clearArray(_$P.temBM);
				var rec:Rectangle = Rectangle.TEMP;
				rec.copyFrom(this.scrollRect);
				Utils.concatArray(rst, rec._getBoundPoints());
				return rst;
			}
			var pList:Array = this._graphics ? this._graphics.getBoundPoints() : Utils.clearArray(_$P.temBM);
			//处理子对象区域
			var child:Sprite;
			var cList:Array;
			var __childs:Array;
			__childs = _childs;
			for (var i:int = 0, n:int = __childs.length; i < n; i++) {
				//child = getChildAt(i) as Sprite; 
				child = __childs[i] as Sprite;
				if (child is Sprite && child.visible == true) {
					cList = child._boundPointsToParent(ifRotate);
					if (cList)
						pList = pList ? Utils.concatArray(pList, cList) : cList;
				}
			}
			return pList;
		}
		
		/**
		 * @private
		 * 获取样式。
		 * @return  样式 Style 。
		 */
		public function getStyle():Style {
			this._style === Style.EMPTY && (this._style = new Style());
			return this._style;
		}
		
		/**
		 * @private
		 * 设置样式。
		 * @param	value 样式。
		 */
		public function setStyle(value:Style):void {
			this._style = value;
		}
		
		/**X轴缩放值，默认值为1。*/
		public function get scaleX():Number {
			return this._style._tf.scaleX;
		}
		
		public function set scaleX(value:Number):void {
			var style:Style = getStyle();
			if (style._tf.scaleX !== value) {
				style.setScaleX(value);
				_changeType |= CHG_VIEW;
				_tfChanged = true;
				conchModel && conchModel.scale(value, style._tf.scaleY);
				_renderType |= RenderSprite.TRANSFORM;
				var p:Sprite = _parent as Sprite;
				p && p._repaint === 0 && (p._repaint = 1, p.parentRepaint());
			}
		}
		
		/**Y轴缩放值，默认值为1。*/
		public function get scaleY():Number {
			return this._style._tf.scaleY;
		}
		
		public function set scaleY(value:Number):void {
			var style:Style = getStyle();
			if (style._tf.scaleY !== value) {
				style.setScaleY(value);
				_changeType |= CHG_VIEW;
				_tfChanged = true;
				conchModel && conchModel.scale(style._tf.scaleX, value);
				_renderType |= RenderSprite.TRANSFORM;
				var p:Sprite = _parent as Sprite;
				p && p._repaint === 0 && (p._repaint = 1, p.parentRepaint());
			}
		}
		
		/**旋转角度，默认值为0。*/
		public function get rotation():Number {
			return this._style._tf.rotate;
		}
		
		public function set rotation(value:Number):void {
			var style:Style = getStyle();
			if (style._tf.rotate !== value) {
				_changeType |= CHG_VIEW;
				style.setRotate(value);
				_tfChanged = true;
				conchModel && conchModel.rotate(value);
				_renderType |= RenderSprite.TRANSFORM;
				var p:Sprite = _parent as Sprite;
				p && p._repaint === 0 && (p._repaint = 1, p.parentRepaint());
			}
		}
		
		/**水平倾斜角度，默认值为0。*/
		public function get skewX():Number {
			return this._style._tf.skewX;
		}
		
		public function set skewX(value:Number):void {
			var style:Style = getStyle();
			if (style._tf.skewX !== value) {
				style.setSkewX(value);
				_tfChanged = true;
				_renderType |= RenderSprite.TRANSFORM;
				var p:Sprite = _parent as Sprite;
				p && p._repaint === 0 && (p._repaint = 1, p.parentRepaint());
			}
		}
		
		/**垂直倾斜角度，默认值为0。*/
		public function get skewY():Number {
			return this._style._tf.skewY;
		}
		
		public function set skewY(value:Number):void {
			var style:Style = getStyle();
			if (style._tf.skewY !== value) {
				style.setSkewY(value);
				_tfChanged = true;
				conchModel && conchModel.skew(style._tf.skewX, value);
				_renderType |= RenderSprite.TRANSFORM;
				var p:Sprite = _parent as Sprite;
				p && p._repaint === 0 && (p._repaint = 1, p.parentRepaint());
			}
		}
		
		/** @private */
		private function _adjustTransform():Matrix {
			'use strict';
			_tfChanged = false;
			var style:Style = this._style;
			var tf:Object = style._tf;
			var sx:Number = tf.scaleX, sy:Number = tf.scaleY;
			var m:Matrix;
			if (tf.rotate || sx !== 1 || sy !== 1 || tf.skewX || tf.skewY) {
				m = this._transform || (this._transform = Matrix.create());
				m.bTransform = true;
				if (tf.rotate) {
					var angle:Number = tf.rotate * 0.0174532922222222;//laya.CONST.PI180;
					var cos:Number = m.cos = Math.cos(angle);
					var sin:Number = m.sin = Math.sin(angle);
					
					m.a = sx * cos;
					m.b = sx * sin;
					m.c = -sy * sin;
					m.d = sy * cos;
					m.tx = m.ty = 0;
					return m;
				} else {
					m.a = sx;
					m.d = sy;
					m.c = m.b = m.tx = m.ty = 0;
					if (tf.skewX || tf.skewY) {
						return m.skew(tf.skewX * 0.0174532922222222, tf.skewY * 0.0174532922222222);
					}
					return m;
				}
			} else {
				this._transform && this._transform.destroy();
				this._transform = null;
				_renderType &= ~RenderSprite.TRANSFORM;
			}
			return m;
		}
		
		/**
		 * 对象的矩阵信息。
		 */
		public function get transform():Matrix {
			return _tfChanged ? _adjustTransform() : _transform;
		}
		
		public function set transform(value:Matrix):void {
			this._tfChanged = false;
			this._transform = value;
			//设置transform时重置x,y
			if (value) {
				_x = value.tx;
				_y = value.ty;
				value.tx = value.ty = 0;
				conchModel && conchModel.transform(value.a, value.b, value.c, value.d, _x, _y);
			}
			if (value) _renderType |= RenderSprite.TRANSFORM;
			else {
				_renderType &= ~RenderSprite.TRANSFORM;
				conchModel && conchModel.removeType(RenderSprite.TRANSFORM);
			}
			parentRepaint();
		}
		
		/**X轴 轴心点的位置，单位为像素，默认为0，轴心点会影响对象位置，缩放，旋转。*/
		public function get pivotX():Number {
			return this._style._tf.translateX;
		}
		
		public function set pivotX(value:Number):void {
			getStyle().setTranslateX(value);
			_changeType |= CHG_VIEW;
			conchModel && conchModel.pivot(value, this._style._tf.translateY);
			repaint();
		}
		
		/**Y轴 轴心点的位置，单位为像素，默认为0，轴心点会影响对象位置，缩放，旋转。*/
		public function get pivotY():Number {
			return this._style._tf.translateY;
		}
		
		public function set pivotY(value:Number):void {
			getStyle().setTranslateY(value);
			_changeType |= CHG_VIEW;
			conchModel && conchModel.pivot(this._style._tf.translateX, value);
			repaint();
		}
		
		/**透明度，值为0-1，默认值为1，表示不透明。*/
		public function get alpha():Number {
			return this._style.alpha;
		}
		
		public function set alpha(value:Number):void {
			if (_style && _style.alpha !== value) {
				value = value < 0 ? 0 : (value > 1 ? 1 : value);
				getStyle().alpha = value;
				conchModel && conchModel.alpha(value);
				if (value !== 1) _renderType |= RenderSprite.ALPHA;
				else _renderType &= ~RenderSprite.ALPHA;
				parentRepaint();
			}
		}
		
		/**表示是否可见，默认为true。*/
		public function get visible():Boolean {
			return this._style.visible;
		}
		
		public function set visible(value:Boolean):void {
			if (_style && _style.visible !== value) {
				getStyle().visible = value;
				conchModel && conchModel.visible(value);
				parentRepaint();
			}
		}
		
		/**指定要使用的混合模式。*/
		public function get blendMode():String {
			return this._style.blendMode;
		}
		
		public function set blendMode(value:String):void {
			getStyle().blendMode = value;
			conchModel && conchModel.blendMode(value);
			if (value && value != "source-over") _renderType |= RenderSprite.BLEND;
			else _renderType &= ~RenderSprite.BLEND;
			parentRepaint();
		}
		
		/**绘图对象。*/
		public function get graphics():Graphics {
			return this._graphics || (this.graphics = RunDriver.createGraphics());
		}
		
		public function set graphics(value:Graphics):void {
			if (this._graphics) this._graphics._sp = null;
			this._graphics = value;
			if (value) {
				_renderType &= ~RenderSprite.IMAGE;
				_renderType |= RenderSprite.GRAPHICS;
				value._sp = this;
				conchModel && conchModel.graphics(this._graphics);
					//if (value.empty()) _renderType &= ~RenderSprite.IMAGE;
			} else {
				_renderType &= ~RenderSprite.GRAPHICS;
				_renderType &= ~RenderSprite.IMAGE;
				conchModel && conchModel.removeType(RenderSprite.GRAPHICS);
			}
			repaint();
		}
		
		/**显示对象的滚动矩形范围。*/
		public function get scrollRect():Rectangle {
			return this._style.scrollRect;
		}
		
		public function set scrollRect(value:Rectangle):void {
			getStyle().scrollRect = value;
			viewport = value;
			repaint();
			if (value) {
				_renderType |= RenderSprite.CLIP;
				conchModel && conchModel.scrollRect(value.x, value.y, value.width, value.height);
			} else {
				_renderType &= ~RenderSprite.CLIP;
				conchModel && conchModel.removeType(RenderSprite.CLIP);
			}
		}
		
		/**
		 * 设置坐标位置。
		 * @param	x X 轴坐标。
		 * @param	y Y 轴坐标。
		 * @return	返回对象本身。
		 */
		public function pos(x:Number, y:Number):Sprite {
			if (_x !== x || _y !== y) {
				this.x = x;
				this.y = y;
			}
			return this;
		}
		
		/**
		 * 设置轴心点。
		 * @param	x X轴心点。
		 * @param	y Y轴心点。
		 * @return	返回对象本身。
		 */
		public function pivot(x:Number, y:Number):Sprite {
			this.pivotX = x;
			this.pivotY = y;
			return this;
		}
		
		/**
		 * 设置宽高。
		 * @param	width 宽度。
		 * @param	hegiht 高度。
		 * @return	返回对象本身。
		 */
		public function size(width:Number, height:Number):Sprite {
			this.width = width;
			this.height = height;
			return this;
		}
		
		/**
		 * 设置缩放。
		 * @param	scaleX X轴缩放比例。
		 * @param	scaleY Y轴缩放比例。
		 * @return	返回对象本身。
		 */
		public function scale(scaleX:Number, scaleY:Number):Sprite {
			this.scaleX = scaleX;
			this.scaleY = scaleY;
			return this;
		}
		
		/**
		 * 设置倾斜角度。
		 * @param	skewX 水平倾斜角度。
		 * @param	skewY 垂直倾斜角度。
		 * @return	返回对象本身
		 */
		public function skew(skewX:Number, skewY:Number):Sprite {
			this.skewX = skewX;
			this.skewY = skewY;
			return this;
		}
		
		/**
		 * 更新、呈现显示对象。
		 * @param	context 渲染的上下文引用。
		 * @param	x X轴坐标。
		 * @param	y Y轴坐标。
		 */
		public function render(context:RenderContext, x:Number, y:Number):void {
			Stat.spriteCount++;
			RenderSprite.renders[_renderType]._fun(this, context, x + _x, y + _y);
			_repaint = 0;
		}
		
		/**
		 * 绘制 <code>Sprite</code> 到 <code>canvas</code> 上。
		 * @param	canvasWidth 画布宽度。
		 * @param	canvasHeight 画布高度。
		 * @param	x 绘制的 X 轴偏移量。
		 * @param	y 绘制的 Y 轴偏移量。
		 * @return  HTMLCanvas 对象。
		 */
		public function drawToCanvas(canvasWidth:Number, canvasHeight:Number, offsetX:Number, offsetY:Number):HTMLCanvas {
			//var canvas:HTMLCanvas = new HTMLCanvas("2D");
			//var context:RenderContext = new RenderContext(canvasWidth, canvasHeight, canvas);
			//RenderSprite.renders[_renderType]._fun(this, context, offsetX, offsetY);
			//return canvas;
			return RunDriver.drawToCanvas(this, _renderType, canvasWidth, canvasHeight, offsetX, offsetY);//暂时这么做
		}
		
		/**
		 * 自定义更新、呈现显示对象。
		 * <p><b>注意</b>不要在此函数内增加或删除树节点，否则会树节点遍历照成影响。</p>
		 * @param	context  渲染的上下文引用。
		 * @param	x X轴坐标。
		 * @param	y Y轴坐标。
		 */
		public function customRender(context:RenderContext, x:Number, y:Number):void {
			_renderType |= RenderSprite.CUSTOM;
		}
		
		/**
		 * @private
		 * 应用滤镜。
		 */
		public function _applyFilters():void {
			if (Render.isWebGL) return;
			var _filters:Array;
			_filters = _$P.filters;
			if (!_filters || _filters.length < 1) return;
			for (var i:int = 0, n:int = _filters.length; i < n; i++) {
				_filters[i].action.apply(_$P.cacheCanvas);
			}
		}
		
		/**滤镜集合。*/
		public function get filters():Array {
			return _$P.filters;
		}
		
		public function set filters(value:Array):void {
			value && value.length === 0 && (value = null);
			if (_$P.filters == value) return;
			_set$P("filters", value ? value.slice() : null);
			if (Render.isConchApp) {
				conchModel && conchModel.removeType(0x10);
				if (_$P.filters && _$P.filters.length == 1 /*&& (_$P.filters[0] is ColorFilter)*/) {
					_$P.filters[0].callNative(this);
				}
			}
			
			if (Render.isWebGL) {
				if (value && value.length) {
					_renderType |= RenderSprite.FILTERS;
				} else {
					_renderType &= ~RenderSprite.FILTERS;
				}
			}
			
			if (value && value.length > 0) {
				if (!(Render.isWebGL && value.length == 1 && (value[0] is ColorFilter))) {
					if (cacheAs != "bitmap") {
						if (!Render.isConchNode) cacheAs = "bitmap";
						_set$P("cacheForFilters", true);
					}
					_set$P("hasFilter", true);
				}
			} else {
				_set$P("hasFilter", false);
				if (_$P["cacheForFilters"] && cacheAs == "bitmap") {
					cacheAs = "none";
				}
			}
			repaint();
		}
		
		/**
		 * @private
		 * 查看当前原件中是否包含发光滤镜。
		 * @return 一个 Boolean 值，表示当前原件中是否包含发光滤镜。
		 */
		public function _isHaveGlowFilter():Boolean {
			var i:int, len:int;
			if (filters) {
				for (i = 0; i < filters.length; i++) {
					if (filters[i].type == Filter.GLOW) {
						return true;
					}
				}
			}
			for (i = 0, len = _childs.length; i < len; i++) {
				if (_childs[i]._isHaveGlowFilter()) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 本地坐标转全局坐标。
		 * @param	point 本地坐标点。
		 * @param	createNewPoint 用于存储转换后的坐标的点。
		 * @return  转换后的坐标的点。
		 */
		public function localToGlobal(point:Point, createNewPoint:Boolean = false):Point {
			if (!_displayedInStage || !point) return point;
			if (createNewPoint === true) {
				point = new Point(point.x, point.y);
			}
			var ele:Sprite = this;
			while (ele) {
				if (ele == Laya.stage) break;
				point = ele.toParentPoint(point);
				ele = ele.parent as Sprite;
			}
			
			return point;
		}
		
		/**
		 * 全局坐标转本地坐标。
		 * @param	point 全局坐标点。
		 * @param	createNewPoint 用于存储转换后的坐标的点。
		 * @return 转换后的坐标的点。
		 */
		public function globalToLocal(point:Point, createNewPoint:Boolean = false):Point {
			if (!_displayedInStage || !point) return point;
			if (createNewPoint === true) {
				point = new Point(point.x, point.y);
			}
			var ele:Sprite = this;
			var list:Array = [];
			while (ele) {
				if (ele == Laya.stage) break;
				list.push(ele);
				ele = ele.parent as Sprite;
			}
			var i:int = list.length - 1;
			while (i >= 0) {
				ele = list[i];
				point = ele.fromParentPoint(point);
				i--;
			}
			return point;
		}
		
		/**
		 * 将本地坐标系坐标转换到父容器坐标系。
		 * @param point 本地坐标点。
		 * @return  转换后的点。
		 */
		public function toParentPoint(point:Point):Point {
			if (!point) return point;
			point.x -= pivotX;
			point.y -= pivotY;
			
			if (transform) {
				_transform.transformPoint(point);
			}
			point.x += _x;
			point.y += _y;
			var scroll:Rectangle = this._style.scrollRect;
			if (scroll) {
				point.x -= scroll.x;
				point.y -= scroll.y;
			}
			return point;
		}
		
		/**
		 * 将父容器坐标系坐标转换到本地坐标系。
		 * @param point 父容器坐标点。
		 * @return  转换后的点。
		 */
		public function fromParentPoint(point:Point):Point {
			if (!point) return point;
			point.x -= _x;
			point.y -= _y;
			var scroll:Rectangle = this._style.scrollRect;
			if (scroll) {
				point.x += scroll.x;
				point.y += scroll.y;
			}
			if (transform) {
				//_transform.setTranslate(0,0);
				_transform.invertTransformPoint(point);
			}
			point.x += pivotX;
			point.y += pivotY;
			return point;
		}
		
		/**
		 * 使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知。
		 * 如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnable 的值为 true。
		 * @param	type 事件的类型。
		 * @param	caller 事件侦听函数的执行域。
		 * @param	listener 事件侦听函数。
		 * @param	args 事件侦听函数的回调参数。
		 * @return 此 EventDispatcher 对象。
		 */
		override public function on(type:String, caller:*, listener:Function, args:Array = null):EventDispatcher {
			//如果是鼠标事件，则设置自己和父对象为可接受鼠标交互事件
			if (_mouseEnableState !== 1 && isMouseEvent(type)) {
				if (_displayedInStage) _onDisplay();
				else super.once(Event.DISPLAY, this, _onDisplay);
			}
			return super.on(type, caller, listener, args);
		}
		
		/**
		 * 使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知，此侦听事件响应一次后自动移除。
		 * 如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。
		 * @param	type 事件的类型。
		 * @param	caller 事件侦听函数的执行域。
		 * @param	listener 事件侦听函数。
		 * @param	args 事件侦听函数的回调参数。
		 * @return 此 EventDispatcher 对象。
		 */
		override public function once(type:String, caller:*, listener:Function, args:Array = null):EventDispatcher {
			//如果是鼠标事件，则设置自己和父对象为可接受鼠标交互事件
			if (_mouseEnableState !== 1 && isMouseEvent(type)) {
				if (_displayedInStage) _onDisplay();
				else super.once(Event.DISPLAY, this, _onDisplay);
			}
			return super.once(type, caller, listener, args);
		}
		
		/** @private */
		private function _onDisplay():void {
			if (_mouseEnableState !== 1) {
				var ele:* = this;
				while (ele && ele._mouseEnableState !== 1) {
					ele.mouseEnabled = true;
					ele = ele.parent as Sprite;
				}
			}
		}
		
		/**
		 * 加载并显示一个图片。功能等同于Graphics.loadImage
		 * @param	url	图片地址。
		 * @param	x 显示图片的x位置
		 * @param	y 显示图片的y位置
		 * @param	width 显示图片的宽度，设置为0表示使用图片默认宽度
		 * @param	height 显示图片的高度，设置为0表示使用图片默认高度
		 * @param	complete 加载完成回调
		 * @return	返回精灵对象本身
		 */
		public function loadImage(url:String, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, complete:Handler = null):Sprite {
			function loaded(tex:Texture):void {
				if (!destroyed) {
					size(x + (width || tex.width), y + (height || tex.height));
					repaint();
					complete && complete.runWith(tex);
				}
			}
			graphics.loadImage(url, x, y, width, height, loaded);
			return this;
		}
		
		/**
		 * 根据图片地址创建一个新的 <code>Sprite</code> 对象用于加载并显示此图片。
		 * @param	url 图片地址。
		 * @return	返回新的 <code>Sprite</code> 对象。
		 */
		public static function fromImage(url:String):Sprite {
			return new Sprite().loadImage(url);
		}
		
		/**cacheAs后，设置自己和父对象缓存失效。*/
		public function repaint():void {
			this.conchModel&&this.conchModel.repaint&&this.conchModel.repaint();
			(_repaint === 0) && (_repaint = 1, parentRepaint());
			if (this._$P && this._$P.maskParent) {
				_$P.maskParent.repaint();
			}
		}
		
		/**
		 * @private
		 * 获取是否重新缓存。
		 * @return 如果重新缓存值为 true，否则值为 false。
		 */
		public function _needRepaint():Boolean {
			return (_repaint !== 0) && _$P.cacheCanvas && _$P.cacheCanvas.reCache;
		}
		
		/**@inheritDoc	*/
		override protected function _childChanged(child:Node = null):void {
			if (_childs.length) _renderType |= RenderSprite.CHILDS;
			else _renderType &= ~RenderSprite.CHILDS;
			
			if (child && Sprite(child).zOrder) Laya.timer.callLater(this, updateZOrder);
			repaint();
		}
		
		/**cacheAs时，设置所有父对象缓存失效。 */
		public function parentRepaint():void {
			var p:Sprite = _parent as Sprite;
			p && p._repaint === 0 && (p._repaint = 1, p.parentRepaint());
		}
		
		/** 对舞台 <code>stage</code> 的引用。*/
		public function get stage():Stage {
			return Laya.stage;
		}
		
		/** 手动设置的可点击区域，或者一个HitArea区域。*/
		public function get hitArea():* {
			return _$P.hitArea;
		}
		
		public function set hitArea(value:*):void {
			_set$P("hitArea", value);
		}
		
		/**遮罩，可以设置一个对象或者图片，根据对象形状进行遮罩显示。
		 *【注意】遮罩对象坐标系是相对遮罩对象本身的，这个和flash机制不同*/
		public function get mask():Sprite {
			return this._$P._mask;
		}
		
		public function set mask(value:Sprite):void {
			if (value && mask && mask._$P.maskParent) return;
			if (value) {
				cacheAs = "bitmap";
				_set$P("_mask", value);
				value._set$P("maskParent", this);
			} else {
				cacheAs = "none";
				mask && mask._set$P("maskParent", null);
				_set$P("_mask", value);
			}
			conchModel && conchModel.mask(value ? value.conchModel : null);
			_renderType |= RenderSprite.MASK;
			parentRepaint();
		}
		
		/**
		 * 是否接受鼠标事件。
		 * 默认为false，如果监听鼠标事件，则会自动设置本对象及父节点的属性 mouseEnable 的值都为 true（如果父节点手动设置为false，则不会更改）。
		 * */
		public function get mouseEnabled():Boolean {
			return _mouseEnableState > 1;
		}
		
		public function set mouseEnabled(value:Boolean):void {
			_mouseEnableState = value ? 2 : 1;
		}
		
		/**
		 * 开始拖动此对象。
		 * @param	area 拖动区域，此区域为当前对象注册点活动区域（不包括对象宽高），可选。
		 * @param	hasInertia 鼠标松开后，是否还惯性滑动，默认为false，可选。
		 * @param	elasticDistance 橡皮筋效果的距离值，0为无橡皮筋效果，默认为0，可选。
		 * @param	elasticBackTime 橡皮筋回弹时间，单位为毫秒，默认为300毫秒，可选。
		 * @param	data 拖动事件携带的数据，可选。
		 * @param	disableMouseEvent 禁用其他对象的鼠标检测，默认为false，设置为true能提高性能
		 * @param	ratio 惯性阻尼系数
		 */
		public function startDrag(area:Rectangle = null, hasInertia:Boolean = false, elasticDistance:Number = 0, elasticBackTime:int = 300, data:* = null, disableMouseEvent:Boolean = false,ratio:Number=0.92):void {
			_$P.dragging || (_set$P("dragging", new Dragging()));
			_$P.dragging.start(this, area, hasInertia, elasticDistance, elasticBackTime, data, disableMouseEvent, ratio);
		}
		
		/**停止拖动此对象。*/
		public function stopDrag():void {
			_$P.dragging && _$P.dragging.stop();
		}
		
		/**@private */
		override public function _setDisplay(value:Boolean):void {
			//如果从显示列表移除，则销毁cache缓存
			if (!value && _$P.cacheCanvas && _$P.cacheCanvas.ctx) {
				Pool.recover("RenderContext", _$P.cacheCanvas.ctx);
				_$P.cacheCanvas.ctx = null;
			}
			if (!value) {
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
		 * 检测某个点是否在此对象内。
		 * @param	x 全局x坐标。
		 * @param	y 全局y坐标。
		 * @return  表示是否在对象内。
		 */
		public function hitTestPoint(x:Number, y:Number):Boolean {
			var point:Point = globalToLocal(Point.TEMP.setTo(x, y));
			var rect:Rectangle = _$P.hitArea ? _$P.hitArea : Rectangle.TEMP.setTo(0, 0, _width, _height);
			return rect.contains(point.x, point.y);
		}
		
		/**获得相对于本对象上的鼠标坐标信息。*/
		public function getMousePoint():Point {
			return this.globalToLocal(Point.TEMP.setTo(Laya.stage.mouseX, Laya.stage.mouseY));
		}
		
		/**
		 * 获得全局X轴缩放值
		 */
		public function get globalScaleX():Number {
			var scale:Number = 1;
			var ele:Sprite = this;
			while (ele) {
				if (ele === Laya.stage) break;
				scale *= ele.scaleX;
				ele = ele.parent as Sprite;
			}
			return scale;
		}
		
		/**
		 * 获得全局Y轴缩放值
		 */
		public function get globalScaleY():Number {
			var scale:Number = 1;
			var ele:Sprite = this;
			while (ele) {
				if (ele === Laya.stage) break;
				scale *= ele.scaleX;
				ele = ele.parent as Sprite;
			}
			return scale;
		}
		
		/**
		 * 表示鼠标在此对象上的 X 轴坐标信息。
		 */
		public function get mouseX():Number {
			return getMousePoint().x;
		}
		
		/**
		 * 表示鼠标在此对象上的 Y 轴坐标信息。
		 */
		public function get mouseY():Number {
			return getMousePoint().y;
		}
		
		/** z排序，更改此值，按照值的大小进行显示层级排序。*/
		public function get zOrder():Number {
			return _zOrder;
		}
		
		public function set zOrder(value:Number):void {
			if (_zOrder != value) {
				_zOrder = value;
			    conchModel && conchModel.setZOrder && conchModel.setZOrder(value);
				_parent && Laya.timer.callLater(_parent, updateZOrder);
			}
		}
		
		/**@private 清理graphics，只显示此texture图片，等同于graphics.clear();graphics.drawTexture()*/
		public function get texture():Texture {
			return _texture;
		}
		
		public function set texture(value:Texture):void {
			if (_texture != value) {
				_texture = value;
				graphics.cleanByTexture(value,0,0);
			}
		}
		
		/**@private */
		public function _getWords():Vector.<HTMLChar> {
			return null;
		}
		
		/**@private */
		public function _addChildsToLayout(out:Vector.<ILayout>):Boolean {
			var words:Vector.<HTMLChar> = _getWords();
			if (words == null && _childs.length == 0) return false;
			if (words) {
				for (var i:int = 0, n:int = words.length; i < n; i++) {
					out.push(words[i]);
				}
			}
			_childs.forEach(function(o:Sprite, index:int, array:Array):void {
				o._style._enableLayout() && o._addToLayout(out);
			});
			return true;
		}
		
		/**@private */
		public function _addToLayout(out:Vector.<ILayout>):void {
			if (_style.absolute) return;
			_style.block ? out.push(this) : (_addChildsToLayout(out) && (x = y = 0));
		}
		
		/**@private */
		public function _isChar():Boolean {
			return false;
		}
		
		/**@private */
		public function _getCSSStyle():CSSStyle {
			return _style.getCSSStyle();
		}
		
		/**
		 * @private
		 * 设置指定属性名的属性值。
		 * @param	name 属性名。
		 * @param	value 属性值。
		 */
		public function _setAttributes(name:String, value:String):void {
			switch (name) {
			case 'x': 
				x = parseFloat(value);
				break;
			case 'y': 
				y = parseFloat(value);
				break;
			case 'width': 
				width = parseFloat(value);
				break;
			case 'height': 
				height = parseFloat(value);
				break;
			default: 
				/*[IF-FLASH]*/
				if (this.hasOwnProperty(name))
					this[name] = value;
			}
		}
		
		/**
		 * @private
		 */
		public function _layoutLater():void {
			parent && (parent as Sprite)._layoutLater();
		}
	}
}