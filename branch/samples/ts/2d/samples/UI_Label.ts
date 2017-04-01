module laya {
	import Stage = Laya.Stage;
	import Label = Laya.Label;
	import WebGL = Laya.WebGL;

	export class UI_Label {
		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(800, 600, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			this.setup();
		}

		private setup(): void {
			this.createLabel("#FFFFFF", null).pos(30, 50);
			this.createLabel("#00FFFF", null).pos(290, 50);
			this.createLabel("#FFFF00", "#FFFFFF").pos(30, 100);
			this.createLabel("#000000", "#FFFFFF").pos(290, 100);
			this.createLabel("#FFFFFF", "#00FFFF").pos(30, 150);
			this.createLabel("#0080FF", "#00FFFF").pos(290, 150);
		}

		private createLabel(color: string, strokeColor: string): Label {
			const STROKE_WIDTH: number = 4;

			var label: Label = new Label();
			label.font = "Microsoft YaHei";
			label.text = "SAMPLE DEMO";
			label.fontSize = 30;
			label.color = color;

			if (strokeColor) {
				label.stroke = STROKE_WIDTH;
				label.strokeColor = strokeColor;
			}

			Laya.stage.addChild(label);

			return label;
		}
	}
}
new laya.UI_Label();