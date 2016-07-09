(function()
{
	var Stage    = Laya.Stage;
	var ComboBox = Laya.ComboBox;
	var Handler  = Laya.Handler;
	var WebGL    = Laya.WebGL;

	var skin = "res/ui/combobox.png";

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(800, 600, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		Laya.loader.load(skin, Handler.create(this, onLoadComplete));
	})();

	function onLoadComplete()
	{
		var cb = createComboBox(skin);
		cb.autoSize = true;
		cb.pos((Laya.stage.width - cb.width) / 2, 100);
		cb.autoSize = false;
	}

	function createComboBox(skin)
	{
		var comboBox = new ComboBox(skin, "item0,item1,item2,item3,item4,item5");
		comboBox.labelSize = 30;
		comboBox.itemSize = 25;
		comboBox.selectHandler = new Handler(this, onSelect, [comboBox]);
		Laya.stage.addChild(comboBox);

		return comboBox;
	}

	function onSelect(cb)
	{
		console.log("选中了： " + cb.selectedLabel);
	}
})();