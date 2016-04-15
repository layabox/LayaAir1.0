/// <reference path="../../libs/LayaAir.d.ts" />
var SmartScale_Align_Contral = (function () {
    function SmartScale_Align_Contral() {
        Laya.init(100, 100);
        Laya.stage.scaleMode = laya.display.Stage.SCALE_NOSCALE;
        Laya.stage.alignH = laya.display.Stage.ALIGN_CENTER;
        Laya.stage.alignV = laya.display.Stage.ALIGN_MIDDLE;
    }
    return SmartScale_Align_Contral;
}());
new SmartScale_Align_Contral();
