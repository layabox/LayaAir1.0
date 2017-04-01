(function()
{
	var Stage   = Laya.Stage;
	var Text    = Laya.Text;
	var Browser = Laya.Browser;
	var WebGL   = Laya.WebGL;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(550, 400, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		setup();
	})();

	function setup()
	{
		// 该文本自动适应尺寸
		var autoSizeText = createSampleText();
		autoSizeText.overflow = Text.VISIBLE;
		autoSizeText.y = 50;

		// 该文本被限制了宽度
		var widthLimitText = createSampleText();
		widthLimitText.width = 100;
		widthLimitText.y = 180;

		//该文本被限制了高度 
		var heightLimitText = createSampleText();
		heightLimitText.height = 20;
		heightLimitText.y = 320;
	}

	function createSampleText()
	{
		var text = new Text();
		text.overflow = Text.HIDDEN;

		text.color = "#FFFFFF";
		text.font = "Impact";
		text.fontSize = 20;
		text.borderColor = "#FFFF00";
		text.x = 80;

		Laya.stage.addChild(text);
		text.text = "A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL\n" + "A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL\n" + "A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL";

		return text;
	}
})();