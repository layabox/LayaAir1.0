package laya.ui {
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.events.Event;
	
	/**
	 * <code>Component</code> 是ui控件类的基类。
	 * <p>生命周期：preinitialize > createChildren > initialize > 组件构造函数</p>
	 */
	public class UIComponent extends Sprite {
		/**X锚点，值为0-1，设置anchorX值最终通过pivotX值来改变节点轴心点。*/
		protected var _anchorX:Number = NaN;
		/**Y锚点，值为0-1，设置anchorY值最终通过pivotY值来改变节点轴心点。*/
		protected var _anchorY:Number = NaN;
		/**@private 控件的数据源。 */
		protected var _dataSource:*;
		/**@private 鼠标悬停提示 */
		protected var _toolTip:*;
		/**@private 标签 */
		protected var _tag:*;
		/**@private 禁用 */
		protected var _disabled:Boolean;
		/**@private 变灰*/
		protected var _gray:Boolean;
		/**@private 相对布局组件*/
		protected var _widget:Widget = Widget.EMPTY;
		
		/**
		 * <p>创建一个新的 <code>Component</code> 实例。</p>
		 */
		public function UIComponent() {
			preinitialize();
			createChildren();
			initialize();
		}
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_dataSource = null;
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
		 * <p>表示显示对象的宽度，以像素为单位。</p>
		 * <p><b>注：</b>当值为0时，宽度为自适应大小。</p>
		 */
		override public function get width():Number {
			if (_width) return _width;
			return measureWidth();
		}
		
		/**
		 * <p>显示对象的实际显示区域宽度（以像素为单位）。</p>
		 */
		protected function measureWidth():Number {
			var max:Number = 0;
			commitMeasure();
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:Sprite = getChildAt(i) as Sprite;
				if (comp._visible) {
					max = Math.max(comp._x + comp.width * comp.scaleX, max);
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
			return measureHeight();
		}
		
		/**
		 * <p>显示对象的实际显示区域高度（以像素为单位）。</p>
		 */
		protected function measureHeight():Number {
			var max:Number = 0;
			commitMeasure();
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:Sprite = getChildAt(i) as Sprite;
				if (comp._visible) {
					max = Math.max(comp._y + comp.height * comp.scaleY, max);
				}
			}
			return max;
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
		 * <p>从组件顶边到其内容区域顶边之间的垂直距离（以像素为单位）。</p>
		 */
		public function get top():Number {
			return this._widget.top;
		}
		
		public function set top(value:Number):void {
			if (value != _widget.top) {
				_getWidget().top = value;
			}
		}
		
		/**
		 * <p>从组件底边到其内容区域底边之间的垂直距离（以像素为单位）。</p>
		 */
		public function get bottom():Number {
			return this._widget.bottom;
		}
		
		public function set bottom(value:Number):void {
			if (value != _widget.bottom) {
				_getWidget().bottom = value;
			}
		}
		
		/**
		 * <p>从组件左边到其内容区域左边之间的水平距离（以像素为单位）。</p>
		 */
		public function get left():Number {
			return this._widget.left;
		}
		
		public function set left(value:Number):void {
			if (value != _widget.left) {
				_getWidget().left = value;
			}
		}
		
		/**
		 * <p>从组件右边到其内容区域右边之间的水平距离（以像素为单位）。</p>
		 */
		public function get right():Number {
			return this._widget.right;
		}
		
		public function set right(value:Number):void {
			if (value != _widget.right) {
				_getWidget().right = value;
			}
		}
		
		/**
		 * <p>在父容器中，此对象的水平方向中轴线与父容器的水平方向中心线的距离（以像素为单位）。</p>
		 */
		public function get centerX():Number {
			return this._widget.centerX;
		}
		
		public function set centerX(value:Number):void {
			if (value != _widget.centerX) {
				_getWidget().centerX = value;
			}
		}
		
		/**
		 * <p>在父容器中，此对象的垂直方向中轴线与父容器的垂直方向中心线的距离（以像素为单位）。</p>
		 */
		public function get centerY():Number {
			return this._widget.centerY;
		}
		
		public function set centerY(value:Number):void {
			if (value != _widget.centerY) {
				_getWidget().centerY = value;
			}
		}
		
		protected function _sizeChanged():void {
			if (!isNaN(_anchorX)) this.pivotX = anchorX * width;
			if (!isNaN(_anchorY)) this.pivotY = anchorY * height;
			event(Event.RESIZE);
			if (this._widget !== Widget.EMPTY) this._widget.resetLayout();
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
		
		/**
		 * @private
		 * <p>获取对象的布局样式。请不要直接修改此对象</p>
		 */
		private function _getWidget():Widget {
			this._widget === Widget.EMPTY && (this._widget = addComponent(Widget));
			return this._widget;
		}
		
		/**@inheritDoc */
		override public function set scaleX(value:Number):void {
			if (super.scaleX == value) return;
			super.scaleX = value;
			event(Event.RESIZE);
		}
		
		/**@inheritDoc */
		override public function set scaleY(value:Number):void {
			if (super.scaleY == value) return;
			super.scaleY = value;
			event(Event.RESIZE);
		}
		
		/**@private */
		protected function onCompResize():void {
			_sizeChanged();
		}
		
		/**@inheritDoc */
		override public function set width(value:Number):void {
			if (super.width == value) return;
			super.width = value;
			callLater(_sizeChanged);
		}
		
		/**@inheritDoc */
		override public function set height(value:Number):void {
			if (super.height == value) return;
			super.height = value;
			callLater(_sizeChanged);
		}
		
		/**X锚点，值为0-1，设置anchorX值最终通过pivotX值来改变节点轴心点。*/
		public function get anchorX():Number {
			return _anchorX;
		}
		
		public function set anchorX(value:Number):void {
			if (_anchorX != value) {
				_anchorX = value;
				callLater(_sizeChanged);
			}
		}
		
		/**Y锚点，值为0-1，设置anchorY值最终通过pivotY值来改变节点轴心点。*/
		public function get anchorY():Number {
			return _anchorY;
		}
		
		public function set anchorY(value:Number):void {
			if (_anchorY != value) {
				_anchorY = value
				callLater(_sizeChanged);
			}
		}
		
		override protected function _childChanged(child:Node = null):void {
			callLater(_sizeChanged);
			super._childChanged(child);
		}
	}
}