/// <reference path="../../../bin/ts/LayaAir.d.ts" />
module laya {
	import Sprite = laya.display.Sprite;
	import Stage = laya.display.Stage;
	import Text = laya.display.Text;
	import Stat = laya.utils.Stat;
	import WebGL = laya.webgl.WebGL;

	export class Sprite_Cache {
		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(800, 600, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			Stat.show();

			this.setup();
		}

		private setup(): void {
			var textBox: Sprite = new Sprite();

			// 随机摆放文本
			var text: Text;
			for (var i: number = 0; i < 1000; i++) {
				text = new Text();
				text.fontSize = 20;
				text.text = (Math.random() * 100).toFixed(0);
				text.rotation = Math.random() * 360;
				text.color = "#CCCCCC";

				text.x = Math.random() * Laya.stage.width;
				text.y = Math.random() * Laya.stage.height;

				textBox.addChild(text);
			}

			//缓存为静态图像
			textBox.cacheAsBitmap = true;

			Laya.stage.addChild(textBox);
		}
	}
} new laya.Sprite_Cache();