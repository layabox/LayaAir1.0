var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Event = Laya.Event;
    var Browser = Laya.Browser;
    var WebGL = Laya.WebGL;
    var Interaction_Scale = (function () {
        function Interaction_Scale() {
            //上次记录的两个触模点之间距离
            this.lastDistance = 0;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        Interaction_Scale.prototype.setup = function () {
            this.createSprite();
            Laya.stage.on(Event.MOUSE_UP, this, this.onMouseUp);
            Laya.stage.on(Event.MOUSE_OUT, this, this.onMouseUp);
        };
        Interaction_Scale.prototype.createSprite = function () {
            this.sp = new Sprite();
            var w = 300, h = 300;
            this.sp.graphics.drawRect(0, 0, w, h, "#FF7F50");
            this.sp.size(w, h);
            this.sp.pivot(w / 2, h / 2);
            this.sp.pos(Laya.stage.width / 2, Laya.stage.height / 2);
            Laya.stage.addChild(this.sp);
            this.sp.on(Event.MOUSE_DOWN, this, this.onMouseDown);
        };
        Interaction_Scale.prototype.onMouseDown = function (e) {
            var touches = e.touches;
            if (touches && touches.length == 2) {
                this.lastDistance = this.getDistance(touches);
                Laya.stage.on(Event.MOUSE_MOVE, this, this.onMouseMove);
            }
        };
        Interaction_Scale.prototype.onMouseMove = function (e) {
            var distance = this.getDistance(e.touches);
            //判断当前距离与上次距离变化，确定是放大还是缩小
            var factor = 0.01;
            this.sp.scaleX += (distance - this.lastDistance) * factor;
            this.sp.scaleY += (distance - this.lastDistance) * factor;
            this.lastDistance = distance;
        };
        Interaction_Scale.prototype.onMouseUp = function (e) {
            Laya.stage.off(Event.MOUSE_MOVE, this, this.onMouseMove);
        };
        /**计算两个触摸点之间的距离*/
        Interaction_Scale.prototype.getDistance = function (points) {
            var distance = 0;
            if (points && points.length == 2) {
                var dx = points[0].stageX - points[1].stageX;
                var dy = points[0].stageY - points[1].stageY;
                distance = Math.sqrt(dx * dx + dy * dy);
            }
            return distance;
        };
        return Interaction_Scale;
    }());
    laya.Interaction_Scale = Interaction_Scale;
})(laya || (laya = {}));
new laya.Interaction_Scale();
