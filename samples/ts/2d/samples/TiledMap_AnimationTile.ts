/// <reference path="../../../bin/ts/LayaAir.d.ts" />
module laya {
	import Stage = laya.display.Stage;
	import TiledMap = laya.map.TiledMap;
	import Rectangle = laya.maths.Rectangle;
	import WebGL = laya.webgl.WebGL;

	export class TiledMap_AnimationTile {
		private tiledMap: TiledMap;

		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(1100, 800, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			this.createMap();
		}

		private createMap(): void {
			this.tiledMap = new TiledMap();
			this.tiledMap.createMap("res/tiledMap/orthogonal-test-movelayer.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), null);
		}
	}
}
new laya.TiledMap_AnimationTile();