package
{
	import laya.display.Stage;
	import laya.events.Event;
	import laya.ui.Button;
	import laya.ui.Clip;
	import laya.ui.Image;
	
	public class UI_Clip
	{
		private var buttonSkin:String = "res/ui/button-7.png";
		private var clipSkin:String = "res/ui/num0-9.png";
		private var bgSkin:String = "res/ui/coutDown.png";
		
		private var counter:Clip;
		private var currFrame:int;
		private var controller:Button;
		
		public function UI_Clip()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			Laya.loader.load([buttonSkin, clipSkin, bgSkin], laya.utils.Handler.create(this,onSkinLoaded));
		}
		
		private function onSkinLoaded():void
		{
			showBg();
			createTimerAnimation();
			showTotalSeconds();
			createController();
		}
		
		private function showBg():void 
		{
			var bg:Image = new Image(bgSkin);
			bg.pos(163, 50);
			Laya.stage.addChild(bg);
		}
		
		private function createTimerAnimation():void
		{
			counter = new Clip(clipSkin, 10, 1);
			counter.autoPlay = true;
			counter.interval = 1000;
			
			counter.pos(223, 130);
			
			Laya.stage.addChild(counter);
		}
		
		private function showTotalSeconds():void 
		{
			var clip:Clip = new Clip(clipSkin, 10, 1);
			clip.index = clip.clipX - 1;
			clip.pos(285, 130);
			Laya.stage.addChild(clip);
		}
		
		private function createController():void 
		{
			controller = new Button(buttonSkin, "暂停");
			controller.labelBold = true;
			controller.labelColors = "#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF";
			
			controller.on('click', this, onClipSwitchState);
			
			controller.pos(230, 300);
			Laya.stage.addChild(controller);
		}
		
		private function onClipSwitchState():void 
		{
			if (counter.isPlaying)
			{
				counter.stop();
				currFrame = counter.index;
				controller.label = "播放";
			}
			else
			{
				counter.play();
				counter.index = currFrame;
				controller.label = "暂停";
			}
		}	
	}
}