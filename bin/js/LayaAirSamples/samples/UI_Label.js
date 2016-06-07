(function()
{
	var Stage = Laya.Stage;
	var Label = Laya.Label;
	var WebGL = Laya.WebGL;

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
		createLabel("#FFFFFF", null).pos(30, 50);
		createLabel("#00FFFF", null).pos(290, 50);
		createLabel("#FFFF00", "#FFFFFF").pos(30, 100);
		createLabel("#000000", "#FFFFFF").pos(290, 100);
		createLabel("#FFFFFF", "#00FFFF").pos(30, 150);
		createLabel("#0080FF", "#00FFFF").pos(290, 150);
	}

	function createLabel(color, strokeColor)
	{
		const STROKE_WIDTH = 4;

		var label = new Label();
		label.font = "Microsoft YaHei";
		label.text = "SAMPLE DEMO";
		label.fontSize = 30;
		label.color = color;

		if (strokeColor)
		{
			label.stroke = STROKE_WIDTH;
			label.strokeColor = strokeColor;
		}

		Laya.stage.addChild(label);

		return label;
	}
})();