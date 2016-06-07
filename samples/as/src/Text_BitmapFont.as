package
{
	import laya.display.BitmapFont;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class Text_BitmapFont
	{
		private var fontName:String = "diyFont";
		
		public function Text_BitmapFont()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			loadFont();
		}

		private function loadFont():void
		{
			var bitmapFont:BitmapFont = new BitmapFont();
			bitmapFont.loadFont("res/bitmapFont/test.fnt",new Handler(this,onFontLoaded, [bitmapFont]));
		}

		private function onFontLoaded(bitmapFont:BitmapFont):void
		{
			bitmapFont.setSpaceWidth(10);
			Text.registerBitmapFont(fontName, bitmapFont);
			
			createText(fontName);
		}
		
		private function createText(font:String):void
		{
			var txt:Text = new Text();
			txt.width = 250;
			txt.wordWrap = true;
			txt.text = "Do one thing at a time, and do well.";			
			txt.font = font;
			txt.leading = 5;
			txt.pos(Laya.stage.width - txt.width >> 1, Laya.stage.height - txt.height >> 1);
			Laya.stage.addChild(txt);
		}
	}
	
}