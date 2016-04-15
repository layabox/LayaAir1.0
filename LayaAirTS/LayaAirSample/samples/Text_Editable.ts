/// <reference path="../../libs/LayaAir.d.ts" />
Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

var inputText:laya.display.Input = new laya.display.Input();

inputText.size(350, 100);
inputText.pos(100, 150);

inputText.text = "这段文本不可编辑，但可复制";
inputText.editable = false;

// 设置字体样式
inputText.bold = true;
inputText.bgColor = "#666666";
inputText.color = "#ffffff";
inputText.fontSize = 20;

Laya.stage.addChild(inputText);