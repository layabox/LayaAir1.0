module laya {
    import Stage = Laya.Stage;
    import Text = Laya.Text;
    import Browser = Laya.Browser;
    import WebGL = Laya.WebGL;

    export class Text_AutoSize {
        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(550, 400, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";

            this.setup();
        }

        private setup(): void {
            // 该文本自动适应尺寸
            var autoSizeText: Text = this.createSampleText();
            autoSizeText.overflow = Text.VISIBLE;
            autoSizeText.y = 50;

            // 该文本被限制了宽度
            var widthLimitText: Text = this.createSampleText();
            widthLimitText.width = 100;
            widthLimitText.y = 180;

            //该文本被限制了高度 
            var heightLimitText: Text = this.createSampleText();
            heightLimitText.height = 20;
            heightLimitText.y = 320;
        }

        private createSampleText(): Text {
            var text: Text = new Text();
            text.overflow = Text.HIDDEN;

            text.color = "#FFFFFF";
            text.font = "Impact";
            text.fontSize = 20;
            text.borderColor = "#FFFF00";
            text.x = 80;

            Laya.stage.addChild(text);
            text.text = "A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL\n" + "A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL\n" + "A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL";

            return text;
        }
    }
}
new laya.Text_AutoSize();