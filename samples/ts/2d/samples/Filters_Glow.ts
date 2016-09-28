module laya {
	import Sprite = Laya.Sprite;
	import Stage = Laya.Stage;
	import GlowFilter = Laya.GlowFilter;
	import Texture = Laya.Texture;
	import Browser = Laya.Browser;
	import Handler = Laya.Handler;
	import WebGL = Laya.WebGL;

	export class Filters_Glow {
		private apePath: string = "../../res/apes/monkey2.png";

		private ape: Sprite;

		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			Laya.loader.load(this.apePath, Handler.create(this, this.setup));
		}

		private setup(): void {
			this.createApe();
			this.applayFilter();
		}

		private createApe(): void {
			this.ape = new Sprite();
			this.ape.loadImage(this.apePath);

			var texture: Texture = Laya.loader.getRes(this.apePath);
			this.ape.x = (Laya.stage.width - texture.width) / 2;
			this.ape.y = (Laya.stage.height - texture.height) / 2;

			Laya.stage.addChild(this.ape);
		}

		private applayFilter(): void {
			//创建一个发光滤镜
			var glowFilter: GlowFilter = new GlowFilter("#ffff00", 10, 0, 0);
			//设置滤镜集合为发光滤镜
			this.ape.filters = [glowFilter];
		}
	}
}
new laya.Filters_Glow();