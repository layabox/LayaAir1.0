package threeDimen.primaryStage {
	import laya.d3.Laya3D;
	import laya.d3.component.Component3D;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.camera.Camera;
	import laya.d3.core.fileModel.Mesh;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Stat;
	
	public class SkinAnimation_MultiSubMeshSample {
		private var skinMesh:Mesh;
		private var skinAni:SkinAnimations;
		
		public function SkinAnimation_MultiSubMeshSample() {
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
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.direction = new Vector3(0, -0.8, -1);
			directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
			directionLight.specularColor = new Vector3(2.0, 2.0, 1.6);
			directionLight.diffuseColor = new Vector3(1, 1, 1);
			scene.shadingMode = BaseScene.PIXEL_SHADING;
			
			skinMesh = scene.addChild(new Mesh()) as Mesh;
			skinMesh.load("threeDimen/skinModel/dude/dude-him.lm");
			skinMesh.transform.localRotationEuler = new Vector3(0, 3.14, 0);
			skinAni = skinMesh.addComponent(SkinAnimations) as SkinAnimations;
			skinAni.url = "threeDimen/skinModel/dude/dude.ani";
			skinAni.play();
		
		}
	}
}