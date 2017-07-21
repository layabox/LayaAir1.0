package vrModule
{
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.VRCamera;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.SkyBox;
	import laya.display.Stage;
	import laya.utils.Stat;
	import common.CameraMoveScript;
	import common.VRCameraMoveScript;
	
	public class VRScene1
	{
		private var rotation:Vector3 = new Vector3(0, 0.002, 0);
		public function VRScene1()
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			//与3d场景的不同是添加了vr相机
			var vrCamera:VRCamera = scene.addChild(new VRCamera(0.03, 0, 0, 0.1, 100)) as VRCamera;
			vrCamera.transform.translate(new Vector3(0, 0.1, 10));
			vrCamera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			vrCamera.addComponent(VRCameraMoveScript);
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.direction = new Vector3(0, -0.8, -1);
			directionLight.ambientColor = new Vector3(0.8, 0.8, 0.8);
			directionLight.specularColor = new Vector3(0.5, 0.5, 1.0);
			directionLight.diffuseColor = new Vector3(1, 1, 1);
			
			var earth:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/staticModel/earth/EarthPlanet.lh")) as Sprite3D;
			
			var skyBox:SkyBox = new SkyBox();
			skyBox.textureCube = TextureCube.load("../../../../res/threeDimen/skyBox/skyBox3/skyCube.ltc");
			vrCamera.sky = skyBox;
			
			Laya.timer.frameLoop(1, null, function():void {
				earth.transform.rotate(rotation, true);
			});
		}
	}
}