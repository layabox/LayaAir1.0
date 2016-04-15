var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var List = laya.ui.List;
    var Handler = laya.utils.Handler;
    var ListSample = (function () {
        function ListSample() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            var list = new List();
            list.itemRender = Item;
            list.pos(90, 30);
            list.repeatX = 1;
            list.repeatY = 4;
            // 使用但隐藏滚动条
            list.vScrollBarSkin = "";
            list.selectEnable = true;
            list.selectHandler = new Handler(this, this.onSelect);
            list.renderHandler = new Handler(this, this.updateItem);
            Laya.stage.addChild(list);
            // 设置数据项为对应图片的路径
            var data = [];
            for (var i = 0; i < 10; i++) {
                data.push("res/ui/listskins/1.jpg");
                data.push("res/ui/listskins/2.jpg");
                data.push("res/ui/listskins/3.jpg");
                data.push("res/ui/listskins/4.jpg");
                data.push("res/ui/listskins/5.jpg");
            }
            list.array = data;
        }
        ListSample.prototype.updateItem = function (cell, index) {
            cell.setImg(cell.dataSource);
        };
        ListSample.prototype.onSelect = function (index) {
            console.log("当前选择的索引：" + index);
        };
        return ListSample;
    }());
    ui.ListSample = ListSample;
})(ui || (ui = {}));
var Box = laya.ui.Box;
var Item = (function (_super) {
    __extends(Item, _super);
    function Item() {
        _super.call(this);
        this.size(373, 85);
        this.img = new laya.ui.Image();
        this.addChild(this.img);
    }
    Item.prototype.setImg = function (src) {
        this.img.skin = src;
    };
    return Item;
}(Box));
new ui.ListSample();
