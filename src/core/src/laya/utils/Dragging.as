package laya.utils {
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.events.MouseManager;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	
	/**
	 * @private
	 * <code>Dragging</code> 类是触摸滑动控件。
	 */
	public class Dragging {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/** 被拖动的对象。*/
		public var target:Sprite;
		/** 缓动衰减系数。*/
		public var ratio:Number = 0.92;
		/** 单帧最大偏移量。*/
		public var maxOffset:Number = 60;
		/** 滑动范围。*/
		public var area:Rectangle;
		/** 表示拖动是否有惯性。*/
		public var hasInertia:Boolean;
		/** 橡皮筋最大值。*/
		public var elasticDistance:Number;
		/** 橡皮筋回弹时间，单位为毫秒。*/
		public var elasticBackTime:Number;
		/** 事件携带数据。*/
		public var data:Object;
		
		private var _dragging:Boolean = false;
		private var _clickOnly:Boolean = true;
		private var _elasticRateX:Number;
		private var _elasticRateY:Number;
		private var _lastX:Number;
		private var _lastY:Number;
		private var _offsetX:Number;
		private var _offsetY:Number;
		private var _offsets:Array;
		private var _disableMouseEvent:Boolean;
		private var _tween:Tween;
		private var _parent:Sprite;
		
		/**
		 * 开始拖拽。
		 * @param	target 待拖拽的 <code>Sprite</code> 对象。
		 * @param	area 滑动范围。
		 * @param	hasInertia 拖动是否有惯性。
		 * @param	elasticDistance 橡皮筋最大值。
		 * @param	elasticBackTime 橡皮筋回弹时间，单位为毫秒。
		 * @param	data 事件携带数据。
		 * @param	disableMouseEvent 鼠标事件是否有效。
		 * @param	ratio 惯性阻尼系数
		 */
		public function start(target:Sprite, area:Rectangle, hasInertia:Boolean, elasticDistance:Number, elasticBackTime:int, data:*, disableMouseEvent:Boolean, ratio:Number = 0.92):void {
			clearTimer();
			
			this.target = target;
			this.area = area;
			this.hasInertia = hasInertia;
			this.elasticDistance = area ? elasticDistance : 0;
			this.elasticBackTime = elasticBackTime;
			this.data = data;
			this._disableMouseEvent = disableMouseEvent;
			this.ratio = ratio;
			
			if (target.globalScaleX != 1 || target.globalScaleY != 1) {
				_parent = target.parent as Sprite;
			} else {
				_parent = Laya.stage;
			}
			
			_clickOnly = true;
			_dragging = true;
			_elasticRateX = _elasticRateY = 1;
			_lastX = _parent.mouseX;
			_lastY = _parent.mouseY;
			
			Laya.stage.on(Event.MOUSE_UP, this, onStageMouseUp);
			Laya.stage.on(Event.MOUSE_OUT, this, onStageMouseUp);
			//Laya.stage.on(Event.MOUSE_MOVE, this, onStageMouseMove);
			Laya.timer.frameLoop(1, this, loop);
		}
		
		/**
		 * 清除计时器。
		 */
		private function clearTimer():void {
			Laya.timer.clear(this, loop);
			Laya.timer.clear(this, tweenMove);
			if (_tween) {
				_tween.recover();
				_tween = null;
			}
		}
		
		/**
		 * 停止拖拽。
		 */
		public function stop():void {
			if (_dragging) {
				MouseManager.instance.disableMouseEvent = false;
				Laya.stage.off(Event.MOUSE_UP, this, onStageMouseUp);
				Laya.stage.off(Event.MOUSE_OUT, this, onStageMouseUp);
				_dragging = false;
				target && area && backToArea();
				clear();
			}
		}
		
		/**
		 * 拖拽的循环处理函数。
		 */
		private function loop():void {
			var point:Point = _parent.getMousePoint();
			var mouseX:Number = point.x;
			var mouseY:Number = point.y;
			var offsetX:Number = mouseX - _lastX;
			var offsetY:Number = mouseY - _lastY;
			
			if (_clickOnly) {
				if (Math.abs(offsetX * Laya.stage._canvasTransform.getScaleX()) > 1 || Math.abs(offsetY * Laya.stage._canvasTransform.getScaleY()) > 1) {
					_clickOnly = false;
					_offsets || (_offsets = []);
					_offsets.length = 0;
					target.event(Event.DRAG_START, data);
					MouseManager.instance.disableMouseEvent = _disableMouseEvent;
					target._set$P("$_MOUSEDOWN", false);
				} else return;
			} else {
				_offsets.push(offsetX, offsetY);
			}
			if (offsetX === 0 && offsetY === 0) return;
			
			_lastX = mouseX;
			_lastY = mouseY;
			target.x += offsetX * _elasticRateX;
			target.y += offsetY * _elasticRateY;
			
			area && checkArea();
			
			target.event(Event.DRAG_MOVE, data);
		}
		
		/**
		 * 拖拽区域检测。
		 */
		private function checkArea():void {
			if (elasticDistance <= 0) {
				backToArea();
			} else {
				if (target.x < area.x) {
					var offsetX:Number = area.x - target.x;
				} else if (target.x > area.x + area.width) {
					offsetX = target.x - area.x - area.width;
				} else {
					offsetX = 0;
				}
				_elasticRateX = Math.max(0, 1 - (offsetX / elasticDistance));
				
				if (target.y < area.y) {
					var offsetY:Number = area.y - target.y;
				} else if (target.y > area.y + area.height) {
					offsetY = target.y - area.y - area.height;
				} else {
					offsetY = 0;
				}
				_elasticRateY = Math.max(0, 1 - (offsetY / elasticDistance));
			}
		}
		
		/**
		 * 移动至设定的拖拽区域。
		 */
		private function backToArea():void {
			target.x = Math.min(Math.max(target.x, area.x), area.x + area.width);
			target.y = Math.min(Math.max(target.y, area.y), area.y + area.height);
		}
		
		/**
		 * 舞台的抬起事件侦听函数。
		 * @param	e Event 对象。
		 */
		private function onStageMouseUp(e:Event):void {
			MouseManager.instance.disableMouseEvent = false;
			Laya.stage.off(Event.MOUSE_UP, this, onStageMouseUp);
			Laya.stage.off(Event.MOUSE_OUT, this, onStageMouseUp);
			//Laya.stage.off(Event.MOUSE_MOVE, this, onStageMouseMove);
			Laya.timer.clear(this, loop);
			
			if (_clickOnly || !target) return;
			//target.mouseEnabled = true;
			
			if (hasInertia) {
				//计算平均值
				if (_offsets.length < 1) {
					_offsets.push(_parent.mouseX - _lastX, _parent.mouseY - _lastY);
				}
				
				_offsetX = _offsetY = 0;
				var len:int = _offsets.length;
				var n:Number = Math.min(len, 6);
				var m:int = _offsets.length - n;
				for (var i:int = len - 1; i > m; i--) {
					_offsetY += _offsets[i--];
					_offsetX += _offsets[i];
				}
				
				_offsetX = _offsetX / n * 2;
				_offsetY = _offsetY / n * 2;
				
				if (Math.abs(_offsetX) > maxOffset) _offsetX = _offsetX > 0 ? maxOffset : -maxOffset;
				if (Math.abs(_offsetY) > maxOffset) _offsetY = _offsetY > 0 ? maxOffset : -maxOffset;
				Laya.timer.frameLoop(1, this, tweenMove);
			} else if (elasticDistance > 0) {
				checkElastic();
			} else {
				clear();
			}
		}
		
		/**
		 * 橡皮筋效果检测。
		 */
		private function checkElastic():void {
			var tx:Number = NaN;
			var ty:Number = NaN;
			if (target.x < area.x) tx = area.x;
			else if (target.x > area.x + area.width) tx = area.x + area.width;
			
			if (target.y < area.y) ty = area.y;
			else if (target.y > area.y + area.height) ty = area.y + area.height;
			
			if (!isNaN(tx) || !isNaN(ty)) {
				var obj:Object = {};
				if (!isNaN(tx)) obj.x = tx;
				if (!isNaN(ty)) obj.y = ty;
				_tween = Tween.to(target, obj, elasticBackTime, Ease.sineOut, Handler.create(this, clear), 0, false, false);
			} else {
				clear();
			}
		}
		
		/**
		 * 移动。
		 */
		private function tweenMove():void {
			_offsetX *= ratio * _elasticRateX;
			_offsetY *= ratio * _elasticRateY;
			
			target.x += _offsetX;
			target.y += _offsetY;
			
			area && checkArea();
			
			target.event(Event.DRAG_MOVE, data);
			
			if ((Math.abs(_offsetX) < 1 && Math.abs(_offsetY) < 1) || _elasticRateX < 0.5 || _elasticRateY < 0.5) {
				Laya.timer.clear(this, tweenMove);
				if (elasticDistance > 0) checkElastic();
				else clear();
			}
		}
		
		/**
		 * 结束拖拽。
		 */
		private function clear():void {
			if (this.target) {
				clearTimer();
				var sp:Sprite = this.target;
				this.target = null;
				this._parent = null;
				sp.event(Event.DRAG_END, data);
			}
		}
	}
}