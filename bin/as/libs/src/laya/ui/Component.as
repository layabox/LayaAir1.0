package laya.ui {
	import laya.display.Sprite;
	import laya.events.Event;
	
	/**
	 * 对象的大小经过重新调整时进行调度。
	 * @eventType Event.RESIZE
	 */
	[Event(name = "resize", type = "laya.events.Event")]
	
	/**
	 * <code>Component</code> 是ui控件类的基类。
	 * <p>生命周期：preinitialize > createChildren > initialize > 组件构造函数</p>
	 */
	public class Component extends Sprite implements IComponent {
		private var _comXml:Object;
		/**@private 对象的布局样式 */
		protected var _layout:LayoutStyle = LayoutStyle.EMPTY;
		/**@private 控件的元数据。 */
		protected var _dataSource:*;
		/**@private 鼠标悬停提示 */
		protected var _toolTip:*;
		/**@private 标签 */
		protected var _tag:*;
		/**@private 禁用 */
		protected var _disabled:Boolean;
		/**@private 变灰*/
		protected var _gray:Boolean;
		/**
		 * 是否启用相对布局
		 */
		public var layoutEnabled:Boolean = true;
		
		/**
		 * <p>创建一个新的 <code>Component</code> 实例。</p>
		 */
		public function Component() {
			preinitialize();
			createChildren();
			initialize();
		}
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_dataSource = _layout = null;
			_tag = null;
			_toolTip = null;
		}
		
		/**
		 * <p>预初始化。</p>
		 * @internal 子类可在此函数内设置、修改属性默认值
		 */
		protected function preinitialize():void {
		}
		
		/**
		 * <p>创建并添加控件子节点。</p>
		 * @internal 子类可在此函数内创建并添加子节点。
		 */
		protected function createChildren():void {
		}
		
		/**
		 * <p>控件初始化。</p>
		 * @internal 在此子对象已被创建，可以对子对象进行修改。
		 */
		protected function initialize():void {
		}
		
		/**
		 * <p>延迟运行指定的函数。</p>
		 * <p>在控件被显示在屏幕之前调用，一般用于延迟计算数据。</p>
		 * @param method 要执行的函数的名称。例如，functionName。
		 * @param args 传递给 <code>method</code> 函数的可选参数列表。
		 *
		 * @see #runCallLater()
		 */
		public function callLater(method:Function, args:Array = null):void {
			Laya.timer.callLater(this, method, args);
		}
		
		/**
		 * <p>如果有需要延迟调用的函数（通过 <code>callLater</code> 函数设置），则立即执行延迟调用函数。</p>
		 * @param method 要执行的函数名称。例如，functionName。
		 * @see #callLater()
		 */
		public function runCallLater(method:Function):void {
			Laya.timer.runCallLater(this, method);
		}
		
		/**
		 * <p>表示显示对象的宽度，以像素为单位。</p>
		 * <p><b>注：</b>当值为0时，宽度为自适应大小。</p>
		 */
		override public function get width():Number {
			if (_width) return _width;
			return measureWidth;
		}
		
		override public function set width(value:Number):void {
			if (_width != value) {
				_width = value;
				conchModel && conchModel.size(_width, _height);
				callLater(changeSize);
				if (_layout.enable && (!isNaN(_layout.centerX) || !isNaN(_layout.right) || !isNaN(_layout.anchorX))) resetLayoutX();
			}
		}
		
		/**
		 * <p>对象的显示宽度（以像素为单位）。</p>
		 */
		public function get displayWidth():Number {
			return width * scaleX;
		}
		
		/**
		 * <p>显示对象的实际显示区域宽度（以像素为单位）。</p>
		 */
		protected function get measureWidth():Number {
			var max:Number = 0;
			commitMeasure();
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:Sprite = getChildAt(i) as Sprite;
				if (comp.visible) {
					max = Math.max(comp.x + comp.width * comp.scaleX, max);
				}
			}
			return max;
		}
		
		/**
		 * <p>立即执行影响宽高度量的延迟调用函数。</p>
		 * @internal <p>使用 <code>runCallLater</code> 函数，立即执行影响宽高度量的延迟运行函数(使用 <code>callLater</code> 设置延迟执行函数)。</p>
		 * @see #callLater()
		 * @see #runCallLater()
		 */
		protected function commitMeasure():void {
		}
		
		/**
		 * <p>表示显示对象的高度，以像素为单位。</p>
		 * <p><b>注：</b>当值为0时，高度为自适应大小。</p>
		 */
		override public function get height():Number {
			if (_height) return _height;
			return measureHeight;
		}
		
		override public function set height(value:Number):void {
			if (_height != value) {
				_height = value;
				conchModel && conchModel.size(_width, _height);
				callLater(changeSize);
				if (_layout.enable && (!isNaN(_layout.centerY) || !isNaN(_layout.bottom) || !isNaN(_layout.anchorY))) resetLayoutY();
			}
		}
		
		/**
		 * <p>对象的显示高度（以像素为单位）。</p>
		 */
		public function get displayHeight():Number {
			return height * scaleY;
		}
		
		/**
		 * <p>显示对象的实际显示区域高度（以像素为单位）。</p>
		 */
		protected function get measureHeight():Number {
			var max:Number = 0;
			commitMeasure();
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:Sprite = getChildAt(i) as Sprite;
				if (comp.visible) {
					max = Math.max(comp.y + comp.height * comp.scaleY, max);
				}
			}
			return max;
		}
		
		/**@inheritDoc */
		override public function set scaleX(value:Number):void {
			if (super.scaleX != value) {
				super.scaleX = value;
				callLater(changeSize);
				_layout.enable && resetLayoutX();
			}
		}
		
		/**@inheritDoc */
		override public function set scaleY(value:Number):void {
			if (super.scaleY != value) {
				super.scaleY = value;
				callLater(changeSize);
				_layout.enable && resetLayoutY();
			}
		}
		
		/**
		 * <p>重新调整对象的大小。</p>
		 */
		protected function changeSize():void {
			event(Event.RESIZE);
		}
		
		/**
		 * <p>数据赋值，通过对UI赋值来控制UI显示逻辑。</p>
		 * <p>简单赋值会更改组件的默认属性，使用大括号可以指定组件的任意属性进行赋值。</p>
		 * @example
		   //默认属性赋值
		   dataSource = {label1: "改变了label", checkbox1: true};//(更改了label1的text属性值，更改checkbox1的selected属性)。
		   //任意属性赋值
		   dataSource = {label2: {text:"改变了label",size:14}, checkbox2: {selected:true,x:10}};
		 */
		public function get dataSource():* {
			return _dataSource;
		}
		
		public function set dataSource(value:*):void {
			_dataSource = value;
			for (var prop:String in _dataSource) {
				if (hasOwnProperty(prop) && !(this[prop] is Function)) {
					this[prop] = _dataSource[prop];
				}
			}
		}
		
		/**
		 * @private
		 * <p>获取对象的布局样式。</p>
		 */
		private function getLayout():LayoutStyle {
			this._layout === LayoutStyle.EMPTY && (this._layout = new LayoutStyle());
			return this._layout;
		}
		
		/**
		 * <p>从组件顶边到其内容区域顶边之间的垂直距离（以像素为单位）。</p>
		 */
		public function get top():Number {
			return this._layout.top;
		}
		
		public function set top(value:Number):void {
			if (value != _layout.top) {
				getLayout().top = value;
				_setLayoutEnabled(true);
			}
			resetLayoutY();
		}
		
		/**
		 * <p>从组件底边到其内容区域底边之间的垂直距离（以像素为单位）。</p>
		 */
		public function get bottom():Number {
			return this._layout.bottom;
		}
		
		public function set bottom(value:Number):void {
			if (value != _layout.bottom) {
				getLayout().bottom = value;
				_setLayoutEnabled(true);
			}
			resetLayoutY();
		}
		
		/**
		 * <p>从组件左边到其内容区域左边之间的水平距离（以像素为单位）。</p>
		 */
		public function get left():Number {
			return this._layout.left;
		}
		
		public function set left(value:Number):void {
			if (value != _layout.left) {
				getLayout().left = value;
				_setLayoutEnabled(true);
			}
			resetLayoutX();
		}
		
		/**
		 * <p>从组件右边到其内容区域右边之间的水平距离（以像素为单位）。</p>
		 */
		public function get right():Number {
			return this._layout.right;
		}
		
		public function set right(value:Number):void {
			if (value != _layout.right) {
				getLayout().right = value;
				_setLayoutEnabled(true);		
			}
			resetLayoutX();
		}
		
		/**
		 * <p>在父容器中，此对象的水平方向中轴线与父容器的水平方向中心线的距离（以像素为单位）。</p>
		 */
		public function get centerX():Number {
			return this._layout.centerX;
		}
		
		public function set centerX(value:Number):void {
			if (value != _layout.centerX) {
				getLayout().centerX = value;
				_setLayoutEnabled(true);	
			}
			resetLayoutX();
		}
		
		/**
		 * <p>在父容器中，此对象的垂直方向中轴线与父容器的垂直方向中心线的距离（以像素为单位）。</p>
		 */
		public function get centerY():Number {
			return this._layout.centerY;
		}
		
		public function set centerY(value:Number):void {
			if (value != _layout.centerY) {
				getLayout().centerY = value;
				_setLayoutEnabled(true);
			}
			resetLayoutY();
		}
		
		/**X轴锚点，值为0-1*/
		public function get anchorX():Number {
			return this._layout.anchorX;
		}
		
		public function set anchorX(value:Number):void {
			if (value != _layout.anchorX) {
				getLayout().anchorX = value;
				_setLayoutEnabled(true);	
			}
			resetLayoutX();
		}
		
		/**Y轴锚点，值为0-1*/
		public function get anchorY():Number {
			return this._layout.anchorY;
		}
		
		public function set anchorY(value:Number):void {
			if (value != _layout.anchorY) {
				getLayout().anchorY = value;
				_setLayoutEnabled(true);
			}
			resetLayoutY();
		}
		
		/**
		 * <p>对象的标签。</p>
		 * @internal 冗余字段，可以用来储存数据。
		 */
		public function get tag():* {
			return _tag;
		}
		
		public function set tag(value:*):void {
			_tag = value;
		}
		
		/**
		 * @private
		 * <p>指定对象是否可使用布局。</p>
		 * <p>如果值为true,则此对象可以使用布局样式，否则不使用布局样式。</p>
		 * @param value 一个 Boolean 值，指定对象是否可使用布局。
		 */
		private function _setLayoutEnabled(value:Boolean):void {
			if (_layout && _layout.enable != value) {
				_layout.enable = value;
				on(Event.ADDED, this, onAdded);
				on(Event.REMOVED, this, onRemoved);
				if (this.parent) {
					onAdded();
				}
			}
		}
		
		/**
		 * 对象从显示列表移除的事件侦听处理函数。
		 */
		private function onRemoved():void {
			this.parent.off(Event.RESIZE, this, onCompResize);
		}
		
		/**
		 * 对象被添加到显示列表的事件侦听处理函数。
		 */
		private function onAdded():void {
			this.parent.on(Event.RESIZE, this, onCompResize);
			resetLayoutX();
			resetLayoutY();
		}
		
		/**
		 * 父容器的 <code>Event.RESIZE</code> 事件侦听处理函数。
		 */
		protected function onCompResize():void {
			if (_layout && _layout.enable) {
				resetLayoutX();
				resetLayoutY();
			}
		}
		
		/**
		 * <p>重置对象的 <code>X</code> 轴（水平方向）布局。</p>
		 */
		protected function resetLayoutX():void {
			var layout:LayoutStyle = _layout;
			if (!isNaN(layout.anchorX)) this.pivotX = layout.anchorX * width;
			if (!layoutEnabled) return;
			var parent:Sprite = this.parent as Sprite;
			if (parent) {
				if (!isNaN(layout.centerX)) {
					x = Math.round((parent.width - displayWidth) * 0.5 + layout.centerX + this.pivotX * this.scaleX);
				} else if (!isNaN(layout.left)) {
					x = Math.round(layout.left + this.pivotX * this.scaleX);
					if (!isNaN(layout.right)) {
						//TODO:
						width = (parent._width - layout.left - layout.right) / (scaleX || 0.01);
					}
				} else if (!isNaN(layout.right)) {
					x = Math.round(parent.width - displayWidth - layout.right + this.pivotX * this.scaleX);
				}
			}
		}
		
		/**
		 * <p>重置对象的 <code>Y</code> 轴（垂直方向）布局。</p>
		 */
		protected function resetLayoutY():void {
			var layout:LayoutStyle = _layout;
			if (!isNaN(layout.anchorY)) this.pivotY = layout.anchorY * height;
			if (!layoutEnabled) return;
			var parent:Sprite = this.parent as Sprite;
			if (parent) {
				if (!isNaN(layout.centerY)) {
					y = Math.round((parent.height - displayHeight) * 0.5 + layout.centerY + this.pivotY * this.scaleY);
				} else if (!isNaN(layout.top)) {
					y = Math.round(layout.top + this.pivotY * this.scaleY);
					if (!isNaN(layout.bottom)) {
						//TODO:
						height = (parent._height - layout.top - layout.bottom) / (scaleY || 0.01);
					}
				} else if (!isNaN(layout.bottom)) {
					y = Math.round(parent.height - displayHeight - layout.bottom + this.pivotY * this.scaleY);
				}
			}
		}
		
		/**
		 * <p>鼠标悬停提示。</p>
		 * <p>可以赋值为文本 <code>String</code> 或函数 <code>Handler</code> ，用来实现自定义样式的鼠标提示和参数携带等。</p>
		 * @example
		 * private var _testTips:TestTipsUI = new TestTipsUI();
		 * private function testTips():void {
		  //简单鼠标提示
		 * btn2.toolTip = "这里是鼠标提示&lt;b&gt;粗体&lt;/b&gt;&lt;br&gt;换行";
		  //自定义的鼠标提示
		 * btn1.toolTip = showTips1;
		  //带参数的自定义鼠标提示
		 * clip.toolTip = new Handler(this,showTips2, ["clip"]);
		 * }
		 * private function showTips1():void {
		 * _testTips.label.text = "这里是按钮[" + btn1.label + "]";
		 * tip.addChild(_testTips);
		 * }
		 * private function showTips2(name:String):void {
		 * _testTips.label.text = "这里是" + name;
		 * tip.addChild(_testTips);
		 * }
		 */
		public function get toolTip():* {
			return _toolTip;
		}
		
		public function set toolTip(value:*):void {
			if (_toolTip != value) {
				_toolTip = value;
				if (value != null) {
					on(Event.MOUSE_OVER, this, onMouseOver);
					on(Event.MOUSE_OUT, this, onMouseOut);
				} else {
					off(Event.MOUSE_OVER, this, onMouseOver);
					off(Event.MOUSE_OUT, this, onMouseOut);
				}
			}
		}
		
		/**
		 * 对象的 <code>Event.MOUSE_OVER</code> 事件侦听处理函数。
		 */
		private function onMouseOver(e:Event):void {
			Laya.stage.event(UIEvent.SHOW_TIP, _toolTip);
		}
		
		/**
		 * 对象的 <code>Event.MOUSE_OUT</code> 事件侦听处理函数。
		 */
		private function onMouseOut(e:Event):void {
			Laya.stage.event(UIEvent.HIDE_TIP, _toolTip);
		}
		
		/**
		 * XML 数据。
		 */
		public function get comXml():Object {
			return _comXml;
		}
		
		public function set comXml(value:Object):void {
			_comXml = value;
		}
		
		/** 是否变灰。*/
		public function get gray():Boolean {
			return _gray;
		}
		
		public function set gray(value:Boolean):void {
			if (value !== _gray) {
				_gray = value;
				UIUtils.gray(this, value);
			}
		}
		
		/** 是否禁用页面，设置为true后，会变灰并且禁用鼠标。*/
		public function get disabled():Boolean {
			return _disabled;
		}
		
		public function set disabled(value:Boolean):void {
			if (value !== _disabled) {
				this.gray = _disabled = value;
				this.mouseEnabled = !value;
			}
		}
	}
}