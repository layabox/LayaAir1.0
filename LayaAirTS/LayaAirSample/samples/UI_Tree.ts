/// <reference path="../../libs/LayaAir.d.ts" />
module ui {
    import Tree = laya.ui.Tree;
    import Browser = laya.utils.Browser;
    import Handler = laya.utils.Handler;
    export class TreeSample {
        constructor() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#3d3d3d";
            var res = [
                "res/ui/vscroll.png",
                "res/ui/vscroll$bar.png",
                "res/ui/vscroll$down.png",
                "res/ui/vscroll$up.png",
                "res/ui/tree/clip_selectBox.png",
                "res/ui/tree/clip_tree_folder.png",
                "res/ui/tree/clip_tree_arrow.png"
            ];
            Laya.loader.load(res, new Handler(this, this.onLoadComplete));
        }
        private onLoadComplete(): void {
            var xmlString: string;
            xmlString = "<root><item label='box1'><abc label='child1'/><abc label='child2'/><abc label='child3'/><abc label='child4'/><abc label='child5'/></item><item label='box2'><abc label='child1'/><abc label='child2'/><abc label='child3'/><abc label='child4'/></item></root>";
            var domParser: any = new Browser.window.DOMParser();
            var xml: any = domParser.parseFromString(xmlString, "text/xml");
            var tree: Tree = new Tree();
            tree.scrollBarSkin = "res/ui/vscroll.png";
            tree.itemRender = Item;
            tree.xml = xml;
            tree.x = 175;
            tree.y = 100;
            tree.width = 200;
            tree.height = 200;
            Laya.stage.addChild(tree);
        }
    }
}

import Box = laya.ui.Box;
import Clip = laya.ui.Clip;
import Label = laya.ui.Label;
// 此类对应的json对象：
// {"child": [{"type": "Clip", "props": {"x": "13", "y": "0", "left": "12", "height": "24", "name": "selectBox", "skin": "ui/clip_selectBox.png", "right": "0", "clipY": "2"}}, {"type": "Clip", "props": {"y": "4", "x": "14", "name": "folder", "clipX": "1", "skin": "ui/clip_tree_folder.png", "clipY": "3"}}, {"type": "Label", "props": {"y": "1", "text": "treeItem", "width": "150", "left": "33", "height": "22", "name": "label", "color": "#ffff00", "right": "0", "x": "33"}}, {"type": "Clip", "props": {"x": "0", "name": "arrow", "y": "5", "skin": "ui/clip_tree_arrow.png", "clipY": "2"}}], "type": "Box", "props": {"name": "render", "right": "0", "left": "0"}};
class Item extends Box {
    private __isclass:boolean = true;
    constructor() {
        super();
        this.right = 0;
        this.left = 0;
        this.__isclass = true;
        var selectBox: Clip = new Clip("res/ui/tree/clip_selectBox.png", 1, 2);
        selectBox.name = "selectBox";//设置 selectBox 的name 为“selectBox”时，将被识别为树结构的项的背景。2帧：悬停时背景、选中时背景。
        selectBox.height = 30;
        selectBox.x = 13;
        selectBox.left = 12;
        this.addChild(selectBox);

        var folder: Clip = new Clip("res/ui/tree/clip_tree_folder.png", 1, 3);
        folder.name = "folder";//设置 folder 的name 为“folder”时，将被识别为树结构的文件夹开启状态图表。2帧：折叠状态、打开状态。
        folder.x = 14;
        folder.y = 4;
        this.addChild(folder);

        var label: Label = new Label("treeItem");
        label.name = "label";//设置 label 的name 为“label”时，此值将用于树结构数据赋值。
        label.fontSize = 15;
        label.color = "#ffff00";
        label.padding = "6,0,0,13";
        label.width = 150;
        label.height = 22;
        label.x = 33;
        label.y = 1;
        label.left = 33;
        label.right = 0;
        this.addChild(label);

        var arrow: Clip = new Clip("res/ui/tree/clip_tree_arrow.png", 1, 2);
        arrow.name = "arrow";//设置 arrow 的name 为“arrow”时，将被识别为树结构的文件夹开启状态图表。2帧：折叠状态、打开状态。
        arrow.x = 0;
        arrow.y = 5;
        this.addChild(arrow);
    }
}
new ui.TreeSample();