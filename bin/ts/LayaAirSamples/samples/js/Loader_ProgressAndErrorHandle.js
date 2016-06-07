/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Event = laya.events.Event;
    var Loader = laya.net.Loader;
    var Handler = laya.utils.Handler;
    var Loader_ProgressAndErrorHandle = (function () {
        function Loader_ProgressAndErrorHandle() {
            Laya.init(550, 400);
            // 无加载失败重试
            Laya.loader.retryNum = 0;
            var urls = ["do not exist", "res/fighter/fighter.png", "res/legend/map.jpg"];
            Laya.loader.load(urls, Handler.create(this, this.onAssetLoaded), Handler.create(this, this.onLoading, null, false), Loader.TEXT);
            // 侦听加载失败
            Laya.loader.on(Event.ERROR, this, this.onError);
        }
        Loader_ProgressAndErrorHandle.prototype.onAssetLoaded = function (texture) {
            // 使用texture
            console.log("加载结束");
        };
        // 加载进度侦听器
        Loader_ProgressAndErrorHandle.prototype.onLoading = function (progress) {
            console.log("加载进度: " + progress);
        };
        Loader_ProgressAndErrorHandle.prototype.onError = function (err) {
            console.log("加载失败: " + err);
        };
        return Loader_ProgressAndErrorHandle;
    }());
    laya.Loader_ProgressAndErrorHandle = Loader_ProgressAndErrorHandle;
})(laya || (laya = {}));
new laya.Loader_ProgressAndErrorHandle();
