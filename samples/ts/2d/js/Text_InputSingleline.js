var laya;
(function (laya) {
    var Input = Laya.Input;
    var Stage = Laya.Stage;
    var Browser = Laya.Browser;
    var WebGL = Laya.WebGL;
    var Text_InputSingleline = (function () {
        function Text_InputSingleline() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.createInput();
        }
        Text_InputSingleline.prototype.createInput = function () {
            var inputText = new Input();
            inputText.size(350, 100);
            inputText.x = Laya.stage.width - inputText.width >> 1;
            inputText.y = Laya.stage.height - inputText.height >> 1;
            // 移动端输入提示符
            inputText.prompt = "Type some word...";
            // 设置字体样式
            inputText.bold = true;
            inputText.bgColor = "#666666";
            inputText.color = "#ffffff";
            inputText.fontSize = 20;
            Laya.stage.addChild(inputText);
        };
        return Text_InputSingleline;
    }());
    laya.Text_InputSingleline = Text_InputSingleline;
})(laya || (laya = {}));
new laya.Text_InputSingleline();
