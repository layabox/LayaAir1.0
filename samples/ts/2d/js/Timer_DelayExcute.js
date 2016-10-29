var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Event = Laya.Event;
    var Browser = Laya.Browser;
    var WebGL = Laya.WebGL;
    var Timer_DelayExcute = (function () {
        function Timer_DelayExcute() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        Timer_DelayExcute.prototype.setup = function () {
            var vGap = 100;
            this.button1 = this.createButton("点我3秒之后 alpha - 0.5");
            this.button1.x = (Laya.stage.width - this.button1.width) / 2;
            this.button1.y = (Laya.stage.height - this.button1.height - vGap) / 2;
            Laya.stage.addChild(this.button1);
            this.button1.on(Event.CLICK, this, this.onDecreaseAlpha1);
            this.button2 = this.createButton("点我60帧之后 alpha - 0.5");
            this.button2.pos(this.button1.x, this.button1.y + vGap);
            Laya.stage.addChild(this.button2);
            this.button2.on(Event.CLICK, this, this.onDecreaseAlpha2);
        };
        Timer_DelayExcute.prototype.createButton = function (label) {
            var w = 300, h = 60;
            var button = new Sprite();
            button.graphics.drawRect(0, 0, w, h, "#FF7F50");
            button.size(w, h);
            button.graphics.fillText(label, w / 2, 17, "20px simHei", "#ffffff", "center");
            return button;
        };
        Timer_DelayExcute.prototype.onDecreaseAlpha1 = function (e) {
            //移除鼠标单击事件
            this.button1.off(Event.CLICK, this, this.onDecreaseAlpha1);
            //定时执行一次(间隔时间)
            Laya.timer.once(3000, this, this.onComplete1);
        };
        Timer_DelayExcute.prototype.onDecreaseAlpha2 = function (e) {
            //移除鼠标单击事件
            this.button2.off(Event.CLICK, this, this.onDecreaseAlpha2);
            //定时执行一次(基于帧率)
            Laya.timer.frameOnce(60, this, this.onComplete2);
        };
        Timer_DelayExcute.prototype.onComplete1 = function () {
            //spBtn1的透明度减少0.5
            this.button1.alpha -= 0.5;
        };
        Timer_DelayExcute.prototype.onComplete2 = function () {
            //spBtn2的透明度减少0.5
            this.button2.alpha -= 0.5;
        };
        return Timer_DelayExcute;
    }());
    laya.Timer_DelayExcute = Timer_DelayExcute;
})(laya || (laya = {}));
new laya.Timer_DelayExcute();
