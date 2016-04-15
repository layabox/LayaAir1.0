var SPACING = 100;
var INPUT_WIDTH = 300;
var INPUT_HEIGHT = 50;
var X_OFFSET = 125;
var Y_OFFSET = 20;
var skins;

Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

skins = ["res/ui/input (1).png", "res/ui/input (2).png", "res/ui/input (3).png", "res/ui/input (4).png"];
Laya.loader.load(skins, laya.utils.Handler.create(this, onLoadComplete));//加载资源。
 
function onLoadComplete()
{
	for (var i = 0; i < skins.length;++i)
	{
		var input = createInput(skins[i]);
		input.x = X_OFFSET;
		input.y = i * SPACING + Y_OFFSET;
	}
}

function createInput(skin)
{
	var ti = new laya.ui.TextInput();
	
	ti.inputElementXAdjuster = -1;
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