/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Browser = laya.utils.Browser;
    var Stat = laya.utils.Stat;
    var Debug_FPSStats = (function () {
        function Debug_FPSStats() {
            Laya.init(1, 1);
            Stat.show(Browser.clientWidth - 120 >> 1, Browser.clientHeight - 100 >> 1);
        }
        return Debug_FPSStats;
    }());
    laya.Debug_FPSStats = Debug_FPSStats;
})(laya || (laya = {}));
new laya.Debug_FPSStats();
