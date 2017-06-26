var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var Text = Laya.Text;
    var Browser = Laya.Browser;
    var WebGL = Laya.WebGL;
    var Timer_Interval = (function () {
        function Timer_Interval() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        Timer_Interval.prototype.setup = function () {
            var vGap = 200;
            this.rotateTimeBasedText = this.createText("基于时间旋转", Laya.stage.width / 2, (Laya.stage.height - vGap) / 2);
            this.rotateFrameRateBasedText = this.createText("基于帧频旋转", this.rotateTimeBasedText.x, this.rotateTimeBasedText.y + vGap);
            Laya.timer.loop(200, this, this.animateTimeBased);
            Laya.timer.frameLoop(2, this, this.animateFrameRateBased);
        };
        Timer_Interval.prototype.createText = function (text, x, y) {
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
        Timer_Interval.prototype.animateTimeBased = function () {
            this.rotateTimeBasedText.rotation += 1;
        };
        Timer_Interval.prototype.animateFrameRateBased = function () {
            this.rotateFrameRateBasedText.rotation += 1;
        };
        return Timer_Interval;
    }());
    laya.Timer_Interval = Timer_Interval;
})(laya || (laya = {}));
new laya.Timer_Interval();
