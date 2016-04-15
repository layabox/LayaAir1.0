/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var ColorPicker = laya.ui.ColorPicker;
    var Handler = laya.utils.Handler;
    var ColorPickerSample = (function () {
        function ColorPickerSample() {
            this.skin = "res/ui/colorPicker.png";
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.loader.load(this.skin, Handler.create(this, this.onColorPickerSkinLoaded));
        }
        ColorPickerSample.prototype.onColorPickerSkinLoaded = function () {
            var colorPicker = new ColorPicker();
            colorPicker.skin = this.skin;
            colorPicker.selectedColor = "#ff0033";
            colorPicker.pos(100, 100);
            colorPicker.changeHandler = new Handler(this, this.onChangeColor, [colorPicker]);
            Laya.stage.addChild(colorPicker);
            this.onChangeColor(colorPicker);
        };
        ColorPickerSample.prototype.onChangeColor = function (colorPicker) {
            console.log("你选中的颜色：" + colorPicker.selectedColor);
        };
        return ColorPickerSample;
    }());
    ui.ColorPickerSample = ColorPickerSample;
})(ui || (ui = {}));
new ui.ColorPickerSample();
