/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var Button = laya.ui.Button;
    var Clip = laya.ui.Clip;
    var Image = laya.ui.Image;
    var ClipSample = (function () {
        function ClipSample() {
            this.buttonSkin = "res/ui/button-7.png";
            this.clipSkin = "res/ui/num0-9.png";
            this.bgSkin = "res/ui/coutDown.png";
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.loader.load([this.buttonSkin, this.clipSkin, this.bgSkin], laya.utils.Handler.create(this, this.onSkinLoaded));
        }
        ClipSample.prototype.onSkinLoaded = function () {
            this.showBg();
            this.createTimerAnimation();
            this.showTotalSeconds();
            this.createController();
        };
        ClipSample.prototype.showBg = function () {
            var bg = new Image(this.bgSkin);
            bg.pos(163, 50);
            Laya.stage.addChild(bg);
        };
        ClipSample.prototype.createTimerAnimation = function () {
            this.counter = new Clip(this.clipSkin, 10, 1);
            this.counter.autoPlay = true;
            this.counter.interval = 1000;
            this.counter.pos(223, 130);
            Laya.stage.addChild(this.counter);
        };
        ClipSample.prototype.showTotalSeconds = function () {
            var clip = new Clip(this.clipSkin, 10, 1);
            clip.index = clip.clipX - 1;
            clip.pos(285, 130);
            Laya.stage.addChild(clip);
        };
        ClipSample.prototype.createController = function () {
            this.controller = new Button(this.buttonSkin, "暂停");
            this.controller.labelBold = true;
            this.controller.labelColors = "#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF";
            this.controller.on('click', this, this.onClipSwitchState);
            this.controller.pos(230, 300);
            Laya.stage.addChild(this.controller);
        };
        ClipSample.prototype.onClipSwitchState = function () {
            if (this.counter.isPlaying) {
                this.counter.stop();
                this.currFrame = this.counter.index;
                this.controller.label = "播放";
            }
            else {
                this.counter.play();
                this.counter.index = this.currFrame;
                this.controller.label = "暂停";
            }
        };
        return ClipSample;
    }());
    ui.ClipSample = ClipSample;
})(ui || (ui = {}));
new ui.ClipSample();
