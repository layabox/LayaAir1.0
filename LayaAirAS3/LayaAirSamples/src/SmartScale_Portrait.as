package 
{
	import laya.display.Stage;
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.utils.Browser;

	public class SmartScale_Portrait
	{
		public function SmartScale_Portrait() 
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_NOSCALE;
			Laya.stage.screenMode = Stage.SCREEN_VERTICAL;
			
			showText();
		}
		
		private function showText():void 
		{
			var text:Text = new Text();
			
			text.text = "Orientation-Portrait";
			text.color = "gray";
			text.font = "Impact";
			text.fontSize = 50;
			
			text.x = Laya.stage.width - text.width >> 1;
			text.y = Laya.stage.height - text.height >> 1;
			
			Laya.stage.addChild(text);
		}
	}
}