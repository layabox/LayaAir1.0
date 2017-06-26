var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var SmartScale_Align_Contral = (function () {
        function SmartScale_Align_Contral() {
            Laya.init(100, 100);
            Laya.stage.scaleMode = Stage.SCALE_NOSCALE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.bgColor = "#232628";
        }
        return SmartScale_Align_Contral;
    }());
    laya.SmartScale_Align_Contral = SmartScale_Align_Contral;
})(laya || (laya = {}));
new laya.SmartScale_Align_Contral();
