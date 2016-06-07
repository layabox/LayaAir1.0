/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var Stage = laya.display.Stage;
    var Event = laya.events.Event;
    var Browser = laya.utils.Browser;
    var Tween = laya.utils.Tween;
    var WebGL = laya.webgl.WebGL;
    var Interaction_Swipe = (function () {
        function Interaction_Swipe() {
            //swipe滚动范围
            this.TrackLength = 200;
            //触发swipe的拖动距离
            this.TOGGLE_DIST = this.TrackLength / 2;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        Interaction_Swipe.prototype.setup = function () {
            this.createSprtie();
            this.drawTrack();
        };
        Interaction_Swipe.prototype.createSprtie = function () {
            var w = 50;
            var h = 30;
            this.button = new Sprite();
            this.button.graphics.drawRect(0, 0, w, h, "#FF7F50");
            this.button.pivot(w / 2, h / 2);
            //设置宽高（要接收鼠标事件必须设置宽高，否则不会被命中）  
            this.button.size(w, h);
            this.button.x = (Laya.stage.width - this.TrackLength) / 2;
            this.button.y = Laya.stage.height / 2;
            this.button.on(Event.MOUSE_DOWN, this, this.onMouseDown);
            Laya.stage.addChild(this.button);
            //左侧临界点设为圆形初始位置
            this.beginPosition = this.button.x;
            //右侧临界点设置
            this.endPosition = this.beginPosition + this.TrackLength;
        };
        Interaction_Swipe.prototype.drawTrack = function () {
            var graph = new Sprite();
            Laya.stage.graphics.drawLine(this.beginPosition, Laya.stage.height / 2, this.endPosition, Laya.stage.height / 2, "#FFFFFF", 20);
            Laya.stage.addChild(graph);
        };
        /**按下事件处理*/
        Interaction_Swipe.prototype.onMouseDown = function (e) {
            //添加鼠标移到侦听
            Laya.stage.on(Event.MOUSE_MOVE, this, this.onMouseMove);
            this.buttonPosition = this.button.x;
            Laya.stage.on(Event.MOUSE_UP, this, this.onMouseUp);
            Laya.stage.on(Event.MOUSE_OUT, this, this.onMouseUp);
        };
        /**移到事件处理*/
        Interaction_Swipe.prototype.onMouseMove = function (e) {
            this.button.x = Math.max(Math.min(Laya.stage.mouseX, this.endPosition), this.beginPosition);
        };
        /**抬起事件处理*/
        Interaction_Swipe.prototype.onMouseUp = function (e) {
            Laya.stage.off(Event.MOUSE_MOVE, this, this.onMouseMove);
            Laya.stage.off(Event.MOUSE_UP, this, this.onMouseUp);
            Laya.stage.off(Event.MOUSE_OUT, this, this.onMouseUp);
            // 滑动到目的地
            var dist = Laya.stage.mouseX - this.buttonPosition;
            var targetX = this.beginPosition;
            if (dist > this.TOGGLE_DIST)
                targetX = this.endPosition;
            Tween.to(this.button, { x: targetX }, 100);
        };
        return Interaction_Swipe;
    }());
    laya.Interaction_Swipe = Interaction_Swipe;
})(laya || (laya = {}));
new laya.Interaction_Swipe();
