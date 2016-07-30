package threeDimen.primaryStage {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.Material;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.resource.WebGLImageCube;
	
	public class D3Base_Materil_Reflect {
		private var meshSprite:MeshSprite3D;
		private var reflectTexture:Texture;
		private var material:Material;
		
		public function D3Base_Materil_Reflect() {
			//是否抗锯齿
			//Config.isAntialias = true;
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			scene.shadingMode = BaseScene.PIXEL_SHADING;
			
			scene.currentCamera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.5));
			scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			
			var sprit:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			
			 //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
			var mesh:Mesh = Mesh.load("../../../../res/threeDimen/staticModel/teapot/teapot-Teapot001.lm");
			meshSprite = sprit.addChild(new MeshSprite3D(mesh)) as MeshSprite3D;
			mesh.once(Event.LOADED, null, function():void {
				meshSprite.materials[0].once(Event.LOADED, null, function():void {
					material = meshSprite.materials[0];
					material.luminance = 0;
					material.cullFace = false;
					(material && reflectTexture) && (material.reflectTexture = reflectTexture);
				});
			});
			meshSprite.transform.localPosition = new Vector3(-0.3, 0.0, 0.0);
			meshSprite.transform.localScale = new Vector3(0.5, 0.5, 0.5);
			meshSprite.transform.localRotation = new Quaternion(-0.7071068, 0.0, 0.0, 0.7071068);
			
			 //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
			var webGLImageCube:WebGLImageCube = new WebGLImageCube(["../../../../res/threeDimen/skyBox/px.jpg", "../../../../res/threeDimen/skyBox/nx.jpg", "../../../../res/threeDimen/skyBox/py.jpg", "../../../../res/threeDimen/skyBox/ny.jpg", "../../../../res/threeDimen/skyBox/pz.jpg", "../../../../res/threeDimen/skyBox/nz.jpg"], 1024);
			webGLImageCube.once(Event.LOADED, null, function(imgCube:WebGLImageCube):void {
				reflectTexture = new Texture(imgCube);
				(material && reflectTexture) && (meshSprite.materials[0].reflectTexture = reflectTexture);
			});
			
			Laya.timer.frameLoop(1, null, function():void {
				meshSprite.transform.rotate(new Vector3(0, 0.01, 0), false);
			});
		}
	}
}