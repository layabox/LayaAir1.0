package laya.ui {
	import laya.events.Event;
	import laya.maths.Point;
	import laya.utils.Handler;
	
	/**
	 * 移动滑块位置时调度。
	 * @eventType laya.events.Event
	 */
	[Event(name = "change", type = "laya.events.Event")]
	
	/**
	 * 移动滑块位置完成（用户鼠标抬起）后调度。
	 * @eventType @eventType laya.events.EventD
	 *
	 */
	[Event(name = "changed", type = "laya.events.Event")]
	
	/**
	 * 使用 <code>Slider</code> 控件，用户可以通过在滑块轨道的终点之间移动滑块来选择值。
	 * <p>滑块的当前值由滑块端点（对应于滑块的最小值和最大值）之间滑块的相对位置确定。</p>
	 * <p>滑块允许最小值和最大值之间特定间隔内的值。滑块还可以使用数据提示显示其当前值。</p>
	 *
	 * @see laya.ui.HSlider
	 * @see laya.ui.VSlider
	 */
	public class Slider extends Component {
		
		/** @private 获取对 <code>Slider</code> 组件所包含的 <code>Label</code> 组件的引用。*/
		public static var label:Label = new Label();
		
		/**
		 * 数据变化处理器。
		 * <p>默认回调参数为滑块位置属性 <code>value</code>属性值：Number 。</p>
		 */
		public var changeHandler:Handler;
		
		/**
		 * 一个布尔值，指示是否为垂直滚动。如果值为true，则为垂直方向，否则为水平方向。
		 * <p>默认值为：true。</p>
		 * @default true
		 */
		public var isVertical:Boolean = true;
		
		/**
		 * 一个布尔值，指示是否显示标签。
		 * @default true
		 */
		public var showLabel:Boolean = true;
		/**@private */
		protected var _allowClickBack:Boolean;
		/**@private */
		protected var _max:Number = 100;
		/**@private */
		protected var _min:Number = 0;
		/**@private */
		protected var _tick:Number = 1;
		/**@private */
		protected var _value:Number = 0;
		/**@private */
		protected var _skin:String;
		/**@private */
		protected var _bg:Image;
		/**@private */
		protected var _bar:Button;
		/**@private */
		protected var _tx:Number;
		/**@private */
		protected var _ty:Number;
		/**@private */
		protected var _maxMove:Number;
		/**@private */
		protected var _globalSacle:Point;
		
		/**
		 * 创建一个新的 <code>Slider</code> 类示例。
		 * @param skin 皮肤。
		 */
		public function Slider(skin:String = null):void {
			this.skin = skin;
		}
		
		/**
		 *@inheritDoc
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_bg && _bg.destroy(destroyChild);
			_bar && _bar.destroy(destroyChild);
			_bg = null;
			_bar = null;
			changeHandler = null;
		}
		
		/**@inheritDoc */
		override protected function createChildren():void {
			addChild(_bg = new Image());
			addChild(_bar = new Button());
		}
		
		/**@inheritDoc */
		override protected function initialize():void {
			_bar.on(Event.MOUSE_DOWN, this, onBarMouseDown);
			_bg.sizeGrid = _bar.sizeGrid = "4,4,4,4,0";
			allowClickBack = true;
		}
		
		/**
		 * @private
		 * 滑块的的 <code>Event.MOUSE_DOWN</code> 事件侦听处理函数。
		 * @param e
		 */
		protected function onBarMouseDown(e:Event):void {
			_globalSacle || (_globalSacle = new Point());
			_globalSacle.setTo(globalScaleX, globalScaleY);
			
			_maxMove = isVertical ? (height - _bar.height) : (width - _bar.width);
			_tx = Laya.stage.mouseX;
			_ty = Laya.stage.mouseY;
			Laya.stage.on(Event.MOUSE_MOVE, this, mouseMove);
			Laya.stage.once(Event.MOUSE_UP, this, mouseUp);
			
			//显示提示
			showValueText();
		}
		
		/**
		 * @private
		 * 显示标签。
		 */
		protected function showValueText():void {
			if (showLabel) {
				var label:Label = Slider.label;
				addChild(label);
				label.textField.changeText(_value + "");
				if (isVertical) {
					label.x = _bar.x + 20;
					label.y = (_bar.height - label.height) * 0.5 + _bar.y;
				} else {
					label.y = _bar.y - 20;
					label.x = (_bar.width - label.width) * 0.5 + _bar.x;
				}
			}
		}
		
		/**
		 * @private
		 * 隐藏标签。
		 */
		protected function hideValueText():void {
			Slider.label && Slider.label.removeSelf();
		}
		
		/**
		 * @private
		 * @param e
		 */
		private function mouseUp(e:Event):void {
			Laya.stage.off(Event.MOUSE_MOVE, this, mouseMove);
			sendChangeEvent(Event.CHANGED);
			hideValueText();
		}
		
		/**
		 * @private
		 * @param e
		 */
		private function mouseMove(e:Event):void {
			var oldValue:Number = _value;
			if (isVertical) {
				_bar.y += (Laya.stage.mouseY - _ty) / _globalSacle.y;
				if (_bar.y > _maxMove) _bar.y = _maxMove;
				else if (_bar.y < 0) _bar.y = 0;
				_value = _bar.y / _maxMove * (_max - _min) + _min;
			} else {
				_bar.x += (Laya.stage.mouseX - _tx) / _globalSacle.x;
				if (_bar.x > _maxMove) _bar.x = _maxMove;
				else if (_bar.x < 0) _bar.x = 0;
				_value = _bar.x / _maxMove * (_max - _min) + _min;
			}
			
			_tx = Laya.stage.mouseX;
			_ty = Laya.stage.mouseY;
			
			var pow:Number = Math.pow(10, (_tick + "").length - 1);
			_value = Math.round(Math.round(_value / _tick) * _tick * pow) / pow;
			if (_value != oldValue) {
				sendChangeEvent();
			}
			showValueText();
		}
		
		/**
		 * @private
		 * @param type
		 */
		protected function sendChangeEvent(type:String = Event.CHANGE):void {
			event(type);
			changeHandler && changeHandler.runWith(_value);
		}
		
		/**
		 * @copy laya.ui.Image#skin
		 * @return
		 */
		public function get skin():String {
			return _skin;
		}
		
		public function set skin(value:String):void {
			if (_skin != value) {
				_skin = value;
				_bg.skin = _skin;
				_bar.skin = _skin.replace(".png", "$bar.png");
				setBarPoint();
			}
		}
		
		/**
		 * @private
		 * 设置滑块的位置信息。
		 */
		protected function setBarPoint():void {
			if (isVertical) _bar.x = (_bg.width - _bar.width) * 0.5;
			else _bar.y = (_bg.height - _bar.height) * 0.5;
		}
		
		/**@inheritDoc */
		override protected function get measureWidth():Number {
			return Math.max(_bg.width, _bar.width);
		}
		
		/**@inheritDoc */
		override protected function get measureHeight():Number {
			return Math.max(_bg.height, _bar.height);
		}
		
		/**@inheritDoc */
		override protected function changeSize():void {
			super.changeSize();
			if (isVertical) _bg.height = height;
			else _bg.width = width;
			setBarPoint();
			changeValue();
		}
		
		/**
		 * <p>当前实例的背景图（ <code>Image</code> ）和滑块按钮（ <code>Button</code> ）实例的有效缩放网格数据。</p>
		 * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		 * <ul><li>例如："4,4,4,4,1"</li></ul></p>
		 * @see laya.ui.AutoBitmap.sizeGrid
		 * @return
		 */
		public function get sizeGrid():String {
			return _bg.sizeGrid;
		}
		
		public function set sizeGrid(value:String):void {
			_bg.sizeGrid = value;
			_bar.sizeGrid = value;
		}
		
		/**
		 * 设置滑动条的信息。
		 * @param min 滑块的最小值。
		 * @param max 滑块的最小值。
		 * @param value 滑块的当前值。
		 */
		public function setSlider(min:Number, max:Number, value:Number):void {
			_value = -1;
			_min = min;
			_max = max > min ? max : min;
			this.value = value < min ? min : value > max ? max : value;
		}
		
		/**
		 * 表示当前的刻度值。默认值为1。
		 * @return
		 */
		public function get tick():Number {
			return _tick;
		}
		
		public function set tick(value:Number):void {
			if (_tick != value) {
				_tick = value;
				callLater(changeValue);
			}
		}
		
		/**
		 * @private
		 * 改变滑块的位置值。
		 */
		protected function changeValue():void {
			//_value = Math.round(_value / _tick) * _tick;			
			var pow:Number = Math.pow(10, (_tick + "").length - 1);
			_value = Math.round(Math.round(_value / _tick) * _tick * pow) / pow;
			
			_value = _value > _max ? _max : _value < _min ? _min : _value;
			if (isVertical) _bar.y = (_value - _min) / (_max - _min) * (height - _bar.height);
			else _bar.x = (_value - _min) / (_max - _min) * (width - _bar.width);
		}
		
		/**
		 * 获取或设置表示最高位置的数字。 默认值为100。
		 */
		public function get max():Number {
			return _max;
		}
		
		public function set max(value:Number):void {
			if (_max != value) {
				_max = value;
				callLater(changeValue);
			}
		}
		
		/**
		 * 获取或设置表示最低位置的数字。 默认值为0。
		 */
		public function get min():Number {
			return _min;
		}
		
		public function set min(value:Number):void {
			if (_min != value) {
				_min = value;
				callLater(changeValue);
			}
		}
		
		/**
		 * 获取或设置表示当前滑块位置的数字。
		 */
		public function get value():Number {
			return _value;
		}
		
		public function set value(num:Number):void {
			if (_value != num) {
				var oldValue:Number = _value;
				_value = num;
				changeValue();
				if (_value != oldValue) {
					sendChangeEvent();
				}
			}
		}
		
		/**
		 * 一个布尔值，指定是否允许通过点击滑动条改变 <code>Slider</code> 的 <code>value</code> 属性值。
		 */
		public function get allowClickBack():Boolean {
			return _allowClickBack;
		}
		
		public function set allowClickBack(value:Boolean):void {
			if (_allowClickBack != value) {
				_allowClickBack = value;
				if (value) _bg.on(Event.MOUSE_DOWN, this, onBgMouseDown);
				else _bg.off(Event.MOUSE_DOWN, this, onBgMouseDown);
			}
		}
		
		/**
		 * @private
		 * 滑动条的 <code>Event.MOUSE_DOWN</code> 事件侦听处理函数。
		 */
		protected function onBgMouseDown(e:Event):void {
			var point:Point = _bg.getMousePoint();
			if (isVertical) value = point.y / (height - _bar.height) * (_max - _min) + _min;
			else value = point.x / (width - _bar.width) * (_max - _min) + _min;
		}
		
		/**@inheritDoc */
		override public function set dataSource(value:*):void {
			_dataSource = value;
			if (value is Number || value is String) this.value = Number(value);
			else super.dataSource = value;
		}
		
		/**
		 * 表示滑块按钮的引用。
		 */
		public function get bar():Button {
			return _bar;
		}
	}
}