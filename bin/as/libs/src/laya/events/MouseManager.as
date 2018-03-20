package laya.events {
	import laya.display.Input;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.utils.Browser;
	import laya.utils.HitArea;
	
	/**
	 * <p><code>MouseManager</code> 是鼠标、触摸交互管理器。</p>
	 * <p>鼠标事件流包括捕获阶段、目标阶段、冒泡阶段。<br/>
	 * 捕获阶段：此阶段引擎会从stage开始递归检测stage及其子对象，直到找到命中的目标对象或者未命中任何对象；<br/>
	 * 目标阶段：找到命中的目标对象；<br/>
	 * 冒泡阶段：事件离开目标对象，按节点层级向上逐层通知，直到到达舞台的过程。</p>
	 */
	public class MouseManager {
		/**
		 * MouseManager 单例引用。
		 */
		public static const instance:MouseManager = new MouseManager();
		
		/**是否开启鼠标检测，默认为true*/
		public static var enabled:Boolean = true;
		/**是否开启多点触控*/
		public static var multiTouchEnabled:Boolean = true;
		/** canvas 上的鼠标X坐标。*/
		public var mouseX:Number = 0;
		/** canvas 上的鼠标Y坐标。*/
		public var mouseY:Number = 0;
		/** 是否禁用除 stage 以外的鼠标事件检测。*/
		public var disableMouseEvent:Boolean = false;
		/** 鼠标按下的时间。单位为毫秒。*/
		public var mouseDownTime:Number = 0;
		/** 鼠标移动精度。*/
		public var mouseMoveAccuracy:Number = 2;
		/** @private */
		private static var _isTouchRespond:Boolean;
		public var _event:Event = new Event();
		private var _stage:Stage;
		private var _matrix:Matrix = new Matrix();
		private var _point:Point = new Point();
		private var _rect:Rectangle = new Rectangle();
		private var _target:*;
		private var _lastMoveTimer:Number = 0;
		private var _isLeftMouse:Boolean;
		private var _eventList:Array = [];
		private var _prePoint:Point = new Point();
		private var _touchIDs:Object = {};
		private var _curTouchID:Number = NaN;
		private var _id:int = 1;
		private static var _isFirstTouch:Boolean = true;
		/**
		 * @private
		 * 初始化。
		 */
		public function __init__(stage:Stage, canvas:*):void {
			this._stage = stage;
			var _this:MouseManager = this;
			//var canvas:* = Render.canvas;
			var list:Array = _eventList;
			
			canvas.oncontextmenu = function(e:*):* {
				if (enabled) return false;
			}
			canvas.addEventListener('mousedown', function(e:*):void {
				if (enabled) {
					if(!Browser.onIE) e.preventDefault();
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
			canvas.addEventListener('mousemove', function(e:*):void {
				if (enabled) {
					e.preventDefault();
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
					list.push(e);
					if (!_isFirstTouch&&!Input.isInputting) e.preventDefault();
					_this.mouseDownTime = Browser.now();
						//runEvent();
				}
			});
			canvas.addEventListener("touchend", function(e:*):void {
				if (enabled) {
					if (!_isFirstTouch&&!Input.isInputting) e.preventDefault();
					_isFirstTouch = false;
					list.push(e);
					_this.mouseDownTime = -Browser.now();
				}else {
					_curTouchID = NaN;
				}
			}, true);
			canvas.addEventListener("touchmove", function(e:*):void {
				if (enabled) {
					e.preventDefault();
					list.push(e);
				}
			}, true);
			canvas.addEventListener("touchcancel", function(e:*):void {
				if (enabled) {
					e.preventDefault();
					list.push(e);
				}else {
					_curTouchID = NaN;
				}
			}, true);
			canvas.addEventListener('mousewheel', function(e:*):void {
				if (enabled) list.push(e);
			});
			canvas.addEventListener('DOMMouseScroll', function(e:*):void {
				if (enabled) list.push(e);
			});
		}
		private var _tTouchID:int;
		
		private function initEvent(e:*, nativeEvent:* = null):void {
			var _this:MouseManager = this;
			
			_this._event._stoped = false;
			_this._event.nativeEvent = nativeEvent || e;
			_this._target = null;
			
			_point.setTo(e.pageX || e.clientX, e.pageY || e.clientY);
			_stage._canvasTransform.invertTransformPoint(_point);
			
			_this.mouseX = _point.x;
			_this.mouseY = _point.y;
			_this._event.touchId = e.identifier || 0;
			_tTouchID = _this._event.touchId;
			
			var evt:Event;
			evt = TouchManager.I._event;
			evt._stoped = false;
			evt.nativeEvent = _this._event.nativeEvent;
			evt.touchId = _this._event.touchId;
		}
		
		private function checkMouseWheel(e:*):void {
			_event.delta = e.wheelDelta ? e.wheelDelta * 0.025 : -e.detail;
			var _lastOvers:Array = TouchManager.I.getLastOvers();
			
			for (var i:int = 0, n:int = _lastOvers.length; i < n; i++) {
				var ele:* = _lastOvers[i];
				ele.event(Event.MOUSE_WHEEL, _event.setTo(Event.MOUSE_WHEEL, ele, _target));
			}
			//			_stage.event(Event.MOUSE_WHEEL, _event.setTo(Event.MOUSE_WHEEL, _stage, _target));
		}
		
		private function onMouseMove(ele:*):void {
			
			TouchManager.I.onMouseMove(ele, _tTouchID);
		
		}
		
		private function onMouseDown(ele:*):void {
			if (Input.isInputting && Laya.stage.focus && Laya.stage.focus["focus"] && !Laya.stage.focus.contains(_target)) {
				// 从UI Input组件中取得Input引用
				// _tf 是TextInput的属性
				var pre_input:* = Laya.stage.focus['_tf'] || Laya.stage.focus;
				var new_input:Input = ele['_tf'] || ele;
				
				// 新的焦点是Input的情况下，不需要blur；
				// 不过如果是Input和TextArea之间的切换，还是需要重新弹出输入法；
				if (new_input is Input && new_input.multiline == pre_input.multiline)
					pre_input['_focusOut']();
				else
					pre_input.focus = false;
			}
			TouchManager.I.onMouseDown(ele, _tTouchID, _isLeftMouse);
		}
		
		private function onMouseUp(ele:*):void {
			TouchManager.I.onMouseUp(ele, _tTouchID, _isLeftMouse);
		}
		
		private function check(sp:Sprite, mouseX:Number, mouseY:Number, callBack:Function):Boolean {
			this._point.setTo(mouseX, mouseY);
			sp.fromParentPoint(this._point);
			mouseX = this._point.x;
			mouseY = this._point.y;
			
			//如果有裁剪，则先判断是否在裁剪范围内
			var scrollRect:Rectangle = sp.scrollRect;
			if (scrollRect) {
				_rect.setTo(scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
				if (!_rect.contains(mouseX, mouseY)) return false;
			}
			
			//先判定子对象是否命中
			if (!disableMouseEvent) {
				//优先判断父对象
				//默认情况下，hitTestPrior=mouseThrough=false，也就是优先check子对象
				//$NEXTBIG:下个重大版本将sp.mouseThrough从此逻辑中去除，从而使得sp.mouseThrough只负责目标对象的穿透
				if (sp.hitTestPrior && !sp.mouseThrough && !hitTest(sp, mouseX, mouseY)) {
					return false;
				}
				for (var i:int = sp._childs.length - 1; i > -1; i--) {
					var child:Sprite = sp._childs[i];
					//只有接受交互事件的，才进行处理
					if (!child.destroyed && child.mouseEnabled && child.visible) {
						if (check(child, mouseX, mouseY, callBack)) return true;
					}
				}
			}
			
			//避免重复进行碰撞检测，考虑了判断条件的命中率。
			var isHit:Boolean = (sp.hitTestPrior && !sp.mouseThrough && !disableMouseEvent) ? true : hitTest(sp, mouseX, mouseY);
			
			if (isHit) {
				_target = sp;
				callBack.call(this, sp);
			} else if (callBack === onMouseUp && sp === _stage) {
				//如果stage外mouseUP
				_target = _stage;
				callBack.call(this, _target);
			}
			
			return isHit;
		}
		
		private function hitTest(sp:Sprite, mouseX:Number, mouseY:Number):Boolean {
			var isHit:Boolean = false;
			if (sp.scrollRect) {
				mouseX -= sp.scrollRect.x;
				mouseY -= sp.scrollRect.y;
			}
			if (sp.hitArea is HitArea) {
				return sp.hitArea.isHit(mouseX, mouseY);
			}
			if (sp.width > 0 && sp.height > 0 || sp.mouseThrough || sp.hitArea) {
				//判断是否在矩形区域内
				if (!sp.mouseThrough) {
					var hitRect:Rectangle = this._rect;
					if (sp.hitArea) hitRect = sp.hitArea;
					else hitRect.setTo(0, 0, sp.width, sp.height);
					isHit = hitRect.contains(mouseX, mouseY);
				} else {
					//如果可穿透，则根据子对象实际大小进行碰撞
					isHit = sp.getGraphicBounds().contains(mouseX, mouseY);
				}
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
			var i:int = 0,j:int,n:int,touch:*;
			while (i < len) {
				var evt:* = _eventList[i];
				
				if (evt.type !== 'mousemove') _prePoint.x = _prePoint.y = -1000000;
				
				switch (evt.type) {
				case 'mousedown': 
					_touchIDs[0] = _id++;
					if (!_isTouchRespond) {
						_this._isLeftMouse = evt.button === 0;
						_this.initEvent(evt);
						_this.check(_this._stage, _this.mouseX, _this.mouseY, _this.onMouseDown);
					} else
						_isTouchRespond = false;
					break;
				case 'mouseup': 
					_this._isLeftMouse = evt.button === 0;
					_this.initEvent(evt);
					_this.check(_this._stage, _this.mouseX, _this.mouseY, _this.onMouseUp);
					break;
				case 'mousemove': 
					if ((Math.abs(_prePoint.x - evt.clientX) + Math.abs(_prePoint.y - evt.clientY)) >= mouseMoveAccuracy) {
						_prePoint.x = evt.clientX;
						_prePoint.y = evt.clientY;
						_this.initEvent(evt);
						_this.check(_this._stage, _this.mouseX, _this.mouseY, _this.onMouseMove);
							//						_this.checkMouseOut();
					}
					break;
				case "touchstart": 
					_isTouchRespond = true;
					_this._isLeftMouse = true;
					var touches:Array = evt.changedTouches;
					for (j = 0, n = touches.length; j < n; j++) {
						touch = touches[j];
						//是否禁用多点触控
						if (multiTouchEnabled || isNaN(_curTouchID)) {
							_curTouchID = touch.identifier;
							//200次点击清理一下id资源
							if (_id % 200 === 0) _touchIDs = {};
							_touchIDs[touch.identifier] = _id++;
							_this.initEvent(touch, evt);
							_this.check(_this._stage, _this.mouseX, _this.mouseY, _this.onMouseDown);
						}
					}
					
					break;
				case "touchend": 
				case "touchcancel":
					_isTouchRespond = true;
					_this._isLeftMouse = true;
					var touchends:Array = evt.changedTouches;
					for (j = 0, n = touchends.length; j < n; j++) {
						touch = touchends[j];
						//是否禁用多点触控
						if (multiTouchEnabled || touch.identifier == _curTouchID) {
							_curTouchID = NaN;
							_this.initEvent(touch, evt);
							var isChecked:Boolean;
							isChecked = _this.check(_this._stage, _this.mouseX, _this.mouseY, _this.onMouseUp);
							if (!isChecked)
							{
								_this.onMouseUp(null);
							}
						}
					}
					
					break;
				case "touchmove": 
					var touchemoves:Array = evt.changedTouches;
					for (j = 0, n = touchemoves.length; j < n; j++) {
						touch = touchemoves[j];
						//是否禁用多点触控
						if (multiTouchEnabled || touch.identifier == _curTouchID) {
							_this.initEvent(touch, evt);
							_this.check(_this._stage, _this.mouseX, _this.mouseY, _this.onMouseMove);
						}
					}
					break;
				case "wheel": 
				case "mousewheel": 
				case "DOMMouseScroll": 
					_this.checkMouseWheel(evt);
					break;
				case "mouseout": 
					//_this._stage.event(Event.MOUSE_OUT, _this._event.setTo(Event.MOUSE_OUT, _this._stage, _this._stage));
					TouchManager.I.stageMouseOut();
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