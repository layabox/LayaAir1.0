// 这段代码需要在setupDemo之前执行。
(function(_super)
{
	function Item()
	{
		this.img = null;
		Item.__super.call(this);
		this.size(373, 85);
		this.img = new laya.ui.Image();
		this.addChild(this.img);

		this.setImg = function(src)
		{
			this.img.skin = src;
		}
	}
	Laya.class(Item, "Item", _super)
})(laya.ui.Box);
var myConsole;
var sampleDemoArea;

Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
	
var list = new laya.ui.List();

list.itemRender = Item;
list.pos(90, 30);

list.repeatX = 1;
list.repeatY = 4;

// 使用但隐藏滚动条
list.vScrollBarSkin = "";

list.selectEnable = true;
list.selectHandler = new laya.utils.Handler(this, onSelect);

list.renderHandler = new laya.utils.Handler(this, updateItem);
Laya.stage.addChild(list);

// 设置数据项为对应图片的路径
var data = [];
for (var i = 0; i < 10; ++i)
{
	data.push("res/ui/listskins/1.jpg");
	data.push("res/ui/listskins/2.jpg");
	data.push("res/ui/listskins/3.jpg");
	data.push("res/ui/listskins/4.jpg");
	data.push("res/ui/listskins/5.jpg");
}
list.array = data;

function updateItem(cell, index)
{
	cell.setImg(cell.dataSource);
}

function onSelect(index)
{
	console.log("当前选择的索引：" + index);
}
