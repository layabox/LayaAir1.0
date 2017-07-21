package materialModule {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SkyBox;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	import threeDimen.common.CameraMoveScript;
	
	public class StandardMaterial_ReflectMap {
		
		private var rotation:Vector3 = new Vector3(0, 0.01, 0);
		public function StandardMaterial_ReflectMap() {
			
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 1.3, 1.8));
			camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.direction = new Vector3(0, -0.8, -1);
			directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
			directionLight.specularColor = new Vector3(1.0, 1.0, 0.8);
			directionLight.diffuseColor = new Vector3(1, 1, 1);
			
			var textureCube:TextureCube = TextureCube.load("../../../../res/threeDimen/skyBox/skyBox1/skyCube.ltc");
			
			var skyBox:SkyBox = new SkyBox();
			skyBox.textureCube = textureCube;
			camera.sky = skyBox;
			
			var teapot1:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/staticModel/teapot/teapot-Teapot001.lm"))) as MeshSprite3D;
			teapot1.transform.position = new Vector3( -0.8, 0, 0);
			teapot1.transform.rotation = new Quaternion(0.7071068, 0, 0, -0.7071067);
			
			var teapot2:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/staticModel/teapot/teapot-Teapot001.lm"))) as MeshSprite3D;
			teapot2.transform.position = new Vector3( 0.8, 0, 0);
			teapot2.transform.rotation = new Quaternion(0.7071068, 0, 0, -0.7071067);
			teapot2.meshFilter.sharedMesh.once(Event.LOADED, null, function():void {
				var material:StandardMaterial = teapot2.meshRender.material as StandardMaterial;
				//反射贴图
				material.renderMode = StandardMaterial.RENDERMODE_OPAQUEDOUBLEFACE;
				material.reflectTexture = textureCube;
			});
			
			Laya.timer.frameLoop(1, null, function():void {
				teapot1.transform.rotate(rotation, false);
				teapot2.transform.rotate(rotation, false);
			});
		}
	}
}