/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var HSlider = laya.ui.HSlider;
    var VSlider = laya.ui.VSlider;
    var Handler = laya.utils.Handler;
    var Slider = (function () {
        function Slider() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            var skins = [];
            skins.push("res/ui/hslider.png", "res/ui/hslider$bar.png");
            skins.push("res/ui/vslider.png", "res/ui/vslider$bar.png");
            Laya.loader.load(skins, Handler.create(this, this.onLoadComplete));
        }
        Slider.prototype.onLoadComplete = function () {
            this.placeHSlider();
            this.placeVSlider();
        };
        Slider.prototype.placeHSlider = function () {
            var hs = new HSlider();
            hs.skin = "res/ui/hslider.png";
            hs.width = 300;
            hs.pos(50, 170);
            hs.min = 0;
            hs.max = 100;
            hs.value = 50;
            hs.tick = 1;
            hs.changeHandler = new Handler(this, this.onChange);
            Laya.stage.addChild(hs);
        };
        Slider.prototype.placeVSlider = function () {
            var vs = new VSlider();
            vs.skin = "res/ui/vslider.png";
            vs.height = 300;
            vs.pos(400, 50);
            vs.min = 0;
            vs.max = 100;
            vs.value = 50;
            vs.tick = 1;
            vs.changeHandler = new Handler(this, this.onChange);
            Laya.stage.addChild(vs);
        };
        Slider.prototype.onChange = function (value) {
            console.log("滑块的位置：" + value);
        };
        return Slider;
    }());
    ui.Slider = Slider;
})(ui || (ui = {}));
new ui.Slider();
