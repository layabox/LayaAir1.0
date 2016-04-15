/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
	import TiledMap = laya.map.TiledMap;
	import Rectangle = laya.maths.Rectangle;

	export class TiledMap_PerspectiveWall {
		private tiledMap: TiledMap;

		constructor() {
			Laya.init(700, 450);

			this.createMap();
		}

		private createMap(): void {
			this.tiledMap = new TiledMap();
			this.tiledMap.createMap(
				"res/tiledMap/perspective_walls.json",
				new Rectangle(0, 0, Laya.stage.width, Laya.stage.height),
				null);
		}
	}
}
new laya.TiledMap_PerspectiveWall();