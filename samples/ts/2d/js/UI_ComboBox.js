var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var ComboBox = Laya.ComboBox;
    var Handler = Laya.Handler;
    var WebGL = Laya.WebGL;
    var UI_ComboBox = (function () {
        function UI_ComboBox() {
            this.skin = "../../res/ui/combobox.png";
            // 不支持WebGL时自动切换至Canvas
            Laya.init(800, 600, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            Laya.loader.load(this.skin, Handler.create(this, this.onLoadComplete));
        }
        UI_ComboBox.prototype.onLoadComplete = function () {
            var cb = this.createComboBox(this.skin);
            cb.autoSize = true;
            cb.pos((Laya.stage.width - cb.width) / 2, 100);
            cb.autoSize = false;
        };
        UI_ComboBox.prototype.createComboBox = function (skin) {
            var comboBox = new ComboBox(this.skin, "item0,item1,item2,item3,item4,item5");
            comboBox.labelSize = 30;
            comboBox.itemSize = 25;
            comboBox.selectHandler = new Handler(this, this.onSelect, [comboBox]);
            Laya.stage.addChild(comboBox);
            return comboBox;
        };
        UI_ComboBox.prototype.onSelect = function (cb) {
            console.log("选中了： " + cb.selectedLabel);
        };
        return UI_ComboBox;
    }());
    laya.UI_ComboBox = UI_ComboBox;
})(laya || (laya = {}));
new laya.UI_ComboBox();
