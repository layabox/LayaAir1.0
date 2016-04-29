(function() {
	var Text = Laya.Text;

	function createSampleText() {
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

	Laya.init(550, 400);
	Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

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
})();