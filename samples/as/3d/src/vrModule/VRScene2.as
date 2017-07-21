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
	import common.VRCameraMoveScript;
	
	public class VRScene2
	{
		public function VRScene2()
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(Scene.load("../../../../res/threeDimen/scene/Arena/Arena.ls")) as Scene;
			
			//与3d场景的不同是添加了vr相机
			var vrCamera:VRCamera = scene.addChild(new VRCamera(0.03, 0, 0, 0.1, 100)) as VRCamera;
			vrCamera.transform.translate(new Vector3(0, 2, 0));
			vrCamera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			vrCamera.addComponent(VRCameraMoveScript);
			
			var skyBox:SkyBox = new SkyBox();
			skyBox.textureCube = TextureCube.load("../../../../res/threeDimen/skyBox/skyBox2/skyCube.ltc");
			vrCamera.sky = skyBox;
		}
	}
}