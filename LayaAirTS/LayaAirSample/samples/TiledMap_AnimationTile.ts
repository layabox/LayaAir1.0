/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
	import TiledMap = laya.map.TiledMap;
	import Rectangle = laya.maths.Rectangle;

	export class TiledMap_AnimationTile {
		private tiledMap: TiledMap;

		constructor() {
			Laya.init(1600, 800);

			this.createMap();
		}

		private createMap(): void {
			this.tiledMap = new TiledMap();
			this.tiledMap.createMap(
				"res/tiledMap/orthogonal-test-movelayer.json",
				new Rectangle(0, 0, Laya.stage.width, Laya.stage.height),
				null);
		}
	}
}
new laya.TiledMap_AnimationTile();