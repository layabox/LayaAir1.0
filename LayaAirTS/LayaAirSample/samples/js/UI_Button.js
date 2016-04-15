/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var Button = laya.ui.Button;
    var Handler = laya.utils.Handler;
    var ButtonSample = (function () {
        function ButtonSample() {
            this.COLUMNS = 2;
            this.BUTTON_WIDTH = 147;
            this.BUTTON_HEIGHT = 165 / 3;
            this.HORIZONTAL_SPACING = 200;
            this.VERTICAL_SPACING = 100;
            this.skins = [
                "res/ui/button-1.png", "res/ui/button-2.png", "res/ui/button-3.png",
                "res/ui/button-4.png", "res/ui/button-5.png", "res/ui/button-6.png"
            ];
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            // 计算将Button至于舞台中心的偏移量
            this.xOffset = (Laya.stage.width - this.HORIZONTAL_SPACING * (this.COLUMNS - 1) - this.BUTTON_WIDTH) / 2;
            this.yOffset = (Laya.stage.height - this.VERTICAL_SPACING * (this.skins.length / this.COLUMNS - 1) - this.BUTTON_HEIGHT) / 2;
            Laya.loader.load(this.skins, Handler.create(this, this.onUIAssertLoaded));
        }
        ButtonSample.prototype.onUIAssertLoaded = function () {
            for (var i = 0, len = this.skins.length; i < len; ++i) {
                var btn = this.createButton(this.skins[i]);
                var x = i % this.COLUMNS * this.HORIZONTAL_SPACING + this.xOffset;
                var y = (i / this.COLUMNS | 0) * this.VERTICAL_SPACING + this.yOffset;
                btn.pos(x, y);
            }
        };
        ButtonSample.prototype.createButton = function (skin) {
            var btn = new Button(skin);
            Laya.stage.addChild(btn);
            return btn;
        };
        return ButtonSample;
    }());
    ui.ButtonSample = ButtonSample;
})(ui || (ui = {}));
new ui.ButtonSample();
