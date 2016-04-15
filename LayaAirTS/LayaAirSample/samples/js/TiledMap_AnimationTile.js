/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var TiledMap = laya.map.TiledMap;
    var Rectangle = laya.maths.Rectangle;
    var TiledMap_AnimationTile = (function () {
        function TiledMap_AnimationTile() {
            Laya.init(1600, 800);
            this.createMap();
        }
        TiledMap_AnimationTile.prototype.createMap = function () {
            this.tiledMap = new TiledMap();
            this.tiledMap.createMap("res/tiledMap/orthogonal-test-movelayer.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), null);
        };
        return TiledMap_AnimationTile;
    }());
    laya.TiledMap_AnimationTile = TiledMap_AnimationTile;
})(laya || (laya = {}));
new laya.TiledMap_AnimationTile();
