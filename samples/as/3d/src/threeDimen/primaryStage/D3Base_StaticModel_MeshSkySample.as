package threeDimen.primaryStage {
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.Material;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.ClassUtils;
	import laya.utils.Stat;
	import threeDimen.common.SkySampleScript;
	
	import threeDimen.common.CameraMoveScript;
	
	/**
	 * ...
	 * @author ...
	 */
	public class D3Base_StaticModel_MeshSkySample {
		private var skySprite3D:Sprite3D;
		private var camera:Camera;
		
		public function D3Base_StaticModel_MeshSkySample() {
			Laya3D.init(0, 0,true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			camera = new Camera( 0, 0.1, 100);
			
			scene.currentCamera = scene.addChild(camera) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0.3, 0.3, 0.6));
			scene.currentCamera.transform.rotate(new Vector3(-12, 0, 0), true, false);
			
			scene.currentCamera.addComponent(CameraMoveScript);
			
			skySprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			var skySampleScript:SkySampleScript = skySprite3D.addComponent(SkySampleScript) as SkySampleScript;
			skySampleScript.skySprite = skySprite3D;
			skySampleScript.cameraSprite = camera;
			
			//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
			skySprite3D.loadHierarchy("../../../../res/threeDimen/staticModel/simpleScene/B00IT006M.v3f.lh");
			skySprite3D.once(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				var meshSprite:MeshSprite3D = sprite.getChildAt(0) as MeshSprite3D;
				var mesh:BaseMesh = meshSprite.meshFilter.sharedMesh;
				mesh.once(Event.LOADED, null, function(templet:BaseMesh):void {
					for (var i:int = 0; i < meshSprite.meshRender.shadredMaterials.length; i++) {
						var material:Material = meshSprite.meshRender.shadredMaterials[i];
						material.once(Event.LOADED, null, function(mat:Material):void {
							mat.albedo = new Vector4(3.5, 3.5, 3.5, 1.0);
							mat.renderMode = Material.RENDERMODE_SKY;
						});
					}
				});
			});
		}
	
	}

}