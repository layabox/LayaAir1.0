Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
Laya.stage.bgColor = "#151515";

var skins = [];
skins.push("res/ui/hslider.png", "res/ui/hslider$bar.png");
skins.push("res/ui/vslider.png", "res/ui/vslider$bar.png");
Laya.loader.load(skins, laya.utils.Handler.create(this, onLoadComplete));

function onLoadComplete()
{
	placeHSlider();
	placeVSlider();
}

function placeHSlider()
{
	var hs = new laya.ui.HSlider();
	hs.skin = "res/ui/hslider.png";
	
	hs.width = 300;
	hs.pos(50, 170);
	hs.min = 0;
	hs.max = 100;
	hs.value = 50;
	hs.tick = 1;
	
	hs.changeHandler = new laya.utils.Handler(this, onChange);
	Laya.stage.addChild(hs);
}

function placeVSlider()
{
	var vs = new laya.ui.VSlider();
	
	vs.skin = "res/ui/vslider.png";
	
	vs.height = 300;
	vs.pos(400, 50);
	vs.min = 0;
	vs.max = 100;
	vs.value = 50;
	vs.tick = 1;
	
	vs.changeHandler = new laya.utils.Handler(this, onChange);
	Laya.stage.addChild(vs);
}

function onChange(value)
{
	console.log("滑块的位置：" + value);
}