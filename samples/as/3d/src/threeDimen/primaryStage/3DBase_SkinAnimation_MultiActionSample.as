package threeDimen.primaryStage {
	import laya.d3.Laya3D;
	import laya.d3.component.Component3D;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.camera.Camera;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.fileModel.Mesh;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.ui.Button;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SkinAnimation_MultiActionSample {
		private var currentState:int = 0;
		private var skinAni0:SkinAnimations;
		private var skinAni1:SkinAnimations;
		private var skinAni2:SkinAnimations;
		private var skinAni3:SkinAnimations;
		
		public function SkinAnimation_MultiActionSample() {
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			loadUI();
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			scene.currentCamera = (scene.addChild(new Camera(new Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0, 2.2, 3.0));
			scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			scene.currentCamera.clearColor = null;
			Laya.stage.on(Event.RESIZE, null, function():void {
				(scene.currentCamera as Camera).viewport = new Viewport(0, 0, Laya.stage.width, Laya.stage.height);
			});
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.direction = new Vector3(0, -0.8, -1);
			directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
			directionLight.specularColor = new Vector3(2.0, 2.0, 1.6);
			directionLight.diffuseColor = new Vector3(1, 1, 1);
			scene.shadingMode = BaseScene.PIXEL_SHADING;
			
			var rootSkinMesh:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			
			var skinMesh0:Mesh = rootSkinMesh.addChild(new Mesh()) as Mesh;
			skinMesh0.load("threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT0.lm");
			var skinMesh1:Mesh = rootSkinMesh.addChild(new Mesh()) as Mesh;
			skinMesh1.load("threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT1.lm");
			var skinMesh2:Mesh = rootSkinMesh.addChild(new Mesh()) as Mesh
			skinMesh2.load("threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT2.lm");
			var skinMesh3:Mesh = rootSkinMesh.addChild(new Mesh()) as Mesh;
			skinMesh3.load("threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT3.lm");
			
			skinAni0 = skinMesh0.addComponent(SkinAnimations) as SkinAnimations;
			skinAni0.url = "threeDimen/skinModel/nvXia/yequangongjinv.ani";
			skinAni0.play(0, 0.6);
			skinAni1 = skinMesh1.addComponent(SkinAnimations) as SkinAnimations;
			skinAni1.url = "threeDimen/skinModel/nvXia/yequangongjinv.ani";
			skinAni1.play(0, 0.6);
			skinAni2 = skinMesh2.addComponent(SkinAnimations) as SkinAnimations;
			skinAni2.url = "threeDimen/skinModel/nvXia/yequangongjinv.ani";
			skinAni2.play(0, 0.6);
			skinAni3 = skinMesh3.addComponent(SkinAnimations) as SkinAnimations;
			skinAni3.url = "threeDimen/skinModel/nvXia/yequangongjinv.ani";
			skinAni3.play(0, 0.6);
		}
		
		private function loadUI():void {
			var _this:SkinAnimation_MultiActionSample = this;
			Laya.loader.load(["threeDimen/ui/button.png"], Handler.create(null, function():void {
				var btn:Button = new Button();
				btn.skin = "threeDimen/ui/button.png";
				btn.label = "切换动作";
				btn.labelBold = true;
				btn.labelSize = 20;
				btn.sizeGrid = "4,4,4,4";
				btn.size(120, 30);
				btn.scale(Browser.pixelRatio, Browser.pixelRatio);
				btn.pos(Laya.stage.width / 2 - btn.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
				//btn.strokeColors = "#ff0000,#ffff00,#00ffff";
				btn.on(Event.CLICK, _this, onclick);
				Laya.stage.addChild(btn);
				
				Laya.stage.on(Event.RESIZE, null, function():void {
					btn.pos(Laya.stage.width / 2 - btn.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
				});
			}));
		}
		
		private function onclick():void {
			switch (currentState) {
			case 0: 
				skinAni0.url = "threeDimen/skinModel/nvXia/yequanaidanv.ani";
				skinAni0.play();
				skinAni1.url = "threeDimen/skinModel/nvXia/yequanaidanv.ani";
				skinAni1.play();
				skinAni2.url = "threeDimen/skinModel/nvXia/yequanaidanv.ani";
				skinAni2.play();
				skinAni3.url = "threeDimen/skinModel/nvXia/yequanaidanv.ani";
				skinAni3.play();
				break;
			case 1: 
				skinAni0.url = "threeDimen/skinModel/nvXia/yequangongjinv.ani";
				skinAni0.play(0, 0.6);
				skinAni1.url = "threeDimen/skinModel/nvXia/yequangongjinv.ani";
				skinAni1.play(0, 0.6);
				skinAni2.url = "threeDimen/skinModel/nvXia/yequangongjinv.ani";
				skinAni2.play(0, 0.6);
				skinAni3.url = "threeDimen/skinModel/nvXia/yequangongjinv.ani";
				skinAni3.play(0, 0.6);
				break;
			}
			
			currentState++;
			(currentState > 1) && (currentState = 0);
		}
	}

}