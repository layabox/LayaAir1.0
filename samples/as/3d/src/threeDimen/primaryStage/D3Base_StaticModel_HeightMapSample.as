package threeDimen.primaryStage {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.HeightMap;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Stat;
	
	public class D3Base_StaticModel_HeightMapSample {
		private var skinMesh:MeshSprite3D;
		private var skinAni:SkinAnimations;
		
		public function D3Base_StaticModel_HeightMapSample() {
			//是否抗锯齿
			//Config.isAntialias = true;
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			scene.currentCamera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.5));
			scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			
			var mesh:Mesh = Mesh.load("../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm");
			var meshSprite:MeshSprite3D = scene.addChild(new MeshSprite3D(mesh)) as MeshSprite3D;
			
			mesh.once(Event.LOADED, null, function():void {
				var cellSize:Vector2 = new Vector2();
				var heightMap:HeightMap= HeightMap.creatFromMesh(meshSprite, 512, 512, cellSize);
			});
		
		}
	}
}