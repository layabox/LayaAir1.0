module laya {
	import Sprite = Laya.Sprite;
	import Stage = Laya.Stage;
	import BlurFilter = Laya.BlurFilter;
	import Browser = Laya.Browser;
	import Handler = Laya.Handler;
	import WebGL = Laya.WebGL;

	export class Filters_Blur {
		private apePath: string = "../../res/apes/monkey2.png";

		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			Laya.loader.load(this.apePath, Handler.create(this, this.createApe));
		}

		private createApe(): void {
			var ape: Sprite = new Sprite();
			ape.loadImage(this.apePath);

			ape.x = (Laya.stage.width - ape.width) / 2;
			ape.y = (Laya.stage.height - ape.height) / 2;

			Laya.stage.addChild(ape);

			this.applayFilter(ape);
		}

		private applayFilter(ape: Sprite): void {
			var blurFilter: BlurFilter = new BlurFilter();
			blurFilter.strength = 5;
			ape.filters = [blurFilter];
		}
	}
}
new laya.Filters_Blur();