module laya {
	import Input = Laya.Input;
	import Stage = Laya.Stage;
	import Browser = Laya.Browser;
	import WebGL = Laya.WebGL;

	export class Text_InputSingleline {

		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			this.createInput();
		}

		private createInput(): void {
			var inputText: Input = new Input();

			inputText.size(350, 100);
			inputText.x = Laya.stage.width - inputText.width >> 1;
			inputText.y = Laya.stage.height - inputText.height >> 1;

			// 移动端输入提示符
			inputText.prompt = "Type some word...";

			// 设置字体样式
			inputText.bold = true;
			inputText.bgColor = "#666666";
			inputText.color = "#ffffff";
			inputText.fontSize = 20;

			Laya.stage.addChild(inputText);
		}
	}
}
new laya.Text_InputSingleline();