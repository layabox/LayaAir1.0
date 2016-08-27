package threeDimen.primaryStage {
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.light.PointLight;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.ClassUtils;
	import laya.utils.Stat;
	
	import threeDimen.common.CameraMoveScript;
	
	/**
	 * ...
	 * @author laya
	 */
	public class D3Base_ScriptAndCameraSample {
		private var skinMesh:MeshSprite3D;
		
		public function D3Base_ScriptAndCameraSample() {
			Laya3D.init(0, 0,true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			scene.currentCamera = (scene.addChild(new Camera( 0, 0.1, 100))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.0));
			scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			scene.currentCamera.clearColor = null;
			
			scene.currentCamera.addComponent(CameraMoveScript);
			
			var pointLight:PointLight = scene.addChild(new PointLight()) as PointLight;
			pointLight.transform.position = new Vector3(0, 0.6, 0.3);
			pointLight.range = 1.0;
			pointLight.attenuation = new Vector3(0.6, 0.6, 0.6);
			pointLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
			pointLight.specularColor = new Vector3(2.0, 2.0, 1.6);
			pointLight.diffuseColor = new Vector3(1, 1, 1);
			scene.shadingMode = BaseScene.PIXEL_SHADING;
			
			skinMesh = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/dude/dude-him.lm"))) as MeshSprite3D;
		}
	
	}

}