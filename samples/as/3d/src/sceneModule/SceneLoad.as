package sceneModule
{
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.SkyBox;
	import laya.display.Stage;
	import laya.utils.Stat;
	import common.CameraMoveScript;
	
	public class SceneLoad
	{
		public function SceneLoad()
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(Scene.load("../../../../res/threeDimen/scene/Arena/Arena.ls")) as Scene;
			
			var camera:Camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
			camera.transform.translate(new Vector3(0, 2, 0));
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			camera.addComponent(CameraMoveScript);
			
			var skyBox:SkyBox = new SkyBox();
			skyBox.textureCube = TextureCube.load("../../../../res/threeDimen/skyBox/skyBox2/skyCube.ltc");
			camera.sky = skyBox;
		}
	}
}