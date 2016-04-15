/// <reference path="../../libs/LayaAir.d.ts" />
var Handler = laya.utils.Handler;
var Loader = laya.net.Loader;
var Texture = laya.resource.Texture;
var Loader_SingleType = (function () {
    function Loader_SingleType() {
        Laya.init(100, 100);
        // 加载一张png类型资源
        Laya.loader.load("res/apes/monkey0.png", Handler.create(this, this.onAssetLoaded1));
        // 加载多张png类型资源
        Laya.loader.load(["res/apes/monkey0.png", "res/apes/monkey1.png", "res/apes/monkey2.png"], Handler.create(this, this.onAssetLoaded2));
    }
    Loader_SingleType.prototype.onAssetLoaded1 = function (texture) {
        // 使用texture
    };
    Loader_SingleType.prototype.onAssetLoaded2 = function () {
        var pic1 = Loader.getRes("res/apes/monkey0.png");
        var pic2 = Loader.getRes("res/apes/monkey1.png");
        var pic3 = Loader.getRes("res/apes/monkey2.png");
        // 使用资源
    };
    return Loader_SingleType;
}());
new Loader_SingleType();
