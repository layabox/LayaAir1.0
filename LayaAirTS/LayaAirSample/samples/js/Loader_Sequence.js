/// <reference path="../../libs/LayaAir.d.ts" />
var Texture = laya.resource.Texture;
var Handler = laya.utils.Handler;
var Loader_Sequence = (function () {
    function Loader_Sequence() {
        Laya.init(100, 100);
        // 按序列加载 monkey2.png - monkey1.png - monkey0.png
        // 不开启缓存
        Laya.loader.load("res/apes/monkey2.png", Handler.create(this, this.onAssetLoaded), null, null, 0, false);
        Laya.loader.load("res/apes/monkey1.png", Handler.create(this, this.onAssetLoaded), null, null, 1, false);
        Laya.loader.load("res/apes/monkey0.png", Handler.create(this, this.onAssetLoaded), null, null, 2, false);
    }
    Loader_Sequence.prototype.onAssetLoaded = function (texture) {
        console.log(texture.source);
    };
    return Loader_Sequence;
}());
new Loader_Sequence();
