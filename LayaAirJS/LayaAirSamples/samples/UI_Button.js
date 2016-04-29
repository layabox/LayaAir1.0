var COLUMNS = 2;
var BUTTON_WIDTH = 147;
var BUTTON_HEIGHT = 165 / 3;
var HORIZONTAL_SPACING = 200;
var VERTICAL_SPACING = 100;

var xOffset;
var yOffset;

var skins;

Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

skins = [
	"res/ui/button-1.png", "res/ui/button-2.png", "res/ui/button-3.png", 
	"res/ui/button-4.png", "res/ui/button-5.png", "res/ui/button-6.png"
	];

// 计算将Button至于舞台中心的偏移量
xOffset = (Laya.stage.width - HORIZONTAL_SPACING * (COLUMNS - 1) - BUTTON_WIDTH) / 2;
yOffset = (Laya.stage.height - VERTICAL_SPACING * (skins.length / COLUMNS - 1) - BUTTON_HEIGHT) / 2;

Laya.loader.load(skins, Laya.Handler.create(this, onUIAssertLoaded));

function onUIAssertLoaded()
{
	for(var i = 0, len = skins.length; i < len; ++i)
	{
		var btn = createButton(skins[i]);
		var x = i % COLUMNS * HORIZONTAL_SPACING + xOffset;
		var y = (i / COLUMNS | 0) * VERTICAL_SPACING + yOffset;
		btn.pos(x, y);
	}
}

function createButton(skin)
{
	var btn = new Laya.Button(skin);
	Laya.stage.addChild(btn);
	return btn;
}