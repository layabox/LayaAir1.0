package
{
	import laya.display.BitmapFont;
	import laya.display.Text;
	import laya.utils.Handler;
	
	public class Text_BitmapFont
	{
		private var fontName:String = "diyFont";
		
		public function Text_BitmapFont()
		{
			Laya.init(550, 400);
			
			var bitmapFont:BitmapFont = new BitmapFont();
			bitmapFont.loadFont("res/bitmapFont/test.fnt",new Handler(this,onLoaded, [bitmapFont]));
		}
		
		private function onLoaded(bitmapFont:BitmapFont):void
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
			txt.pos(150, 100);
			Laya.stage.addChild(txt);
		}
	}
	
}