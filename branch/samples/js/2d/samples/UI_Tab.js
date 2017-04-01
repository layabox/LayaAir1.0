(function()
{
	var Stage = Laya.Stage;
	var Tab = Laya.Tab;
	var Handler = Laya.Handler;
	var WebGL = Laya.WebGL;

	var skins = ["../../res/ui/tab1.png", "../../res/ui/tab2.png"];

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(550, 400, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		Laya.stage.bgColor = "#3d3d3d";
		Laya.loader.load(skins, Handler.create(this, onSkinLoaded));
	})();

	function onSkinLoaded()
	{
		var tabA = createTab(skins[0]);
		tabA.pos(40, 120);
		tabA.labelColors = "#000000,#d3d3d3,#333333";

		var tabB = createTab(skins[1]);
		tabB.pos(40, 220);
		tabB.labelColors = "#FFFFFF,#8FB299,#FFFFFF";
	}

	function createTab(skin)
	{
		var tab = new Tab();
		tab.skin = skin;

		tab.labelBold = true;
		tab.labelSize = 20;
		tab.labelStrokeColor = "#000000";

		tab.labels = "Tab Control 1,Tab Control 2,Tab Control 3";
		tab.labelPadding = "0,0,0,0";

		tab.selectedIndex = 1;

		onSelect(tab.selectedIndex);
		tab.selectHandler = new Handler(this, onSelect);

		Laya.stage.addChild(tab);

		return tab;
	}

	function onSelect(index)
	{
		console.log("当前选择的标签页索引为 " + index);
	}
})();