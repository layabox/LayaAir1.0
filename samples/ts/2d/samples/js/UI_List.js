var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Stage = laya.display.Stage;
    var List = laya.ui.List;
    var Handler = laya.utils.Handler;
    var WebGL = laya.webgl.WebGL;
    var UI_List = (function () {
        function UI_List() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(800, 600, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        UI_List.prototype.setup = function () {
            var list = new List();
            list.itemRender = Item;
            list.repeatX = 1;
            list.repeatY = 4;
            list.x = (Laya.stage.width - Item.WID) / 2;
            list.y = (Laya.stage.height - Item.HEI * list.repeatY) / 2;
            // 使用但隐藏滚动条
            list.vScrollBarSkin = "";
            list.selectEnable = true;
            list.selectHandler = new Handler(this, this.onSelect);
            list.renderHandler = new Handler(this, this.updateItem);
            Laya.stage.addChild(list);
            // 设置数据项为对应图片的路径
            var data = [];
            for (var i = 0; i < 10; ++i) {
                data.push("res/ui/listskins/1.jpg");
                data.push("res/ui/listskins/2.jpg");
                data.push("res/ui/listskins/3.jpg");
                data.push("res/ui/listskins/4.jpg");
                data.push("res/ui/listskins/5.jpg");
            }
            list.array = data;
        };
        UI_List.prototype.updateItem = function (cell, index) {
            cell.setImg(cell.dataSource);
        };
        UI_List.prototype.onSelect = function (index) {
            console.log("当前选择的索引：" + index);
        };
        return UI_List;
    }());
    laya.UI_List = UI_List;
    var Box = laya.ui.Box;
    var Image = laya.ui.Image;
    var Item = (function (_super) {
        __extends(Item, _super);
        function Item() {
            _super.call(this);
            this.size(Item.WID, Item.HEI);
            this.img = new Image();
            this.addChild(this.img);
        }
        Item.prototype.setImg = function (src) {
            this.img.skin = src;
        };
        Item.WID = 373;
        Item.HEI = 85;
        return Item;
    }(Box));
})(laya || (laya = {}));
new laya.UI_List();
