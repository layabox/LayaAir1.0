package 
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.utils.Ease;
	import laya.utils.Tween;
	public class Tween_Letters
	{
		
		public function Tween_Letters() 
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			setup();
		}
		
		private function setup():void 
		{
			var demoString:String = "LayaBox";
			
			for (var i:int = 0, len = demoString.length; i < len; ++i)
			{
				var letterText:Text = createLetter(demoString.charAt(i));
				letterText.x = 400 / len * i + 50;
				
				Tween.to(letterText, { y : 200 }, 1000, Ease.elasticOut, null, i * 1000);
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