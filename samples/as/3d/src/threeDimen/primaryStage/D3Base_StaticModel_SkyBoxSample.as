package threeDimen.primaryStage {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SkyBox;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import threeDimen.common.CameraMoveScript;
	
	public class D3Base_StaticModel_SkyBoxSample {
		private var skinMesh:MeshSprite3D;
		private var skinAni:SkinAnimations;
		
		public function D3Base_StaticModel_SkyBoxSample() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.8, 1.5));
			camera.transform.rotate(new Vector3( -30, 0, 0), true, false);
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			
			camera.addComponent(CameraMoveScript);
			
			var skyBox:SkyBox = new SkyBox();
			camera.sky = skyBox;
			//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
			Laya.loader.load("../../../../res/threeDimen/skyBox/px.jpg,../../../../res/threeDimen/skyBox/nx.jpg,../../../../res/threeDimen/skyBox/py.jpg,../../../../res/threeDimen/skyBox/ny.jpg,../../../../res/threeDimen/skyBox/pz.jpg,../../../../res/threeDimen/skyBox/nz.jpg", Handler.create(null, function(texture:TextureCube):void {
				skyBox.textureCube = texture;
			}), null, Loader.TEXTURECUBE);
			
			var mesh:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm"))) as MeshSprite3D;
		}
	}
}