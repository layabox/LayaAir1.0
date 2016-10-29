var laya;
(function (laya) {
    var Handler = Laya.Handler;
    var Loader_Sequence = (function () {
        function Loader_Sequence() {
            this.numLoaded = 0;
            this.resAmount = 3;
            Laya.init(500, 400);
            // 按序列加载 monkey2.png - monkey1.png - monkey0.png
            // 不开启缓存
            // 关闭并发加载
            Laya.loader.maxLoader = 1;
            Laya.loader.load("../../res/apes/monkey2.png", Handler.create(this, this.onAssetLoaded), null, null, 0, false);
            Laya.loader.load("../../res/apes/monkey1.png", Handler.create(this, this.onAssetLoaded), null, null, 1, false);
            Laya.loader.load("../../res/apes/monkey0.png", Handler.create(this, this.onAssetLoaded), null, null, 2, false);
        }
        Loader_Sequence.prototype.onAssetLoaded = function (texture) {
            console.log(texture.source);
            // 恢复默认并发加载个数。
            if (++this.numLoaded == 3) {
                Laya.loader.maxLoader = 5;
                console.log("All done.");
            }
        };
        return Loader_Sequence;
    }());
    laya.Loader_Sequence = Loader_Sequence;
})(laya || (laya = {}));
new laya.Loader_Sequence();
