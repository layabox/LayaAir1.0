package threeDimen.primaryStage {
	import laya.d3.component.Component3D;
	import laya.d3.component.animation.RigidAnimations;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.TransformUV;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.Material;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
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
			
			scene.currentCamera = (scene.addChild(new Camera(0, 0.1, 1000))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0, 16.8, 26.0));
			scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			scene.currentCamera.clearColor = null;
			
			scene.currentCamera.addComponent(CameraMoveScript);
			
			effectSprite = scene.addChild(new Sprite3D()) as Sprite3D;
			effectSprite.once(Event.HIERARCHY_LOADED, null, function(sender:Sprite3D, sprite3D:Sprite3D):void {
				setMeshParams(effectSprite, Material.RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE);
				var rootAnimations:RigidAnimations = sprite3D.addComponent(RigidAnimations) as RigidAnimations;
				rootAnimations.url = "../../../../res/threeDimen/staticModel/effect/WuShen/WuShen.lani";
				rootAnimations.player.play(0);
			});
			effectSprite.loadHierarchy("../../../../res/threeDimen/staticModel/effect/WuShen/WuShen.lh");
		}
		
		private function setMeshParams(spirit3D:Sprite3D, renderMode:int):void {
			if (spirit3D is MeshSprite3D) {
				var meshSprite:MeshSprite3D = spirit3D as MeshSprite3D;
				var mesh:BaseMesh = meshSprite.meshFilter.sharedMesh;
				if (mesh != null) {
					//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
					mesh.once(Event.LOADED, this, function(mesh:BaseMesh):void {
						for (var i:int = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
							var material:Material = meshSprite.meshRender.sharedMaterials[i];
							material.once(Event.LOADED, null, function(mat:Material):void {
								mat.renderMode = renderMode;
							});
							
						}
					});
				}
			}
			for (var i:int = 0; i < spirit3D._childs.length; i++)
				setMeshParams(spirit3D._childs[i], renderMode);
		}
	}
}