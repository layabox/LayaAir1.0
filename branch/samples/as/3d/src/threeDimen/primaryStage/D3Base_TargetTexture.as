package threeDimen.primaryStage {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.RenderTexture;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.ui.Button;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	import threeDimen.common.CameraMoveScript;
	
	public class D3Base_TargetTexture {
		private var skinMesh:MeshSprite3D;
		private var skinAni:SkinAnimations;
		private var mesh0:MeshSprite3D;
		private var mesh1:MeshSprite3D;
		private var camera2:Camera;
		
		private var x:Number = 0;
		private var y:Number = 0;
		
		public function D3Base_TargetTexture() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			loadUI();
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera1:Camera = new Camera(0, 0.1, 100);
			scene.addChild(camera1);
			camera1.transform.translate(new Vector3(0, 0.8, 1.5));
			camera1.transform.rotate(new Vector3(-30, 0, 0), true, false);
			
			camera2 = new Camera(0, 0.1, 100);
			scene.addChild(camera2);
			camera2.clearColor = new Vector4(0.0, 0.0, 1.0, 1.0);
			camera2.transform.translate(new Vector3(0, 0.8, 1.5));
			camera2.transform.rotate(new Vector3(-30, 0, 0), true, false);
			camera2.renderTarget = new RenderTexture(512, 512);
			camera2.renderingOrder = -1;
			
			mesh0 = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/staticModel/quad/quad-Plane001.lm"))) as MeshSprite3D;
			mesh0.transform.localPosition = new Vector3(-0.3, 0.0, 0.0);
			mesh0.transform.localScale = new Vector3(0.01, 0.01, 0.01);
			
			mesh1 = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/staticModel/quad/quad-Plane001.lm"))) as MeshSprite3D;
			mesh1.transform.localPosition = new Vector3(0.3, 0.0, 0.0);
			mesh1.transform.localScale = new Vector3(0.01, 0.01, 0.01);
			
			camera1.addComponent(CameraMoveScript);
		}
		
		private function loadUI():void {
			var _this:D3Base_TargetTexture = this;
			Laya.loader.load(["../../../../res/threeDimen/ui/button.png"], Handler.create(null, function():void {
				var btn:Button = new Button();
				btn.skin = "../../../../res/threeDimen/ui/button.png";
				btn.label = "切换RenderTexture";
				btn.labelBold = true;
				btn.labelSize = 20;
				btn.sizeGrid = "4,4,4,4";
				btn.size(200, 30);
				btn.scale(Browser.pixelRatio, Browser.pixelRatio);
				btn.pos(Laya.stage.width / 2 - btn.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
				btn.on(Event.CLICK, _this, onclick);
				Laya.stage.addChild(btn);
				
				Laya.stage.on(Event.RESIZE, null, function():void {
					btn.pos(Laya.stage.width / 2 - btn.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
				});
			}));
		
		}
		
		private function onclick():void {
			(mesh1.meshRender.material as StandardMaterial).diffuseTexture = camera2.renderTarget;
		}
	}
}