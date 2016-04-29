Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_NOSCALE;
Laya.stage.screenMode = Laya.Stage.SCREEN_VERTICAL;
showText();

function showText()
{
	var text = new Laya.Text();
	
	text.text = "Orientation-Portrait";
	text.color = "dimgray";
	text.font = "Impact";
	text.fontSize = 50;
	
	text.x = Laya.stage.width - text.width >> 1;
	text.y = Laya.stage.height - text.height >> 1;
	
	Laya.stage.addChild(text);
}