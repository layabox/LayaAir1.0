var laya;
(function (laya) {
    var Loader = Laya.Loader;
    var Handler = Laya.Handler;
    var Loader_MultipleType = (function () {
        function Loader_MultipleType() {
            this.ROBOT_DATA_PATH = "../../res/skeleton/robot/robot.bin";
            this.ROBOT_TEXTURE_PATH = "../../res/skeleton/robot/texture.png";
            Laya.init(100, 100);
            var assets = [];
            assets.push({ url: this.ROBOT_DATA_PATH, type: Loader.BUFFER });
            assets.push({ url: this.ROBOT_TEXTURE_PATH, type: Loader.IMAGE });
            Laya.loader.load(assets, Handler.create(this, this.onAssetsLoaded));
        }
        Loader_MultipleType.prototype.onAssetsLoaded = function () {
            var robotData = Loader.getRes(this.ROBOT_DATA_PATH);
            var robotTexture = Loader.getRes(this.ROBOT_TEXTURE_PATH);
            // 使用资源
        };
        return Loader_MultipleType;
    }());
    laya.Loader_MultipleType = Loader_MultipleType;
})(laya || (laya = {}));
new laya.Loader_MultipleType();
