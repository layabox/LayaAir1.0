/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var HScrollBar = laya.ui.HScrollBar;
    var VScrollBar = laya.ui.VScrollBar;
    var Handler = laya.utils.Handler;
    var HScrollBarSample = (function () {
        function HScrollBarSample() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            var skins = [];
            skins.push("res/ui/hscroll.png", "res/ui/hscroll$bar.png", "res/ui/hscroll$down.png", "res/ui/hscroll$up.png");
            skins.push("res/ui/vscroll.png", "res/ui/vscroll$bar.png", "res/ui/vscroll$down.png", "res/ui/vscroll$up.png");
            Laya.loader.load(skins, Handler.create(this, this.onSkinLoadComplete));
        }
        HScrollBarSample.prototype.onSkinLoadComplete = function () {
            this.placeHScroller();
            this.placeVScroller();
        };
        HScrollBarSample.prototype.placeHScroller = function () {
            var hs = new HScrollBar();
            hs.skin = "res/ui/hscroll.png";
            hs.width = 300;
            hs.pos(50, 170);
            hs.min = 0;
            hs.max = 100;
            hs.changeHandler = new Handler(this, this.onChange);
            Laya.stage.addChild(hs);
        };
        HScrollBarSample.prototype.placeVScroller = function () {
            var vs = new VScrollBar();
            vs.skin = "res/ui/vscroll.png";
            vs.height = 300;
            vs.pos(400, 50);
            vs.min = 0;
            vs.max = 100;
            vs.changeHandler = new Handler(this, this.onChange);
            Laya.stage.addChild(vs);
        };
        HScrollBarSample.prototype.onChange = function (value) {
            console.log("滚动条的位置： value=" + value);
        };
        return HScrollBarSample;
    }());
    ui.HScrollBarSample = HScrollBarSample;
})(ui || (ui = {}));
new ui.HScrollBarSample();
