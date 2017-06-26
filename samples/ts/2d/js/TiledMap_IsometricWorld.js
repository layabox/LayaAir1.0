var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var TiledMap = Laya.TiledMap;
    var Point = Laya.Point;
    var Rectangle = Laya.Rectangle;
    var Handler = Laya.Handler;
    var WebGL = Laya.WebGL;
    var TiledMap_IsometricWorld = (function () {
        function TiledMap_IsometricWorld() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(1600, 800, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.createMap();
            Laya.stage.on("click", this, this.onStageClick);
        }
        TiledMap_IsometricWorld.prototype.createMap = function () {
            this.tiledMap = new TiledMap();
            this.tiledMap.createMap("../../res/tiledMap/isometric_grass_and_water.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), Handler.create(this, this.mapLoaded), null, new Point(1600, 800));
        };
        TiledMap_IsometricWorld.prototype.onStageClick = function () {
            var p = new Point(0, 0);
            this.layer.getTilePositionByScreenPos(Laya.stage.mouseX, Laya.stage.mouseY, p);
            this.layer.getScreenPositionByTilePos(Math.floor(p.x), Math.floor(p.y), p);
            this.sprite.pos(p.x, p.y);
        };
        TiledMap_IsometricWorld.prototype.mapLoaded = function () {
            this.layer = this.tiledMap.getLayerByIndex(0);
            var radiusX = 32;
            var radiusY = Math.tan(180 / Math.PI * 30) * radiusX;
            var color = "#FF7F50";
            this.sprite = new Sprite();
            this.sprite.graphics.drawLine(0, 0, -radiusX, radiusY, color);
            this.sprite.graphics.drawLine(0, 0, radiusX, radiusY, color);
            this.sprite.graphics.drawLine(-radiusX, radiusY, 0, radiusY * 2, color);
            this.sprite.graphics.drawLine(radiusX, radiusY, 0, radiusY * 2, color);
            Laya.stage.addChild(this.sprite);
        };
        return TiledMap_IsometricWorld;
    }());
    laya.TiledMap_IsometricWorld = TiledMap_IsometricWorld;
})(laya || (laya = {}));
new laya.TiledMap_IsometricWorld();
