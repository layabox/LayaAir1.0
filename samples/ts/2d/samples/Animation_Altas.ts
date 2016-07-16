module laya 
{
	import Animation = laya.display.Animation;
	import Stage = laya.display.Stage;
	import Rectangle = laya.maths.Rectangle;
	import Loader = laya.net.Loader;
	import Browser = laya.utils.Browser;
	import Handler = laya.utils.Handler;
	import WebGL = laya.webgl.WebGL;

	export class Animation_Altas {
		private AniConfPath: string = "../../res/fighter/fighter.json";

		constructor() {
			// 不支持eWebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			Laya.loader.load(this.AniConfPath, Handler.create(this, this.createAnimation), null, Loader.ATLAS);
		}

		private createAnimation(): void {
			var ani: Animation = new Animation();
			ani.loadAtlas(this.AniConfPath); // 加载图集动画
			ani.interval = 30; // 设置播放间隔（单位：毫秒）
			ani.index = 1; // 当前播放索引
			ani.play(); // 播放图集动画

			// 获取动画的边界信息
			var bounds: Rectangle = ani.getGraphicBounds();
			ani.pivot(bounds.width / 2, bounds.height / 2);

			ani.pos(Laya.stage.width / 2, Laya.stage.height / 2);

			Laya.stage.addChild(ani);
		}
	}
}
new laya.Animation_Altas()
