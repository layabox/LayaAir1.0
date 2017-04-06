package threeDimen.primaryStage {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.ui.Image;
	import laya.utils.Stat;
	
	public class D3Base_StaticModel_3DSpaceTo2DSpace {
		private var skinMesh:MeshSprite3D;
		private var skinAni:SkinAnimations;
		private var outPos:Vector3;
		private var projectViewMat:Matrix4x4;
		private var offset0:Vector3 = new Vector3(0.01, 0, 0);
		private var offset1:Vector3 = new Vector3(-0.01, 0, 0);
		private var totalOffset:Number = 0;
		private var b:Boolean = true;
		
		public function D3Base_StaticModel_3DSpaceTo2DSpace() {
			Laya3D.init(0, 0,true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			outPos = new Vector3();
			projectViewMat = new Matrix4x4();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.8, 1.5));
			camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			
			var mesh:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm"))) as MeshSprite3D;
			mesh.transform.localScale = new Vector3(0.5, 0.5, 0.5);
			
			var monkey:Image = new Image("../../../../res/apes/monkey2.png");
			Laya.stage.addChild(monkey);
			
			Laya.timer.frameLoop(1, null, function():void {
				if (Math.abs(totalOffset) > 0.5)
					b = !b;
				
				if (b) {
					totalOffset += offset0.x;
					mesh.transform.translate(offset0);
				} else {
					totalOffset += offset1.x;
					mesh.transform.translate(offset1);
				}
				
				Matrix4x4.multiply(camera.projectionMatrix, camera.viewMatrix, projectViewMat);
				camera.viewport.project(mesh.transform.position, projectViewMat, outPos);
				
				monkey.pos(outPos.x/Laya.stage.clientScaleX, outPos.y/Laya.stage.clientScaleY);//TODO:后期会考虑stage缩放问题。
			});
		}
	
	}
}