(function()
{
	var BitmapFont = Laya.BitmapFont;
	var Stage      = Laya.Stage;
	var Text       = Laya.Text;
	var Browser    = Laya.Browser;
	var Handler    = Laya.Handler;
	var WebGL      = Laya.WebGL;

	var fontName = "diyFont";

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		loadFont();
	})();

	function loadFont()
	{
		var bitmapFont = new BitmapFont();
		bitmapFont.loadFont("res/bitmapFont/test.fnt", new Handler(this, onFontLoaded, [bitmapFont]));
	}

	function onFontLoaded(bitmapFont)
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
		txt.pos(Laya.stage.width - txt.width >> 1, Laya.stage.height - txt.height >> 1);
		Laya.stage.addChild(txt);
	}
})();