/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var TextArea = laya.ui.TextArea;
    var Handler = laya.utils.Handler;
    var TextAreaSample = (function () {
        function TextAreaSample() {
            this.skin = "res/ui/textarea.png";
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.loader.load(this.skin, Handler.create(this, this.onLoadComplete)); //加载资源。
        }
        TextAreaSample.prototype.onLoadComplete = function () {
            var ta = new TextArea("");
            ta.skin = this.skin;
            ta.inputElementXAdjuster = -2;
            ta.inputElementYAdjuster = -1;
            ta.font = "Arial";
            ta.fontSize = 20;
            ta.bold = true;
            ta.color = "#3d3d3d";
            ta.pos(100, 15);
            ta.size(375, 355);
            ta.padding = "70,8,8,8";
            Laya.stage.addChild(ta);
        };
        return TextAreaSample;
    }());
    ui.TextAreaSample = TextAreaSample;
})(ui || (ui = {}));
new ui.TextAreaSample();
