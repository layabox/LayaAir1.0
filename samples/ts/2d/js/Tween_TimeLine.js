var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Event = Laya.Event;
    var Keyboard = Laya.Keyboard;
    var TimeLine = Laya.TimeLine;
    var WebGL = Laya.WebGL;
    var Tween_TimeLine = (function () {
        function Tween_TimeLine() {
            this.timeLine = new TimeLine();
            // 不支持WebGL时自动切换至Canvas
            Laya.init(550, 400, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        Tween_TimeLine.prototype.setup = function () {
            this.createApe();
            this.createTimerLine();
            Laya.stage.on(Event.KEY_DOWN, this, this.keyDown);
        };
        Tween_TimeLine.prototype.createApe = function () {
            this.target = new Sprite();
            this.target.loadImage("../../res/apes/monkey2.png");
            Laya.stage.addChild(this.target);
            this.target.pivot(55, 72);
            this.target.pos(100, 100);
        };
        Tween_TimeLine.prototype.createTimerLine = function () {
            this.timeLine.addLabel("turnRight", 0).to(this.target, { x: 450, y: 100, scaleX: 0.5, scaleY: 0.5 }, 2000, null, 0)
                .addLabel("turnDown", 0).to(this.target, { x: 450, y: 300, scaleX: 0.2, scaleY: 1, alpha: 1 }, 2000, null, 0)
                .addLabel("turnLeft", 0).to(this.target, { x: 100, y: 300, scaleX: 1, scaleY: 0.2, alpha: 0.1 }, 2000, null, 0)
                .addLabel("turnUp", 0).to(this.target, { x: 100, y: 100, scaleX: 1, scaleY: 1, alpha: 1 }, 2000, null, 0);
            this.timeLine.play(0, true);
            this.timeLine.on(Event.COMPLETE, this, this.onComplete);
            this.timeLine.on(Event.LABEL, this, this.onLabel);
        };
        Tween_TimeLine.prototype.onComplete = function () {
            console.log("timeLine complete!!!!");
        };
        Tween_TimeLine.prototype.onLabel = function (label) {
            console.log("LabelName:" + label);
        };
        Tween_TimeLine.prototype.keyDown = function (e) {
            switch (e.keyCode) {
                case Keyboard.LEFT:
                    this.timeLine.play("turnLeft");
                    break;
                case Keyboard.RIGHT:
                    this.timeLine.play("turnRight");
                    break;
                case Keyboard.UP:
                    this.timeLine.play("turnUp");
                    break;
                case Keyboard.DOWN:
                    this.timeLine.play("turnDown");
                    break;
                case Keyboard.P:
                    this.timeLine.pause();
                    break;
                case Keyboard.R:
                    this.timeLine.resume();
                    break;
            }
        };
        return Tween_TimeLine;
    }());
    laya.Tween_TimeLine = Tween_TimeLine;
})(laya || (laya = {}));
new laya.Tween_TimeLine();
