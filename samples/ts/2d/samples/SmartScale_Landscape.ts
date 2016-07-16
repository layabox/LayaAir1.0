module laya {
	import Stage = laya.display.Stage;
	import Text = laya.display.Text;
	import WebGL = laya.webgl.WebGL;

	export class SmartScale_Landscape {
		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(550, 400, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;

			Laya.stage.bgColor = "#232628";

			this.showText();
		}

		private showText(): void {
			var text: Text = new Text();

			text.text = "Orientation-Landscape";
			text.color = "gray";
			text.font = "Impact";
			text.fontSize = 50;

			text.x = Laya.stage.width - text.width >> 1;
			text.y = Laya.stage.height - text.height >> 1;

			Laya.stage.addChild(text);
		}
	}
}
new laya.SmartScale_Landscape();