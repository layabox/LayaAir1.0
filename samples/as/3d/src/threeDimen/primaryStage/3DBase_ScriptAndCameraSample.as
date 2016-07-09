package threeDimen.primaryStage {
	import laya.d3.Laya3D;
	import laya.d3.core.camera.Camera;
	import laya.d3.core.fileModel.Mesh;
	import laya.d3.core.light.PointLight;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.ClassUtils;
	import laya.utils.Stat;
	
	import threeDimen.common.CameraMoveScript;
	
	/**
	 * ...
	 * @author laya
	 */
	public class ScriptAndCameraSample {
		private var skinMesh:Mesh;
		
		public function ScriptAndCameraSample() {
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			scene.currentCamera = (scene.addChild(new Camera(new Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.0));
			scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			scene.currentCamera.clearColor = null;
			Laya.stage.on(Event.RESIZE, null, function():void {
				(scene.currentCamera as Camera).viewport = new Viewport(0, 0, Laya.stage.width, Laya.stage.height);
			});
			
			scene.currentCamera.addComponent(CameraMoveScript);
			
			var pointLight:PointLight = scene.addChild(new PointLight()) as PointLight;
			pointLight.transform.position = new Vector3(0, 0.6, 0.3);
			pointLight.range = 1.0;
			pointLight.attenuation = new Vector3(0.6, 0.6, 0.6);
			pointLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
			pointLight.specularColor = new Vector3(2.0, 2.0, 1.6);
			pointLight.diffuseColor = new Vector3(1, 1, 1);
			scene.shadingMode = BaseScene.PIXEL_SHADING;
			
			skinMesh = scene.addChild(new Mesh()) as Mesh;
			skinMesh.load("threeDimen/skinModel/dude/dude-him.lm");
		}
	
	}

}