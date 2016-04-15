/// <reference path="../../libs/LayaAir.d.ts" />
var SmartScale_Scale_NO_SCALE = (function () {
    function SmartScale_Scale_NO_SCALE() {
        Laya.init(550, 400);
        Laya.stage.scaleMode = laya.display.Stage.SCALE_NOSCALE;
        var rect = new laya.display.Sprite();
        rect.graphics.drawRect(-100, -100, 200, 200, "gray");
        Laya.stage.addChild(rect);
        rect.x = Laya.stage.width / 2;
        rect.y = Laya.stage.height / 2;
    }
    return SmartScale_Scale_NO_SCALE;
}());
new SmartScale_Scale_NO_SCALE();
