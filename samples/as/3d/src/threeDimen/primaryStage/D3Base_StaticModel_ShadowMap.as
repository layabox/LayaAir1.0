package threeDimen.primaryStage {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.MeshRender;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.Mesh;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.ui.Button;
	import laya.ui.Label;
	import laya.utils.Stat;
	import threeDimen.common.CameraMoveScript;
	
	public class D3Base_StaticModel_ShadowMap {
		private var pCamera:Camera = null;
		private var planeSprite:Sprite3D = null;
		private var planeSprite1:MeshSprite3D = null;
		private var scene:Scene = null;
		private var tempQuaternion:Quaternion;
		private var directionLight:DirectionLight;
		public function D3Base_StaticModel_ShadowMap() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			scene = Laya.stage.addChild(new Scene()) as Scene;
			scene.setShadowMapInfo( 8, new Vector3(0, -1, 0), 512, 1 , 0 );
			scene.initOctree(160, 200, 160, new Vector3(0, -10, 0), 4);
			
			var mesh:Mesh = Mesh.load("http://10.10.20.200:7788/sphere/sphere-Sphere001.lm");
			//var mesh:Mesh = Mesh.load("../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm");
			var meshSprite:MeshSprite3D = scene.addChild(new MeshSprite3D(mesh)) as MeshSprite3D;
			meshSprite.transform.localPosition = new Vector3(0.0, 1.5, 0.0);
			meshSprite.transform.localScale = new Vector3(1, 1, 1);
			meshSprite.meshRender.castShadow = true;
			
			
			planeSprite = Sprite3D.load("http://10.10.20.200:7788/grid/plane.lh");
			//planeSprite = Sprite3D.load("../../../../res/threeDimen/staticModel/grid/plane.lh");
			scene.addChild( planeSprite );
			planeSprite.once(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void 
			{
				var pPlane:MeshSprite3D = planeSprite._childs[0] as MeshSprite3D;
				pPlane.meshRender.receiveShadow = true;
			});

			tempQuaternion = new Quaternion();
			directionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
			directionLight.specularColor = new Vector3(1.0, 1.0, 0.9);
			directionLight.diffuseColor = new Vector3(1, 1, 1);
			directionLight.direction = new Vector3(0, -1.0, -1.0);
			
			
			pCamera = new Camera(0, 0.1, 20);
			scene.addChild(pCamera);
			pCamera.transform.lookAt(new Vector3(0, 3, 4), new Vector3(0, 0, 0), new Vector3(0, 1, 0) );
			pCamera.addComponent(CameraMoveScript);
			Laya.stage.on( Event.MOUSE_DOWN, this, onMouseDown);

			Laya.stage.timer.frameLoop(1, null, function():void {	
				Quaternion.createFromYawPitchRoll(0.03, 0, 0, tempQuaternion);
				Vector3.transformQuat(directionLight.direction, tempQuaternion, directionLight.direction);
				if (scene.parallelSplitShadowMap)
				{
					scene.parallelSplitShadowMap.setGlobalParallelLightDir(directionLight.direction);
				}
			});
			
			initUI();
		}
		public function initUI():void
		{
			var nX:int = 400;
			var pssmLabel:Label = new Label();
			pssmLabel.pos(nX+0, 20);
			pssmLabel.size(150, 50);
			pssmLabel.bgColor = "#aaaaaa";
			pssmLabel.fontSize = 25;
			var pssmLabelText = "PSSM=";
			if ( scene.parallelSplitShadowMap )
			{
				pssmLabelText += scene.parallelSplitShadowMap.getPSSMNum(); 
			}
			else
			{
				pssmLabelText = "PSSM 未初始化shadow";
			}
			pssmLabel.text = pssmLabelText;
			Laya.stage.addChild(pssmLabel);
			pssmLabel.on(Event.MOUSE_DOWN, this, function():void {
				if (scene.parallelSplitShadowMap)
				{
					var nCurrentPSSMNum:int = scene.parallelSplitShadowMap.getPSSMNum();
					nCurrentPSSMNum++;
					if ( nCurrentPSSMNum > 3 )
					{
						nCurrentPSSMNum = 1;
					}
					scene.parallelSplitShadowMap.setPSSMNum( nCurrentPSSMNum );
					pssmLabel.text = "PSSM=" + nCurrentPSSMNum;
				}
				else
				{
					pssmLabel.text = "PCF 没有初始化阴影";
				}
			});

			var pcfLabel:Label = new Label();
			pcfLabel.pos(nX+180, 20);
			pcfLabel.size(150, 50);
			pcfLabel.fontSize = 25;
			pcfLabel.bgColor = "#aaaaaa";
			var pcfLabelText = "PCF=";
			if ( scene.parallelSplitShadowMap )
			{
				pcfLabelText += scene.parallelSplitShadowMap.getPCFType(); 
			}
			else
			{
				pcfLabelText = "PCF 未初始化shadow";
			}
			pcfLabel.text = pcfLabelText;
			Laya.stage.addChild(pcfLabel);
			pcfLabel.on(Event.MOUSE_DOWN, this, function():void {
				if (scene.parallelSplitShadowMap)
				{
					var nCurrentPCFNum:int = scene.parallelSplitShadowMap.getPCFType();
					nCurrentPCFNum++;
					if ( nCurrentPCFNum > 3 )
					{
						nCurrentPCFNum = 0;
					}
					scene.parallelSplitShadowMap.setPCFType( nCurrentPCFNum );
					pcfLabel.text = "PCF=" + nCurrentPCFNum;
				}
				else
				{
					pcfLabel.text = "PCF 没有初始化阴影";
				}
			});
			
			var shadowSizeLabel:Label = new Label();
			shadowSizeLabel.pos(nX+360, 20);
			shadowSizeLabel.size(180, 50);
			shadowSizeLabel.fontSize = 25;
			shadowSizeLabel.bgColor = "#aaaaaa";
			var shadowSizeLabelText = "SMTSize=";
			if ( scene.parallelSplitShadowMap )
			{
				shadowSizeLabelText += scene.parallelSplitShadowMap.getShadowMapTextureSize(); 
			}
			else
			{
				shadowSizeLabelText = "SMTSize 未初始化阴影";
			}
			shadowSizeLabel.text = shadowSizeLabelText;
			Laya.stage.addChild(shadowSizeLabel);
			shadowSizeLabel.on(Event.MOUSE_DOWN, this, function():void {
				if (scene.parallelSplitShadowMap)
				{
					var textureSize:int = scene.parallelSplitShadowMap.getShadowMapTextureSize();
					if (textureSize == 512)
					{
						textureSize = 1024;
					}
					else if (textureSize == 1024 )
					{
						textureSize = 2048;
					}
					else
					{
						textureSize = 512;
					}
					scene.parallelSplitShadowMap.setShadowMapTextureSize(textureSize);
					shadowSizeLabel.text = "SMTSize=" + textureSize;
				}
				else
				{
					shadowSizeLabel.text = "SMTSize 未初始化阴影";
				}
			});
		
			var closeLabel:Label = new Label();
			closeLabel.pos(nX, 100);
			closeLabel.size(150, 50);
			closeLabel.fontSize = 25;
			closeLabel.bgColor = "#aaaaaa";
			var closeLabelText = "阴影状态=";
			if ( scene.parallelSplitShadowMap )
			{
				closeLabelText += "开"
			}
			else
			{
				closeLabelText += "关";
			}
			closeLabel.text = closeLabelText;
			Laya.stage.addChild(closeLabel);
			closeLabel.on(Event.MOUSE_DOWN, this, function():void {
				if (scene.parallelSplitShadowMap)
				{
					scene.disableShadowMap();
					closeLabelText = "阴影状态=关";
					closeLabel.text = closeLabelText;
				}
				else
				{
					closeLabelText = "阴影状态=打";
					closeLabel.text = closeLabelText;
					scene.setShadowMapInfo( 8, new Vector3(0, -1, 0), 512, 1 , 0 );
				}
			});
			
			
			var distanceLabelShow:Label = new Label();
			distanceLabelShow.pos(nX+180+55, 100);
			distanceLabelShow.size(150, 50);
			distanceLabelShow.fontSize = 25;
			distanceLabelShow.bgColor = "#aaaaaa";
			if (scene.parallelSplitShadowMap)
			{
				distanceLabelShow.text = "距离=" + scene.parallelSplitShadowMap.getFarDistance();
			}
			Laya.stage.addChild(distanceLabelShow);
			
			var distanceLabel:Label = new Label();
			distanceLabel.pos(nX+180, 100);
			distanceLabel.size(50, 50);
			distanceLabel.fontSize = 25;
			distanceLabel.bgColor = "#aaaaaa";
			distanceLabel.text = " -";
			Laya.stage.addChild(distanceLabel);
			distanceLabel.on(Event.MOUSE_DOWN, this, function():void {
				if (scene.parallelSplitShadowMap)
				{
					var nCurrentDistance = scene.parallelSplitShadowMap.getFarDistance();
					nCurrentDistance --;
					scene.parallelSplitShadowMap.setFarDistance( nCurrentDistance );
					distanceLabelShow.text = "距离=" + nCurrentDistance;
				}
			});
			var distanceLabel1:Label = new Label();
			distanceLabel1.pos(nX+180+210, 100);
			distanceLabel1.size(50, 50);
			distanceLabel1.fontSize = 25;
			distanceLabel1.bgColor = "#aaaaaa";
			distanceLabel1.text = " +";
			Laya.stage.addChild(distanceLabel1);
			distanceLabel1.on(Event.MOUSE_DOWN, this, function():void {
				if (scene.parallelSplitShadowMap)
				{
					var nCurrentDistance = scene.parallelSplitShadowMap.getFarDistance();
					nCurrentDistance ++;
					scene.parallelSplitShadowMap.setFarDistance( nCurrentDistance );
					distanceLabelShow.text = "距离=" + nCurrentDistance;
				}
			});
		}
		public function onMouseDown():void
		{
			//pCamera.transform.lookAt(new Vector3(-100, 0, 0), new Vector3(0, 0, 0), new Vector3(0, 1, 0) );
			//pCamera.farPlane = 1000;
			//var pPlane:MeshSprite3D = planeSprite._childs[0] as MeshSprite3D;
			//pPlane.meshRender.receiveShadow = true;
		}
	}
}