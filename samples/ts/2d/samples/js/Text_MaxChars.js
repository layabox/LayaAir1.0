/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Input = laya.display.Input;
    var Stage = laya.display.Stage;
    var Browser = laya.utils.Browser;
    var WebGL = laya.webgl.WebGL;
    var Text_MaxChars = (function () {
        function Text_MaxChars() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.createInput();
        }
        Text_MaxChars.prototype.createInput = function () {
            var inputText = new Input();
            inputText.size(350, 100);
            inputText.x = Laya.stage.width - inputText.width >> 1;
            inputText.y = Laya.stage.height - inputText.height >> 1;
            inputText.inputElementXAdjuster = -1;
            inputText.inputElementYAdjuster = 1;
            // 设置字体样式
            inputText.bold = true;
            inputText.bgColor = "#666666";
            inputText.color = "#ffffff";
            inputText.fontSize = 20;
            inputText.maxChars = 5;
            Laya.stage.addChild(inputText);
        };
        return Text_MaxChars;
    }());
    laya.Text_MaxChars = Text_MaxChars;
})(laya || (laya = {}));
new laya.Text_MaxChars();
