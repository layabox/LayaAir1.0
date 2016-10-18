package threeDimen.primaryStage {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.TransformUV;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.resource.RenderTexture;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Stat;
	
	public class D3Base_Camera_MultiCamera {
		private var skinMesh:MeshSprite3D;
		private var skinAni:SkinAnimations;
		
		private var x:Number=0;
		private var y:Number=0;
		public function D3Base_Camera_MultiCamera() {
			Laya3D.init(0, 0,true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera1:Camera = new Camera( 0, 0.1, 100);
			scene.addChild(camera1);
			camera1.transform.translate(new Vector3(0, 0.8, 1.5));
			camera1.transform.rotate(new Vector3( -30, 0, 0), true, false);
			camera1.normalizedViewport = new Viewport(0, 0, 0.5, 1.0);
			
			var camera2:Camera = new Camera( 0, 0.1, 100);
			scene.addChild(camera2);
			camera2.clearColor = new Vector4(1.0, 1.0, 1.0, 1.0);
			camera2.transform.translate(new Vector3(0, 0.8, 1.5));
			camera2.transform.rotate(new Vector3( -30, 0, 0), true, false);
			camera2.normalizedViewport = new Viewport(0.5, 0.5, 0.5, 0.5);
			
			var mesh:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm"))) as MeshSprite3D;
			mesh.transform.localPosition = new Vector3(-0.3, 0.0, 0.0);
			mesh.transform.localScale = new Vector3(0.5, 0.5, 0.5);
		}
	}
}