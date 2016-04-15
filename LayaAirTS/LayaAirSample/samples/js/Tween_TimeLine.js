/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var Event = laya.events.Event;
    var Keyboard = laya.events.Keyboard;
    var TimeLine = laya.utils.TimeLine;
    var Tween_TimeLine = (function () {
        function Tween_TimeLine() {
            this.timeLine = new TimeLine();
            Laya.init(550, 400);
            this.setup();
        }
        Tween_TimeLine.prototype.setup = function () {
            this.createApe();
            this.createTimerLine();
            Laya.stage.on(Event.KEY_DOWN, this, this.keyDown);
        };
        Tween_TimeLine.prototype.keyDown = function (e) {
            switch (e["keyCode"]) {
                case Keyboard.LEFT:
                    this.timeLine.gotoLabel("turnLeft");
                    break;
                case Keyboard.RIGHT:
                    this.timeLine.gotoLabel("turnRight");
                    break;
                case Keyboard.UP:
                    this.timeLine.gotoLabel("turnUp");
                    break;
                case Keyboard.DOWN:
                    this.timeLine.gotoLabel("turnDown");
                    break;
                case Keyboard.P:
                    this.timeLine.pause();
                    break;
                case Keyboard.R:
                    this.timeLine.resume();
                    break;
            }
        };
        Tween_TimeLine.prototype.createTimerLine = function () {
            this.timeLine.add("turnRight", 0);
            this.timeLine.to(this.target, { x: 450, y: 100, scaleX: 0.5, scaleY: 0.5 }, 2000);
            this.timeLine.add("turnDown", 0);
            this.timeLine.to(this.target, { x: 450, y: 300, scaleX: 0.2, scaleY: 1, alpha: 1 }, 2000);
            this.timeLine.add("turnLeft", 0);
            this.timeLine.to(this.target, { x: 100, y: 300, scaleX: 1, scaleY: 0.2, alpha: 0.1 }, 2000);
            this.timeLine.add("turnUp", 0);
            this.timeLine.to(this.target, { x: 100, y: 100, scaleX: 1, scaleY: 1, alpha: 1 }, 2000);
            this.timeLine.play(0, true);
        };
        Tween_TimeLine.prototype.createApe = function () {
            this.target = new Sprite();
            this.target.loadImage("res/apes/monkey2.png");
            Laya.stage.addChild(this.target);
            this.target.pivot(55, 72);
            this.target.pos(100, 100);
        };
        return Tween_TimeLine;
    }());
    laya.Tween_TimeLine = Tween_TimeLine;
})(laya || (laya = {}));
new laya.Tween_TimeLine();
