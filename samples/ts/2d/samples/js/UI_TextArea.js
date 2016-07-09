/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Stage = laya.display.Stage;
    var TextArea = laya.ui.TextArea;
    var Browser = laya.utils.Browser;
    var Handler = laya.utils.Handler;
    var WebGL = laya.webgl.WebGL;
    var UI_TextArea = (function () {
        function UI_TextArea() {
            this.skin = "res/ui/textarea.png";
            // 不支持WebGL时自动切换至Canvas
            Laya.init(550, 400, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            Laya.loader.load(this.skin, Handler.create(this, this.onLoadComplete));
        }
        UI_TextArea.prototype.onLoadComplete = function () {
            var ta = new TextArea("");
            ta.skin = this.skin;
            ta.inputElementXAdjuster = -2;
            ta.inputElementYAdjuster = -1;
            ta.font = "Arial";
            ta.fontSize = 18;
            ta.bold = true;
            ta.color = "#3d3d3d";
            ta.pos(100, 15);
            ta.size(375, 355);
            ta.padding = "70,8,8,8";
            var scaleFactor = Browser.pixelRatio;
            Laya.stage.addChild(ta);
        };
        return UI_TextArea;
    }());
    laya.UI_TextArea = UI_TextArea;
})(laya || (laya = {}));
new laya.UI_TextArea();
