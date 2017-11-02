package materialModule
{
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
	
	public class StandardMaterial_NormalMap
	{
		private var scene:Scene;
		private var rotation:Vector3 = new Vector3(0, 0.01, 0);
		private var normalMapUrl:Array = ["../../../../res/threeDimen/staticModel/lizardCal/rock_norm.png", "../../../../res/threeDimen/staticModel/lizardCal/lizard_norm.png", "../../../../res/threeDimen/staticModel/lizardCal/lizard_norm.png"];
		
		public function StandardMaterial_NormalMap()
		{
			
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.6, 1.1));
			camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.direction = new Vector3(0, -0.8, -1);
			directionLight.color = new Vector3(1, 1, 1);
			
			Laya.loader.create("../../../../res/threeDimen/staticModel/lizardCal/lizardCaclute.lh", Handler.create(this, onComplete));
		
		}
		
		public function onComplete():void {
			
			var monster1:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/staticModel/lizardCal/lizardCaclute.lh")) as Sprite3D;
			monster1.transform.position = new Vector3(-0.6, 0, 0);
			monster1.transform.localScale = new Vector3(0.002, 0.002, 0.002);
			
			var monster2:Sprite3D = Sprite3D.instantiate(monster1, scene, false, new Vector3(0.6, 0, 0));
			monster2.transform.localScale = new Vector3(0.002, 0.002, 0.002);
				for (var i:int = 0; i < monster2._childs.length; i++)
				{
					var meshSprite3D:MeshSprite3D = monster2._childs[i] as MeshSprite3D;
					var material:StandardMaterial = meshSprite3D.meshRender.material as StandardMaterial;
					//法线贴图
					material.normalTexture = Texture2D.load(normalMapUrl[i]);
				}
			
			Laya.timer.frameLoop(1, null, function():void
			{
				monster1.transform.rotate(rotation);
				monster2.transform.rotate(rotation);
			});
		}
	
	}
}