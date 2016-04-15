package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	
	public class Timer_CallLater
	{
		public function Timer_CallLater()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			for (var i:int = 0; i < 10; i++)
			{
				Laya.timer.callLater(this, onCallLater);
			}
		
		}
		
		private function onCallLater():void
		{
			trace("onCallLater triggered");
			
			var text:Text = new Text();
			text.font = "SimHei";
			text.fontSize = 30;
			text.color = "#FFFFFF";
			text.pos(30, 180);
			text.text = "打开控制台可见该函数仅触发了一次";
			Laya.stage.addChild(text);
		}
	}
}