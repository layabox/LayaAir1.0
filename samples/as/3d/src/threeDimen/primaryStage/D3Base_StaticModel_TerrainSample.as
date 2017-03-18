package threeDimen.primaryStage {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.material.TerrainMaterial;
	import laya.d3.core.MeshRender;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.Texture2D;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.d3.terrain.TerrainChunk;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.ui.Button;
	import laya.ui.Label;
	import laya.utils.Stat;
	import threeDimen.common.CameraMoveScript;
	
	public class D3Base_StaticModel_TerrainSample {
		private var pCamera:Camera = null;
		private var planeSprite:Sprite3D = null;
		private var planeSprite1:MeshSprite3D = null;
		private var scene:Scene = null;
		private var tempQuaternion:Quaternion;
		private var directionLight:DirectionLight;
		public function D3Base_StaticModel_TerrainSample() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			scene = Laya.stage.addChild(new Scene()) as Scene;
			scene.initOctree(160, 200, 160, new Vector3(0, -10, 0), 4);
			
			var mesh:Mesh = Mesh.load("http://10.10.20.200:7788/sphere/sphere-Sphere001.lm");
			var meshSprite:MeshSprite3D = scene.addChild(new MeshSprite3D(mesh)) as MeshSprite3D;
			meshSprite.transform.localPosition = new Vector3(0.0, 0.0, 0.0);
			meshSprite.transform.localScale = new Vector3(1, 1, 1);
			meshSprite.meshRender.castShadow = true;
			
			var terrain:TerrainChunk = new TerrainChunk(256, 256, 0.1);
			scene.addChild( terrain );
			
			var terrainMaterial:TerrainMaterial = terrain._render.sharedMaterial as TerrainMaterial;
			
			terrainMaterial.splatAlphaTexture = Texture2D.load("http://10.10.20.200:7788/terrain/SplatAlpha.jpg");
			terrainMaterial.diffuseTexture1 = Texture2D.load("http://10.10.20.200:7788/terrain/CliffAlbedoSpecular.jpg");
			terrainMaterial.diffuseTexture2 = Texture2D.load("http://10.10.20.200:7788/terrain/GrassHillAlbedo.jpg");
			terrainMaterial.diffuseTexture3 = Texture2D.load("http://10.10.20.200:7788/terrain/MudRockyAlbedoSpecular.jpg");
			terrainMaterial.diffuseTexture4 = Texture2D.load("http://10.10.20.200:7788/terrain/SandAlbedo.jpg");

			pCamera = new Camera(0, 0.1, 1000);
			scene.addChild(pCamera);
			pCamera.transform.lookAt(new Vector3(0, 8, 1), new Vector3(256*0.1/3, 0 , 256*0.1/3), new Vector3(0, 1, 0) );
			pCamera.addComponent(CameraMoveScript);
			Laya.stage.on( Event.MOUSE_DOWN, this, onMouseDown);
		}
		public function onMouseDown():void
		{
		}
	}
}