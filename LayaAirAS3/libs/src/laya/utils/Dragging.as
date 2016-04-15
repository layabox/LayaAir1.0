package laya.utils {
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.events.MouseManager;
	import laya.maths.Rectangle;
	
	/**
	 * 触摸滑动控件
	 * @author yung
	 */
	public class Dragging {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**被拖动的对象*/
		public var target:Sprite;
		/**缓动衰减系数*/
		public var ratio:Number = 0.92;
		/**单帧最大偏移量*/
		public var maxOffset:Number = 60;
		/**滑动范围*/
		public var area:Rectangle;
		/**拖动是否有惯性*/
		public var hasInertia:Boolean;
		/**橡皮筋最大值*/
		public var elasticDistance:Number;
		/**橡皮筋回弹时间，单位为毫秒*/
		public var elasticBackTime:Number;
		/**事件携带数据*/
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
		
		public function start(target:Sprite, area:Rectangle, hasInertia:Boolean, elasticDistance:Number, elasticBackTime:int, data:*, disableMouseEvent:Boolean):void {
			clearTimer();
			
			this.target = target;
			this.area = area;
			this.hasInertia = hasInertia;
			this.elasticDistance = elasticDistance;
			this.elasticBackTime = elasticBackTime;
			this.data = data;
			this._disableMouseEvent = disableMouseEvent;
			
			_clickOnly = true;
			_dragging = true;
			_elasticRateX = _elasticRateY = 1;
			_lastX = Laya.stage.mouseX;
			_lastY = Laya.stage.mouseY;
			
			Laya.stage.on(Event.MOUSE_UP, this, onStageMouseUp);
			Laya.stage.on(Event.MOUSE_OUT, this, onStageMouseUp);
			//Laya.stage.on(Event.MOUSE_MOVE, this, onStageMouseMove);
			Laya.timer.frameLoop(1, this, loop);
		}
		
		private function clearTimer():void {
			Laya.timer.clear(this, loop);
			Laya.timer.clear(this, tweenMove);
			if (_tween) {
				_tween.recover();
				_tween = null;
			}
		}
		
		public function stop():void {
			if (_dragging) {
				MouseManager.instance.disableMouseEvent = false;
				Laya.stage.off(Event.MOUSE_UP, this, onStageMouseUp);
				Laya.stage.off(Event.MOUSE_OUT, this, onStageMouseUp);
				_dragging = false;
				target && area && backToArea();
				//target && (target.mouseEnabled = true);
				clear();
			}
		}
		
		private function loop():void {
			var mouseX:Number = Laya.stage.mouseX;
			var mouseY:Number = Laya.stage.mouseY;
			var offsetX:Number = mouseX - _lastX;
			var offsetY:Number = mouseY - _lastY;
			
			if (_clickOnly) {
				if (Math.abs(offsetX * Laya.stage._canvasTransform.getScaleX()) > 1 || Math.abs(offsetY * Laya.stage._canvasTransform.getScaleY()) > 1) {
					_clickOnly = false;
					_offsets || (_offsets = []);
					_offsets.length = 0;
					target.event(Event.DRAG_START, data);
					MouseManager.instance.disableMouseEvent = _disableMouseEvent;
					target["$_MOUSEDOWN"] = false;
						//target.mouseEnabled = false;
				} else return;
			} else {
				_offsets.push(offsetX, offsetY);
				_lastX = mouseX;
				_lastY = mouseY;
			}
			if (offsetX === 0 && offsetY === 0) return;
			
			target.x += offsetX * _elasticRateX;
			target.y += offsetY * _elasticRateY;
			
			area && checkArea();
			
			target.event(Event.DRAG_MOVE, data);
		}
		
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
		
		private function backToArea():void {
			target.x = Math.min(Math.max(target.x, area.x), area.x + area.width);
			target.y = Math.min(Math.max(target.y, area.y), area.y + area.height);
		}
		
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
					_offsets.push(Laya.stage.mouseX - _lastX, Laya.stage.mouseY - _lastY);
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
		
		private function clear():void {
			if (this.target) {
				clearTimer();
				var sp:Sprite = this.target;
				this.target = null;
				sp.event(Event.DRAG_END, data);
			}
		}
	}
}