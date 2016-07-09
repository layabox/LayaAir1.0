package threeDimen.primaryStage {
	import laya.d3.Laya3D;
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
	import laya.utils.ClassUtils;
	import laya.utils.Stat;
	
	import threeDimen.common.CameraMoveScript;
	
	/**
	 * ...
	 * @author ...
	 */
	public class StaticModel_MeshSkySample {
		
		public function StaticModel_MeshSkySample() {
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			scene.currentCamera = (scene.addChild(new Camera(new Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0.3, 0.3, 0.6));
			scene.currentCamera.transform.rotate(new Vector3(-12, 0, 0), true, false);
			Laya.stage.on(Event.RESIZE, null, function():void {
				(scene.currentCamera as Camera).viewport = new Viewport(0, 0, Laya.stage.width, Laya.stage.height);
			});
			
			scene.currentCamera.addComponent(CameraMoveScript);
			
			var skySprite3D:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			skySprite3D.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT006M.v3f.lh");
			skySprite3D.on(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				var meshTemplet:MeshTemplet = (sprite.getChildAt(0) as Mesh).templet;
				meshTemplet.on(Event.LOADED, null, function(templet:MeshTemplet):void {
					for (var i:int = 0; i < templet.materials.length; i++) {
						var material:Material = meshTemplet.materials[i];
						material.luminance = 3.5;
					}
				});
			});
		}
	
	}

}