package threeDimen.primaryStage {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.resource.Texture2D;
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
	
	public class D3Base_Materil_Reflect {
		private var meshSprite:MeshSprite3D;
		private var cubeTexture:TextureCube;
		private var material:StandardMaterial;
		
		public function D3Base_Materil_Reflect() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.8, 1.5));
			camera.transform.rotate(new Vector3( -30, 0, 0), true, false);
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			var skyBox:SkyBox = new SkyBox();
			camera.sky = skyBox;
			
			camera.addComponent(CameraMoveScript);
			
			var sprite:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			
			//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
			var mesh:Mesh = Mesh.load("../../../../res/threeDimen/staticModel/teapot/teapot-Teapot001.lm");
			meshSprite = sprite.addChild(new MeshSprite3D(mesh)) as MeshSprite3D;
			mesh.once(Event.LOADED, null, function():void {
				meshSprite.meshRender.sharedMaterials[0].once(Event.LOADED, null, function():void {
					material = meshSprite.meshRender.sharedMaterials[0] as  StandardMaterial;
					material.albedo = new Vector4(0.0, 0.0, 0.0, 0.0);
					material.renderMode = BaseMaterial.RENDERMODE_OPAQUEDOUBLEFACE;
					(material && cubeTexture) && (material.reflectTexture = cubeTexture);
				});
			});
			meshSprite.transform.localPosition = new Vector3(-0.3, 0.0, 0.0);
			meshSprite.transform.localScale = new Vector3(0.5, 0.5, 0.5);
			meshSprite.transform.localRotation = new Quaternion(-0.7071068, 0.0, 0.0, 0.7071068);
			
			////可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
			Laya.loader.load("../../../../res/threeDimen/skyBox/px.jpg,../../../../res/threeDimen/skyBox/nx.jpg,../../../../res/threeDimen/skyBox/py.jpg,../../../../res/threeDimen/skyBox/ny.jpg,../../../../res/threeDimen/skyBox/pz.jpg,../../../../res/threeDimen/skyBox/nz.jpg", Handler.create(null, function(texture:TextureCube):void {
				cubeTexture = texture;
				(material && cubeTexture) && ((meshSprite.meshRender.sharedMaterials[0] as  StandardMaterial).reflectTexture = texture);
				skyBox.textureCube = texture;
			}), null, Loader.TEXTURECUBE);
			
			Laya.timer.frameLoop(1, null, function():void {
				meshSprite.transform.rotate(new Vector3(0, 0.01, 0), false);
			});
		}
	}
}