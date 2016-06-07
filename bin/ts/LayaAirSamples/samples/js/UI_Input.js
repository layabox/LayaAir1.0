/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Stage = laya.display.Stage;
    var TextInput = laya.ui.TextInput;
    var Handler = laya.utils.Handler;
    var WebGL = laya.webgl.WebGL;
    var UI_Input = (function () {
        function UI_Input() {
            this.SPACING = 100;
            this.INPUT_WIDTH = 300;
            this.INPUT_HEIGHT = 50;
            this.Y_OFFSET = 50;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(800, 600, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.skins = ["res/ui/input (1).png", "res/ui/input (2).png", "res/ui/input (3).png", "res/ui/input (4).png"];
            Laya.loader.load(this.skins, Handler.create(this, this.onLoadComplete)); //加载资源。
        }
        UI_Input.prototype.onLoadComplete = function () {
            for (var i = 0; i < this.skins.length; ++i) {
                var input = this.createInput(this.skins[i]);
                input.prompt = 'Type:';
                input.x = (Laya.stage.width - input.width) / 2;
                input.y = i * this.SPACING + this.Y_OFFSET;
            }
        };
        UI_Input.prototype.createInput = function (skin) {
            var ti = new TextInput();
            ti.inputElementXAdjuster = 0;
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
        return UI_Input;
    }());
    laya.UI_Input = UI_Input;
})(laya || (laya = {}));
new laya.UI_Input();
