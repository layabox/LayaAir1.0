/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var ProgressBar = laya.ui.ProgressBar;
    var Handler = laya.utils.Handler;
    var ProgressBarSample = (function () {
        function ProgressBarSample() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.loader.load(["res/ui/progressBar.png", "res/ui/progressBar$bar.png"], Handler.create(this, this.onLoadComplete));
        }
        ProgressBarSample.prototype.onLoadComplete = function () {
            this.progressBar = new ProgressBar("res/ui/progressBar.png");
            this.progressBar.pos(75, 150);
            this.progressBar.width = 400;
            this.progressBar.sizeGrid = "5,5,5,5";
            this.progressBar.changeHandler = new Handler(this, this.onChange);
            Laya.stage.addChild(this.progressBar);
            Laya.timer.loop(100, this, this.changeValue);
        };
        ProgressBarSample.prototype.changeValue = function () {
            this.progressBar.value += 0.05;
            if (this.progressBar.value == 1)
                this.progressBar.value = 0;
        };
        ProgressBarSample.prototype.onChange = function (value) {
            console.log("进度：" + Math.floor(value * 100) + "%");
        };
        return ProgressBarSample;
    }());
    ui.ProgressBarSample = ProgressBarSample;
})(ui || (ui = {}));
new ui.ProgressBarSample();
