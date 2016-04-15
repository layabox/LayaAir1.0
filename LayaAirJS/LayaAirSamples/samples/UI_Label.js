Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

createLabel("#FFFFFF", null).pos(30, 50);
createLabel("#00FFFF", null).pos(290, 50);
createLabel("#FFFF00", "#FFFFFF").pos(30, 100);
createLabel("#000000", "#FFFFFF").pos(290, 100);
createLabel("#FFFFFF", "#00FFFF").pos(30, 150);
createLabel("#0080FF", "#00FFFF").pos(290, 150);

function createLabel(color, strokeColor)
{
	const STROKE_WIDTH = 4;
	
	var label = new laya.ui.Label();
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