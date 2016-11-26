package threeDimen.primaryStage {
	import laya.ani.AnimationTemplet;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	public class D3Base_StaticModel_InstantiateSample {
		private var scene:Scene;
		
		public function D3Base_StaticModel_InstantiateSample() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.8, 1.5));
			camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			
			var processHandler:Handler = Handler.create(this, onProcessChange, null, false);//创建进度处理Handler，注意：后面要对应释放
			var completeHandler:Handler = Handler.create(this, onComplete);//创建完成事件处理Handler
		
			//一:资源释放。
			//1.批量加载复杂模式。
			Laya.loader.create([			
			//3D:
			{url:"../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh", clas:Sprite3D, priority:1}, 
			{url:"../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000-DEFAULT01.lm", clas:Mesh, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000B00IT001A.lmat", clas:StandardMaterial, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000B00IT001C.lmat", clas:StandardMaterial, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000B00IT002A.lmat", clas:StandardMaterial, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000B00IT003A.lmat", clas:StandardMaterial, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000B00IT004A.lmat", clas:StandardMaterial, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000B00IT005A.lmat", clas:StandardMaterial, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000B00IT006A.lmat", clas:StandardMaterial, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/map/01Jokul/Texture/B00IT001A.png", clas:Texture2D, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/map/01Jokul/Texture/B00IT001C.png", clas:Texture2D, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/map/01Jokul/Texture/B00IT002A.png", clas:Texture2D, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/map/01Jokul/Texture/B00IT003A.png", clas:Texture2D, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/map/01Jokul/Texture/B00IT004A.png", clas:Texture2D, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/map/01Jokul/Texture/B00IT005A.png", clas:Texture2D, priority:1},
			{url:"../../../../res/threeDimen/staticModel/simpleScene/map/01Jokul/Texture/B00IT006A.png", clas:Texture2D, priority:1}
			], completeHandler, processHandler);
		}
		
		public function onComplete():void {
			var staticMesh:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh")) as Sprite3D;
			staticMesh.transform.localScale = new Vector3(10, 10, 10);
			staticMesh.transform.localPosition = new Vector3(0.1, 0.1, 0.1);
			
			var meshSprite:MeshSprite3D = staticMesh.getChildAt(0) as MeshSprite3D;
			var mesh:BaseMesh = meshSprite.meshFilter.sharedMesh;
			for (var i:int = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
				var material:StandardMaterial = meshSprite.meshRender.sharedMaterials[i] as StandardMaterial;
				material.albedo = new Vector4(3.5, 3.5, 3.5, 1.0);
			}
			
			//一:........................................................................................
			var cloneSprite3D:Sprite3D = Sprite3D.instantiate(staticMesh);
			scene.addChild(cloneSprite3D);
			cloneSprite3D.transform.localScale = new Vector3(10, 10, 10);
			cloneSprite3D.transform.localPosition = new Vector3(0.2, 0.2, 0.2);
			//........................................................................................
			
			//二:........................................................................................
			//var cloneSprite3D:Sprite3D = Sprite3D.instantiate(staticMesh,null,null,scene);
			//cloneSprite3D.transform.localScale = new Vector3(10, 10, 10);
			//cloneSprite3D.transform.localPosition = new Vector3(0.2, 0.2, 0.2);
			//........................................................................................
			
			//二:........................................................................................
			//var cloneSprite3D:Sprite3D = Sprite3D.instantiate(staticMesh, new Vector3(0.3, 0.3, 0.3), new Quaternion(), scene);//注意坐标为加入场景后的世界坐标
			//cloneSprite3D.transform.localScale = new Vector3(10, 10, 10);
			//........................................................................................
		}
		
		public function onProcessChange(process:Number):void {
			trace("Process:", process);
		}
	}
}