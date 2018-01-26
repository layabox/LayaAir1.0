package laya.display {
	import laya.display.css.CSSStyle;
	import laya.display.css.Style;
	import laya.display.css.TransformInfo;
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
	 * <p> <code>Sprite</code> 是基本的显示图形的显示列表节点。 <code>Sprite</code> 默认没有宽高，默认不接受鼠标事件。通过 <code>graphics</code> 可以绘制图片或者矢量图，支持旋转，缩放，位移等操作。<code>Sprite</code>同时也是容器类，可用来添加多个子节点。</p>
	 * <p>注意： <code>Sprite</code> 默认没有宽高，可以通过<code>getBounds</code>函数获取；也可手动设置宽高；还可以设置<code>autoSize=true</code>，然后再获取宽高。<code>Sprite</code>的宽高一般用于进行碰撞检测和排版，并不影响显示图像大小，如果需要更改显示图像大小，请使用 <code>scaleX</code> ， <code>scaleY</code> ， <code>scale</code>。</p>
	 * <p> <code>Sprite</code> 默认不接受鼠标事件，即<code>mouseEnabled=false</code>，但是只要对其监听任意鼠标事件，会自动打开自己以及所有父对象的<code>mouseEnabled=true</code>。所以一般也无需手动设置<code>mouseEnabled</code>。</p>
	 * <p>LayaAir引擎API设计精简巧妙。核心显示类只有一个<code>Sprite</code>。<code>Sprite</code>针对不同的情况做了渲染优化，所以保证一个类实现丰富功能的同时，又达到高性能。</p>
	 *
	 * @example <caption>创建了一个 <code>Sprite</code> 实例。</caption>
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
	 *
	 * @example
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
	 *
	 * @example
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
	 */
	public class Sprite extends Node implements ILayout {
		/** @private */
		private static var CustomList:Array = [];
		/**@private 矩阵变换信息。*/
		protected var _transform:Matrix;
		/**@private */
		protected var _tfChanged:Boolean;
		/**@private */
		protected var _x:Number = 0;
		/**@private */
		protected var _y:Number = 0;
		/**@private */
		public var _width:Number = 0;
		/**@private */
		public var _height:Number = 0;
		/**@private */
		protected var _repaint:int = 1;
		/**@private 鼠标状态，0:auto,1:mouseEnabled=false,2:mouseEnabled=true。*/
		protected var _mouseEnableState:int = 0;
		/**@private Z排序，数值越大越靠前。*/
		public var _zOrder:Number = 0;
		//以下变量为系统调用，请不要直接使用
		/**@private */
		public var _style:Style = Style.EMPTY;
		/**@private */
		public var _graphics:Graphics;
		/**@private */
		public var _renderType:int = 0;
		/**@private */
		private var _optimizeScrollRect:Boolean = false;
		/**@private */
		private var _texture:Texture = null;
		
		//优化child渲染复杂度，暂时这样
		//public var _childRenderMax:Boolean = false;
		/**
		 * <p>鼠标事件与此对象的碰撞检测是否可穿透。碰撞检测发生在鼠标事件的捕获阶段，此阶段引擎会从stage开始递归检测stage及其子对象，直到找到命中的目标对象或者未命中任何对象。</p>
		 * <p>穿透表示鼠标事件发生的位置处于本对象绘图区域内时，才算命中，而与对象宽高和值为Rectangle对象的hitArea属性无关。如果sprite.hitArea值是HitArea对象，表示显式声明了此对象的鼠标事件响应区域，而忽略对象的宽高、mouseThrough属性。</p>
		 * <p>影响对象鼠标事件响应区域的属性为：width、height、hitArea，优先级顺序为：hitArea(type:HitArea)>hitArea(type:Rectangle)>width/height。</p>
		 * @default false	不可穿透，此对象的鼠标响应区域由width、height、hitArea属性决定。</p>
		 */
		public var mouseThrough:Boolean = false;
		/**
		 * <p>指定是否自动计算宽高数据。默认值为 false 。</p>
		 * <p>Sprite宽高默认为0，并且不会随着绘制内容的变化而变化，如果想根据绘制内容获取宽高，可以设置本属性为true，或者通过getBounds方法获取。设置为true，对性能有一定影响。</p>
		 */
		public var autoSize:Boolean = false;
		/**
		 * <p>指定鼠标事件检测是优先检测自身，还是优先检测其子对象。鼠标事件检测发生在鼠标事件的捕获阶段，此阶段引擎会从stage开始递归检测stage及其子对象，直到找到命中的目标对象或者未命中任何对象。</p>
		 * <p>如果为false，优先检测子对象，当有子对象被命中时，中断检测，获得命中目标。如果未命中任何子对象，最后再检测此对象；如果为true，则优先检测本对象，如果本对象没有被命中，直接中断检测，表示没有命中目标；如果本对象被命中，则进一步递归检测其子对象，以确认最终的命中目标。</p>
		 * <p>合理使用本属性，能减少鼠标事件检测的节点，提高性能。可以设置为true的情况：开发者并不关心此节点的子节点的鼠标事件检测结果，也就是以此节点作为其子节点的鼠标事件检测依据。</p>
		 * <p>Stage对象和UI的View组件默认为true。</p>
		 * @default false	优先检测此对象的子对象，当递归检测完所有子对象后，仍然没有找到目标对象，最后再检测此对象。
		 */
		public var hitTestPrior:Boolean = false;
		/**
		 * <p>视口大小，视口外的子对象，将不被渲染(如果想实现裁剪效果，请使用srollRect)，合理使用能提高渲染性能。比如由一个个小图片拼成的地图块，viewport外面的小图片将不渲染</p>
		 * <p>srollRect和viewport的区别：<br/>
		 * 1. srollRect自带裁剪效果，viewport只影响子对象渲染是否渲染，不具有裁剪效果（性能更高）。<br/>
		 * 2. 设置rect的x,y属性均能实现区域滚动效果，但scrollRect会保持0,0点位置不变。</p>
		 * @default null
		 */
		public var viewport:Rectangle = null;
		
		/**@private */
		private static var RUNTIMEVERION:String = __JS__("window.conch?conchConfig.getRuntimeVersion().substr(conchConfig.getRuntimeVersion().lastIndexOf('-')+1):''");
		
		/**@private */
		override public function createConchModel():* {
			return __JS__("new ConchNode()");
		}
		
		/**
		 * <p>指定是否对使用了 scrollRect 的显示对象进行优化处理。默认为false(不优化)。</p>
		 * <p>当值为ture时：将对此对象使用了scrollRect 设定的显示区域以外的显示内容不进行渲染，以提高性能(如果子对象有旋转缩放或者中心点偏移，则显示筛选会不精确)。</p>
		 */
		public function get optimizeScrollRect():Boolean {
			return _optimizeScrollRect;
		}
		
		public function set optimizeScrollRect(b:Boolean):void {
			if (_optimizeScrollRect != b) {
				_optimizeScrollRect = b;
				conchModel && conchModel.optimizeScrollRect(b);
			}
		}
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			_releaseMem();
			super.destroy(destroyChild);
			this._style && this._style.destroy();
			this._transform && this._transform.destroy();
			this._transform = null;
			this._style = null;
			this._graphics = null;
		}
		
		/**根据zOrder进行重新排序。*/
		public function updateZOrder():void {
			Utils.updateOrder(_childs) && repaint();
		}
		
		/**
		 * 指定显示对象是否缓存为静态图像。功能同cacheAs的normal模式。建议优先使用cacheAs代替。
		 */
		public function get cacheAsBitmap():Boolean {
			return cacheAs !== "none";
		}
		
		public function set cacheAsBitmap(value:Boolean):void {
			//TODO:去掉关联
			cacheAs = value ? (_$P["hasFilter"] ? "none" : "normal") : "none";
		}
		
		/**
		 * 设置是否开启自定义渲染，只有开启自定义渲染，才能使用customRender函数渲染。
		 */
		public function set customRenderEnable(b:Boolean):void {
			if (b) {
				_renderType |= RenderSprite.CUSTOM;
				if (Render.isConchNode) {
					CustomList.push(this);
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
		 * <p>建议把不经常变化的“复杂内容”缓存为静态图像，能极大提高渲染性能。cacheAs有"none"，"normal"和"bitmap"三个值可选。
		 * <li>默认为"none"，不做任何缓存。</li>
		 * <li>当值为"normal"时，canvas模式下进行画布缓存，webgl模式下进行命令缓存。</li>
		 * <li>当值为"bitmap"时，canvas模式下进行依然是画布缓存，webgl模式下使用renderTarget缓存。</li></p>
		 * <p>webgl下renderTarget缓存模式缺点：会额外创建renderTarget对象，增加内存开销，缓存面积有最大2048限制，不断重绘时会增加CPU开销。优点：大幅减少drawcall，渲染性能最高。
		 * webgl下命令缓存模式缺点：只会减少节点遍历及命令组织，不会减少drawcall数，性能中等。优点：没有额外内存开销，无需renderTarget支持。</p>
		 */
		public function get cacheAs():String {
			return _$P.cacheCanvas == null ? "none" : _$P.cacheCanvas.type;
		}
		
		public function set cacheAs(value:String):void {
			var cacheCanvas:* = _$P.cacheCanvas;
			if (value === (cacheCanvas ? cacheCanvas.type : "none")) return;
			if (value !== "none") {
				if (!_getBit(Node.NOTICE_DISPLAY)) _setUpNoticeType(Node.NOTICE_DISPLAY);
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
					if (cacheCanvas)
					{
						var cc:* = cacheCanvas;
						//如果从显示列表移除，则销毁cache缓存
						if (cc && cc.ctx) {
							Pool.recover("RenderContext", cc.ctx);
							cc.ctx.canvas.size(0, 0);
							//cc.ctx.canvas.clear();
							cc.ctx = null;
							
						}
						Pool.recover("cacheCanvas", cacheCanvas);
					} 
					_$P.cacheCanvas = null;
					_renderType &= ~RenderSprite.CANVAS;
					conchModel && conchModel.cacheAs(0);
				}
				
			}
			repaint();
		}
		
		/**
		 * 是否静态缓存此对象的当前帧的最终属性。为 true 时，子对象变化时不会自动更新缓存，但是可以通过调用 reCache 方法手动刷新。
		 * <b>注意：</b> 1. 设置 cacheAs 为非空和非"none"时才有效。 2. 由于渲染的时机在脚本执行之后，也就是说当前帧渲染的是对象的最终属性，所以如果在当前帧渲染之前、设置静态缓存之后改变对象属性，则最终渲染结果表现的是对象的最终属性。
		 */
		public function get staticCache():Boolean {
			return _$P.staticCache;
		}
		
		public function set staticCache(value:Boolean):void {
			_set$P("staticCache", value);
			if (!value) reCache();
		}
		
		/**在设置cacheAs的情况下，调用此方法会重新刷新缓存。*/
		public function reCache():void {
			if (_$P.cacheCanvas) _$P.cacheCanvas.reCache = true;
			_repaint = 1;
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
				if (p && p._repaint === 0) {
					p._repaint = 1;
					p.parentRepaint();
				}
				if (this._$P.maskParent && _$P.maskParent._repaint === 0) {
					_$P.maskParent._repaint = 1;
					_$P.maskParent.parentRepaint();
				}
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
				if (p && p._repaint === 0) {
					p._repaint = 1;
					p.parentRepaint();
				}
				if (this._$P.maskParent && _$P.maskParent._repaint === 0) {
					_$P.maskParent._repaint = 1;
					_$P.maskParent.parentRepaint();
				}
			}
		}
		
		/**
		 * <p>显示对象的宽度，单位为像素，默认为0。</p>
		 * <p>此宽度用于鼠标碰撞检测，并不影响显示对象图像大小。需要对显示对象的图像进行缩放，请使用scale、scaleX、scaleY。</p>
		 * <p>可以通过getbounds获取显示对象图像的实际宽度。</p>
		 */
		public function get width():Number {
			if (!autoSize) return this._width;
			return getSelfBounds().width;
		}
		
		public function set width(value:Number):void {
			if (this._width !== value) {
				this._width = value;
				conchModel && conchModel.size(value, this._height)
				repaint();
			}
		}
		
		/**
		 * <p>显示对象的高度，单位为像素，默认为0。</p>
		 * <p>此高度用于鼠标碰撞检测，并不影响显示对象图像大小。需要对显示对象的图像进行缩放，请使用scale、scaleX、scaleY。</p>
		 * <p>可以通过getbounds获取显示对象图像的实际高度。</p>
		 */
		public function get height():Number {
			if (!autoSize) return this._height;
			return getSelfBounds().height;
		}
		
		public function set height(value:Number):void {
			if (this._height !== value) {
				this._height = value;
				conchModel && conchModel.size(this._width, value);
				repaint();
			}
		}
		
		/**
		 * <p>设置对象在自身坐标系下的边界范围。与 <code>getSelfBounds</code> 对应。当 autoSize==true 时，会影响对象宽高。设置后，当需要获取自身边界范围时，就不再需要计算，合理使用能提高性能。比如 <code>getBounds</code> 会优先使用 <code>setBounds</code> 指定的值，如果没有指定则进行计算，此计算会对性能消耗比较大。</p>
		 * <p><b>注意：</b> <code>setBounds</code> 与 <code>getBounds</code> 并非对应相等关系， <code>getBounds</code> 获取的是本对象在父容器坐标系下的边界范围，通过设置 <code>setBounds</code> 会影响 <code>getBounds</code> 的结果。</p>
		 * @param	bound bounds矩形区域
		 */
		public function setBounds(bound:Rectangle):void {
			_set$P("uBounds", bound);
		}
		
		/**
		 * <p>获取本对象在父容器坐标系的矩形显示区域。</p>
		 * <p><b>注意：</b> 1.计算量较大，尽量少用，如果需要频繁使用，可以通过手动设置 <code>setBounds</code> 来缓存自身边界信息，从而避免比较消耗性能的计算。2. <code>setBounds</code> 与 <code>getBounds</code> 并非对应相等关系， <code>getBounds</code> 获取的是本对象在父容器坐标系下的边界范围，通过设置 <code>setBounds</code> 会影响 <code>getBounds</code> 的结果。</p>
		 * @return 矩形区域。
		 */
		public function getBounds():Rectangle {
			if (!_$P.mBounds) _set$P("mBounds", new Rectangle());
			return Rectangle._getWrapRec(_boundPointsToParent(), _$P.mBounds);
		}
		
		/**
		 * 获取对象在自身坐标系的边界范围。与 <code>setBounds</code> 对应。
		 * <p><b>注意：</b>计算量较大，尽量少用，如果需要频繁使用，可以提前手动设置 <code>setBounds</code> 来缓存自身边界信息，从而避免比较消耗性能的计算。</p>
		 * @return 矩形区域。
		 */
		public function getSelfBounds():Rectangle {
			if (_$P.uBounds) return _$P.uBounds;
			if (!_$P.mBounds) _set$P("mBounds", new Rectangle());
			return Rectangle._getWrapRec(_getBoundPointsM(false), _$P.mBounds);
		}
		
		/**
		 * @private
		 * 获取本对象在父容器坐标系的显示区域多边形顶点列表。
		 * 当显示对象链中有旋转时，返回多边形顶点列表，无旋转时返回矩形的四个顶点。
		 * @param ifRotate	（可选）之前的对象链中是否有旋转。
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
				pList = ifRotate ? GrahamScan.scanPList(pList) : Rectangle._getWrapRec(pList, Rectangle.TEMP)._getBoundPoints();
			}
			
			if (!transform) {
				Utils.transPointList(pList, this._x - pX, this._y - pY);
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
		 * 返回此实例中的绘图对象（ <code>Graphics</code> ）的显示区域，不包括子对象。
		 * @param realSize	（可选）使用图片的真实大小，默认为false
		 * @return 一个 Rectangle 对象，表示获取到的显示区域。
		 */
		public function getGraphicBounds(realSize:Boolean = false):Rectangle {
			if (!this._graphics) return Rectangle.TEMP.setTo(0, 0, 0, 0);
			return this._graphics.getBounds(realSize);
		}
		
		/**
		 * @private
		 * 获取自己坐标系的显示区域多边形顶点列表
		 * @param ifRotate	（可选）当前的显示对象链是否由旋转
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
		
		/**X轴缩放值，默认值为1。设置为负数，可以实现水平反转效果，比如scaleX=-1。*/
		public function get scaleX():Number {
			return this._style._tf.scaleX;
		}
		
		public function set scaleX(value:Number):void {
			var style:Style = getStyle();
			if (style._tf.scaleX !== value) {
				style.setScaleX(value);
				_tfChanged = true;
				conchModel && conchModel.scale(value, style._tf.scaleY);
				_renderType |= RenderSprite.TRANSFORM;
				var p:Sprite = _parent as Sprite;
				if (p && p._repaint === 0) {
					p._repaint = 1;
					p.parentRepaint();
				}
			}
		}
		
		/**Y轴缩放值，默认值为1。设置为负数，可以实现垂直反转效果，比如scaleX=-1。*/
		public function get scaleY():Number {
			return this._style._tf.scaleY;
		}
		
		public function set scaleY(value:Number):void {
			var style:Style = getStyle();
			if (style._tf.scaleY !== value) {
				style.setScaleY(value);
				_tfChanged = true;
				conchModel && conchModel.scale(style._tf.scaleX, value);
				_renderType |= RenderSprite.TRANSFORM;
				var p:Sprite = _parent as Sprite;
				if (p && p._repaint === 0) {
					p._repaint = 1;
					p.parentRepaint();
				}
			}
		}
		
		/**旋转角度，默认值为0。以角度为单位。*/
		public function get rotation():Number {
			return this._style._tf.rotate;
		}
		
		public function set rotation(value:Number):void {
			var style:Style = getStyle();
			if (style._tf.rotate !== value) {
				style.setRotate(value);
				_tfChanged = true;
				conchModel && conchModel.rotate(value);
				_renderType |= RenderSprite.TRANSFORM;
				var p:Sprite = _parent as Sprite;
				if (p && p._repaint === 0) {
					p._repaint = 1;
					p.parentRepaint();
				}
			}
		}
		
		/**水平倾斜角度，默认值为0。以角度为单位。*/
		public function get skewX():Number {
			return this._style._tf.skewX;
		}
		
		public function set skewX(value:Number):void {
			var style:Style = getStyle();
			if (style._tf.skewX !== value) {
				style.setSkewX(value);
				_tfChanged = true;
				conchModel && conchModel.skew(value,style._tf.skewY);
				_renderType |= RenderSprite.TRANSFORM;
				var p:Sprite = _parent as Sprite;
				if (p && p._repaint === 0) {
					p._repaint = 1;
					p.parentRepaint();
				}
			}
		}
		
		/**垂直倾斜角度，默认值为0。以角度为单位。*/
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
				if (p && p._repaint === 0) {
					p._repaint = 1;
					p.parentRepaint();
				}
			}
		}
		
		/**@private */
		protected function _adjustTransform():Matrix {
			'use strict';
			_tfChanged = false;
			var style:Style = this._style;
			var tf:Object = style._tf;
			var sx:Number = tf.scaleX, sy:Number = tf.scaleY;
			var m:Matrix;
			if (tf.rotate || sx !== 1 || sy !== 1 || tf.skewX || tf.skewY) {
				m = this._transform || (this._transform = Matrix.create());
				m.bTransform = true;
				
				var skx:Number = (tf.rotate - tf.skewX) * 0.0174532922222222;//laya.CONST.PI180;
				var sky:Number = (tf.rotate + tf.skewY) * 0.0174532922222222;
				var cx:Number = Math.cos(sky);
				var ssx:Number = Math.sin(sky);
				var cy:Number = Math.sin(skx);
				var ssy:Number = Math.cos(skx);
				m.a = sx * cx;
				m.b = sx * ssx;
				m.c = -sy * cy;
				m.d = sy * ssy;
				m.tx = m.ty = 0;
				return m;
			} else {
				this._transform && this._transform.destroy();
				this._transform = null;
				_renderType &= ~RenderSprite.TRANSFORM;
			}
			return m;
		}
		
		/**
		 * <p>对象的矩阵信息。通过设置矩阵可以实现节点旋转，缩放，位移效果。</p>
		 * <p>矩阵更多信息请参考 <code>Matrix</code></p>
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
		
		/**X轴 轴心点的位置，单位为像素，默认为0。轴心点会影响对象位置，缩放中心，旋转中心。*/
		public function get pivotX():Number {
			return this._style._tf.translateX;
		}
		
		public function set pivotX(value:Number):void {
			getStyle().setTranslateX(value);
			conchModel && conchModel.pivot(value, this._style._tf.translateY);
			repaint();
		}
		
		/**Y轴 轴心点的位置，单位为像素，默认为0。轴心点会影响对象位置，缩放中心，旋转中心。*/
		public function get pivotY():Number {
			return this._style._tf.translateY;
		}
		
		public function set pivotY(value:Number):void {
			getStyle().setTranslateY(value);
			conchModel && conchModel.pivot(this._style._tf.translateX, value);
			repaint();
		}
		
		/**透明度，值为0-1，默认值为1，表示不透明。更改alpha值会影响drawcall。*/
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
		
		/**表示是否可见，默认为true。如果设置不可见，节点将不被渲染。*/
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
		
		/**指定要使用的混合模式。目前只支持"lighter"。*/
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
		
		/**绘图对象。封装了绘制位图和矢量图的接口，Sprite所有的绘图操作都通过Graphics来实现的。*/
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
				if (conchModel) {
					if (RUNTIMEVERION < "0.9.1")
						conchModel.removeType(0x100);
					else
						conchModel.removeType(RenderSprite.GRAPHICS);
				}
			}
			repaint();
		}
		
		/**
		 * <p>显示对象的滚动矩形范围，具有裁剪效果(如果只想限制子对象渲染区域，请使用viewport)，设置optimizeScrollRect=true，可以优化裁剪区域外的内容不进行渲染。</p>
		 * <p> srollRect和viewport的区别：<br/>
		 * 1.srollRect自带裁剪效果，viewport只影响子对象渲染是否渲染，不具有裁剪效果（性能更高）。<br/>
		 * 2.设置rect的x,y属性均能实现区域滚动效果，但scrollRect会保持0,0点位置不变。</p>
		 */
		public function get scrollRect():Rectangle {
			return this._style.scrollRect;
		}
		
		public function set scrollRect(value:Rectangle):void {
			getStyle().scrollRect = value;
			//viewport = value;
			repaint();
			if (value) {
				_renderType |= RenderSprite.CLIP;
				conchModel && conchModel.scrollRect(value.x, value.y, value.width, value.height);
			} else {
				_renderType &= ~RenderSprite.CLIP;
				if (conchModel) {
					if (RUNTIMEVERION < "0.9.1")
						conchModel.removeType(0x40);
					else
						conchModel.removeType(RenderSprite.CLIP);
				}
			}
		}
		
		/**
		 * <p>设置坐标位置。相当于分别设置x和y属性。</p>
		 * <p>因为返回值为Sprite对象本身，所以可以使用如下语法：spr.pos(...).scale(...);</p>
		 * @param	x			X轴坐标。
		 * @param	y			Y轴坐标。
		 * @param 	speedMode	（可选）是否极速模式，正常是调用this.x=value进行赋值，极速模式直接调用内部函数处理，如果未重写x,y属性，建议设置为急速模式性能更高。
		 * @return	返回对象本身。
		 */
		public function pos(x:Number, y:Number, speedMode:Boolean = false):Sprite {
			if (_x !== x || _y !== y) {
				if (this.destroyed) return this;
				if (speedMode) {
					this._x = x;
					this._y = y;
					conchModel && conchModel.pos(this._x, this._y);
					var p:Sprite = _parent as Sprite;
					if (p && p._repaint === 0) {
						p._repaint = 1;
						p.parentRepaint();
					}
					if (this._$P.maskParent && _$P.maskParent._repaint === 0) {
						_$P.maskParent._repaint = 1;
						_$P.maskParent.parentRepaint();
					}
				} else {
					this.x = x;
					this.y = y;
				}
			}
			return this;
		}
		
		/**
		 * <p>设置轴心点。相当于分别设置pivotX和pivotY属性。</p>
		 * <p>因为返回值为Sprite对象本身，所以可以使用如下语法：spr.pivot(...).pos(...);</p>
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
		 * <p>设置宽高。相当于分别设置width和height属性。</p>
		 * <p>因为返回值为Sprite对象本身，所以可以使用如下语法：spr.size(...).pos(...);</p>
		 * @param	width 宽度值。
		 * @param	hegiht 高度值。
		 * @return	返回对象本身。
		 */
		public function size(width:Number, height:Number):Sprite {
			this.width = width;
			this.height = height;
			return this;
		}
		
		/**
		 * <p>设置缩放。相当于分别设置scaleX和scaleY属性。</p>
		 * <p>因为返回值为Sprite对象本身，所以可以使用如下语法：spr.scale(...).pos(...);</p>
		 * @param	scaleX		X轴缩放比例。
		 * @param	scaleY		Y轴缩放比例。
		 * @param 	speedMode	（可选）是否极速模式，正常是调用this.scaleX=value进行赋值，极速模式直接调用内部函数处理，如果未重写scaleX,scaleY属性，建议设置为急速模式性能更高。
		 * @return	返回对象本身。
		 */
		public function scale(scaleX:Number, scaleY:Number, speedMode:Boolean = false):Sprite {
			var style:Style = getStyle();
			var _tf:TransformInfo = style._tf;
			if (_tf.scaleX != scaleX || _tf.scaleY != scaleY) {
				if (this.destroyed) return this;
				if (speedMode) {
					style.setScale(scaleX, scaleY);
					_tfChanged = true;
					conchModel && conchModel.scale(scaleX, scaleY);
					_renderType |= RenderSprite.TRANSFORM;
					var p:Sprite = _parent as Sprite;
					if (p && p._repaint === 0) {
						p._repaint = 1;
						p.parentRepaint();
					}
				} else {
					this.scaleX = scaleX;
					this.scaleY = scaleY;
				}
			}
			return this;
		}
		
		/**
		 * <p>设置倾斜角度。相当于分别设置skewX和skewY属性。</p>
		 * <p>因为返回值为Sprite对象本身，所以可以使用如下语法：spr.skew(...).pos(...);</p>
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
		 * 更新、呈现显示对象。由系统调用。
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
		 * <p>绘制 当前<code>Sprite</code> 到 <code>Canvas</code> 上，并返回一个HtmlCanvas。</p>
		 * <p>绘制的结果可以当作图片源，再次绘制到其他Sprite里面，示例：</p>
		 *
		 * var htmlCanvas:HTMLCanvas = sprite.drawToCanvas(100, 100, 0, 0);//把精灵绘制到canvas上面
		 * var texture:Texture = new Texture(htmlCanvas);//使用htmlCanvas创建Texture
		 * var sp:Sprite = new Sprite().pos(0, 200);//创建精灵并把它放倒200位置
		 * sp.graphics.drawTexture(texture);//把截图绘制到精灵上
		 * Laya.stage.addChild(sp);//把精灵显示到舞台
		 *
		 * <p>也可以获取原始图片数据，分享到网上，从而实现截图效果，示例：</p>
		 *
		 * var htmlCanvas:HTMLCanvas = sprite.drawToCanvas(100, 100, 0, 0);//把精灵绘制到canvas上面
		 * 
		 * htmlCanvas.toBase64("image/png",0.92,function(base64){//webgl和canvas模式下为同步方法，加速器下是异步方法
		 * 						trace(base64);//打印图片base64信息，可以发给服务器或者保存为图片
		 * 						});
		 *
		 * @param	canvasWidth 画布宽度。
		 * @param	canvasHeight 画布高度。
		 * @param	x 绘制的 X 轴偏移量。
		 * @param	y 绘制的 Y 轴偏移量。
		 * @return  HTMLCanvas 对象。
		 */
		public function drawToCanvas(canvasWidth:Number, canvasHeight:Number, offsetX:Number, offsetY:Number):HTMLCanvas {
			if (Render.isConchNode) {
				var canvas:HTMLCanvas = HTMLCanvas.create("2D");
				var context:RenderContext = new RenderContext(canvasWidth, canvasHeight, canvas);
				context.ctx.setCanvasType(1);
				conchModel.drawToCanvas(canvas.source, offsetX, offsetY);
				return canvas;
			} else {
				return RunDriver.drawToCanvas(this, _renderType, canvasWidth, canvasHeight, offsetX, offsetY);
			}
		}
		
		/**
		 * <p>自定义更新、呈现显示对象。一般用来扩展渲染模式，请合理使用，可能会导致在加速器上无法渲染。</p>
		 * <p><b>注意</b>不要在此函数内增加或删除树节点，否则会对树节点遍历造成影响。</p>
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
		
		/**滤镜集合。可以设置多个滤镜组合。*/
		public function get filters():Array {
			return _$P.filters;
		}
		
		public function set filters(value:Array):void {
			value && value.length === 0 && (value = null);
			if (_$P.filters == value) return;
			_set$P("filters", value ? value.slice() : null);
			if (Render.isConchApp) {
				if (conchModel) {
					if (RUNTIMEVERION < "0.9.1")
						conchModel.removeType(0x10);
					else
						conchModel.removeType(RenderSprite.FILTERS);
				}
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
				if (!_getBit(Node.NOTICE_DISPLAY)) _setUpNoticeType(Node.NOTICE_DISPLAY);
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
		 * 把本地坐标转换为相对stage的全局坐标。
		 * @param point				本地坐标点。
		 * @param createNewPoint	（可选）是否创建一个新的Point对象作为返回值，默认为false，使用输入的point对象返回，减少对象创建开销。
		 * @return 转换后的坐标的点。
		 */
		public function localToGlobal(point:Point, createNewPoint:Boolean = false):Point {
			//if (!_displayedInStage || !point) return point;
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
		 * 把stage的全局坐标转换为本地坐标。
		 * @param point				全局坐标点。
		 * @param createNewPoint	（可选）是否创建一个新的Point对象作为返回值，默认为false，使用输入的point对象返回，减少对象创建开销。
		 * @return 转换后的坐标的点。
		 */
		public function globalToLocal(point:Point, createNewPoint:Boolean = false):Point {
			//if (!_displayedInStage || !point) return point;
			if (createNewPoint) {
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
		 * 将本地坐标系坐标转转换到父容器坐标系。
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
		 * <p>增加事件侦听器，以使侦听器能够接收事件通知。</p>
		 * <p>如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。</p>
		 * @param type		事件的类型。
		 * @param caller	事件侦听函数的执行域。
		 * @param listener	事件侦听函数。
		 * @param args		（可选）事件侦听函数的回调参数。
		 * @return 此 EventDispatcher 对象。
		 */
		override public function on(type:String, caller:*, listener:Function, args:Array = null):EventDispatcher {
			//如果是鼠标事件，则设置自己和父对象为可接受鼠标交互事件
			if (_mouseEnableState !== 1 && isMouseEvent(type)) {
				this.mouseEnabled = true;
				_setBit(Node.MOUSEENABLE, true);
				if (_parent) {
					_onDisplay();
				}
				return _createListener(type, caller, listener, args, false);
			}
			return super.on(type, caller, listener, args);
		}
		
		/**
		 * <p>增加事件侦听器，以使侦听器能够接收事件通知，此侦听事件响应一次后则自动移除侦听。</p>
		 * <p>如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。</p>
		 * @param type		事件的类型。
		 * @param caller	事件侦听函数的执行域。
		 * @param listener	事件侦听函数。
		 * @param args		（可选）事件侦听函数的回调参数。
		 * @return 此 EventDispatcher 对象。
		 */
		override public function once(type:String, caller:*, listener:Function, args:Array = null):EventDispatcher {
			//如果是鼠标事件，则设置自己和父对象为可接受鼠标交互事件
			if (_mouseEnableState !== 1 && isMouseEvent(type)) {
				this.mouseEnabled = true;
				_setBit(Node.MOUSEENABLE, true);
				if (_parent) {
					_onDisplay();
				}
				return _createListener(type, caller, listener, args, true);
			}
			return super.once(type, caller, listener, args);
		}
		
		/** @private */
		private function _onDisplay():void {
			if (_mouseEnableState !== 1) {
				var ele:Sprite = this;
				ele = ele.parent as Sprite;
				while (ele && ele._mouseEnableState !== 1) {
					if (ele._getBit(Node.MOUSEENABLE)) break;
					ele.mouseEnabled = true;
					ele._setBit(Node.MOUSEENABLE, true);
					ele = ele.parent as Sprite;
				}
			}
		}
		
		override public function set parent(value:Node):void {
			super.parent = value;
			if (value && _getBit(Node.MOUSEENABLE)) {
				_onDisplay();
			}
		}
		
		/**
		 * <p>加载并显示一个图片。功能等同于graphics.loadImage方法。支持异步加载。</p>
		 * <p>注意：多次调用loadImage绘制不同的图片，会同时显示。</p>
		 * @param url		图片地址。
		 * @param x			（可选）显示图片的x位置。
		 * @param y			（可选）显示图片的y位置。
		 * @param width		（可选）显示图片的宽度，设置为0表示使用图片默认宽度。
		 * @param height	（可选）显示图片的高度，设置为0表示使用图片默认高度。
		 * @param complete	（可选）加载完成回调。
		 * @return	返回精灵对象本身。
		 */
		public function loadImage(url:String, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, complete:Handler = null):Sprite {
			function loaded(tex:Texture):void {
				if (!destroyed) {
					size(x + (width || tex.width), y + (height || tex.height));
					//if (_width == 0 && _height == 0) setBounds(getSelfBounds());
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
			this.conchModel && this.conchModel.repaint && this.conchModel.repaint();
			if (_repaint === 0) {
				_repaint = 1;
				parentRepaint();
			}
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
		
		/**@private	*/
		override protected function _childChanged(child:Node = null):void {
			if (_childs.length) _renderType |= RenderSprite.CHILDS;
			else _renderType &= ~RenderSprite.CHILDS;
			if (child && _get$P("hasZorder")) Laya.timer.callLater(this, updateZOrder);
			repaint();
		}
		
		/**cacheAs时，设置所有父对象缓存失效。 */
		public function parentRepaint():void {
			var p:Sprite = _parent as Sprite;
			if (p && p._repaint === 0) {
				p._repaint = 1;
				p.parentRepaint();
			}
		}
		
		/**对舞台 <code>stage</code> 的引用。*/
		public function get stage():Stage {
			return Laya.stage;
		}
		
		/**
		 * <p>可以设置一个Rectangle区域作为点击区域，或者设置一个<code>HitArea</code>实例作为点击区域，HitArea内可以设置可点击和不可点击区域。</p>
		 * <p>如果不设置hitArea，则根据宽高形成的区域进行碰撞。</p>
		 */
		public function get hitArea():* {
			return _$P.hitArea;
		}
		
		public function set hitArea(value:*):void {
			_set$P("hitArea", value);
		}
		
		/**
		 * <p>遮罩，可以设置一个对象(支持位图和矢量图)，根据对象形状进行遮罩显示。</p>
		 * <p>【注意】遮罩对象坐标系是相对遮罩对象本身的，和Flash机制不同</p>
		 */
		public function get mask():Sprite {
			return this._$P._mask;
		}
		
		public function set mask(value:Sprite):void {
			if (value && mask && mask._$P.maskParent) return;
			if (value) {
				//TODO:去掉关联
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
		 * @param area				（可选）拖动区域，此区域为当前对象注册点活动区域（不包括对象宽高），可选。
		 * @param hasInertia		（可选）鼠标松开后，是否还惯性滑动，默认为false，可选。
		 * @param elasticDistance	（可选）橡皮筋效果的距离值，0为无橡皮筋效果，默认为0，可选。
		 * @param elasticBackTime	（可选）橡皮筋回弹时间，单位为毫秒，默认为300毫秒，可选。
		 * @param data				（可选）拖动事件携带的数据，可选。
		 * @param disableMouseEvent	（可选）禁用其他对象的鼠标检测，默认为false，设置为true能提高性能。
		 * @param ratio				（可选）惯性阻尼系数，影响惯性力度和时长。
		 */
		public function startDrag(area:Rectangle = null, hasInertia:Boolean = false, elasticDistance:Number = 0, elasticBackTime:int = 300, data:* = null, disableMouseEvent:Boolean = false, ratio:Number = 0.92):void {
			_$P.dragging || (_set$P("dragging", new Dragging()));
			_$P.dragging.start(this, area, hasInertia, elasticDistance, elasticBackTime, data, disableMouseEvent, ratio);
		}
		
		/**停止拖动此对象。*/
		public function stopDrag():void {
			_$P.dragging && _$P.dragging.stop();
		}
		
		private function _releaseMem():void
		{
			if (!_$P) return;
			var cc:* = _$P.cacheCanvas;
			//如果从显示列表移除，则销毁cache缓存
			if (cc && cc.ctx) {
				Pool.recover("RenderContext", cc.ctx);
				cc.ctx.canvas.size(0, 0);
				cc.ctx = null;
			}
			//_$P.cacheCanvas = null;
			var fc:* = _$P._filterCache;
			//fc && (fc.destroy(), fc.recycle(), this._set$P('_filterCache', null));
			if (fc) {
				fc.destroy();
				fc.recycle();
				this._set$P('_filterCache', null);
			}
			_$P._isHaveGlowFilter && this._set$P('_isHaveGlowFilter', false);
			_$P._isHaveGlowFilter = null;			
		}
		
		/**@private */
		override public function _setDisplay(value:Boolean):void {
			if (!value) _releaseMem();
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
			x = point.x;
			y = point.y;
			var rect:Rectangle = _$P.hitArea ? _$P.hitArea : (_width > 0 && _height > 0)? Rectangle.TEMP.setTo(0, 0, _width, _height): getSelfBounds();
			return rect.contains(x, y);
		}
		
		/**获得相对于本对象上的鼠标坐标信息。*/
		public function getMousePoint():Point {
			return this.globalToLocal(Point.TEMP.setTo(Laya.stage.mouseX, Laya.stage.mouseY));
		}
		
		/**
		 * 获得相对于stage的全局X轴缩放值（会叠加父亲节点的缩放值）。
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
		 * 获得相对于stage的全局Y轴缩放值（会叠加父亲节点的缩放值）。
		 */
		public function get globalScaleY():Number {
			var scale:Number = 1;
			var ele:Sprite = this;
			while (ele) {
				if (ele === Laya.stage) break;
				scale *= ele.scaleY;
				ele = ele.parent as Sprite;
			}
			return scale;
		}
		
		/**
		 * 返回鼠标在此对象坐标系上的 X 轴坐标信息。
		 */
		public function get mouseX():Number {
			return getMousePoint().x;
		}
		
		/**
		 * 返回鼠标在此对象坐标系上的 Y 轴坐标信息。
		 */
		public function get mouseY():Number {
			return getMousePoint().y;
		}
		
		/**z排序，更改此值，则会按照值的大小对同一容器的所有对象重新排序。值越大，越靠上。默认为0，则根据添加顺序排序。*/
		public function get zOrder():Number {
			return _zOrder;
		}
		
		public function set zOrder(value:Number):void {
			if (_zOrder != value) {
				_zOrder = value;
				conchModel && conchModel.setZOrder && conchModel.setZOrder(value);
				if (_parent) {
					value && _parent._set$P("hasZorder", true);
					Laya.timer.callLater(_parent, updateZOrder);
				}
			}
		}
		
		/**设置一个Texture实例，并显示此图片（如果之前有其他绘制，则会被清除掉）。等同于graphics.clear();graphics.drawTexture()*/
		public function get texture():Texture {
			return _texture;
		}
		
		public function set texture(value:Texture):void {
			if (_texture != value) {
				_texture = value;
				graphics.cleanByTexture(value, 0, 0);
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