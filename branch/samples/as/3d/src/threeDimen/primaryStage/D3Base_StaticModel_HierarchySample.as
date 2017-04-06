package threeDimen.primaryStage {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.BaseMesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Stat;
	
	public class D3Base_StaticModel_HierarchySample {
		private var skinMesh:MeshSprite3D;
		private var skinAni:SkinAnimations;
		
		public function D3Base_StaticModel_HierarchySample() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.8, 1.5));
			camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			
			//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
			var staticMesh:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh")) as Sprite3D;
			staticMesh.once(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				staticMesh.transform.localScale = new Vector3(10, 10, 10);
				var meshSprite:MeshSprite3D = sprite.getChildAt(0) as MeshSprite3D;
				var mesh:BaseMesh = meshSprite.meshFilter.sharedMesh;
				for (var i:int = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
					var mat:StandardMaterial = meshSprite.meshRender.sharedMaterials[i] as StandardMaterial;
					mat.albedo = new Vector4(3.5, 3.5, 3.5, 1.0);
				}
			});
		
		}
	}
}