package skyModule 
{
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.models.SkyDome;
	import laya.display.Stage;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import common.CameraMoveScript;
	/**
	 * ...
	 * @author 
	 */
	public class SkyDomeSample 
	{
		
		public function SkyDomeSample() 
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.8, 1.5));
			camera.transform.rotate(new Vector3( -30, 0, 0), true, false);
			camera.addComponent(CameraMoveScript);
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			
			var skyDome:SkyDome = new SkyDome();
			camera.sky = skyDome;
			skyDome.texture = Texture2D.load("../../../../res/threeDimen/env/sp_default/env.png");
		}
	}
}