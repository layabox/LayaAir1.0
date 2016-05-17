/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var BlurFilter = laya.filters.BlurFilter;
    var WebGL = laya.webgl.WebGL;
    var Filters_Blur = (function () {
        function Filters_Blur() {
            Laya.init(550, 400, WebGL);
            var ape = new Sprite();
            ape.loadImage("res/apes/monkey2.png");
            ape.pos(200, 100);
            Laya.stage.addChild(ape);
            var blurFilter = new BlurFilter();
            blurFilter.strength = 5;
            ape.filters = [blurFilter];
        }
        return Filters_Blur;
    }());
    laya.Filters_Blur = Filters_Blur;
})(laya || (laya = {}));
new laya.Filters_Blur();
