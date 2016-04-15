Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

var inputText = new laya.display.Input();

//是否多行输入框:多行输入
inputText.multiline = true;

inputText.size(350, 100);
inputText.pos(100, 150);

inputText.inputElementXAdjuster = -2;
inputText.inputElementYAdjuster = -1;

inputText.bgColor = "#666666";
inputText.color = "#ffffff";
inputText.fontSize = 20;

Laya.stage.addChild(inputText);
