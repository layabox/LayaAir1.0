var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var SmartScale_Scale_SHOW_ALL = (function () {
        function SmartScale_Scale_SHOW_ALL() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.createCantralRect();
        }
        SmartScale_Scale_SHOW_ALL.prototype.createCantralRect = function () {
            this.rect = new Sprite();
            this.rect.graphics.drawRect(-100, -100, 200, 200, "gray");
            Laya.stage.addChild(this.rect);
            this.updateRectPos();
        };
        SmartScale_Scale_SHOW_ALL.prototype.updateRectPos = function () {
            this.rect.x = Laya.stage.width / 2;
            this.rect.y = Laya.stage.height / 2;
        };
        return SmartScale_Scale_SHOW_ALL;
    }());
    laya.SmartScale_Scale_SHOW_ALL = SmartScale_Scale_SHOW_ALL;
})(laya || (laya = {}));
new laya.SmartScale_Scale_SHOW_ALL();
