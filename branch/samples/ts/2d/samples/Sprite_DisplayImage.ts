module laya {
	import Sprite = Laya.Sprite;
	import Stage = Laya.Stage;
	import Texture = Laya.Texture;
	import Browser = Laya.Browser;
	import Handler = Laya.Handler;
	import WebGL = Laya.WebGL;

	export class Sprite_DisplayImage {
		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			this.showApe();
		}

		private showApe(): void {
			// 方法1：使用loadImage
			var ape: Sprite = new Sprite();
			Laya.stage.addChild(ape);
			ape.loadImage("../../res/apes/monkey3.png");

			// 方法2：使用drawTexture
			Laya.loader.load("../../res/apes/monkey2.png", Handler.create(this, function(): void {
				var t: Texture = Laya.loader.getRes("../../res/apes/monkey2.png");
				var ape: Sprite = new Sprite();
				ape.graphics.drawTexture(t, 0, 0);
				Laya.stage.addChild(ape);
				ape.pos(200, 0);
			}));
		}
	}
}
new laya.Sprite_DisplayImage();