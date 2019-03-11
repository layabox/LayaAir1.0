package laya.d3Editor.component {
	import laya.components.Component;
	import laya.d3.component.Script3D;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3Editor.EditerScene3D;
	import laya.d3Editor.TransformSprite3D;
	import laya.events.Event;
	import laya.events.KeyBoardManager;
	import laya.events.Keyboard;
	//import laya.ide.designplugin.Editer3DUtils;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	/**
	 * ...
	 * @author
	 */
	public class EditerCameraScript extends Script3D {
		
		/** @private */
		protected var _tempVector3:Vector3 = new Vector3();
		protected var lastMouseX:Number;
		protected var lastMouseY:Number;
		protected var yawPitchRoll:Vector3 = new Vector3();
		protected var resultRotation:Quaternion = new Quaternion();
		protected var tempRotationZ:Quaternion = new Quaternion();
		protected var tempRotationX:Quaternion = new Quaternion();
		protected var tempRotationY:Quaternion = new Quaternion();
		protected var isRightMouseDown:Boolean;
		protected var isMouseDown:Boolean;
		protected var rotaionSpeed:Number = 0.00006;
		protected var camera:BaseCamera;
		protected var speed:Number = 0.01;
		protected var isWheel:int;
		protected var isMove:Boolean;
		protected var _worldCentre:Vector3 = new Vector3();
		public var scene:EditerScene3D;
		
		public static var isSelect:Boolean;
		private var _movePosition:Vector3;
		private var _offSpeed:Number = 0;
		private var isKeyDown:Boolean;
		
		public var saveCameraInfoHandler:Handler;
		public var updateWorldCentreDistance:Handler;
		public var worldCentreDistance:Number;
		public function EditerCameraScript() {
			isSelect = false;
		}
		
		override public function _onAdded():void {
			Laya.stage.on(Event.MOUSE_DOWN, this, mouseDown);
			Laya.stage.on(Event.MOUSE_UP, this, mouseUp);
			Laya.stage.on(Event.RIGHT_MOUSE_DOWN, this, rightMouseDown);
			Laya.stage.on(Event.RIGHT_MOUSE_UP, this, rightMouseUp);
			Laya.stage.on(Event.MOUSE_WHEEL, this, mouseWheel);
			camera = owner as Camera;
		
		}
		
		override protected function _onDestroy():void {
			super._onDestroy();
			Laya.stage.off(Event.MOUSE_DOWN, this, mouseDown);
			Laya.stage.off(Event.MOUSE_UP, this, mouseUp);
			Laya.stage.off(Event.RIGHT_MOUSE_DOWN, this, rightMouseDown);
			Laya.stage.off(Event.RIGHT_MOUSE_UP, this, rightMouseUp);
			Laya.stage.off(Event.MOUSE_WHEEL, this, mouseWheel);
		}
		
		override public function onUpdate():void {
			super.onUpdate();
			updateCamera(Laya.timer.delta);
			
			var transformSprite3d:TransformSprite3D = scene.transformSprite3D;
			var distance:Number = Vector3.distance(camera.transform.position, transformSprite3d.transform.position);
			_tempVector3.x = _tempVector3.y = _tempVector3.z = distance * 0.25;
			transformSprite3d.transform.scale = _tempVector3;
		}
		
		override public function onKeyDown(e:Event):void 
		{
			isKeyDown = true;
		}
		
		override public function onKeyUp(e:Event):void 
		{
			isKeyDown = false;
			speed = 0.01;
			offSpeed = 0;
		}
		
		protected function rightMouseDown(e:Event):void {
			if (!isSelect)
				return
				
			camera.transform.localRotation.getYawPitchRoll(yawPitchRoll);
			
			lastMouseX = Laya.stage.mouseX;
			lastMouseY = Laya.stage.mouseY;
			isRightMouseDown = true;
		}
		
		protected function rightMouseUp(e:Event):void {
			if (!isSelect)
				return
				
			isRightMouseDown = false;
			//Editer3DUtils.I.saveCameraInfo();
			saveCameraInfoHandler && saveCameraInfoHandler.run();
			speed = 0.01;
			offSpeed = 0;
		}
		
		private function mouseDown(e:Event):void 
		{
			if (!isSelect)
				return
			
			if (isKeyDown && KeyBoardManager.hasKeyDown(Keyboard.ALTERNATE)){
				lastMouseX = Laya.stage.mouseX;
				lastMouseY = Laya.stage.mouseY;
				isMouseDown = true;
				Vector3.scale(camera.transform.forward, worldCentreDistance, _worldCentre);
				Vector3.add(camera.transform.position, _worldCentre, _worldCentre);
			}
		}
		
		private function mouseUp(e:Event):void 
		{
			if (!isSelect)
				return
				
			isMouseDown = false;
			//Editer3DUtils.I.saveCameraInfo();
			saveCameraInfoHandler && saveCameraInfoHandler.run();
			speed = 0.01;
			offSpeed = 0;
		}
		
		protected function mouseWheel(e:Event):void {
			if (!isSelect)
				return
				
				isWheel = e.delta;
		}
		
		/**
		 * 向前移动。
		 * @param distance 移动距离。
		 */
		public function moveForward(distance:Number):void {
			_tempVector3.elements[0] = _tempVector3.elements[1] = 0;
			_tempVector3.elements[2] = distance;
			camera.transform.translate(_tempVector3);
			
			updateWorldCentreDistance && updateWorldCentreDistance.runWith(worldCentreDistance + distance);
			//worldCentreDistance = camera.transform.position.z;
		}
		
		/**
		 * 向右移动。
		 * @param distance 移动距离。
		 */
		public function moveRight(distance:Number):void {
			_tempVector3.elements[1] = _tempVector3.elements[2] = 0;
			_tempVector3.elements[0] = distance;
			camera.transform.translate(_tempVector3);
		}
		
		/**
		 * 向上移动。
		 * @param distance 移动距离。
		 */
		public function moveVertical(distance:Number):void {
			_tempVector3.elements[0] = _tempVector3.elements[2] = 0;
			_tempVector3.elements[1] = distance;
			camera.transform.translate(_tempVector3, false);
		}
		
		protected function updateCamera(elapsedTime:Number):void {
			if (isRightMouseDown || isMouseDown) {
				offSpeed += 0.001;
				speed = offSpeed;
				var offsetX:Number = Laya.stage.mouseX - lastMouseX;
				var offsetY:Number = Laya.stage.mouseY - lastMouseY;
				
				var yprElem:Float32Array = yawPitchRoll.elements;
				
				
				if (isRightMouseDown){
					yprElem[0] -= offsetX * rotaionSpeed * elapsedTime;
					yprElem[1] -= offsetY * rotaionSpeed * elapsedTime;
					
					KeyBoardManager.hasKeyDown(Keyboard.W) && moveForward(-speed * elapsedTime);//W
					KeyBoardManager.hasKeyDown(Keyboard.S) && moveForward(speed * elapsedTime);//S
					KeyBoardManager.hasKeyDown(Keyboard.A) && moveRight(-speed * elapsedTime);//A
					KeyBoardManager.hasKeyDown(Keyboard.D) && moveRight(speed * elapsedTime);//D
					KeyBoardManager.hasKeyDown(Keyboard.Q) && moveVertical(speed * elapsedTime);//Q
					KeyBoardManager.hasKeyDown(Keyboard.E) && moveVertical( -speed * elapsedTime);//E
					updateRotation();
				}
				
				if (isKeyDown && isMouseDown && KeyBoardManager.hasKeyDown(Keyboard.ALTERNATE)){
					yprElem[0] -= offsetX * rotaionSpeed * elapsedTime * 8;
					yprElem[1] -= offsetY * rotaionSpeed * elapsedTime * 8;
					
					updateRotation();
					Vector3.scale(camera.transform.forward, worldCentreDistance, _tempVector3);
					Vector3.subtract(_worldCentre, _tempVector3, _tempVector3);
					camera.transform.position = _tempVector3;
				}
			}
			if (isWheel) {
				var distance:Number = worldCentreDistance / 100;
				if (distance <= 0.001)
					distance = 0.001
					
				if (isWheel > 0) {//放大
					moveForward(-distance * elapsedTime);
				} else {//缩小
					moveForward(distance * elapsedTime);
				}
				isWheel = 0;
				//Editer3DUtils.I.saveCameraInfo();
				saveCameraInfoHandler && saveCameraInfoHandler.run();
			}
			
			if (isMove){
				camera.transform.position = _movePosition;
				//Editer3DUtils.I.saveCameraInfo();
				saveCameraInfoHandler && saveCameraInfoHandler.run();
			}
			lastMouseX = Laya.stage.mouseX;
			lastMouseY = Laya.stage.mouseY;
		}
		
		protected function updateRotation():void {
			var yprElem:Float32Array = yawPitchRoll.elements;
			if (Math.abs(yprElem[1]) < 1.50) {
				Quaternion.createFromYawPitchRoll(yprElem[0], yprElem[1], yprElem[2], tempRotationZ);
				tempRotationZ.cloneTo(camera.transform.localRotation);
				camera.transform.localRotation = camera.transform.localRotation;
			}
		}
		
		public function focusCamera(x:Number,y:Number,z:Number):void 
		{
			isMove = true;
			_movePosition = camera.transform.position;
			Tween.to(_movePosition, {x:x, y:y, z:z}, 200,null,Handler.create(this,function ():void 
			{
				Laya.timer.frameOnce(1,this,function ():void 
				{
					isMove = false;
				});
			}));
		}
		
		override public function _cloneTo(dest:Component):void {
			super._cloneTo(dest);
			(dest as EditerCameraScript).scene = scene;
		}
		
		public function get offSpeed():Number 
		{
			return _offSpeed;
		}
		
		public function set offSpeed(value:Number):void 
		{
			if (value >= 1.5)
				value = 1.5;
			_offSpeed = value;
		}
	
	}

}