var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var TiledMap = Laya.TiledMap;
    var Rectangle = Laya.Rectangle;
    var WebGL = Laya.WebGL;
    var TiledMap_AnimationTile = (function () {
        function TiledMap_AnimationTile() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(1100, 800, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.createMap();
        }
        TiledMap_AnimationTile.prototype.createMap = function () {
            this.tiledMap = new TiledMap();
            this.tiledMap.createMap("../../res/tiledMap/orthogonal-test-movelayer.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), null);
        };
        return TiledMap_AnimationTile;
    }());
    laya.TiledMap_AnimationTile = TiledMap_AnimationTile;
})(laya || (laya = {}));
new laya.TiledMap_AnimationTile();
