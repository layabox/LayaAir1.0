/// <reference path="../../libs/LayaAir.d.ts" />
var Handler = laya.utils.Handler;
var Loader = laya.net.Loader;
var Loader_MultipleType = (function () {
    function Loader_MultipleType() {
        this.ROBOT_DATA_PATH = "res/robot/data.bin";
        this.ROBOT_TEXTURE_PATH = "res/robot/texture.png";
        Laya.init(100, 100);
        var assets = [];
        assets.push({ url: this.ROBOT_DATA_PATH, type: Loader.BUFFER });
        assets.push({ url: this.ROBOT_TEXTURE_PATH, type: Loader.IMAGE });
        Laya.loader.load(assets, Handler.create(this, this.onAssetsLoaded));
    }
    Loader_MultipleType.prototype.onAssetsLoaded = function () {
        var robotData = Loader.getRes(this.ROBOT_DATA_PATH);
        var robotTexture = Loader.getRes(this.ROBOT_TEXTURE_PATH);
    };
    return Loader_MultipleType;
}());
new Loader_MultipleType();
