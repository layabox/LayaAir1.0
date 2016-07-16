(function()
{
	var Stage = Laya.Stage;
	var TextInput = Laya.TextInput;
	var Handler = Laya.Handler;
	var WebGL = Laya.WebGL;

	var SPACING = 100;
	var INPUT_WIDTH = 300;
	var INPUT_HEIGHT = 50;
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

		skins = ["../../res/ui/input (1).png", "../../res/ui/input (2).png", "../../res/ui/input (3).png", "../../res/ui/input (4).png"];
		Laya.loader.load(skins, Handler.create(this, onLoadComplete)); //加载资源。
	})();

	function onLoadComplete()
	{
		for (var i = 0; i < skins.length; ++i)
		{
			var input = createInput(skins[i]);
			input.prompt = 'Type:';
			input.x = (Laya.stage.width - input.width) / 2;
			input.y = i * SPACING + Y_OFFSET;
		}
	}

	function createInput(skin)
	{
		var ti = new TextInput();

		ti.inputElementXAdjuster = 0;
		ti.inputElementYAdjuster = 1;

		ti.skin = skin;
		ti.size(300, 50);
		ti.sizeGrid = "0,40,0,40";
		ti.font = "Arial";
		ti.fontSize = 30;
		ti.bold = true;
		ti.color = "#606368";

		Laya.stage.addChild(ti);

		return ti;
	}
})();