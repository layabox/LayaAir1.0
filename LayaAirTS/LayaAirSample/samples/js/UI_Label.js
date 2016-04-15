/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var Label = laya.ui.Label;
    var LabelSample = (function () {
        function LabelSample() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            this.createLabel("#FFFFFF", null).pos(30, 50);
            this.createLabel("#00FFFF", null).pos(290, 50);
            this.createLabel("#FFFF00", "#FFFFFF").pos(30, 100);
            this.createLabel("#000000", "#FFFFFF").pos(290, 100);
            this.createLabel("#FFFFFF", "#00FFFF").pos(30, 150);
            this.createLabel("#0080FF", "#00FFFF").pos(290, 150);
        }
        LabelSample.prototype.createLabel = function (color, strokeColor) {
            var STROKE_WIDTH = 4;
            var label = new Label();
            label.font = "Microsoft YaHei";
            label.text = "SAMPLE DEMO";
            label.fontSize = 30;
            label.color = color;
            if (strokeColor) {
                label.stroke = STROKE_WIDTH;
                label.strokeColor = strokeColor;
            }
            Laya.stage.addChild(label);
            return label;
        };
        return LabelSample;
    }());
    ui.LabelSample = LabelSample;
})(ui || (ui = {}));
new ui.LabelSample();
