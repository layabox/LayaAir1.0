/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var Stage = laya.display.Stage;
    var SmartScale_Scale_NOBORDER = (function () {
        function SmartScale_Scale_NOBORDER() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = Stage.SCALE_NOBORDER;
            Laya.stage.bgColor = "#232628";
            this.createCantralRect();
        }
        SmartScale_Scale_NOBORDER.prototype.createCantralRect = function () {
            this.rect = new Sprite();
            this.rect.graphics.drawRect(-100, -100, 200, 200, "gray");
            Laya.stage.addChild(this.rect);
            this.updateRectPos();
        };
        SmartScale_Scale_NOBORDER.prototype.updateRectPos = function () {
            this.rect.x = Laya.stage.width / 2;
            this.rect.y = Laya.stage.height / 2;
        };
        return SmartScale_Scale_NOBORDER;
    }());
    laya.SmartScale_Scale_NOBORDER = SmartScale_Scale_NOBORDER;
})(laya || (laya = {}));
new laya.SmartScale_Scale_NOBORDER();
