/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var ComboBox = laya.ui.ComboBox;
    var Handler = laya.utils.Handler;
    var ComboBoxSample = (function () {
        function ComboBoxSample() {
            this.skin = "res/ui/comboBox.png";
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.loader.load(this.skin, Handler.create(this, this.onLoadComplete));
        }
        ComboBoxSample.prototype.onLoadComplete = function () {
            var cb = this.createComboBox(this.skin);
            cb.pos(100, 100);
        };
        ComboBoxSample.prototype.createComboBox = function (skin) {
            var comboBox = new ComboBox(skin, "item0,item1,item2,item3,item4,item5");
            comboBox.labelSize = 30;
            comboBox.itemSize = 25;
            comboBox.selectHandler = new Handler(this, this.onSelect, [comboBox]);
            Laya.stage.addChild(comboBox);
            return comboBox;
        };
        ComboBoxSample.prototype.onSelect = function (cb) {
            console.log("选中了： " + cb.selectedLabel);
        };
        return ComboBoxSample;
    }());
    ui.ComboBoxSample = ComboBoxSample;
})(ui || (ui = {}));
new ui.ComboBoxSample();
