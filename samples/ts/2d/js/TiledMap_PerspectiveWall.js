var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var TiledMap = Laya.TiledMap;
    var Rectangle = Laya.Rectangle;
    var WebGL = Laya.WebGL;
    var TiledMap_PerspectiveWall = (function () {
        function TiledMap_PerspectiveWall() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(700, 500, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.bgColor = "#232628";
            this.createMap();
        }
        TiledMap_PerspectiveWall.prototype.createMap = function () {
            this.tiledMap = new TiledMap();
            this.tiledMap.createMap("../../res/tiledMap/perspective_walls.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), null);
        };
        return TiledMap_PerspectiveWall;
    }());
    laya.TiledMap_PerspectiveWall = TiledMap_PerspectiveWall;
})(laya || (laya = {}));
new laya.TiledMap_PerspectiveWall();
