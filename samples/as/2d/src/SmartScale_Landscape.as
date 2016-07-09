package 
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.webgl.WebGL;

	public class SmartScale_Landscape
	{
		public function SmartScale_Landscape() 
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(550, 400, WebGL);
	
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;
	
			Laya.stage.scaleMode = "showall";
			Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
	
			Laya.stage.bgColor = "#232628";
	
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