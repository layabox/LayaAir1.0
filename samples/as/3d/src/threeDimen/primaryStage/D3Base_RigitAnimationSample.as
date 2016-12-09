package threeDimen.primaryStage {
	import laya.d3.component.animation.RigidAnimations;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.BaseMesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Stat;
	
	import threeDimen.common.CameraMoveScript;
	
	public class D3Base_RigitAnimationSample {
		private var effectSprite:Sprite3D;
		private var skinAni:SkinAnimations;
		
		public function D3Base_RigitAnimationSample() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 1000))) as Camera;
			camera.transform.translate(new Vector3(0, 16.8, 26.0));
			camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			camera.clearColor = null;
			
			camera.addComponent(CameraMoveScript);
			
			effectSprite = scene.addChild(Sprite3D.load("../../../../res/threeDimen/staticModel/effect/WuShen/WuShen.lh")) as Sprite3D;
			effectSprite.once(Event.HIERARCHY_LOADED, null, function(sender:Sprite3D):void {
				setMeshParams(effectSprite, BaseMaterial.RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE);
				var rootAnimations:RigidAnimations = sender.addComponent(RigidAnimations) as RigidAnimations;
				rootAnimations.url = "../../../../res/threeDimen/staticModel/effect/WuShen/WuShen.lani";
				rootAnimations.player.play(0);
			});
		}
		
		private function setMeshParams(spirit3D:Sprite3D, renderMode:int):void {
			var i:int, n:int;
			if (spirit3D is MeshSprite3D) {
				var meshSprite:MeshSprite3D = spirit3D as MeshSprite3D;
				var mesh:BaseMesh = meshSprite.meshFilter.sharedMesh;
				if (mesh != null) {
					for (i = 0, n = meshSprite.meshRender.sharedMaterials.length; i < n; i++) {
						var mat:BaseMaterial = meshSprite.meshRender.sharedMaterials[i];
						mat.renderMode = renderMode;
					}
				}
			}
			for (i = 0, n = spirit3D._childs.length; i < n; i++)
				setMeshParams(spirit3D._childs[i], renderMode);
		}
	}
}