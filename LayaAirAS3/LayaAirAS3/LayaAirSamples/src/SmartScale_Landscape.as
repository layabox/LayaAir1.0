package 
{
	import laya.display.Stage;
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.utils.Browser;

	public class SmartScale_Landscape
	{
		public function SmartScale_Landscape() 
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_NOSCALE;
			Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
			
			showText();
		}
		
		private function showText():void 
		{
			var text:Text = new Text();
			
			text.text = "Orientation-Landscape";
			text.color = "gray";
			text.font = "Impact";
			text.fontSize = 50;
			
			text.x = Laya.stage.width - text.width >> 1;
			text.y = Laya.stage.height - text.height >> 1;
			
			Laya.stage.addChild(text);
		}
	}
}