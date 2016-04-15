/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var BitmapFont = laya.display.BitmapFont;
    var Handler = laya.utils.Handler;
    var Text = laya.display.Text;
    var Text_BitmapFont = (function () {
        function Text_BitmapFont() {
            this.fontName = "diyFont";
            Laya.init(550, 400);
            var bitmapFont = new BitmapFont();
            bitmapFont.loadFont("res/bitmapFont/test.fnt", new Handler(this, this.onLoaded, [bitmapFont]));
        }
        Text_BitmapFont.prototype.onLoaded = function (bitmapFont) {
            bitmapFont.setSpaceWidth(10);
            Text.registerBitmapFont(this.fontName, bitmapFont);
            this.createText(this.fontName);
        };
        Text_BitmapFont.prototype.createText = function (font) {
            var txt = new laya.display.Text();
            txt.width = 250;
            txt.wordWrap = true;
            txt.text = "Do one thing at a time, and do well.";
            txt.font = font;
            txt.leading = 5;
            txt.pos(150, 100);
            Laya.stage.addChild(txt);
        };
        return Text_BitmapFont;
    }());
    laya.Text_BitmapFont = Text_BitmapFont;
})(laya || (laya = {}));
new laya.Text_BitmapFont();
