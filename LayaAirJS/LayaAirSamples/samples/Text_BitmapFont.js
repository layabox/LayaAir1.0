var Text = Laya.Text;
var Handler = Laya.Handler;
var BitmapFont = Laya.BitmapFont;

var fontName = "diyFont";

Laya.init(550, 400);

var bitmapFont = new BitmapFont();
bitmapFont.loadFont("res/bitmapFont/test.fnt",new Handler(this,onLoaded, [bitmapFont]));

function onLoaded(bitmapFont)
{
	bitmapFont.setSpaceWidth(10);
	Text.registerBitmapFont(fontName, bitmapFont);

	createText(fontName);
}

function createText(font)
{
	var txt = new Text();
	txt.width = 250;
	txt.wordWrap = true;
	txt.text = "Do one thing at a time, and do well.";
	txt.font = font;
	txt.leading = 5;
	txt.pos(150, 100);
	Laya.stage.addChild(txt);
}