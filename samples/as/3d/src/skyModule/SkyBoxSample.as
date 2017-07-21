package skyModule {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SkyBox;
	import laya.display.Stage;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	import common.CameraMoveScript;
	
	public class SkyBoxSample {
		
		public function SkyBoxSample() {
			
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
			
			//天空盒
			var skyBox:SkyBox = new SkyBox();
			camera.sky = skyBox;
			skyBox.textureCube = TextureCube.load("../../../../res/threeDimen/skyBox/skyBox1/skyCube.ltc");
			
		}
	}
}