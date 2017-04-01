package threeDimen.advancedStage {
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.VRCamera;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.VRScene;
	import laya.d3.math.Viewport;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.models.SphereMesh;
	import laya.display.Stage;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	import threeDimen.common.VRCameraMoveScript;
	
	/** @private */
	public class D3Advance_panoramaVRSample {
		
		public function D3Advance_panoramaVRSample() {
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
			Stat.show();
			
			var scene:VRScene = Laya.stage.addChild(new VRScene()) as VRScene;
			
			var leftViewport:Viewport = new Viewport(0, 0, RenderState.clientWidth / 2, RenderState.clientHeight);
			var rightViewport:Viewport = new Viewport(RenderState.clientWidth / 2, 0, RenderState.clientWidth / 2, RenderState.clientHeight);
			
			var camera:VRCamera = new VRCamera(0.03, 0, 0, 0.1, 100);
			scene.addChild(camera);
			
			camera.addComponent(VRCameraMoveScript);
			loadScene(scene, camera);
		}
		
		private function loadScene(scene:BaseScene, camera:VRCamera):void {
			var mesh:MeshSprite3D = scene.addChild(new MeshSprite3D(new SphereMesh(1, 20, 20))) as MeshSprite3D;
			
			var material:StandardMaterial = new StandardMaterial();
			material.renderMode = StandardMaterial.RENDERMODE_OPAQUEDOUBLEFACE;
			mesh.meshRender.sharedMaterial = material;
			
			material.diffuseTexture = Texture2D.load("../../../../res/threeDimen/panorama/panorama.jpg");
		}
	}
}