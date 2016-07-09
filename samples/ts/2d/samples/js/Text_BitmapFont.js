/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var BitmapFont = laya.display.BitmapFont;
    var Stage = laya.display.Stage;
    var Text = laya.display.Text;
    var Browser = laya.utils.Browser;
    var Handler = laya.utils.Handler;
    var WebGL = laya.webgl.WebGL;
    var Text_BitmapFont = (function () {
        function Text_BitmapFont() {
            this.fontName = "diyFont";
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.loadFont();
        }
        Text_BitmapFont.prototype.loadFont = function () {
            var bitmapFont = new BitmapFont();
            bitmapFont.loadFont("res/bitmapFont/test.fnt", new Handler(this, this.onFontLoaded, [bitmapFont]));
        };
        Text_BitmapFont.prototype.onFontLoaded = function (bitmapFont) {
            bitmapFont.setSpaceWidth(10);
            Text.registerBitmapFont(this.fontName, bitmapFont);
            this.createText(this.fontName);
        };
        Text_BitmapFont.prototype.createText = function (font) {
            var txt = new Text();
            txt.width = 250;
            txt.wordWrap = true;
            txt.text = "Do one thing at a time, and do well.";
            txt.font = font;
            txt.leading = 5;
            txt.pos(Laya.stage.width - txt.width >> 1, Laya.stage.height - txt.height >> 1);
            Laya.stage.addChild(txt);
        };
        return Text_BitmapFont;
    }());
    laya.Text_BitmapFont = Text_BitmapFont;
})(laya || (laya = {}));
new laya.Text_BitmapFont();
