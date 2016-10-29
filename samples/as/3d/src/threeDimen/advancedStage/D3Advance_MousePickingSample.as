package threeDimen.advancedStage {
	import laya.display.Stage;
	import laya.utils.Stat;
	
	/*[COMPI2LER OPTIONS:showdebug]*/
	
	public class D3Advance_MousePickingSample {
		public function D3Advance_MousePickingSample() {
			Laya3D.init(0, 0,true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			Laya.stage.addChild(new MousePickingScene());
		
		}
	
	}
}