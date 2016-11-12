package laya.ui {
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.utils.Ease;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	/**
	 * 滚动条滑块位置发生变化后调度。
	 * @eventType laya.events.Event
	 */
	[Event(name = "change", type = "laya.events.Event")]
	/**
	 * 开始滑动。
	 * @eventType laya.events.Event
	 */
	[Event(name = "start", type = "laya.events.Event")]
	/**
	 * 结束滑动。
	 * @eventType laya.events.Event
	 */
	[Event(name = "end", type = "laya.events.Event")]
	
	/**
	 * <code>ScrollBar</code> 组件是一个滚动条组件。
	 * <p>当数据太多以至于显示区域无法容纳时，最终用户可以使用 <code>ScrollBar</code> 组件控制所显示的数据部分。</p>
	 * <p> 滚动条由四部分组成：两个箭头按钮、一个轨道和一个滑块。 </p>	 *
	 *
	 * @see laya.ui.VScrollBar
	 * @see laya.ui.HScrollBar
	 */
	public class ScrollBar extends Component {
		/**滚动衰减系数*/
		public var rollRatio:Number = 0.95
		/**滚动变化时回调，回传value参数。*/
		public var changeHandler:Handler;
		/**是否缩放滑动条，默认值为true。 */
		public var scaleBar:Boolean = true;
		/**一个布尔值，指定是否自动隐藏滚动条(无需滚动时)，默认值为false。*/
		public var autoHide:Boolean = false;
		/**橡皮筋效果极限距离，0为没有橡皮筋效果。*/
		public var elasticDistance:Number = 0;
		/**橡皮筋回弹时间，单位为毫秒。*/
		public var elasticBackTime:Number = 500;
		/**上按钮 */
		public var upButton:Button;
		/**下按钮 */
		public var downButton:Button;
		/**滑条 */
		public var slider:Slider;
		
		/**@private */
		protected var _showButtons:Boolean = UIConfig.showButtons;
		/**@private */
		protected var _scrollSize:Number = 1;
		/**@private */
		protected var _skin:String;
		/**@private */
		protected var _thumbPercent:Number = 1;
		/**@private */
		protected var _target:Sprite;
		/**@private */
		protected var _lastPoint:Point;
		/**@private */
		protected var _lastOffset:Number = 0;
		/**@private */
		protected var _checkElastic:Boolean = false;
		/**@private */
		protected var _isElastic:Boolean = false;
		/**@private */
		protected var _value:Number;
		/**@private */
		protected var _hide:Boolean = false;
		/**@private */
		protected var _clickOnly:Boolean = true;
		/**@private */
		protected var _offsets:Array;
		/**@private */
		protected var _touchScrollEnable:Boolean = UIConfig.touchScrollEnable;
		/**@private */
		protected var _mouseWheelEnable:Boolean = UIConfig.mouseWheelEnable;
		
		/**
		 * 创建一个新的 <code>ScrollBar</code> 实例。
		 * @param skin 皮肤资源地址。
		 */
		public function ScrollBar(skin:String = null):void {
			this.skin = skin;
			this.max = 1;
		}
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			upButton && upButton.destroy(destroyChild);
			downButton && downButton.destroy(destroyChild);
			slider && slider.destroy(destroyChild);
			upButton = downButton = null;
			slider = null;
			changeHandler = null;
			_offsets = null;
		}
		
		/**@inheritDoc */
		override protected function createChildren():void {
			addChild(slider = new Slider());
			//TODO:
			addChild(upButton = new Button());
			addChild(downButton = new Button());
		}
		
		/**@inheritDoc */
		override protected function initialize():void {
			slider.showLabel = false;
			slider.on(Event.CHANGE, this, onSliderChange);
			slider.setSlider(0, 0, 0);
			upButton.on(Event.MOUSE_DOWN, this, onButtonMouseDown);
			downButton.on(Event.MOUSE_DOWN, this, onButtonMouseDown);
		}
		
		/**
		 * @private
		 * 滑块位置发生改变的处理函数。
		 */
		protected function onSliderChange():void {
			value = slider.value;
		}
		
		/**
		 * @private
		 * 向上和向下按钮的 <code>Event.MOUSE_DOWN</code> 事件侦听处理函数。
		 */
		protected function onButtonMouseDown(e:Event):void {
			var isUp:Boolean = e.currentTarget === upButton;
			slide(isUp);
			Laya.timer.once(Styles.scrollBarDelayTime, this, startLoop, [isUp]);
			Laya.stage.once(Event.MOUSE_UP, this, onStageMouseUp);
		}
		
		/**@private */
		protected function startLoop(isUp:Boolean):void {
			Laya.timer.frameLoop(1, this, slide, [isUp]);
		}
		
		/**@private */
		protected function slide(isUp:Boolean):void {
			if (isUp) value -= _scrollSize;
			else value += _scrollSize;
		}
		
		/**
		 * @private
		 * 舞台的 <code>Event.MOUSE_DOWN</code> 事件侦听处理函数。
		 */
		protected function onStageMouseUp(e:Event):void {
			Laya.timer.clear(this, startLoop);
			Laya.timer.clear(this, slide);
		}
		
		/**
		 * @copy laya.ui.Image#skin
		 */
		public function get skin():String {
			return _skin;
		}
		
		public function set skin(value:String):void {
			if (_skin != value) {
				_skin = value;
				slider.skin = _skin;
				callLater(changeScrollBar);
			}
		}
		
		/**
		 * @private
		 * 更改对象的皮肤及位置。
		 */
		protected function changeScrollBar():void {
			upButton.visible = _showButtons;
			downButton.visible = _showButtons;
			if (_showButtons) {
				upButton.skin = _skin.replace(".png", "$up.png");
				downButton.skin = _skin.replace(".png", "$down.png");
			}
			if (slider.isVertical) slider.y = _showButtons ? upButton.height : 0;
			else slider.x = _showButtons ? upButton.width : 0;
			resetPositions();
		}
		
		/**@inheritDoc */
		override protected function changeSize():void {
			super.changeSize();
			resetPositions();
			event(Event.CHANGE);
			changeHandler && changeHandler.runWith(value);
		}
		
		/**@private */
		private function resetPositions():void {
			if (slider.isVertical) slider.height = height - (_showButtons ? (upButton.height + downButton.height) : 0);
			else slider.width = width - (_showButtons ? (upButton.width + downButton.width) : 0);
			resetButtonPosition();
		
		}
		
		/**@private */
		protected function resetButtonPosition():void {
			if (slider.isVertical) downButton.y = slider.y + slider.height;
			else downButton.x = slider.x + slider.width;
		}
		
		/**@inheritDoc */
		override protected function get measureWidth():Number {
			if (slider.isVertical) return slider.width;
			return 100;
		}
		
		/**@inheritDoc */
		override protected function get measureHeight():Number {
			if (slider.isVertical) return 100;
			return slider.height;
		}
		
		/**
		 * 设置滚动条信息。
		 * @param min 滚动条最小位置值。
		 * @param max 滚动条最大位置值。
		 * @param value 滚动条当前位置值。
		 */
		public function setScroll(min:Number, max:Number, value:Number):void {
			runCallLater(changeSize);
			slider.setSlider(min, max, value);
			//_upButton.disabled = max <= 0;
			//_downButton.disabled = max <= 0;
			slider.bar.visible = max > 0;
			if (!_hide && autoHide) visible = false;
		}
		
		/**
		 * 获取或设置表示最高滚动位置的数字。
		 */
		public function get max():Number {
			return slider.max;
		}
		
		public function set max(value:Number):void {
			slider.max = value;
		}
		
		/**
		 * 获取或设置表示最低滚动位置的数字。
		 */
		public function get min():Number {
			return slider.min;
		}
		
		public function set min(value:Number):void {
			slider.min = value;
		}
		
		/**
		 * 获取或设置表示当前滚动位置的数字。
		 */
		public function get value():Number {
			return _value;
		}
		
		public function set value(v:Number):void {
			if (v !== _value) {
				if (_isElastic) _value = v;
				else {
					slider.value = v;
					_value = slider.value;
				}
				event(Event.CHANGE);
				changeHandler && changeHandler.runWith(value);
			}
		}
		
		/**
		 * 一个布尔值，指示滚动条是否为垂直滚动。如果值为true，则为垂直滚动，否则为水平滚动。
		 * <p>默认值为：true。</p>
		 */
		public function get isVertical():Boolean {
			return slider.isVertical;
		}
		
		public function set isVertical(value:Boolean):void {
			slider.isVertical = value;
		}
		
		/**
		 * <p>当前实例的 <code>Slider</code> 实例的有效缩放网格数据。</p>
		 * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		 * <ul><li>例如："4,4,4,4,1"</li></ul></p>
		 * @see laya.ui.AutoBitmap.sizeGrid
		 */
		public function get sizeGrid():String {
			return slider.sizeGrid;
		}
		
		public function set sizeGrid(value:String):void {
			slider.sizeGrid = value;
		}
		
		/**获取或设置一个值，该值表示按下滚动条轨道时页面滚动的增量。 */
		public function get scrollSize():Number {
			return _scrollSize;
		}
		
		public function set scrollSize(value:Number):void {
			_scrollSize = value;
		}
		
		/**@inheritDoc */
		override public function set dataSource(value:*):void {
			_dataSource = value;
			if (value is Number || value is String) this.value = Number(value);
			else super.dataSource = value;
		}
		
		/**获取或设置一个值，该值表示滑条长度比例，值为：（0-1）。 */
		public function get thumbPercent():Number {
			return _thumbPercent;
		}
		
		public function set thumbPercent(value:Number):void {
			runCallLater(changeScrollBar);
			runCallLater(changeSize);
			value = value >= 1 ? 0.99 : value;
			_thumbPercent = value;
			if (scaleBar) {
				if (slider.isVertical) slider.bar.height = Math.max(slider.height * value, Styles.scrollBarMinNum);
				else slider.bar.width = Math.max(slider.width * value, Styles.scrollBarMinNum);
			}
		}
		
		/**
		 * 设置滚动对象。
		 * @see laya.ui.TouchScroll#target
		 */
		public function get target():Sprite {
			return _target;
		}
		
		public function set target(value:Sprite):void {
			if (_target) {
				_target.off(Event.MOUSE_WHEEL, this, onTargetMouseWheel);
				_target.off(Event.MOUSE_DOWN, this, onTargetMouseDown);
			}
			_target = value;
			if (value) {
				_mouseWheelEnable && _target.on(Event.MOUSE_WHEEL, this, onTargetMouseWheel);
				_touchScrollEnable && _target.on(Event.MOUSE_DOWN, this, onTargetMouseDown);
			}
		}
		
		/**是否隐藏滚动条，不显示滚动条，但是可以正常滚动，默认为false。*/
		public function get hide():Boolean {
			return _hide;
		}
		
		public function set hide(value:Boolean):void {
			_hide = value;
			visible = !value;
		}
		
		/**一个布尔值，指定是否显示向上、向下按钮，默认值为true。*/
		public function get showButtons():Boolean {
			return _showButtons;
		}
		
		public function set showButtons(value:Boolean):void {
			_showButtons = value;
			callLater(changeScrollBar);
		}
		
		/**一个布尔值，指定是否开启触摸，默认值为true。*/
		public function get touchScrollEnable():Boolean {
			return _touchScrollEnable;
		}
		
		public function set touchScrollEnable(value:Boolean):void {
			_touchScrollEnable = value;
			target = _target;
		}
		
		/** 一个布尔值，指定是否滑轮滚动，默认值为true。*/
		public function get mouseWheelEnable():Boolean {
			return _mouseWheelEnable;
		}
		
		public function set mouseWheelEnable(value:Boolean):void {
			_mouseWheelEnable = value;
		}
		
		/**@private */
		protected function onTargetMouseWheel(e:Event):void {
			value -= e.delta * _scrollSize;
			target = _target;
		}
		
		/**@private */
		protected function onTargetMouseDown(e:Event):void {
			_clickOnly = true;
			_lastOffset = 0;
			_checkElastic = false;
			_lastPoint || (_lastPoint = new Point());
			_lastPoint.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
			Laya.timer.clear(this, tweenMove);
			Tween.clearTween(this);
			Laya.stage.once(Event.MOUSE_UP, this, onStageMouseUp2);
			Laya.stage.once(Event.MOUSE_OUT, this, onStageMouseUp2);
			Laya.timer.frameLoop(1, this, loop);
		}
		
		/**@private */
		protected function loop():void {
			var mouseY:Number = Laya.stage.mouseY;
			var mouseX:Number = Laya.stage.mouseX;
			_lastOffset = isVertical ? (mouseY - _lastPoint.y) : (mouseX - _lastPoint.x);
			
			if (_clickOnly) {
				if (Math.abs(_lastOffset * (isVertical ? Laya.stage._canvasTransform.getScaleY() : Laya.stage._canvasTransform.getScaleX())) > 1) {
					_clickOnly = false;
					_offsets || (_offsets = []);
					_offsets.length = 0;
					_target.mouseEnabled = false;
					if (!hide && autoHide) {
						alpha = 1;
						visible = true;
					}
					event(Event.START);
				} else return;
			}
			_offsets.push(_lastOffset);
			
			_lastPoint.x = mouseX;
			_lastPoint.y = mouseY;
			
			if (_lastOffset === 0) return;
			
			if (!this._checkElastic) {
				if (this.elasticDistance > 0) {
					if (!this._checkElastic && _lastOffset != 0) {
						this._checkElastic = true;
						if ((_lastOffset > 0 && _value <= min) || (_lastOffset < 0 && _value >= max)) {
							this._isElastic = true;
						} else {
							this._isElastic = false;
						}
					}
				} else {
					_checkElastic = true;
				}
			}
			if (this._checkElastic) {
				if (this._isElastic) {
					if (_value <= min) {
						value -= _lastOffset * Math.max(0, (1 - ((min - _value) / elasticDistance)));
					} else if (_value >= max) {
						value -= _lastOffset * Math.max(0, (1 - ((_value - max) / elasticDistance)));
					}
				} else {
					value -= _lastOffset;
				}
			}
		}
		
		/**@private */
		protected function onStageMouseUp2(e:Event):void {
			Laya.stage.off(Event.MOUSE_UP, this, onStageMouseUp2);
			Laya.stage.off(Event.MOUSE_OUT, this, onStageMouseUp2);
			Laya.timer.clear(this, loop);
			
			if (_clickOnly) return;
			_target.mouseEnabled = true;
			
			if (this._isElastic) {
				if (_value < min) {
					Tween.to(this, {value: min}, elasticBackTime, Ease.sineOut, Handler.create(this, elasticOver));
				} else if (_value > max) {
					Tween.to(this, {value: max}, elasticBackTime, Ease.sineOut, Handler.create(this, elasticOver));
				}
			} else {
				//计算平均值
				if (_offsets.length < 1) {
					_offsets[0] = isVertical ? Laya.stage.mouseY - _lastPoint.y : Laya.stage.mouseX - _lastPoint.x;
				}
				var offset:Number = 0;
				var n:Number = Math.min(_offsets.length, 3);
				for (var i:int = 0; i < n; i++) {
					offset += _offsets[_offsets.length - 1 - i];
				}
				_lastOffset = offset / n;
				
				offset = Math.abs(_lastOffset);
				if (offset < 2) {
					event(Event.END);
					return;
				}
				if (offset > 60) _lastOffset = _lastOffset > 0 ? 60 : -60;
				Laya.timer.frameLoop(1, this, tweenMove);
			}
		}
		
		/**@private */
		private function elasticOver():void {
			this._isElastic = false;
			if (!hide && autoHide) {
				Tween.to(this, {alpha: 0}, 500);
			}
			event(Event.END);
		}
		
		/**@private */
		protected function tweenMove():void {
			_lastOffset *= rollRatio;
			value -= _lastOffset;
			if (Math.abs(_lastOffset) < 1 || value== max || value == min) {
				Laya.timer.clear(this, tweenMove);
				event(Event.END);
				if (!hide && autoHide) {
					Tween.to(this, {alpha: 0}, 500);
				}
			}
		}
		
		/**
		 * 停止滑动。
		 */
		public function stopScroll():void {
			onStageMouseUp2(null);
			Laya.timer.clear(this, tweenMove);
			Tween.clearTween(this);
		}
	}
}