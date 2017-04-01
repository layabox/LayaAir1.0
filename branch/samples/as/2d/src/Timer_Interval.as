package 
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	
	public class Timer_Interval
	{
		private var rotateTimeBasedText:Text;
		private var rotateFrameRateBasedText:Text;
		
		public function Timer_Interval() 
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			setup();
		}

		private function setup():void
		{
			var vGap:int = 200;
			
			rotateTimeBasedText = createText("基于时间旋转", Laya.stage.width / 2, (Laya.stage.height - vGap) / 2);
			rotateFrameRateBasedText = createText("基于帧频旋转", rotateTimeBasedText.x, rotateTimeBasedText.y + vGap);

			Laya.timer.loop(200, this, animateTimeBased);
			Laya.timer.frameLoop(2, this, animateFrameRateBased);
		}
		
		private function createText(text:String, x:int, y:int):Text
		{
			var t:Text = new Text();
			t.text = text;
			t.fontSize = 30;
			t.color = "white";
			t.bold = true;
			t.pivot(t.width / 2, t.height / 2);
			t.pos(x, y);
			Laya.stage.addChild(t);
			
			return t;
		}
		
		private function animateTimeBased():void
		{
			rotateTimeBasedText.rotation += 1;
		}
		
		private function animateFrameRateBased():void
		{
			rotateFrameRateBasedText.rotation += 1;
		}
	}
}