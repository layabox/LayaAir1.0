package laya.events {
	
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.utils.Browser;
	
	/**
	 * <code>MouseManager</code> 是鼠标、触摸交互管理器。
	 */
	public class MouseManager {
		/**
		 * MouseManager 单例引用。
		 */
		public static const instance:MouseManager = new MouseManager();
		
		/**是否开启鼠标检测，默认为true*/
		public static var enabled:Boolean = true;
		/** canvas 上的鼠标X坐标。*/
		public var mouseX:Number = 0;
		/** canvas 上的鼠标Y坐标。*/
		public var mouseY:Number = 0;
		/** 是否禁用除 stage 以外的鼠标事件检测。*/
		public var disableMouseEvent:Boolean = false;
		/** 鼠标按下的时间。单位为毫秒。*/
		public var mouseDownTime:Number = 0;
		/** @private */
		public var _event:Event = new Event();
		private var _stage:Stage;
		private var _matrix:Matrix = new Matrix();
		private var _point:Point = new Point();
		private var _rect:Rectangle = new Rectangle();
		private var _target:*;
		private var _lastOvers:Array = [];
		private var _currOvers:Array = [];
		private var _lastClickTimer:Number = 0;
		private var _lastMoveTimer:Number = 0;
		private var _isDoubleClick:Boolean = false;
		private var _isLeftMouse:Boolean;
		private var _eventList:Array = [];
		
		/**
		 * @private
		 * 初始化。
		 */
		public function __init__():void {
			this._stage = Laya.stage;
			var _this:MouseManager = this;
			var canvas:* = Render.canvas.source;
			var list:Array = _eventList;
			
			Browser.document.oncontextmenu = function(e:*):* {
				if (enabled) return false;
			}
			canvas.addEventListener('mousedown', function(e:*):void {
				if (enabled) {
					e.preventDefault();
					list.push(e);
					_this.mouseDownTime = Browser.now();
				}
			});
			canvas.addEventListener('mouseup', function(e:*):void {
				if (enabled) {
					e.preventDefault();
					list.push(e);
					_this.mouseDownTime = -Browser.now();
				}
			}, true);
			Browser.document.addEventListener('mousemove', function(e:*):void {
				if (enabled) {
					//e.preventDefault();
					var now:Number = Browser.now();
					if (now - _this._lastMoveTimer < 10) return;
					_this._lastMoveTimer = now;
					list.push(e);
				}
			}, true);
			canvas.addEventListener("mouseout", function(e:*):void {
				if (enabled) list.push(e);
			})
			canvas.addEventListener("mouseover", function(e:*):void {
				if (enabled) list.push(e);
			})
			canvas.addEventListener("touchstart", function(e:*):void {
				if (enabled) {
					e.preventDefault();
					list.push(e);
					_this.mouseDownTime = Browser.now();
				}
			});
			canvas.addEventListener("touchend", function(e:*):void {
				if (enabled) {
					e.preventDefault();
					list.push(e);
					_this.mouseDownTime = -Browser.now();
				}
			}, true);
			canvas.addEventListener("touchmove", function(e:*):void {
				if (enabled) {
					e.preventDefault();
					list.push(e);
				}
			}, true);
			canvas.addEventListener('mousewheel', function(e:*):void {
				if (enabled) list.push(e);
			});
			canvas.addEventListener('DOMMouseScroll', function(e:*):void {
				if (enabled) list.push(e);
			});
		}
		
		private function initEvent(e:*, nativeEvent:* = null):void {
			var _this:MouseManager = MouseManager.instance;
			
			_this._event._stoped = false;
			_this._event.nativeEvent = nativeEvent || e;
			_this._target = null;
			
			_point.setTo(e.clientX, e.clientY);
			_stage._canvasTransform.invertTransformPoint(_point);
			
			e.stageX = _this.mouseX = _point.x;
			e.stageY = _this.mouseY = _point.y;
			_this._event.touchId = e.identifier;
		}
		
		private function checkMouseWheel(e:*):void {
			_event.delta = e.wheelDelta ? e.wheelDelta * 0.025 : -e.detail;
			for (var i:int = 0, n:int = _lastOvers.length; i < n; i++) {
				var ele:* = _lastOvers[i];
				ele.event(Event.MOUSE_WHEEL, _event.setTo(Event.MOUSE_WHEEL, ele, _target));
			}
		}
		
		private function checkMouseOut():void {
			if (disableMouseEvent) return;
			for (var i:int = 0, n:int = _lastOvers.length; i < n; i++) {
				var ele:* = _lastOvers[i];
				if (!ele.destroyed && _currOvers.indexOf(ele) < 0) {
					ele._set$P("$_MOUSEOVER", false);
					ele.event(Event.MOUSE_OUT, _event.setTo(Event.MOUSE_OUT, ele, _target));
				}
			}
			var temp:Array = _lastOvers;
			_lastOvers = _currOvers;
			_currOvers = temp;
			_currOvers.length = 0;
		}
		
		private function onMouseMove(ele:*):void {
			sendMouseMove(ele);
			_event._stoped = false;
			sendMouseOver(_target);
		}
		
		private function sendMouseMove(ele:*):void {
			ele.event(Event.MOUSE_MOVE, _event.setTo(Event.MOUSE_MOVE, ele, _target));
			!_event._stoped && ele.parent && sendMouseMove(ele.parent);
		}
		
		private function sendMouseOver(ele:*):void {
			if (ele.parent) {
				if (!ele._get$P("$_MOUSEOVER")) {
					ele._set$P("$_MOUSEOVER", true);
					ele.event(Event.MOUSE_OVER, _event.setTo(Event.MOUSE_OVER, ele, _target));
				}
				_currOvers.push(ele);
			}
			!_event._stoped && ele.parent && sendMouseOver(ele.parent);
		}
		
		private function onMouseDown(ele:*):void {
			if (_isLeftMouse) {
				ele._set$P("$_MOUSEDOWN", true);
				ele.event(Event.MOUSE_DOWN, _event.setTo(Event.MOUSE_DOWN, ele, _target));
			} else {
				ele._set$P("$_RIGHTMOUSEDOWN", true);
				ele.event(Event.RIGHT_MOUSE_DOWN, _event.setTo(Event.RIGHT_MOUSE_DOWN, ele, _target));
			}
			!_event._stoped && ele.parent && onMouseDown(ele.parent);
		}
		
		private function onMouseUp(ele:*):void {
			var type:String = _isLeftMouse ? Event.MOUSE_UP : Event.RIGHT_MOUSE_UP;
			sendMouseUp(ele, type);
			_event._stoped = false;
			sendClick(_target, type);
		}
		
		private function sendMouseUp(ele:*, type:String):void {
			ele.event(type, _event.setTo(type, ele, _target));
			!_event._stoped && ele.parent && sendMouseUp(ele.parent, type);
		}
		
		private function sendClick(ele:*, type:String):void {
			if (type === Event.MOUSE_UP && ele._get$P("$_MOUSEDOWN")) {
				ele._set$P("$_MOUSEDOWN", false);
				ele.event(Event.CLICK, _event.setTo(Event.CLICK, ele, _target));
				_isDoubleClick && ele.event(Event.DOUBLE_CLICK, _event.setTo(Event.DOUBLE_CLICK, ele, _target));
			} else if (type === Event.RIGHT_MOUSE_UP && ele._get$P("$_RIGHTMOUSEDOWN")) {
				ele._set$P("$_RIGHTMOUSEDOWN", false);
				ele.event(Event.RIGHT_CLICK, _event.setTo(Event.RIGHT_CLICK, ele, _target));
			}
			!_event._stoped && ele.parent && sendClick(ele.parent, type);
		}
		
		private function check(sp:Sprite, mouseX:Number, mouseY:Number, callBack:Function):Boolean {
			var transform:Matrix = sp.transform || this._matrix;
			var pivotX:Number = sp.pivotX;
			var pivotY:Number = sp.pivotY;
			
			//设置矩阵信息为相对父亲的偏移
			if (pivotX === 0 && pivotY === 0) {
				transform.setTranslate(sp.x, sp.y);
			} else {
				//如果有轴心旋转，则矩阵信息加上轴心的影响
				if (transform === this._matrix) {
					transform.setTranslate(sp.x - pivotX, sp.y - pivotY);
				} else {
					var cos:Number = transform.cos;
					var sin:Number = transform.sin;
					transform.setTranslate(sp.x - (pivotX * cos - pivotY * sin) * sp.scaleX, sp.y - (pivotX * sin + pivotY * cos) * sp.scaleY);
				}
			}
			
			//变换鼠标坐标到节点坐标系
			transform.invertTransformPoint(this._point.setTo(mouseX, mouseY));
			//重置transform
			transform.setTranslate(0, 0);
			mouseX = this._point.x;
			mouseY = this._point.y;
			
			//如果有裁剪，则先判断是否在裁剪范围内
			var scrollRect:Rectangle = sp.scrollRect;
			if (scrollRect) {
				_rect.setTo(0, 0, scrollRect.width, scrollRect.height);
				var isHit:Boolean = _rect.contains(mouseX, mouseY);
				if (!isHit) return false;
			}
			
			//先判定子对象是否命中
			if (!disableMouseEvent) {
				var flag:Boolean = false;
				for (var i:int = sp._childs.length - 1; i > -1; i--) {
					var child:Sprite = sp._childs[i];
					//只有接受交互事件的，才进行处理
					if (child.mouseEnabled && child.visible) {
						flag = check(child, mouseX + (scrollRect ? scrollRect.x : 0), mouseY + (scrollRect ? scrollRect.y : 0), callBack);
						if (flag) return true;
					}
				}
			}
			
			if (sp.width > 0 && sp.height > 0) {
				//判断是否在矩形区域内
				var graphicHit:Boolean = false;
				var hitRect:Rectangle = this._rect;
				if (!sp.mouseThrough) {
					if (sp.hitArea) hitRect = sp.hitArea;
					else hitRect.setTo(0, 0, sp.width, sp.height);
					isHit = hitRect.contains(mouseX, mouseY);
				} else {
					//如果可穿透，则根据子对象实际大小进行碰撞
					//var rect:Rectangle = sp.getSelfBounds();
					//hitRect.setTo(rect.x, rect.y, rect.width, rect.height);
					isHit = sp.getGraphicBounds().contains(mouseX, mouseY);
				}
				
				if (isHit) {
					_target = sp;
					callBack.call(this, sp);
				}
				
					//if (callBack == onMouseDown) {					
					//trace("hit", sp.name, isHit, sp);
					//}
			}
			
			return isHit;
		}
		
		/**
		 * 执行事件处理。
		 */
		public function runEvent():void {
			var len:int = _eventList.length;
			if (!len) return;
			
			var _this:MouseManager = this;
			var i:int = 0;
			while (i < len) {
				var evt:* = _eventList[i];
				switch (evt.type) {
				case 'mousedown': 
					_this._isLeftMouse = evt.button === 0;
					_this.initEvent(evt);
					_this.check(_this._stage, _this.mouseX, _this.mouseY, _this.onMouseDown);
					break;
				case 'mouseup': 
					_this._isLeftMouse = evt.button === 0;
					var now:Number = Browser.now();
					_this._isDoubleClick = (now - _this._lastClickTimer) < 300;
					_this._lastClickTimer = now;
					
					_this.initEvent(evt);
					_this.check(_this._stage, _this.mouseX, _this.mouseY, _this.onMouseUp);
					break;
				case 'mousemove': 
					_this.initEvent(evt);
					_this.check(_this._stage, _this.mouseX, _this.mouseY, _this.onMouseMove);
					_this.checkMouseOut();
					break;
				case "touchstart": 
					_this._isLeftMouse = true;
					var touches:Array = evt.changedTouches;
					for (var j:int = 0, n:int = touches.length; j < n; j++) {
						_this.initEvent(touches[j], evt);
						_this.check(_this._stage, _this.mouseX, _this.mouseY, _this.onMouseDown);
					}
					break;
				case "touchend": 
					_this._isLeftMouse = true;
					var touchends:Array = evt.changedTouches;
					for (j = 0, n = touchends.length; j < n; j++) {
						_this.initEvent(touchends[j], evt);
						_this.check(_this._stage, _this.mouseX, _this.mouseY, _this.onMouseUp);
					}
					break;
				case "touchmove": 
					var touchemoves:Array = evt.changedTouches;
					for (j = 0, n = touchemoves.length; j < n; j++) {
						_this.initEvent(touchemoves[j], evt);
						_this.check(_this._stage, _this.mouseX, _this.mouseY, _this.onMouseMove);
					}
					_this.checkMouseOut();
					break;
				case "wheel": 
				case "mousewheel": 
				case "DOMMouseScroll": 
					_this.checkMouseWheel(evt);
					break;
				case "mouseout": 
					_this._stage.event(Event.MOUSE_OUT, _this._event.setTo(Event.MOUSE_OUT, _this._stage, _this._stage));
					break;
				case "mouseover": 
					_this._stage.event(Event.MOUSE_OVER, _this._event.setTo(Event.MOUSE_OVER, _this._stage, _this._stage));
					break;
				}
				i++;
			}
			_eventList.length = 0;
		}
	}
}