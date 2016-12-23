var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var SmartScale_Scale_EXTRACT_FIT = (function () {
        function SmartScale_Scale_EXTRACT_FIT() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = Stage.SCALE_EXACTFIT;
            Laya.stage.bgColor = "#232628";
            this.createCantralRect();
        }
        SmartScale_Scale_EXTRACT_FIT.prototype.createCantralRect = function () {
            this.rect = new Sprite();
            this.rect.graphics.drawRect(-100, -100, 200, 200, "gray");
            Laya.stage.addChild(this.rect);
            this.updateRectPos();
        };
        SmartScale_Scale_EXTRACT_FIT.prototype.updateRectPos = function () {
            this.rect.x = Laya.stage.width / 2;
            this.rect.y = Laya.stage.height / 2;
        };
        return SmartScale_Scale_EXTRACT_FIT;
    }());
    laya.SmartScale_Scale_EXTRACT_FIT = SmartScale_Scale_EXTRACT_FIT;
})(laya || (laya = {}));
new laya.SmartScale_Scale_EXTRACT_FIT();
