var laya;
(function (laya) {
    var Browser = Laya.Browser;
    var Stat = Laya.Stat;
    var Debug_FPSStats = (function () {
        function Debug_FPSStats() {
            Laya.init(Browser.clientWidth, Browser.clientHeight);
            Stat.show(Browser.clientWidth - 120 >> 1, Browser.clientHeight - 100 >> 1);
        }
        return Debug_FPSStats;
    }());
    laya.Debug_FPSStats = Debug_FPSStats;
})(laya || (laya = {}));
new laya.Debug_FPSStats();
