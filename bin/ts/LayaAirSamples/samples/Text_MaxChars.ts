/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
	import Input = laya.display.Input;
	import Stage = laya.display.Stage;
	import Browser = laya.utils.Browser;
	import WebGL = laya.webgl.WebGL;

	export class Text_MaxChars {

		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			this.createInput();
		}

		private createInput(): void {
			var inputText: Input = new Input();

			inputText.size(350, 100);
			inputText.x = Laya.stage.width - inputText.width >> 1;
			inputText.y = Laya.stage.height - inputText.height >> 1;

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