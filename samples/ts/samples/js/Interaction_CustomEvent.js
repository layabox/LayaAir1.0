/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var Stage = laya.display.Stage;
    var Event = laya.events.Event;
    var Browser = laya.utils.Browser;
    var Ease = laya.utils.Ease;
    var Tween = laya.utils.Tween;
    var WebGL = laya.webgl.WebGL;
    var Interaction_CustomEvent = (function () {
        function Interaction_CustomEvent() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.createSprite();
        }
        Interaction_CustomEvent.prototype.createSprite = function () {
            this.sp = new Sprite();
            this.sp.graphics.drawRect(0, 0, 200, 200, "#D2691E");
            this.sp.pivot(100, 100);
            this.sp.x = Laya.stage.width / 2;
            this.sp.y = Laya.stage.height / 2;
            this.sp.size(200, 200);
            Laya.stage.addChild(this.sp);
            this.sp.on(Interaction_CustomEvent.ROTATE, this.sp, this.onRotate); // 侦听自定义的事件
            this.sp.on(Event.CLICK, this, this.onSpriteClick);
        };
        Interaction_CustomEvent.prototype.onSpriteClick = function (e) {
            var randomAngle = Math.random() * 180;
            //发送自定义事件
            this.sp.event(Interaction_CustomEvent.ROTATE, [randomAngle]);
        };
        // 触发自定义的rotate事件
        Interaction_CustomEvent.prototype.onRotate = function (newAngle) {
            Tween.to(this, { "rotation": newAngle }, 1000, Ease.elasticOut);
        };
        Interaction_CustomEvent.ROTATE = "rotate";
        return Interaction_CustomEvent;
    }());
    laya.Interaction_CustomEvent = Interaction_CustomEvent;
})(laya || (laya = {}));
new laya.Interaction_CustomEvent();
