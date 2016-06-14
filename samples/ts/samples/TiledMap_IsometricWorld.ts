/// <reference path="../../../bin/ts/LayaAir.d.ts" />
module laya {
	import Sprite = laya.display.Sprite;
	import Stage = laya.display.Stage;
	import MapLayer = laya.map.MapLayer;
	import TiledMap = laya.map.TiledMap;
	import Point = laya.maths.Point;
	import Rectangle = laya.maths.Rectangle;
	import Handler = laya.utils.Handler;
	import WebGL = laya.webgl.WebGL;

	export class TiledMap_IsometricWorld {
		private tiledMap: TiledMap;
		private layer: MapLayer;
		private sprite: Sprite;

		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(1600, 800, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			this.createMap();

			Laya.stage.on("click", this, this.onStageClick);
		}

		private createMap(): void {
			this.tiledMap = new TiledMap();
			this.tiledMap.createMap("res/tiledMap/isometric_grass_and_water.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), Handler.create(this, this.mapLoaded), null, new Point(1600, 800));
		}

		private onStageClick(): void {
			var p: Point = new Point(0, 0);
			this.layer.getTilePositionByScreenPos(Laya.stage.mouseX, Laya.stage.mouseY, p);
			this.layer.getScreenPositionByTilePos(Math.floor(p.x), Math.floor(p.y), p);
			this.sprite.pos(p.x, p.y);
		}

		private mapLoaded(): void {
			this.layer = this.tiledMap.getLayerByIndex(0);

			var radiusX: number = 32;
			var radiusY: number = Math.tan(180 / Math.PI * 30) * radiusX;
			var color: string = "FF7F50";

			this.sprite = new Sprite();
			this.sprite.graphics.drawLine(0, 0, -radiusX, radiusY, color);
			this.sprite.graphics.drawLine(0, 0, radiusX, radiusY, color);
			this.sprite.graphics.drawLine(-radiusX, radiusY, 0, radiusY * 2, color);
			this.sprite.graphics.drawLine(radiusX, radiusY, 0, radiusY * 2, color);
			Laya.stage.addChild(this.sprite);
		}
	}
}
new laya.TiledMap_IsometricWorld();