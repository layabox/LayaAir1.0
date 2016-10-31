package threeDimen.common {
	import laya.d3.component.Script;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.events.Event;
	import laya.events.KeyBoardManager;
	
	/**
	 * ...
	 * @author
	 */
	public class CameraMoveScript extends Script {
		protected var lastMouseX:Number;
		protected var lastMouseY:Number;
		protected var yawPitchRoll:Vector3 = new Vector3();
		protected var resultRotation:Quaternion = new Quaternion();
		protected var tempRotationZ:Quaternion = new Quaternion();
		protected var tempRotationX:Quaternion = new Quaternion();
		protected var tempRotationY:Quaternion = new Quaternion();
		protected var isMouseDown:Boolean;
		protected var rotaionSpeed:Number = 0.00006;
		protected var camera:BaseCamera;
		protected var scene:Scene;
		
		public function CameraMoveScript() {
		
		}
		
		override public function _initialize(owner:Sprite3D):void {
			super._initialize(owner);
			Laya.stage.on(Event.MOUSE_DOWN, this, mouseDown);
			Laya.stage.on(Event.MOUSE_UP, this, mouseUp);
			Laya.stage.on(Event.MOUSE_OUT, this, mouseOut);
			
			camera = owner as Camera;
		}
		
		override public function _update(state:RenderState):void {
			super._update(state);
			updateCamera(state.elapsedTime);
		}
		
		protected function mouseDown(e:Event):void {
			camera.transform.localRotation.getYawPitchRoll(yawPitchRoll);
			
			lastMouseX = Laya.stage.mouseX;
			lastMouseY = Laya.stage.mouseY;
			isMouseDown = true;
		}
		
		protected function mouseUp(e:Event):void {
			isMouseDown = false;
		}
		
		protected function mouseOut(e:Event):void {
			isMouseDown = false;
		}
		
		protected function updateCamera(elapsedTime:Number):void {
			if (!isNaN(lastMouseX) && !isNaN(lastMouseY)) {
				var scene:BaseScene = owner.scene;
				KeyBoardManager.hasKeyDown(87) && camera.moveForward(-0.02 * elapsedTime);//W
				KeyBoardManager.hasKeyDown(83) && camera.moveForward(0.02 * elapsedTime);//S
				KeyBoardManager.hasKeyDown(65) && camera.moveRight(-0.02 * elapsedTime);//A
				KeyBoardManager.hasKeyDown(68) && camera.moveRight(0.02 * elapsedTime);//D
				KeyBoardManager.hasKeyDown(81) && camera.moveVertical(0.02 * elapsedTime);//Q
				KeyBoardManager.hasKeyDown(69) && camera.moveVertical(-0.02 * elapsedTime);//E
				
				if (isMouseDown) {
					var offsetX:Number = Laya.stage.mouseX - lastMouseX;
					var offsetY:Number = Laya.stage.mouseY - lastMouseY;
					
					var yprElem:Float32Array = yawPitchRoll.elements;
					yprElem[0] -= offsetX * rotaionSpeed * elapsedTime;
					yprElem[1] -= offsetY * rotaionSpeed * elapsedTime;
					updateRotation();
				}
			}
			lastMouseX = Laya.stage.mouseX;
			lastMouseY = Laya.stage.mouseY;
		}
		
		protected function updateRotation():void {
			var yprElem:Float32Array = yawPitchRoll.elements;
			if (Math.abs(yprElem[1]) < 1.50) {
				Quaternion.createFromYawPitchRoll(yprElem[0], yprElem[1], yprElem[2], tempRotationZ);
				camera.transform.localRotation = tempRotationZ;
			}
		}
	
	}

}