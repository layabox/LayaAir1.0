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
	import laya.d3.resource.models.BoxMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SkyBox;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.d3.terrain.Terrain;
	import laya.d3.terrain.TerrainChunk;
	import laya.d3.terrain.TerrainFilter;
	import laya.d3.terrain.TerrainHeightData;
	import laya.d3.terrain.TerrainRes;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.ui.Button;
	import laya.ui.Label;
	import laya.utils.Browser;
	import laya.utils.Stat;
	import threeDimen.common.CameraMoveScript;
	
	public class D3Base_StaticModel_TerrainSample {
		private static var _tempQuaternion:Quaternion = new Quaternion();
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
			//ShaderCompile3D.debugMode = true;
			Stat.show();
			scene = Laya.stage.addChild(new Scene()) as Scene;
			//scene.initOctree(1024, 1024, 1024, new Vector3(0, -10, 0), 4);
			var mesh:Mesh = Mesh.load("../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm");
			var meshSprite:MeshSprite3D = scene.addChild(new MeshSprite3D(mesh)) as MeshSprite3D;
			meshSprite.transform.localPosition = new Vector3(512+3, 4, 512+3);
			meshSprite.transform.localScale = new Vector3(1, 1, 1);
			meshSprite.meshRender.castShadow = true;
			
			var terrain:Terrain = new Terrain( TerrainRes.load( "../../../../res/threeDimen/terrain/terrain.json" ) );
			terrain.transform.localPosition = new Vector3(0, 0, 0);
			scene.addChild(terrain);
			
			pCamera = new Camera(0, 1, 1024);
			scene.addChild(pCamera);
			pCamera.transform.position = new Vector3(512, 5, 512);
			pCamera.transform.lookAt(new Vector3(517,5,517), new Vector3(0, 1, 0) );
			pCamera.addComponent(CameraMoveScript);
			pCamera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			
			
			directionLight = new DirectionLight();
			directionLight.ambientColor = new Vector3(0.4, 0.4, 0.4);
			directionLight.specularColor = new Vector3(0.7, 0.6, 0.6);
			directionLight.diffuseColor = new Vector3(1.5, 1.5, 1.5);
			directionLight.direction = new Vector3(0, -1.0, -1.0);
			scene.addChild(directionLight);
			//directionLight.shadow = true;//阴影开关
			directionLight.shadowDistance = 300;
			directionLight.shadowResolution = 2048;
			
			var skyBox:SkyBox = new SkyBox();
			pCamera.sky = skyBox;
			//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
			skyBox.textureCube = TextureCube.load("../../../../res/threeDimen/skyBox/skyCube.ltc");
			
			Laya.stage.timer.frameLoop(1, null, function():void {
				Quaternion.createFromYawPitchRoll(0.03, 0, 0, _tempQuaternion);
				var direction:Vector3 = directionLight.direction;
				Vector3.transformQuat(direction, _tempQuaternion, direction);
				directionLight.direction = direction;
			});
			Laya.stage.on(Event.KEY_DOWN, this, onKeyDown);
			
			initUI();
		}
		public function initUI():void {
			var nX:int = 100;
			var toleranceLabel:Label = new Label();
			toleranceLabel.pos(nX + 180 + 60, 20);
			toleranceLabel.size(200, 50);
			toleranceLabel.bgColor = "#aaaaaa";
			toleranceLabel.fontSize = 25;
			toleranceLabel.text = "LOD容忍值=" + Terrain.LOD_TOLERANCE_VALUE;
			Laya.stage.addChild(toleranceLabel);
			
			var toleranceAddLabel:Label = new Label();
			toleranceAddLabel.pos(nX + 180 + 270, 20);
			toleranceAddLabel.size(50, 50);
			toleranceAddLabel.fontSize = 25;
			toleranceAddLabel.bgColor = "#aaaaaa";
			toleranceAddLabel.text = " +";
			Laya.stage.addChild(toleranceAddLabel);
			toleranceAddLabel.on(Event.MOUSE_DOWN, this, function():void {
				Terrain.LOD_TOLERANCE_VALUE++;
				toleranceLabel.text = "LOD容忍值=" + Terrain.LOD_TOLERANCE_VALUE;
			});
			
			var toleranceSubLabel:Label = new Label();
			toleranceSubLabel.pos(nX + 180, 20);
			toleranceSubLabel.size(50, 50);
			toleranceSubLabel.fontSize = 25;
			toleranceSubLabel.bgColor = "#aaaaaa";
			toleranceSubLabel.text = " -";
			Laya.stage.addChild(toleranceSubLabel);
			toleranceSubLabel.on(Event.MOUSE_DOWN, this, function():void {
				Terrain.LOD_TOLERANCE_VALUE--;
				if (Terrain.LOD_TOLERANCE_VALUE < 0)
				{
					Terrain.LOD_TOLERANCE_VALUE = 0;
				}
				toleranceLabel.text = "LOD容忍值=" + Terrain.LOD_TOLERANCE_VALUE;
			});
			
			//----------------------------------------------------------------------
			var distanceFactorLabel:Label = new Label();
			distanceFactorLabel.pos(nX + 180 + 60, 90);
			distanceFactorLabel.size(200, 50);
			distanceFactorLabel.bgColor = "#aaaaaa";
			distanceFactorLabel.fontSize = 25;
			distanceFactorLabel.text = "LOD距离因子=" + Terrain.LOD_DISTANCE_FACTOR;
			Laya.stage.addChild(distanceFactorLabel);
			
			var disFactorAddLabel:Label = new Label();
			disFactorAddLabel.pos(nX + 180 + 270,90);
			disFactorAddLabel.size(50, 50);
			disFactorAddLabel.fontSize = 25;
			disFactorAddLabel.bgColor = "#aaaaaa";
			disFactorAddLabel.text = " +";
			Laya.stage.addChild(disFactorAddLabel);
			disFactorAddLabel.on(Event.MOUSE_DOWN, this, function():void {
				Terrain.LOD_DISTANCE_FACTOR+=0.1;
				distanceFactorLabel.text = "LOD距离因子=" + Terrain.LOD_DISTANCE_FACTOR.toFixed(1);
			});
			
			var disFactorSubLabel:Label = new Label();
			disFactorSubLabel.pos(nX + 180, 90);
			disFactorSubLabel.size(50, 50);
			disFactorSubLabel.fontSize = 25;
			disFactorSubLabel.bgColor = "#aaaaaa";
			disFactorSubLabel.text = " -";
			Laya.stage.addChild(disFactorSubLabel);
			disFactorSubLabel.on(Event.MOUSE_DOWN, this, function():void {
				Terrain.LOD_DISTANCE_FACTOR-=0.1;
				if (Terrain.LOD_DISTANCE_FACTOR < 1)
				{
					Terrain.LOD_DISTANCE_FACTOR = 1;
				}
				distanceFactorLabel.text = "LOD距离因子=" + Terrain.LOD_DISTANCE_FACTOR.toFixed(1);
			});
			//----------------------------------------------------------------------
			
			var changeLabel:Label = new Label();
			changeLabel.pos(nX + 180 + 270 + 100, 20);
			changeLabel.size(100, 50);
			changeLabel.bgColor = "#aaaaaa";
			changeLabel.fontSize = 25;
			changeLabel.text = " 三角面";
			Laya.stage.addChild(changeLabel);
			changeLabel.on(Event.MOUSE_DOWN, this, function():void {
				Terrain.RENDER_LINE_MODEL = !Terrain.RENDER_LINE_MODEL;
				if (Terrain.RENDER_LINE_MODEL)
				{
					changeLabel.text = "  线框";
				}
				else
				{
					changeLabel.text = "三角面";
				}
			});
			
			/*
			var shadowLabel:Label = new Label();
			shadowLabel.pos(nX + 180 + 270 + 100 + 120, 20);
			shadowLabel.size(100, 50);
			shadowLabel.bgColor = "#aaaaaa";
			shadowLabel.fontSize = 25;
			shadowLabel.text = "阴影=关";
			Laya.stage.addChild(shadowLabel);
			shadowLabel.on(Event.MOUSE_DOWN, this, function():void {
				directionLight.shadow = !(directionLight.shadow);
				if (directionLight.shadow)
				{
					shadowLabel.text = "阴影=开";
				}
				else
				{
					shadowLabel.text = "阴影=关";
				}
			});
			*/
			/*
			var lightLabel:Label = new Label();
			lightLabel.pos(nX + 180 + 270 + 100 + 120 + 120, 20);
			lightLabel.size(100, 50);
			lightLabel.bgColor = "#aaaaaa";
			lightLabel.fontSize = 25;
			lightLabel.text = "灯光=开";
			Laya.stage.addChild(lightLabel);
			lightLabel.on(Event.MOUSE_DOWN, this, function():void {
				scene.removeChild(directionLight);
			});
			*/
		}
		public function onKeyDown(e:*):void {
			switch(e.keyCode)
			{
			case 51:
				Terrain.RENDER_LINE_MODEL = true;
				break;
			case 52:
				Terrain.RENDER_LINE_MODEL = false;
				break;
			}
		}
	}
}