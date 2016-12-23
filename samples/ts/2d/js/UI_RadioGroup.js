var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var RadioGroup = Laya.RadioGroup;
    var Handler = Laya.Handler;
    var WebGL = Laya.WebGL;
    var UI_RadioGroup = (function () {
        function UI_RadioGroup() {
            this.SPACING = 150;
            this.X_OFFSET = 200;
            this.Y_OFFSET = 200;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(800, 600, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.skins = ["../../res/ui/radioButton (1).png", "../../res/ui/radioButton (2).png", "../../res/ui/radioButton (3).png"];
            Laya.loader.load(this.skins, Handler.create(this, this.initRadioGroups));
        }
        UI_RadioGroup.prototype.initRadioGroups = function () {
            for (var i = 0; i < this.skins.length; ++i) {
                var rg = this.createRadioGroup(this.skins[i]);
                rg.selectedIndex = i;
                rg.x = i * this.SPACING + this.X_OFFSET;
                rg.y = this.Y_OFFSET;
            }
        };
        UI_RadioGroup.prototype.createRadioGroup = function (skin) {
            var rg = new RadioGroup();
            rg.skin = skin;
            rg.space = 70;
            rg.direction = "v";
            rg.labels = "Item1, Item2, Item3";
            rg.labelColors = "#787878,#d3d3d3,#FFFFFF";
            rg.labelSize = 20;
            rg.labelBold = true;
            rg.labelPadding = "5,0,0,5";
            rg.selectHandler = new Handler(this, this.onSelectChange);
            Laya.stage.addChild(rg);
            return rg;
        };
        UI_RadioGroup.prototype.onSelectChange = function (index) {
            console.log("你选择了第 " + (index + 1) + " 项");
        };
        return UI_RadioGroup;
    }());
    laya.UI_RadioGroup = UI_RadioGroup;
})(laya || (laya = {}));
new laya.UI_RadioGroup();
