package threeDimen.common {
	import laya.ani.AnimationState;
	import laya.d3.component.Component3D;
	import laya.d3.component.animation.CameraAnimations;
	import laya.d3.component.Script;
	import laya.d3.core.VRCamera;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.core.render.RenderState;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.events.KeyBoardManager;
	import laya.utils.Browser;
	
	/**
	 * ...
	 * @author
	 */
	public class VRCameraMoveScript extends Script {
		
		protected var mainCameraAnimation:CameraAnimations;
		protected var q0:Quaternion = new Quaternion();
		protected var q1:Quaternion = new Quaternion(-Math.sqrt(0.5), 0, 0, Math.sqrt(0.5));// - PI/2 around the x-axis
		protected var q2:Quaternion = new Quaternion();
		protected var q3:Quaternion = new Quaternion();
		protected var orientation:Number;
		protected var camera:VRCamera;
		
		public function VRCameraMoveScript() {
		
		}
		
		override public function _initialize(owner:Sprite3D):void {
			super._initialize(owner);
			
			camera = owner as VRCamera;
			
			camera.on(Event.COMPONENT_ADDED, this, function(component:Component3D):void {
				if (component is CameraAnimations)
					mainCameraAnimation = component as CameraAnimations;
			});
			
			camera.on(Event.COMPONENT_REMOVED, this, function(component:Component3D):void {
				if (component is CameraAnimations)
					mainCameraAnimation = null;
			});
			
			Browser.window.addEventListener('deviceorientation', function(e:*):void {
				orientation = (Browser.window.orientation || 0);
				if (Laya.stage.canvasRotation) {
					if (Laya.stage.screenMode == Stage.SCREEN_HORIZONTAL)
						orientation += 90
					else if (Laya.stage.screenMode == Stage.SCREEN_VERTICAL)
						orientation -= 90
				}
				
				Quaternion.createFromYawPitchRoll(e.alpha / 360 * Math.PI * 2, e.beta / 360 * Math.PI * 2, -e.gamma / 360 * Math.PI * 2, q0);
				Quaternion.multiply(q0, q1, q2);
				Quaternion.createFromAxisAngle(Vector3.UnitZ, -orientation / 360 * Math.PI * 2, q3);
				Quaternion.multiply(q2, q3, camera.transform.localRotation);
			}, false);
		}
		
		override public function _update(state:RenderState):void {
			super._update(state);
			updateCamera(state.elapsedTime);
		}
		
		protected function updateCamera(elapsedTime:Number):void {
			if ((!mainCameraAnimation || (mainCameraAnimation && mainCameraAnimation.player.state === AnimationState.stopped))) {
				KeyBoardManager.hasKeyDown(87) && camera.moveForward(-0.002 * elapsedTime);//W
				KeyBoardManager.hasKeyDown(83) && camera.moveForward(0.002 * elapsedTime);//S
				KeyBoardManager.hasKeyDown(65) && camera.moveRight(-0.002 * elapsedTime);//A
				KeyBoardManager.hasKeyDown(68) && camera.moveRight(0.002 * elapsedTime);//D
				KeyBoardManager.hasKeyDown(81) && camera.moveVertical(0.002 * elapsedTime);//Q
				KeyBoardManager.hasKeyDown(69) && camera.moveVertical(-0.002 * elapsedTime);//E
				updateRotation();
			}
		}
		
		protected function updateRotation():void {
			camera.transform.localRotation = camera.transform.localRotation;
		}
	}
}