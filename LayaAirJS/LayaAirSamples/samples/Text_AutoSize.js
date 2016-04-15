function createSampleText()
{
	var text = new laya.display.Text();
	
	text.color = 0xFFFFFF;
	text.font = "Impact";
	text.fontSize = 20;
	text.borderColor = 0xFFFF00;
	text.x = 80;
	
	Laya.stage.addChild(text);
	text.text = 
		"A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL\n" + 
		"A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL\n" + 
		"A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL";
		
	return text;
}

Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

// 该文本自动适应尺寸
var autoSizeText = createSampleText();
autoSizeText.y = 50;

// 该文本被限制了宽度
var widthLimitText = createSampleText();
widthLimitText.width = 100;
widthLimitText.y = 180;

//该文本被限制了高度
var heightLimitText = createSampleText();
heightLimitText.height = 20;
heightLimitText.y = 320;