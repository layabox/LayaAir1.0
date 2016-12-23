var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var Text = Laya.Text;
    var WebGL = Laya.WebGL;
    var Text_AutoSize = (function () {
        function Text_AutoSize() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(550, 400, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        Text_AutoSize.prototype.setup = function () {
            // 该文本自动适应尺寸
            var autoSizeText = this.createSampleText();
            autoSizeText.overflow = Text.VISIBLE;
            autoSizeText.y = 50;
            // 该文本被限制了宽度
            var widthLimitText = this.createSampleText();
            widthLimitText.width = 100;
            widthLimitText.y = 180;
            //该文本被限制了高度 
            var heightLimitText = this.createSampleText();
            heightLimitText.height = 20;
            heightLimitText.y = 320;
        };
        Text_AutoSize.prototype.createSampleText = function () {
            var text = new Text();
            text.overflow = Text.HIDDEN;
            text.color = "#FFFFFF";
            text.font = "Impact";
            text.fontSize = 20;
            text.borderColor = "#FFFF00";
            text.x = 80;
            Laya.stage.addChild(text);
            text.text = "A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL\n" + "A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL\n" + "A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL";
            return text;
        };
        return Text_AutoSize;
    }());
    laya.Text_AutoSize = Text_AutoSize;
})(laya || (laya = {}));
new laya.Text_AutoSize();
