package materialModule {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.BlinnPhongMaterial;
	import laya.d3.core.material.PBRStandardMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SkyBox;
	import laya.d3.resource.models.SphereMesh;
	import laya.d3.shader.ShaderCompile3D;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Stat;
	
	public class BlinnPhong_DiffuseMap {
		
		private var rotation:Vector3 = new Vector3(0, 0.01, 0);
		public function BlinnPhong_DiffuseMap() {

			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.5, 1.5));
			camera.transform.rotate(new Vector3(-15, 0, 0), true, false);
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.direction = new Vector3(0, -0.8, -1);
			directionLight.color = new Vector3(1, 1, 1);
			
			var skyBox:SkyBox = new SkyBox();
			skyBox.textureCube = TextureCube.load("../../../../res/threeDimen/skyBox/skyBox2/skyCube.ltc");
			camera.sky = skyBox;
			
			var earth1:MeshSprite3D = scene.addChild(new MeshSprite3D(new SphereMesh())) as MeshSprite3D;
			earth1.transform.position = new Vector3( -0.6, 0, 0);
			
			var earth2:MeshSprite3D = scene.addChild(new MeshSprite3D(new SphereMesh())) as MeshSprite3D;
			earth2.transform.position = new Vector3( 0.6, 0, 0);
			var material:BlinnPhongMaterial = new BlinnPhongMaterial();
			//漫反射贴图
			material.albedoTexture = Texture2D.load("../../../../res/threeDimen/texture/earth.png");
			earth2.meshRender.material = material;
			
			Laya.timer.frameLoop(1, null, function():void {
				earth1.transform.rotate(rotation, false);
				earth2.transform.rotate(rotation, false);
			});
		}
	}
}