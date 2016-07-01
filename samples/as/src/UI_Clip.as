package
{
	import laya.display.Stage;
	import laya.ui.Button;
	import laya.ui.Clip;
	import laya.ui.Image;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
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
			// 不支持WebGL时自动切换至Canvas
			Laya.init(800, 600, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";
			
			Laya.loader.load([buttonSkin, clipSkin, bgSkin], laya.utils.Handler.create(this,onSkinLoaded));
		}
		
		private function onSkinLoaded(e:*=null):void
		{
			showBg();
			createTimerAnimation();
			showTotalSeconds();
			createController();
		}
		
		private function showBg():void 
		{
			var bg:Image = new Image(bgSkin);
			bg.size(224, 302);
			bg.pos(Laya.stage.width - bg.width >> 1, Laya.stage.height -bg.height >> 1);
			Laya.stage.addChild(bg);
		}
		
		private function createTimerAnimation():void
		{
			counter = new Clip(clipSkin, 10, 1);
			counter.autoPlay = true;
			counter.interval = 1000;
			
			counter.x = (Laya.stage.width - counter.width) / 2 - 35;
			counter.y = (Laya.stage.height - counter.height) / 2 - 40;
			
			Laya.stage.addChild(counter);
		}
		
		private function showTotalSeconds():void 
		{
			var clip:Clip = new Clip(clipSkin, 10, 1);
			clip.index = clip.clipX - 1;
			clip.pos(counter.x + 60, counter.y);
			Laya.stage.addChild(clip);
		}
		
		private function createController():void 
		{
			controller = new Button(buttonSkin, "暂停");
			controller.labelBold = true;
			controller.labelColors = "#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF";
			controller.size(84, 30);
			
			controller.on('click', this, onClipSwitchState);
			
			controller.x = (Laya.stage.width - controller.width) / 2;
			controller.y = (Laya.stage.height - controller.height) / 2 + 110;
			Laya.stage.addChild(controller);
		}
		
		private function onClipSwitchState(e:*=null):void 
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