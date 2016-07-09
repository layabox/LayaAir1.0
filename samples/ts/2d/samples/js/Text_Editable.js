/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Input = laya.display.Input;
    var Stage = laya.display.Stage;
    var Browser = laya.utils.Browser;
    var WebGL = laya.webgl.WebGL;
    var Text_Editable = (function () {
        function Text_Editable() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.createInput();
        }
        Text_Editable.prototype.createInput = function () {
            var inputText = new Input();
            inputText.size(350, 100);
            inputText.x = Laya.stage.width - inputText.width >> 1;
            inputText.y = Laya.stage.height - inputText.height >> 1;
            inputText.text = "这段文本不可编辑，但可复制";
            inputText.editable = false;
            // 输入期间输入框的位置偏移
            inputText.inputElementXAdjuster = -1;
            inputText.inputElementYAdjuster = 1;
            // 设置字体样式
            inputText.bold = true;
            inputText.bgColor = "#666666";
            inputText.color = "#ffffff";
            inputText.fontSize = 20;
            Laya.stage.addChild(inputText);
        };
        return Text_Editable;
    }());
    laya.Text_Editable = Text_Editable;
})(laya || (laya = {}));
new laya.Text_Editable();
