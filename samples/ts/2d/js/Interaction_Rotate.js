var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Event = Laya.Event;
    var Browser = Laya.Browser;
    var WebGL = Laya.WebGL;
    var Interaction_Rotate = (function () {
        function Interaction_Rotate() {
            this.preRadian = 0;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        Interaction_Rotate.prototype.setup = function () {
            this.createSprite();
            Laya.stage.on(Event.MOUSE_UP, this, this.onMouseUp);
            Laya.stage.on(Event.MOUSE_OUT, this, this.onMouseUp);
        };
        Interaction_Rotate.prototype.createSprite = function () {
            this.sp = new Sprite();
            var w = 200, h = 300;
            this.sp.graphics.drawRect(0, 0, w, h, "#FF7F50");
            this.sp.size(w, h);
            this.sp.pivot(w / 2, h / 2);
            this.sp.pos(Laya.stage.width / 2, Laya.stage.height / 2);
            Laya.stage.addChild(this.sp);
            this.sp.on(Event.MOUSE_DOWN, this, this.onMouseDown);
        };
        Interaction_Rotate.prototype.onMouseDown = function (e) {
            var touches = e.touches;
            if (touches && touches.length == 2) {
                this.preRadian = Math.atan2(touches[0].stageY - touches[1].stageY, touches[0].stageX - touches[1].stageX);
                Laya.stage.on(Event.MOUSE_MOVE, this, this.onMouseMove);
            }
        };
        Interaction_Rotate.prototype.onMouseMove = function (e) {
            var touches = e.touches;
            if (touches && touches.length == 2) {
                var nowRadian = Math.atan2(touches[0].stageY - touches[1].stageY, touches[0].stageX - touches[1].stageX);
                this.sp.rotation += 180 / Math.PI * (nowRadian - this.preRadian);
                this.preRadian = nowRadian;
            }
        };
        Interaction_Rotate.prototype.onMouseUp = function (e) {
            Laya.stage.off(Event.MOUSE_MOVE, this, this.onMouseMove);
        };
        return Interaction_Rotate;
    }());
    laya.Interaction_Rotate = Interaction_Rotate;
})(laya || (laya = {}));
new laya.Interaction_Rotate();
