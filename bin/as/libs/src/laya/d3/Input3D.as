package laya.d3 {
	import laya.d3.component.Script3D;
	import laya.d3.component.SimpleSingletonList;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.physics.HitResult;
	import laya.maths.Point;
	import laya.utils.Browser;
	import laya.utils.Stat;
	
	/**
	 * <code>Input3D</code> 类用于实现3D输入。
	 */
	public class Input3D {
		/**@private */
		private static var _tempPoint:Point = new Point();
		/**@private */
		private static var _tempVector20:Vector2 = new Vector2();
		/**@private */
		private static var _tempRay0:Ray = new Ray(new Vector3(), new Vector3());
		/**@private */
		private static var _tempHitResult0:HitResult = new HitResult();
		
		/**@private */
		private var _scene:Scene3D;
		/**@private */
		private var _eventList:Array = [];
		/**@private */
		private var _mouseTouch:MouseTouch = new MouseTouch();
		/**@private */
		private var _touchPool:Vector.<Touch> = new Vector.<Touch>();
		/**@private */
		private var _touches:SimpleSingletonList = new SimpleSingletonList();
		/**@private */
		private var _multiTouchEnabled:Boolean = true;
		
		/**
		 *@private
		 */
		public function __init__(canvas:*, scene:Scene3D):void {
			_scene = scene;
			var list:Array = _eventList;
			canvas.oncontextmenu = function(e:*):* {
				return false;
			}
			canvas.addEventListener('mousedown', function(e:*):void {
				e.preventDefault();
				list.push(e);
			});
			canvas.addEventListener('mouseup', function(e:*):void {
				e.preventDefault();
				list.push(e);
			}, true);
			canvas.addEventListener('mousemove', function(e:*):void {
				e.preventDefault();
				list.push(e);
			}, true);
			
			canvas.addEventListener("touchstart", function(e:*):void {
				e.preventDefault();
				list.push(e);
			});
			canvas.addEventListener("touchend", function(e:*):void {
				e.preventDefault();
				list.push(e);
			}, true);
			canvas.addEventListener("touchmove", function(e:*):void {
				e.preventDefault();
				list.push(e);
			}, true);
			canvas.addEventListener("touchcancel", function(e:*):void {
				//e.preventDefault()会导致debugger中断后touchcancel无法执行,抛异常
				list.push(e);
			}, true);
		}
		
		/**
		 * 获取触摸点个数。
		 * @return 触摸点个数。
		 */
		public function touchCount():int {
			return _touches.length;
		}
		
		/**
		 * 获取是否可以使用多点触摸。
		 * @return 是否可以使用多点触摸。
		 */
		public function get multiTouchEnabled():Boolean {
			return _multiTouchEnabled;
		}
		
		/**
		 * 设置是否可以使用多点触摸。
		 * @param 是否可以使用多点触摸。
		 */
		public function set multiTouchEnabled(value:Boolean):void {
			_multiTouchEnabled = value;
		}
		
		/**
		 * @private
		 * 创建一个 <code>Input3D</code> 实例。
		 */
		public function Input3D() {
		}
		
		/**
		 * @private
		 */
		private function _getTouch(touchID:int):Touch {
			var touch:Touch = _touchPool[touchID];
			if (!touch) {
				touch = new Touch();
				_touchPool[touchID] = touch;
				touch._identifier = touchID;
			}
			return touch;
		}
		
		/**
		 * @private
		 */
		private function _mouseTouchDown():void {
			var touch:MouseTouch = _mouseTouch;
			var sprite:Sprite3D = touch.sprite;
			touch._pressedSprite = sprite;
			touch._pressedLoopCount = Stat.loopCount;
			if (sprite) {
				var scripts:Vector.<Script3D> = sprite._scripts;
				if (scripts) {
					for (var i:int = 0, n:int = scripts.length; i < n; i++)
						scripts[i].onMouseDown();//onMouseDown
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _mouseTouchUp():void {
			var i:int, n:int;
			var touch:MouseTouch = _mouseTouch;
			var lastPressedSprite:Sprite3D = touch._pressedSprite;
			touch._pressedSprite = null;//表示鼠标弹起
			touch._pressedLoopCount = -1;
			var sprite:Sprite3D = touch.sprite;
			if (sprite) {
				if (sprite === lastPressedSprite) {
					var scripts:Vector.<Script3D> = sprite._scripts;
					if (scripts) {
						for (i = 0, n = scripts.length; i < n; i++)
							scripts[i].onMouseClick();//onMouseClifck
					}
				}
			}
			
			if (lastPressedSprite) {
				var lastScripts:Vector.<Script3D> = lastPressedSprite._scripts;
				if (lastScripts) {
					for (i = 0, n = lastScripts.length; i < n; i++)
						lastScripts[i].onMouseUp();//onMouseUp
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _mouseTouchRayCast(cameras:Vector.<BaseCamera>):void {
			var touchHitResult:HitResult = _tempHitResult0;
			var touchPos:Vector2 = _tempVector20;
			var touchRay:Ray = _tempRay0;
			
			touchHitResult.succeeded = false;
			var x:Number = _mouseTouch.mousePositionX;
			var y:Number = _mouseTouch.mousePositionY;
			touchPos.x = x;
			touchPos.y = y;
			for (var i:int = cameras.length - 1; i >= 0; i--) {
				var camera:Camera = cameras[i] as Camera;
				var viewport:Viewport = camera.viewport;
				if (touchPos.x >= viewport.x && touchPos.y >= viewport.y && touchPos.x <= viewport.width && touchPos.y <= viewport.height) {
					camera.viewportPointToRay(touchPos, touchRay);
					
					var sucess:Boolean = _scene._physicsSimulation.rayCast(touchRay, touchHitResult);
					if (sucess || (camera.clearFlag === BaseCamera.CLEARFLAG_SOLIDCOLOR || camera.clearFlag === BaseCamera.CLEARFLAG_SKY))
						break;
				}
			}
			
			var touch:MouseTouch = _mouseTouch;
			var lastSprite:Sprite3D = touch.sprite;
			if (touchHitResult.succeeded) {
				var touchSprite:Sprite3D = touchHitResult.collider.owner as Sprite3D;
				touch.sprite = touchSprite;
				var scripts:Vector.<Script3D> = touchSprite._scripts;
				if (lastSprite !== touchSprite) {
					if (scripts) {
						for (var j:int = 0, m:int = scripts.length; j < m; j++)
							scripts[j].onMouseEnter();//onMouseEnter
					}
				}
			} else {
				touch.sprite = null;
			}
			
			if (lastSprite && (lastSprite !== touchSprite)) {
				var outScripts:Vector.<Script3D> = lastSprite._scripts;
				if (outScripts) {
					for (j = 0, m = outScripts.length; j < m; j++)
						outScripts[j].onMouseOut();//onMouseOut
				}
			}
		}
		
		/**
		 * @private
		 * @param flag 0:add、1:remove、2:change
		 */
		public function _changeTouches(changedTouches:Array, flag:int):void {
			var offsetX:Number = 0, offsetY:Number = 0;
			var lastCount:int = _touches.length;
			for (var j:int = 0, m:int = changedTouches.length; j < m; j++) {
				var nativeTouch:* = changedTouches[j];
				var identifier:int = nativeTouch.identifier;
				if (!_multiTouchEnabled && identifier !== 0)
					continue;
				var touch:Touch = _getTouch(identifier);
				var pos:Vector2 = touch._position;
				var mousePoint:Point = _tempPoint;
				mousePoint.setTo(nativeTouch.pageX,nativeTouch.pageY);
				Laya.stage._canvasTransform.invertTransformPoint(mousePoint);//考虑画布缩放	
				var posX:Number = mousePoint.x;
				var posY:Number = mousePoint.y;
				switch (flag) {
				case 0://add 
					_touches.add(touch);
					offsetX += posX;
					offsetY += posY;
					break;
				case 1://remove 
					_touches.remove(touch);
					offsetX -= posX;
					offsetY -= posY;
					break;
				case 2://change 
					offsetX = posX - pos.x;
					offsetY = posY - pos.y;
					break;
				}
				pos.x= posX;
				pos.y = posY;
			}
			
			var touchCount:int = _touches.length;
			if (touchCount === 0) {//无触摸点需要归零
				_mouseTouch.mousePositionX = 0;
				_mouseTouch.mousePositionY = 0;
			} else {
				_mouseTouch.mousePositionX = (_mouseTouch.mousePositionX * lastCount + offsetX) / touchCount;
				_mouseTouch.mousePositionY = (_mouseTouch.mousePositionY * lastCount + offsetY) / touchCount;
			}
		}
		
		/**
		 * @private
		 */
		public function _update():void {
			var i:int, n:int, j:int, m:int;
			n = _eventList.length;
			var cameras:Vector.<BaseCamera> = _scene._cameraPool;
			if (n > 0) {
				for (i = 0; i < n; i++) {
					var e:* = _eventList[i];
					switch (e.type) {
					case "mousedown": 
						_mouseTouchDown();
						break;
					case "mouseup": 
						_mouseTouchUp();
						break;
					case "mousemove":
						var mousePoint:Point = _tempPoint;
						mousePoint.setTo(e.pageX,e.pageY);
						Laya.stage._canvasTransform.invertTransformPoint(mousePoint);//考虑画布缩放
						_mouseTouch.mousePositionX =mousePoint.x;
						_mouseTouch.mousePositionY =mousePoint.y;
						_mouseTouchRayCast(cameras);
						break;
					case "touchstart": 
						var lastLength:int = _touches.length;
						_changeTouches(e.changedTouches, 0);
						_mouseTouchRayCast(cameras);//触摸点击时touchMove不会触发,需要调用_touchRayCast()函数
						(lastLength === 0) && (_mouseTouchDown());
						break;
					case "touchend": 
					case "touchcancel": 
						_changeTouches(e.changedTouches, 1);
						(_touches.length === 0) && (_mouseTouchUp());
						break;
					case "touchmove": 
						_changeTouches(e.changedTouches, 2);
						_mouseTouchRayCast(cameras);
						break;
					default: 
						throw "Input3D:unkonwn event type.";
					}
				}
				_eventList.length = 0;
			}
			
			var mouseTouch:MouseTouch = _mouseTouch;
			var pressedSprite:Sprite3D = mouseTouch._pressedSprite;
			if (pressedSprite && (Stat.loopCount > mouseTouch._pressedLoopCount)) {
				var pressedScripts:Vector.<Script3D> = pressedSprite._scripts;
				if (pressedScripts) {
					for (j = 0, m = pressedScripts.length; j < m; j++)
						pressedScripts[j].onMouseDrag();//onMouseDrag
				}
			}
			
			var touchSprite:Sprite3D = mouseTouch.sprite;
			if (touchSprite) {
				var scripts:Vector.<Script3D> = touchSprite._scripts;
				if (scripts) {
					for (j = 0, m = scripts.length; j < m; j++)
						scripts[j].onMouseOver();//onMouseOver
				}
			}
		}
		
		/**
		 *	获取触摸点。
		 * 	@param	index 索引。
		 * 	@return 触摸点。
		 */
		public function getTouch(index:int):Touch {
			if (index < _touches.length) {
				return _touches.elements[index] as Touch;
			} else {
				return null;
			}
		}
	
	}

}