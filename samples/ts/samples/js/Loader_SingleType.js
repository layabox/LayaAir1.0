/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Loader = laya.net.Loader;
    var Handler = laya.utils.Handler;
    var Loader_SingleType = (function () {
        function Loader_SingleType() {
            Laya.init(550, 400);
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
    laya.Loader_SingleType = Loader_SingleType;
})(laya || (laya = {}));
new laya.Loader_SingleType();
