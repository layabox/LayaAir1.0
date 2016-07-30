package threeDimen.advancedStage {
	import laya.d3.core.scene.Scene;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.utils.Utils3D;
	import laya.display.Stage;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/*[COMPI2LER OPTIONS:showdebug]*/
	
	public class D3Advance_MousePickingSample {
		public function D3Advance_MousePickingSample() {
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			Laya.stage.addChild(new MousePickingScene());
	
	}

}