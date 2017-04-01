package threeDimen.advancedStage {
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
	
	import threeDimen.common.GlitterStripSampler;
	
	/** @private */
	public class D3Advance_GlitterSample {
		private var glitter:Glitter;
		private var sampler:GlitterStripSampler = new GlitterStripSampler();
		private var scene:Scene;
		private var camera:Camera;
		
		public function D3Advance_GlitterSample() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			scene = Laya.stage.addChild(new Scene()) as Scene;
			
			camera = scene.addChild(new Camera(0, 1, 1000)) as Camera;
			camera.transform.translate(new Vector3(0, 5, 10));
			camera.transform.rotate(new Vector3( -30, 0, 0), true, false);
			camera.clearColor = new Vector4(0.2, 0.2, 0.2, 1.0);
			
			
			glitter = scene.addChild(new Glitter()) as Glitter;
			var glitterTemplet:GlitterTemplet = glitter.templet;
			(glitter.glitterRender.sharedMaterial as GlitterMaterial).diffuseTexture =Texture2D.load("../../../../res/threeDimen/layabox.png");
			glitterTemplet.lifeTime = 0.5;
			glitterTemplet.minSegmentDistance = 0.1;//最小距离，小于抛弃
			glitterTemplet.minInterpDistance = 0.6;//最大插值距离，超过则插值
			glitterTemplet.maxSlerpCount = 128;
			glitterTemplet.color = new Vector4(0.8, 0.6, 0.3, 0.8);
			glitterTemplet.maxSegments = 600;
			
			Laya.timer.frameLoop(1, this, loop);
		}
		
		private function loop():void {
			var projectViewMat:Matrix4x4 = camera.projectionViewMatrix;
			sampler.getSampleP4();
			glitter.addGlitterByPositions(sampler.pos1, sampler.pos2);
		}
	
	}

}