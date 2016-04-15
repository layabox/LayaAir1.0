/// <reference path="../../libs/LayaAir.d.ts" />
var timer;
(function (timer) {
    var Text = laya.display.Text;
    var LoopExecution = (function () {
        function LoopExecution() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            this.rotateTimeBasedText = this.createText("基于时间旋转", 120, 170);
            this.rotateFrameRateBasedText = this.createText("基于帧频旋转", 350, 170);
            Laya.timer.loop(200, this, this.animateTimeBased);
            Laya.timer.frameLoop(2, this, this.animateFrameRateBased);
        }
        LoopExecution.prototype.createText = function (text, x, y) {
            var t = new Text();
            t.text = text;
            t.fontSize = 30;
            t.color = "white";
            t.bold = true;
            t.pivot(t.width / 2, t.height / 2);
            t.pos(x, y);
            Laya.stage.addChild(t);
            return t;
        };
        LoopExecution.prototype.animateTimeBased = function () {
            this.rotateTimeBasedText.rotation += 1;
        };
        LoopExecution.prototype.animateFrameRateBased = function () {
            this.rotateFrameRateBasedText.rotation += 1;
        };
        return LoopExecution;
    }());
    timer.LoopExecution = LoopExecution;
})(timer || (timer = {}));
new timer.LoopExecution();
