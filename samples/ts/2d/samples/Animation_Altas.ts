module laya 
{
	import Animation = Laya.Animation;
	import Stage = Laya.Stage;
	import Rectangle = Laya.Rectangle;
	import Loader = Laya.Loader;
	import Browser = Laya.Browser;
	import WebGL = Laya.WebGL;

	export class Animation_Altas {
		private AniConfPath: string = "../../res/fighter/fighter.json";

		constructor() {
			// 不支持eWebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			ProtoBuf.load(this.AniConfPath, this.createAnimation);
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
