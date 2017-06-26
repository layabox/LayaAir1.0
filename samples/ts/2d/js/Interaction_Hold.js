var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Event = Laya.Event;
    var Browser = Laya.Browser;
    var Ease = Laya.Ease;
    var Handler = Laya.Handler;
    var Tween = Laya.Tween;
    var WebGL = Laya.WebGL;
    var Interaction_Hold = (function () {
        function Interaction_Hold() {
            this.HOLD_TRIGGER_TIME = 1000;
            this.apePath = "../../res/apes/monkey2.png";
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            Laya.loader.load(this.apePath, Handler.create(this, this.createApe));
        }
        Interaction_Hold.prototype.createApe = function () {
            // 添加一只猩猩
            this.ape = new Sprite();
            this.ape.loadImage(this.apePath);
            var texture = Laya.loader.getRes(this.apePath);
            this.ape.pivot(texture.width / 2, texture.height / 2);
            this.ape.pos(Laya.stage.width / 2, Laya.stage.height / 2);
            this.ape.scale(0.8, 0.8);
            Laya.stage.addChild(this.ape);
            // 鼠标交互
            this.ape.on(Event.MOUSE_DOWN, this, this.onApePress);
        };
        Interaction_Hold.prototype.onApePress = function (e) {
            // 鼠标按下后，HOLD_TRIGGER_TIME毫秒后hold
            Laya.timer.once(this.HOLD_TRIGGER_TIME, this, this.onHold);
            Laya.stage.on(Event.MOUSE_UP, this, this.onApeRelease);
        };
        Interaction_Hold.prototype.onHold = function () {
            Tween.to(this.ape, { "scaleX": 1, "scaleY": 1 }, 500, Ease.bounceOut);
            this.isApeHold = true;
        };
        /** 鼠标放开后停止hold */
        Interaction_Hold.prototype.onApeRelease = function () {
            // 鼠标放开时，如果正在hold，则播放放开的效果
            if (this.isApeHold) {
                this.isApeHold = false;
                Tween.to(this.ape, { "scaleX": 0.8, "scaleY": 0.8 }, 300);
            }
            else
                Laya.timer.clear(this, this.onHold);
            Laya.stage.off(Event.MOUSE_UP, this, this.onApeRelease);
        };
        return Interaction_Hold;
    }());
    laya.Interaction_Hold = Interaction_Hold;
})(laya || (laya = {}));
new laya.Interaction_Hold();
