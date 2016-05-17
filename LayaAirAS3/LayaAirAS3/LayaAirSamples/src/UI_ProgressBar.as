package
{
	import laya.display.Stage;
	import laya.ui.ProgressBar;
	import laya.utils.Handler;
	
	public class UI_ProgressBar
	{
		private var progressBar:ProgressBar;
		
		public function UI_ProgressBar()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			Laya.loader.load(["res/ui/progressBar.png", "res/ui/progressBar$bar.png"], Handler.create(this, onLoadComplete));
		}
		
		private function onLoadComplete():void
		{
			progressBar = new ProgressBar("res/ui/progressBar.png");
			progressBar.pos(75, 150);
			
			progressBar.width = 400;
			
			progressBar.sizeGrid = "5,5,5,5";
			progressBar.changeHandler = new Handler(this, onChange);
			Laya.stage.addChild(progressBar);
			
			Laya.timer.loop(100, this, changeValue);
		}
		
		private function changeValue():void
		{
			progressBar.value += 0.05;
			
			if (progressBar.value == 1)
				progressBar.value = 0;
		}
		
		private function onChange(value:Number):void
		{
			trace("进度：" + Math.floor(value * 100) + "%");
		}
	}
}