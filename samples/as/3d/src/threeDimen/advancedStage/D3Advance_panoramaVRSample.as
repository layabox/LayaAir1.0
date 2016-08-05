package threeDimen.advancedStage {
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.TransformUV;
	import laya.d3.core.VRCamera;
	import laya.d3.core.material.Material;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.VRScene;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Sphere;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.resource.Texture;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.resource.WebGLImage;
	import threeDimen.common.SkySampleScript;
	import threeDimen.common.VRCameraMoveScript;
	
	/** @private */
	public class D3Advance_panoramaVRSample {
		
		public function D3Advance_panoramaVRSample() {
			//是否抗锯齿
			//Config.isAntialias = true;
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
			Stat.show();
			
			var scene:VRScene = Laya.stage.addChild(new VRScene()) as VRScene;
			
			var leftViewport:Viewport = new Viewport(0, 0, RenderState.clientWidth / 2, RenderState.clientHeight);
			var rightViewport:Viewport = new Viewport(RenderState.clientWidth / 2, 0, RenderState.clientWidth / 2, RenderState.clientHeight);
			
			var camera:VRCamera = new VRCamera(0.03, 0, 0, 0.1, 100);
			scene.currentCamera = (scene.addChild(camera)) as VRCamera;

			
			scene.currentCamera.addComponent(VRCameraMoveScript);
			loadScene(scene, camera);
		}
		
		private function loadScene(scene:BaseScene, camera:VRCamera):void {
			
			var mesh:MeshSprite3D = scene.addChild(new MeshSprite3D(new Sphere(1, 20, 20))) as MeshSprite3D;
			
			var material:Material = new Material();
			material.cullFace = false;
			mesh.shadredMaterial = material;
			
			Laya.loader.load("../../../../res/threeDimen/panorama/panorama.jpg", Handler.create(null, function(texture:Texture):void {
				(texture.bitmap as WebGLImage).mipmap = true;
				material.diffuseTexture = texture;
			}));
		}
	}
}