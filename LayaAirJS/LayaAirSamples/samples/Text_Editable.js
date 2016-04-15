Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

var inputText = new laya.display.Input();

inputText.size(350, 100);
inputText.pos(100, 150);

inputText.text = "这段文本不可编辑，但可复制";
inputText.editable = false;

inputText.inputElementXAdjuster = -1;
inputText.inputElementYAdjuster = 1;

// 设置字体样式
inputText.bold = true;
inputText.bgColor = "#666666";
inputText.color = "#ffffff";
inputText.fontSize = 20;

Laya.stage.addChild(inputText);
