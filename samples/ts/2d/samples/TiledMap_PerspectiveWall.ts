module laya {
	import Stage = laya.display.Stage;
	import TiledMap = laya.map.TiledMap;
	import Rectangle = laya.maths.Rectangle;
	import Browser = laya.utils.Browser;
	import WebGL = laya.webgl.WebGL;

	export class TiledMap_PerspectiveWall {
		private tiledMap: TiledMap;
		constructor(){
			// 不支持WebGL时自动切换至Canvas
			Laya.init(700, 500, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.bgColor = "#232628";

			this.createMap();
		}

		private createMap(): void {
			this.tiledMap = new TiledMap();
			this.tiledMap.createMap("../../res/tiledMap/perspective_walls.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), null);
		}
	}
}
new laya.TiledMap_PerspectiveWall();