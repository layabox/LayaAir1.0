/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
	import Input = laya.display.Input;

	export class Text_MaxChars {

		constructor() {
			Laya.init(550, 400);

			var inputText: Input = new Input();

			inputText.size(350, 100);
			inputText.pos(100, 150);

			inputText.inputElementXAdjuster = -1;
			inputText.inputElementYAdjuster = 1;

			// 设置字体样式
			inputText.bold = true;
			inputText.bgColor = "#666666";
			inputText.color = "#ffffff";
			inputText.fontSize = 20;

			inputText.maxChars = 5;

			Laya.stage.addChild(inputText);
		}

	}
}
new laya.Text_MaxChars();