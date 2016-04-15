/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var RadioGroup = laya.ui.RadioGroup;
    var Handler = laya.utils.Handler;
    var RadioSample = (function () {
        function RadioSample() {
            this.SPACING = 150;
            this.X_OFFSET = 60;
            this.Y_OFFSET = 120;
            Laya.init(800, 500);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            this.skins = ["res/ui/radioButton (1).png", "res/ui/radioButton (2).png", "res/ui/radioButton (3).png"];
            Laya.loader.load(this.skins, Handler.create(this, this.initRadioGroups));
        }
        RadioSample.prototype.initRadioGroups = function () {
            for (var i = 0; i < this.skins.length; ++i) {
                var rg = this.createRadioGroup(this.skins[i]);
                rg.selectedIndex = i;
                rg.x = i * this.SPACING + this.X_OFFSET;
                rg.y = this.Y_OFFSET;
            }
        };
        RadioSample.prototype.createRadioGroup = function (skin) {
            var rg = new RadioGroup();
            rg.skin = skin;
            rg.space = 70;
            rg.direction = "v";
            rg.labels = "第一项,第二项,第三项";
            rg.labelSize = 20;
            rg.labelBold = true;
            rg.labelColors = "#787878,#d3d3d3,#FFFFFF";
            rg.labelPadding = "5,0,0,5";
            rg.selectHandler = new Handler(this, this.onSelectChange);
            Laya.stage.addChild(rg);
            return rg;
        };
        RadioSample.prototype.onSelectChange = function (index) {
            console.log("你选择了第 " + (index + 1) + " 项");
        };
        return RadioSample;
    }());
    ui.RadioSample = RadioSample;
})(ui || (ui = {}));
new ui.RadioSample();
