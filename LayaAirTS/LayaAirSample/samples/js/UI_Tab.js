/// <reference path="../../libs/LayaAir.d.ts" />
var Handler = laya.utils.Handler;
var Tab = laya.ui.Tab;
var UI_Tab = (function () {
    function UI_Tab() {
        this.skins = ["res/ui/tab1.png", "res/ui/tab2.png"];
        Laya.init(550, 400);
        Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
        Laya.stage.bgColor = "#3d3d3d";
        Laya.loader.load(this.skins, Handler.create(this, this.onSkinLoaded));
    }
    UI_Tab.prototype.onSkinLoaded = function () {
        var tabA = this.createTab(this.skins[0]);
        tabA.pos(40, 120);
        tabA.labelColors = "#000000,#d3d3d3,#333333";
        var tabB = this.createTab(this.skins[1]);
        tabB.pos(40, 220);
        tabB.labelColors = "#FFFFFF,#8FB299,#FFFFFF";
    };
    UI_Tab.prototype.createTab = function (skin) {
        var tab = new Tab();
        tab.skin = skin;
        tab.labelBold = true;
        tab.labelSize = 20;
        tab.labelColors = "#FFFFFF,#8FB299,#5E5E5E";
        tab.labelStrokeColor = "#000000";
        tab.labels = "Tab Control 1,Tab Control 2,Tab Control 3";
        tab.labelPadding = "0,0,0,0";
        tab.selectedIndex = 1;
        this.onSelect(tab.selectedIndex);
        tab.selectHandler = new Handler(this, this.onSelect);
        Laya.stage.addChild(tab);
        return tab;
    };
    UI_Tab.prototype.onSelect = function (index) {
        ("当前选择的标签页索引为 " + index);
    };
    return UI_Tab;
}());
new UI_Tab();
