package threeDimen.primaryStage {
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	import threeDimen.common.CameraMoveScript;
	
	public class D3Base_Material_NormalMap {
		private var root:Sprite3D;
		private var rotation:Vector3 = new Vector3(0, 0.01, 0);
		
		public function D3Base_Material_NormalMap() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.8, 1.6));
			camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			camera.addComponent(CameraMoveScript);
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.direction = new Vector3(0, -0.8, -1);
			directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
			directionLight.specularColor = new Vector3(1.0, 1.0, 0.8);
			directionLight.diffuseColor = new Vector3(1, 1, 1);
			
			root = scene.addChild(new Sprite3D()) as Sprite3D;
			root.transform.localScale = new Vector3(0.002, 0.002, 0.002);
			
			loadModel("../../../../res/threeDimen/staticModel/lizardCal/lizardCaclute-lizard_geo.lm", "../../../../res/threeDimen/staticModel/lizardCal/lizard_norm.png");
			loadModel("../../../../res/threeDimen/staticModel/lizardCal/lizardCaclute-eye_geo.lm", "../../../../res/threeDimen/staticModel/lizardCal/lizardeye_norm.png");
			loadModel("../../../../res/threeDimen/staticModel/lizardCal/lizardCaclute-rock_geo.lm", "../../../../res/threeDimen/staticModel/lizardCal/rock_norm.png");
			Laya.timer.frameLoop(1, null, function():void {
				root.transform.rotate(rotation, true);
			});
		}
		
		public function loadModel(meshPath:String, normalMapPath:String):void {
			var normalTexture:Texture2D;
			var material:StandardMaterial;
			
			var mesh:Mesh = Mesh.load(meshPath);
			var meshSprite:MeshSprite3D = root.addChild(new MeshSprite3D(mesh)) as MeshSprite3D;
			
			//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
			mesh.once(Event.LOADED, null, function():void {
				material = meshSprite.meshRender.sharedMaterials[0] as StandardMaterial;
				(material && normalTexture) && (material.normalTexture = normalTexture);
			});
			
			Laya.loader.load(normalMapPath, Handler.create(null, function(texture:Texture2D):void {
				normalTexture = texture;
				(material && normalTexture) && (material.normalTexture = normalTexture);
			}));
		}
	
	}
}