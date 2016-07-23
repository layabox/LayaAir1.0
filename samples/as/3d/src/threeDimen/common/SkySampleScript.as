package threeDimen.common {
	import laya.d3.component.Script;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.camera.BaseCamera;
	import laya.d3.core.camera.Camera;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SkySampleScript extends Script {
		public var  skySprite:Sprite3D;
		public var  cameraSprite:BaseCamera;
		public function SkySampleScript() {
		
		}
		
		override public function _update(state:RenderState):void 
		{
			super._update(state);
			skySprite.transform.position = cameraSprite.transform.position;
		}
	
	}

}