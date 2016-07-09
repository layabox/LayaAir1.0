package threeDimen.primaryStage {
	import laya.d3.Laya3D;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.camera.Camera;
	import laya.d3.core.fileModel.Mesh;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Stat;
	
	public class StaticModel_MeshSample {
		private var skinMesh:Mesh;
		private var skinAni:SkinAnimations;
		
		public function StaticModel_MeshSample() {
			
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			scene.currentCamera = (scene.addChild(new Camera(new Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.5));
			scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			Laya.stage.on(Event.RESIZE, null, function():void {
				(scene.currentCamera as Camera).viewport = new Viewport(0, 0, Laya.stage.width, Laya.stage.height);
			});
			
			var mesh:Mesh = scene.addChild(new Mesh()) as Mesh;
			mesh.load("threeDimen/staticModel/sphere/sphere-Sphere001.lm");
			mesh.transform.localPosition = new Vector3(-0.3, 0.0, 0.0);
			mesh.transform.localScale = new Vector3(0.5, 0.5, 0.5);
		
		}
	}
}