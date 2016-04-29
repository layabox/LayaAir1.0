Laya.init(550, 400); //设置游戏画布宽高、渲染模式
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;
Laya.stage.bgColor = "black"; //设置画布的背景颜色
var res = [
     "res/ui/vscroll.png",
     "res/ui/vscroll$bar.png",
     "res/ui/vscroll$down.png",
     "res/ui/vscroll$up.png",
     "res/ui/vscroll$up.png",
     "res/ui/tree/clip_selectBox.png",
     "res/ui/tree/clip_tree_folder.png",
     "res/ui/tree/clip_tree_arrow.png"
];

Laya.loader.load(res, new Laya.Handler(this, onLoadComplete));

function onLoadComplete()
{
     var xmlString;
     xmlString = "<root><item label='box1'><abc label='child1'/><abc label='child2'/><abc label='child3'/><abc label='child4'/><abc label='child5'/></item><item label='box2'><abc label='child1'/><abc label='child2'/><abc label='child3'/><abc label='child4'/></item></root>";
     var domParser = new Laya.Browser.window.DOMParser(); //创建一个DOMParser实例domParser。
     var xml = domParser.parseFromString(xmlString, "text/xml"); //解析xml字符。

     var tree = new Laya.Tree();
     tree.scrollBarSkin = "res/ui/vscroll.png";
     tree.itemRender = mypackage.treeExample.Item;
     tree.xml = xml; //设置 tree 的树结构数据。
     tree.x = 175;
     tree.y = 100;
     tree.width = 200;
     tree.height = 200;
     Laya.stage.addChild(tree);
}
(function(_super)
{
     function Item()
     {
          Item.__super.call(this); //初始化父类。
          this.right = 0;
          this.left = 0;

          var selectBox = new Laya.Clip("res/ui/tree/clip_selectBox.png", 1, 2);
          selectBox.name = "selectBox"; //设置 selectBox 的name 为“selectBox”时，将被识别为树结构的项的背景。2帧：悬停时背景、选中时背景。
          selectBox.height = 30;
          selectBox.x = 13;
          selectBox.left = 12;
          this.addChild(selectBox); //需要使用this.访问父类的属性或方法。

          var folder = new Laya.Clip("res/ui/tree/clip_tree_folder.png", 1, 3);
          folder.name = "folder"; //设置 folder 的name 为“folder”时，将被识别为树结构的文件夹开启状态图表。2帧：折叠状态、打开状态。
          folder.x = 14;
          folder.y = 4;
          this.addChild(folder);

          var label = new Laya.Label("treeItem");
          label.name = "label"; //设置 label 的name 为“label”时，此值将用于树结构数据赋值。
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

          var arrow = new Laya.Clip("res/ui/tree/clip_tree_arrow.png", 1, 2);
          arrow.name = "arrow"; //设置 arrow 的name 为“arrow”时，将被识别为树结构的文件夹开启状态图表。2帧：折叠状态、打开状态。
          arrow.x = 0;
          arrow.y = 5;
          this.addChild(arrow);
     };
     Laya.class(Item, "mypackage.treeExample.Item", _super); //注册类 Item 。
})(Laya.Box);