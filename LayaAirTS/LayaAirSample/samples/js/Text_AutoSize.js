/// <reference path="../../libs/LayaAir.d.ts" />
var TextAutoSize = (function () {
    function TextAutoSize() {
        Laya.init(550, 400);
        Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
        // 该文本自动适应尺寸
        var autoSizeText = this.createSampleText();
        autoSizeText.y = 50;
        // 该文本被限制了宽度
        var widthLimitText = this.createSampleText();
        widthLimitText.width = 100;
        widthLimitText.y = 180;
        //该文本被限制了高度
        var heightLimitText = this.createSampleText();
        heightLimitText.height = 20;
        heightLimitText.y = 320;
    }
    TextAutoSize.prototype.createSampleText = function () {
        var text = new laya.display.Text();
        text.color = "#FFFFFF";
        text.font = "Impact";
        text.fontSize = 20;
        text.borderColor = "#FFFF00";
        text.x = 80;
        Laya.stage.addChild(text);
        text.text =
            "A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL\n" +
                "A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL\n" +
                "A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL";
        return text;
    };
    return TextAutoSize;
}());
new TextAutoSize();
