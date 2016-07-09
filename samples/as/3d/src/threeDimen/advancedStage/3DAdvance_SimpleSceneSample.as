package threeDimen.advancedStage {
	import laya.d3.Laya3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.TransformUV;
	import laya.d3.core.camera.Camera;
	import laya.d3.core.fileModel.Mesh;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.resource.tempelet.MeshTemplet;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.ClassUtils;
	import laya.utils.Stat;
	
	import threeDimen.common.CameraMoveScript;
	
/** @private */
	public class SimpleSceneSample {
		
		public function SimpleSceneSample() {
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
			
			loadScene(scene);
		}
		
		private function loadScene(scene:Scene):void {
			var root:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			root.transform.localScale = new Vector3(10, 10, 10);
			
			var skySprite3d0:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			skySprite3d0.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT006M.v3f.lh");
			skySprite3d0.on(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				setMeshParams(skySprite3d0, false, false, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
			});
			
			var skySprite3d1:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			skySprite3d1.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT007M.v3f.lh");
			skySprite3d1.on(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				setMeshParams(skySprite3d1, false, true, 1.0, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
			});
			
			var singleFaceTransparent:Sprite3D = root.addChild(new Sprite3D()) as Sprite3D;
			singleFaceTransparent.on(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				setMeshParams(singleFaceTransparent, false, true, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
			});
			singleFaceTransparent.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT004M.v3f.lh");
			singleFaceTransparent.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT003M000.v3f.lh");
			
			var meshSprite3d:Sprite3D = root.addChild(new Sprite3D()) as Sprite3D;
			meshSprite3d.on(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				setMeshParams(meshSprite3d, false, false, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
			});
			
			meshSprite3d.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh");
			meshSprite3d.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT002M000.v3f.lh");
			meshSprite3d.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT008M.v3f.lh");
			meshSprite3d.loadHierarchy("threeDimen/staticModel/simpleScene/B00MP003M.v3f.lh");
			
			var doubleFaceTransparent:Sprite3D = root.addChild(new Sprite3D()) as Sprite3D;
			doubleFaceTransparent.on(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				setMeshParams(doubleFaceTransparent, true, true, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
			});
			doubleFaceTransparent.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT005M.v3f.lh");
			
			var terrainSpirit0:Sprite3D = root.addChild(new Sprite3D()) as Sprite3D;
			terrainSpirit0.on(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				setMeshParams(terrainSpirit0, false, false, 3.5, new Vector3(0.6823, 0.6549, 0.6352), new Vector2(25.0, 25.0), "TERRAIN");
			});
			terrainSpirit0.loadHierarchy("threeDimen/staticModel/simpleScene/B00MP001M.v3f.lh");
			
			var terrainSpirit1:Sprite3D = root.addChild(new Sprite3D()) as Sprite3D;
			terrainSpirit1.on(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				setMeshParams(terrainSpirit1, false, false, 3.5, new Vector3(0.6823, 0.6549, 0.6352), new Vector2(19.0, 19.0), "TERRAIN");
			});
			terrainSpirit1.loadHierarchy("threeDimen/staticModel/simpleScene/B00MP002M.v3f.lh");
		}
		
		private function setMeshParams(spirit3D:Sprite3D, doubleFace:Boolean, alpha:Boolean, luminance:Number, ambientColor:Vector3, uvScale:Vector2, shaderName:String = undefined, transparentMode:int = 0.0):void {
			if (spirit3D is Mesh) {
				var tempet:MeshTemplet = (spirit3D as Mesh).templet;
				if (tempet != null) {
					tempet.on(Event.LOADED, this, function(tempet:MeshTemplet):void {
						(shaderName) && tempet.setShaderByName(shaderName);
						for (var i:int = 0; i < tempet.materials.length; i++) {
							var transformUV:TransformUV = new TransformUV();
							transformUV.tiling = uvScale;
							tempet.materials[i].transformUV = transformUV;
							tempet.materials[i].ambientColor = ambientColor;
							tempet.materials[i].luminance = luminance;
							doubleFace && (tempet.materials[i].cullFace = false);
							alpha && (tempet.materials[i].transparent = true);
							tempet.materials[i].transparentMode = transparentMode;
						}
					});
				}
			}
			for (var i:int = 0; i < spirit3D._childs.length; i++)
				setMeshParams(spirit3D._childs[i], doubleFace, alpha, luminance, ambientColor, uvScale, shaderName);
		}
	}
}