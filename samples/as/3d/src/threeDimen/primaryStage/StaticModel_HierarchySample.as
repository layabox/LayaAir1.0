package threeDimen.primaryStage {
	import laya.d3.Laya3D;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.camera.Camera;
	import laya.d3.core.fileModel.Mesh;
	import laya.d3.core.material.Material;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.resource.tempelet.MeshTemplet;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Stat;
	
	public class StaticModel_HierarchySample {
		private var skinMesh:Mesh;
		private var skinAni:SkinAnimations;
		
		public function StaticModel_HierarchySample() {
			
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
			
			var staticMesh:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			staticMesh.on(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				var templet:MeshTemplet = (sprite.getChildAt(0) as Mesh).templet;
				templet.on(Event.LOADED, null, function(templet:MeshTemplet):void {
					for (var i:int = 0; i < templet.materials.length; i++) {
						var material:Material = templet.materials[i];
						material.luminance = 3.5;
					}
				});
			});
			staticMesh.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh");
			staticMesh.transform.localScale = new Vector3(10, 10, 10);
		}
	}
}