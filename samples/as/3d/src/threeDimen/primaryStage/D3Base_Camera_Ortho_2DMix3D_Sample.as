package threeDimen.primaryStage {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.resource.models.Mesh;
	import laya.d3.utils.Utils3D;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.ui.Button;
	import laya.ui.ComboBox;
	import laya.ui.Image;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	//////////////////////////////////////////////////
	//         Y
	//         ^
	//         ¦
	//         ¦
	//         ¦(0,0)
	//  --------------->X  正交视图下的3D坐标系统
	//         ¦
	//         ¦ 
	//         ¦
	//         ¦
	//
	//
	//  (0,0)
	//  --------------->X  2D坐标系统
	// ¦
	// ¦ 
	// ¦
	// ¦
	// ¦
	// ¦
	// ¦
	// ˇ
	// Y
	/////////////////////////////////////////////////
	
	public class D3Base_Camera_Ortho_2DMix3D_Sample {
		private var skinMesh:MeshSprite3D;
		private var skinAni:SkinAnimations;
		private var translate:Vector3 = new Vector3(200, 100, 0);//理解为屏幕坐标，左上角为（0，0）
		private var convertTranslate:Vector3 = new Vector3(0, 0, 0);
		
		private var skin:String = "../../../../res/ui/button-1.png";
		
		public function D3Base_Camera_Ortho_2DMix3D_Sample() {
			Laya3D.init(0, 0,true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			//****************************2D背景************************
			var dialog:Image = new Image("../../../../res/bg.jpg");
			dialog.pos(0, 0);
			Laya.stage.addChild(dialog);
			//**********************************************************
			
			
			//****************************3D场景***************************
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 300))) as Camera;
			camera.transform.translate(new Vector3(0, 0, 150));
			camera.clearColor = null;
			camera.orthographicProjection = true;
			var mesh:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm"))) as MeshSprite3D;
			
			Utils3D.convert3DCoordTo2DScreenCoord(translate, convertTranslate);
			mesh.transform.localPosition = convertTranslate;
			mesh.transform.localScale = new Vector3(100, 100, 100);//球的直径在三维空间中为1米（放大100倍，此时为100米），当正交投影矩阵的宽高等同于像素宽高时，一米可认为一个像素，所以球等于200个像素,可与2D直接混合。
			//窗口尺寸变化相关属性重置。
			Laya.stage.on(Event.RESIZE, null, function():void {
				camera.orthographicVerticalSize = RenderState.clientHeight;
				Utils3D.convert3DCoordTo2DScreenCoord(translate, convertTranslate);
				mesh.transform.localPosition = convertTranslate;
			});
			//************************************************************
			
			
			//****************************2D UI***************************
			Laya.loader.load(skin, Handler.create(this, onLoadComplete));
			//************************************************************
		}
		
		private function onLoadComplete(e:* = null):void {
			var cb:Button = createComboBox(skin);
			cb.pos(80, 90);
		}
		
		private function createComboBox(skin:String):Button {
			var btn:Button = new Button(skin);
			Laya.stage.addChild(btn);
			return btn;
		}
	}
}