(function()
{
	var Stage    = Laya.Stage;
	var CheckBox = Laya.CheckBox;
	var Handler  = Laya.Handler;
	var WebGL    = Laya.WebGL;

	var COL_AMOUNT = 2;
	var ROW_AMOUNT = 3;
	var HORIZONTAL_SPACING = 200;
	var VERTICAL_SPACING = 100;
	var X_OFFSET = 100;
	var Y_OFFSET = 50;

	var skins;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(800, 600, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		skins = ["res/ui/checkbox (1).png", "res/ui/checkbox (2).png", "res/ui/checkbox (3).png", "res/ui/checkbox (4).png", "res/ui/checkbox (5).png", "res/ui/checkbox (6).png"];

		Laya.loader.load(skins, Handler.create(this, onCheckBoxSkinLoaded));
	})();

	function onCheckBoxSkinLoaded()
	{
		var cb;
		for (var i = 0; i < COL_AMOUNT; ++i)
		{
			for (var j = 0; j < ROW_AMOUNT; ++j)
			{
				cb = createCheckBox(skins[i * ROW_AMOUNT + j]);
				cb.selected = true;

				cb.x = HORIZONTAL_SPACING * i + X_OFFSET;
				cb.y += VERTICAL_SPACING * j + Y_OFFSET;

				// 给左边的三个CheckBox添加事件使其能够切换标签
				if (i == 0)
				{
					cb.y += 20;
					cb.on("change", this, updateLabel, [cb]);
					updateLabel(cb);
				}
			}
		}
	}

	function createCheckBox(skin)
	{
		var cb = new CheckBox(skin);
		Laya.stage.addChild(cb);

		cb.labelColors = "white";
		cb.labelSize = 20;
		cb.labelFont = "Microsoft YaHei";
		cb.labelPadding = "3,0,0,5";

		return cb;
	}

	function updateLabel(checkBox)
	{
		checkBox.label = checkBox.selected ? "已选中" : "未选中";
	}
})();