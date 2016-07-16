// 这段代码需要在setupDemo之前执行。
(function()
{
	// 项渲染器
	var Box   = Laya.Box;
	var Image = Laya.Image;

	var WID = 373,
		HEI = 85;

	function Item()
	{
		Item.__super.call(this);
		this.size(WID, HEI);
		this.img = new Image();
		this.addChild(this.img);

		this.setImg = function(src)
		{
			this.img.skin = src;
		}
	}
	Laya.class(Item, "Item", Box);

	// 主要逻辑代码
	var Stage   = Laya.Stage;
	var List    = Laya.List;
	var Handler = Laya.Handler;
	var WebGL   = Laya.WebGL;
	

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(800, 600, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		setup();
	})();

	function setup()
	{
		var list = new List();

		list.itemRender = Item;

		list.repeatX = 1;
		list.repeatY = 4;

		list.x = (Laya.stage.width - WID) / 2;
		list.y = (Laya.stage.height - HEI * list.repeatY) / 2;

		// 使用但隐藏滚动条
		list.vScrollBarSkin = "";

		list.selectEnable = true;
		list.selectHandler = new Handler(this, onSelect);

		list.renderHandler = new Handler(this, updateItem);
		Laya.stage.addChild(list);

		// 设置数据项为对应图片的路径
		var data = [];
		for (var i = 0; i < 10; ++i)
		{
			data.push("../../res/ui/listskins/1.jpg");
			data.push("../../res/ui/listskins/2.jpg");
			data.push("../../res/ui/listskins/3.jpg");
			data.push("../../res/ui/listskins/4.jpg");
			data.push("../../res/ui/listskins/5.jpg");
		}
		list.array = data;
	}

	function updateItem(cell, index)
	{
		cell.setImg(cell.dataSource);
	}

	function onSelect(index)
	{
		console.log("当前选择的索引：" + index);
	}
})();