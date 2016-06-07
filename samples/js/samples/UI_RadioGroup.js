(function()
{
	var Stage      = Laya.Stage;
	var RadioGroup = Laya.RadioGroup;
	var Handler    = Laya.Handler;
	var WebGL      = Laya.WebGL;

	var SPACING  = 150;
	var X_OFFSET = 200;
	var Y_OFFSET = 200;

	var skins;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(800, 600, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		skins = ["res/ui/radioButton (1).png", "res/ui/radioButton (2).png", "res/ui/radioButton (3).png"];
		Laya.loader.load(skins, Handler.create(this, initRadioGroups));
	})();

	function initRadioGroups()
	{
		for (var i = 0; i < skins.length; ++i)
		{
			var rg = createRadioGroup(skins[i]);
			rg.selectedIndex = i;
			rg.x = i * SPACING + X_OFFSET;
			rg.y = Y_OFFSET;
		}
	}

	function createRadioGroup(skin)
	{
		var rg = new RadioGroup();
		rg.skin = skin;

		rg.space = 70;
		rg.direction = "v";

		rg.labels = "Item1, Item2, Item3";
		rg.labelColors = "#787878,#d3d3d3,#FFFFFF";
		rg.labelSize = 20;
		rg.labelBold = true;
		rg.labelPadding = "5,0,0,5";

		rg.selectHandler = new Handler(this, onSelectChange);
		Laya.stage.addChild(rg);

		return rg;
	}

	function onSelectChange(index)
	{
		console.log("你选择了第 " + (index + 1) + " 项");
	}
})();