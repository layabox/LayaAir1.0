package threeDimen.primaryStage {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.net.Loader;
	import laya.utils.Stat;
	import threeDimen.common.CameraMoveScript;
	
	public class D3Base_StaticModel_MeshSample {
		public function D3Base_StaticModel_MeshSample() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:BaseCamera = new Camera(0, 0.1, 100);
			scene.addChild(camera);
			camera.transform.translate(new Vector3(0, 0.8, 1.5));
			camera.transform.rotate(new Vector3( -30, 0, 0), true, false);
			
			var mesh:Mesh=Mesh.load("../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm");
			var meshSprite:MeshSprite3D = scene.addChild(new MeshSprite3D(mesh)) as MeshSprite3D;
			meshSprite.transform.localPosition = new Vector3(-0.3, 0.0, 0.0);
			meshSprite.transform.localScale = new Vector3(0.5, 0.5, 0.5);
		}
	}
}