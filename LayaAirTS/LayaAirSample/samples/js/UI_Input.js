/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var TextInput = laya.ui.TextInput;
    var Handler = laya.utils.Handler;
    var InputSample = (function () {
        function InputSample() {
            this.SPACING = 100;
            this.INPUT_WIDTH = 300;
            this.INPUT_HEIGHT = 50;
            this.X_OFFSET = 125;
            this.Y_OFFSET = 20;
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            this.skins = ["res/ui/input (1).png", "res/ui/input (2).png", "res/ui/input (3).png", "res/ui/input (4).png"];
            Laya.loader.load(this.skins, Handler.create(this, this.onLoadComplete)); //加载资源。
        }
        InputSample.prototype.onLoadComplete = function () {
            for (var i = 0; i < this.skins.length; ++i) {
                var input = this.createInput(this.skins[i]);
                input.x = this.X_OFFSET;
                input.y = i * this.SPACING + this.Y_OFFSET;
            }
        };
        InputSample.prototype.createInput = function (skin) {
            var ti = new TextInput("");
            ti.inputElementXAdjuster = -1;
            ti.inputElementYAdjuster = 1;
            ti.skin = skin;
            ti.size(300, 50);
            ti.sizeGrid = "0,40,0,40";
            ti.font = "Arial";
            ti.fontSize = 30;
            ti.bold = true;
            ti.color = "#606368";
            Laya.stage.addChild(ti);
            return ti;
        };
        return InputSample;
    }());
    ui.InputSample = InputSample;
})(ui || (ui = {}));
new ui.InputSample();
