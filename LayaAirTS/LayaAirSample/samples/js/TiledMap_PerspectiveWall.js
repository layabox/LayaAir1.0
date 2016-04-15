/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var TiledMap = laya.map.TiledMap;
    var Rectangle = laya.maths.Rectangle;
    var TiledMap_PerspectiveWall = (function () {
        function TiledMap_PerspectiveWall() {
            Laya.init(700, 450);
            this.createMap();
        }
        TiledMap_PerspectiveWall.prototype.createMap = function () {
            this.tiledMap = new TiledMap();
            this.tiledMap.createMap("res/tiledMap/perspective_walls.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), null);
        };
        return TiledMap_PerspectiveWall;
    }());
    laya.TiledMap_PerspectiveWall = TiledMap_PerspectiveWall;
})(laya || (laya = {}));
new laya.TiledMap_PerspectiveWall();
