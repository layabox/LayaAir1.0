package 
{
	import laya.display.Stage;
	import laya.display.Text;
	
	public class Timer_Interval
	{
		private var rotateTimeBasedText:Text;
		private var rotateFrameRateBasedText:Text;
		
		public function Timer_Interval() 
		{
			Laya.init(550 , 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			rotateTimeBasedText = createText("基于时间旋转", 120, 170);
			
			rotateFrameRateBasedText = createText("基于帧频旋转", 350, 170);
			
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