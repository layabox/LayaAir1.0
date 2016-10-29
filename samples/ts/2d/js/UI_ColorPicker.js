var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var ColorPicker = Laya.ColorPicker;
    var Browser = Laya.Browser;
    var Handler = Laya.Handler;
    var WebGL = Laya.WebGL;
    var UI_ColorPicker = (function () {
        function UI_ColorPicker() {
            this.skin = "../../res/ui/colorPicker.png";
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            Laya.loader.load(this.skin, Handler.create(this, this.onColorPickerSkinLoaded));
        }
        UI_ColorPicker.prototype.onColorPickerSkinLoaded = function () {
            var colorPicker = new ColorPicker();
            colorPicker.selectedColor = "#ff0033";
            colorPicker.skin = this.skin;
            colorPicker.pos(100, 100);
            colorPicker.changeHandler = new Handler(this, this.onChangeColor, [colorPicker]);
            Laya.stage.addChild(colorPicker);
            this.onChangeColor(colorPicker);
        };
        UI_ColorPicker.prototype.onChangeColor = function (colorPicker) {
            console.log(colorPicker.selectedColor);
        };
        return UI_ColorPicker;
    }());
    laya.UI_ColorPicker = UI_ColorPicker;
})(laya || (laya = {}));
new laya.UI_ColorPicker();
