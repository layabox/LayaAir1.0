package 
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.utils.Browser;
	import laya.utils.Ease;
	import laya.utils.Tween;
	import laya.webgl.WebGL;

	public class Tween_Letters
	{
		
		public function Tween_Letters() 
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
			var w:int = 400;
			var offset:int = Laya.stage.width - w >> 1;
			var endY:int = Laya.stage.height / 2 - 50;
			var demoString:String = "LayaBox";
			
			for (var i:int = 0, len:int = demoString.length; i < len; ++i)
			{
				var letterText:Text = createLetter(demoString.charAt(i));
				letterText.x = w / len * i + offset;
				
				Tween.to(letterText, { y : endY }, 1000, Ease.elasticOut, null, i * 1000);
			}
		}
		
		private function createLetter(char:String):Text
		{
			var letter:Text = new Text();
			letter.text = char;
			letter.color = "#FFFFFF";
			letter.font = "Impact";
			letter.fontSize = 110;
			Laya.stage.addChild(letter);
			
			return letter;
		}
	}
}