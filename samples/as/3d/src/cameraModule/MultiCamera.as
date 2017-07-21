package cameraModule {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SkyBox;
	import laya.display.Stage;
	import laya.utils.Stat;
	import common.CameraMoveScript;
	
	public class MultiCamera {
		
		public function MultiCamera() {
			
			Laya3D.init(0, 0,true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera1:Camera = scene.addChild(new Camera( 0, 0.1, 100)) as Camera;
			camera1.clearColor = new Vector4(0.3, 0.3, 0.3, 1.0);
			camera1.transform.translate(new Vector3(0, 0, 1.5));
			camera1.normalizedViewport = new Viewport(0, 0, 0.5, 1.0);
			
			var camera2:Camera = scene.addChild(new Camera( 0, 0.1, 100)) as Camera;
			camera2.clearColor = new Vector4(0.0, 0.0, 1.0, 1.0);
			camera2.transform.translate(new Vector3(0, 0, 1.5));
			camera2.normalizedViewport = new Viewport(0.5, 0.0, 0.5, 0.5);
			camera2.addComponent(CameraMoveScript);
			camera2.clearFlag = BaseCamera.CLEARFLAG_SKY;
			var skyBox:SkyBox = new SkyBox();
			skyBox.textureCube = TextureCube.load("../../../../res/threeDimen/skyBox/skyBox2/skyCube.ltc");
			camera2.sky = skyBox;
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			
			var layaMonkey:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Sprite3D;
			
		}
	}
}