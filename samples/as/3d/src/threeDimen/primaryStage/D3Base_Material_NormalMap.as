package threeDimen.primaryStage {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
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
	import threeDimen.common.CameraMoveScript;
	
	public class D3Base_Material_NormalMap {
		private var root:Sprite3D;
		private var rotation:Vector3 = new Vector3(0, 0.01, 0);
		
		public function D3Base_Material_NormalMap() {
			//是否抗锯齿
			//Config.isAntialias = true;
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			scene.shadingMode = BaseScene.PIXEL_SHADING;
			
			scene.currentCamera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.6));
			scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			
			scene.currentCamera.addComponent(CameraMoveScript);
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.direction = new Vector3(0, -0.8, -1);
			directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
			directionLight.specularColor = new Vector3(1.0, 1.0, 0.8);
			directionLight.diffuseColor = new Vector3(1, 1, 1);
			
			root = scene.addChild(new Sprite3D()) as Sprite3D;
			root.transform.localScale = new Vector3(0.2, 0.2, 0.2);
			
			loadModel("../../../../res/threeDimen/staticModel/lizard/lizard-lizard_geo.lm", "../../../../res/threeDimen/staticModel/lizard/lizard_norm.png");
			loadModel("../../../../res/threeDimen/staticModel/lizard/lizard-eye_geo.lm", "../../../../res/threeDimen/staticModel/lizard/lizardeye_norm.png");
			loadModel("../../../../res/threeDimen/staticModel/lizard/lizard-rock_geo.lm", "../../../../res/threeDimen/staticModel/lizard/rock_norm.png");
			Laya.timer.frameLoop(1, null, function():void {
				root.transform.rotate(rotation, true);
			});
		}
		
		public function loadModel(meshPath:String, normalMapPath:String):void {
			var normalTexture:Texture;
			var material:Material;
			
			var mesh:Mesh = Mesh.load(meshPath);
			var meshSprite:MeshSprite3D = root.addChild(new MeshSprite3D(mesh)) as MeshSprite3D;
			
			 //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
			mesh.once(Event.LOADED, null, function():void {
				meshSprite.materials[0].once(Event.LOADED, null, function():void {
					material = meshSprite.materials[0];
					(material && normalTexture) && (material.normalTexture = normalTexture);
				});
			});
			
			Laya.loader.load(normalMapPath, Handler.create(null, function(texture:Texture):void {
				normalTexture = texture;
				(material && normalTexture) && (material.normalTexture = normalTexture);
			}));
		}
	
	}
}