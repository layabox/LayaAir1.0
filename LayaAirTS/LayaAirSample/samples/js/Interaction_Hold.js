/// <reference path="../../libs/LayaAir.d.ts" />
var mouses;
(function (mouses) {
    var Hold = (function () {
        function Hold() {
            Laya.init(550, 400);
            Laya.stage.bgColor = "#ffeecc";
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            // 添加一只猩猩
            this.ape = new laya.display.Sprite();
            this.ape.loadImage("res/apes/monkey2.png");
            this.ape.pos(260, 180);
            this.ape.pivot(55, 72);
            this.ape.scale(0.8, 0.8);
            Laya.stage.addChild(this.ape);
            // 鼠标交互
            this.ape.on(laya.events.Event.MOUSE_DOWN, this, this.onApePress);
        }
        Hold.prototype.onApePress = function (e) {
            // 鼠标按下后，HOLD_TRIGGER_TIME毫秒后hold
            Laya.timer.once(mouses.Hold.HOLD_TRIGGER_TIME, this, this.onHold);
            Laya.stage.on(laya.events.Event.MOUSE_UP, this, this.onApeRelease);
        };
        Hold.prototype.onHold = function () {
            laya.utils.Tween.to(this.ape, { "scaleX": 1, "scaleY": 1 }, 500, laya.utils.Ease.bounceOut);
            this.isApeHold = true;
        };
        /** 鼠标放开后停止hold */
        Hold.prototype.onApeRelease = function () {
            // 鼠标放开时，如果正在hold，则播放放开的效果
            if (this.isApeHold) {
                this.isApeHold = false;
                laya.utils.Tween.to(this.ape, { "scaleX": 0.8, "scaleY": 0.8 }, 300);
            }
            else
                Laya.timer.clear(this, this.onHold);
            Laya.stage.off(laya.events.Event.MOUSE_UP, this, this.onApeRelease);
        };
        //触发hold事件时间为1秒
        Hold.HOLD_TRIGGER_TIME = 1000;
        return Hold;
    }());
    mouses.Hold = Hold;
})(mouses || (mouses = {}));
new mouses.Hold();
