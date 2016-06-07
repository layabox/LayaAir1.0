/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Stage = laya.display.Stage;
    var Text = laya.display.Text;
    var WebGL = laya.webgl.WebGL;
    var SmartScale_Landscape = (function () {
        function SmartScale_Landscape() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(550, 400, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
            Laya.stage.bgColor = "#232628";
            this.showText();
        }
        SmartScale_Landscape.prototype.showText = function () {
            var text = new Text();
            text.text = "Orientation-Landscape";
            text.color = "gray";
            text.font = "Impact";
            text.fontSize = 50;
            text.x = Laya.stage.width - text.width >> 1;
            text.y = Laya.stage.height - text.height >> 1;
            Laya.stage.addChild(text);
        };
        return SmartScale_Landscape;
    }());
    laya.SmartScale_Landscape = SmartScale_Landscape;
})(laya || (laya = {}));
new laya.SmartScale_Landscape();
