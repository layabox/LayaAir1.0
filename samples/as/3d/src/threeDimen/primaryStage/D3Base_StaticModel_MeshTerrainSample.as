package threeDimen.primaryStage {
	import PathFinding.core.Grid;
	import PathFinding.core.Heuristic;
	
	import laya.d3.component.PathFind;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.MeshTerrainSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.TransformUV;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.events.KeyBoardManager;
	import laya.utils.Stat;
	
	public class D3Base_StaticModel_MeshTerrainSample {
		private var forward:Vector3 = new Vector3(0, 0, -0.01);
		private var back:Vector3 = new Vector3(0, 0, 0.01);
		private var left:Vector3 = new Vector3(-0.01, 0, 0);
		private var right:Vector3 = new Vector3(0.01, 0, 0);
		private var skinMesh:MeshSprite3D;
		private var skinAni:SkinAnimations;
		private var scene:Scene;
		private var terrain:Mesh;
		private var terrainSprite:MeshTerrainSprite3D;
		private var sphere:Mesh;
		private var sphereSprite:MeshSprite3D;
		private var pathFingding:PathFind;
		
		public function D3Base_StaticModel_MeshTerrainSample() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 4.2, 2.6));
			camera.transform.rotate(new Vector3(-45, 0, 0), true, false);
			
			terrain = Mesh.load("../../../../res/threeDimen/staticModel/simpleScene/B00MP001M-DEFAULT01.lm");
			terrainSprite = scene.addChild(MeshTerrainSprite3D.createFromMesh(terrain, 129, 129)) as MeshTerrainSprite3D;
			terrainSprite.transform.localScale = new Vector3(10, 10, 10);
			terrainSprite.transform.position = new Vector3(0, 2.6, 1.5);
			terrainSprite.transform.rotationEuler = new Vector3(0, 0.3, 0.4);
			setMeshParams(terrainSprite, BaseMaterial.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6823, 0.6549, 0.6352), new Vector2(25.0, 25.0), "TERRAIN");
			
			pathFingding = terrainSprite.addComponent(PathFind) as PathFind;
			pathFingding.setting = {allowDiagonal: true, dontCrossCorners: false, heuristic: Heuristic.manhattan, weight: 1};
			pathFingding.grid = new Grid(64, 36);
			
			sphere = Mesh.load("../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm");
			sphereSprite = scene.addChild(new MeshSprite3D(sphere)) as MeshSprite3D;
			sphereSprite.transform.localScale = new Vector3(0.1, 0.1, 0.1);
			
			//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
			terrain.once(Event.LOADED, this, function():void {
				Laya.timer.frameLoop(1, this, _update);
			});
		
		}
		
		private function _update():void {
			KeyBoardManager.hasKeyDown(87) && sphereSprite.transform.translate(forward, false);//W
			KeyBoardManager.hasKeyDown(83) && sphereSprite.transform.translate(back, false);//S
			KeyBoardManager.hasKeyDown(65) && sphereSprite.transform.translate(left, false);//A
			KeyBoardManager.hasKeyDown(68) && sphereSprite.transform.translate(right, false);//D
			var position:Vector3 = sphereSprite.transform.position;
			var height:Number = terrainSprite.getHeight(position.x, position.z);
			isNaN(height) && (height = 0);
			
			position.elements[0] = position.x;
			position.elements[1] = height + 0.05;//0.05为球半径
			position.elements[2] = position.z;
			sphereSprite.transform.position = position;
			
			var array:Array = pathFingding.findPath(0, 0, position.x, position.z);
			trace("start:", 0, 0, " end:", position.x, position.z, "path:", array.toString());
		}
		
		private function setMeshParams(spirit3D:Sprite3D, renderMode:int, albedo:Vector4, ambientColor:Vector3, uvScale:Vector2, shaderName:String = null):void {
			if (spirit3D is MeshSprite3D) {
				var meshSprite:MeshSprite3D = spirit3D as MeshSprite3D;
				var mesh:BaseMesh = meshSprite.meshFilter.sharedMesh;
				if (mesh != null) {
					//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
					mesh.once(Event.LOADED, this, function(mesh:BaseMesh):void {
						for (var i:int = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
							var mat:StandardMaterial = meshSprite.meshRender.sharedMaterials[i] as StandardMaterial;
							var transformUV:TransformUV = new TransformUV();
							transformUV.tiling = uvScale;
							(shaderName) && (mat.setShaderName(shaderName));
							mat.transformUV = transformUV;
							mat.ambientColor = ambientColor;
							mat.albedo = albedo;
							mat.renderMode = renderMode;
						}
					});
				}
			}
			for (var i:int = 0; i < spirit3D._childs.length; i++)
				setMeshParams(spirit3D._childs[i], renderMode, albedo, ambientColor, uvScale, shaderName);
		}
	}
}