package advancedModule {
	import laya.d3.core.Camera;
	import laya.d3.core.glitter.Glitter;
	import laya.d3.core.material.GlitterMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.tempelet.GlitterTemplet;
	import laya.display.Stage;
	import laya.utils.Stat;
	import common.CameraMoveScript;
	
	/** @private */
	public class GlitterDemo {
		
		private var glitter:Glitter;
		private var pos1:Vector3 = new Vector3(0, 0, -0.5);
		private var pos2:Vector3 = new Vector3(0, 0, 0.5);
		private var scaleDelta:Number = 0;
		private var scaleValue:Number = 0;
		
		public function GlitterDemo() {
			
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = scene.addChild(new Camera(0, 1, 1000)) as Camera;
			camera.transform.translate(new Vector3(0, 6, 10));
			camera.transform.rotate(new Vector3( -30, 0, 0), true, false);
			camera.addComponent(CameraMoveScript)
			
			glitter = scene.addChild(new Glitter()) as Glitter;
			var glitterTemplet:GlitterTemplet = glitter.templet;
			var glitterMaterial:GlitterMaterial = glitter.glitterRender.sharedMaterial as GlitterMaterial;
			glitterMaterial.diffuseTexture = Texture2D.load("../../../../res/threeDimen/layabox.png");
			glitterMaterial.albedo = new Vector4(1.3, 1.3, 1.3, 1);
			glitterTemplet.lifeTime = 1.3;
			glitterTemplet.minSegmentDistance = 0.1;
			glitterTemplet.minInterpDistance = 0.6;
			glitterTemplet.maxSlerpCount = 128;
			glitterTemplet.maxSegments = 600;
			
			Laya.timer.frameLoop(1, this, loop);
		}
		
		private function loop():void {
			scaleValue = Math.sin(scaleDelta += 0.01);
			pos1.elements[0] = pos2.elements[0] = scaleValue * 13;  
			pos1.elements[1] = Math.sin(scaleValue * 20) * 2;
			pos2.elements[1] = Math.sin(scaleValue * 20) * 2;
			glitter.addGlitterByPositions(pos1, pos2);
		}
	}
}