package threeDimen.primaryStage {
	import laya.d3.Laya3D;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.camera.Camera;
	import laya.d3.core.fileModel.Mesh;
	import laya.d3.core.material.Material;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.resource.WebGLImageCube;
	
	public class Materil_Reflect {
		private var mesh:Mesh;
		private var reflectTexture:Texture;
		private var material:Material;
		
		public function Materil_Reflect() {
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			scene.shadingMode = BaseScene.PIXEL_SHADING;
			
			scene.currentCamera = (scene.addChild(new Camera(new Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.5));
			scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			Laya.stage.on(Event.RESIZE, null, function():void {
				(scene.currentCamera as Camera).viewport = new Viewport(0, 0, Laya.stage.width, Laya.stage.height);
			});
			
			var sprit:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			
			mesh = sprit.addChild(new Mesh()) as Mesh;
			mesh.on(Event.LOADED, null, function():void {
				material = mesh.templet.materials[0];
				material.luminance = 0;
				material.cullFace = false;
				(material && reflectTexture) && (material.reflectTexture = reflectTexture);
			});
			mesh.load("threeDimen/staticModel/teapot/teapot-Teapot001.lm");
			mesh.transform.localPosition = new Vector3(-0.3, 0.0, 0.0);
			mesh.transform.localScale = new Vector3(0.5, 0.5, 0.5);
			mesh.transform.localRotation = new Quaternion(-0.7071068, 0.0, 0.0, 0.7071068);
			
			var webGLImageCube:WebGLImageCube = new WebGLImageCube(["threeDimen/skyBox/px.jpg", "threeDimen/skyBox/nx.jpg", "threeDimen/skyBox/py.jpg", "threeDimen/skyBox/ny.jpg", "threeDimen/skyBox/pz.jpg", "threeDimen/skyBox/nz.jpg"], 1024);
			webGLImageCube.on(Event.LOADED, null, function(imgCube:WebGLImageCube):void {
				reflectTexture = new Texture(imgCube);
				(material && reflectTexture) && (mesh.templet.materials[0].reflectTexture = reflectTexture);
			});
			
			Laya.timer.frameLoop(1, null, function():void {
				mesh.transform.rotate(new Vector3(0, 0.01, 0), false);
			});
		}
	}
}