Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

Laya.stage.bgColor = "#151515";

var skins = [];
skins.push("res/ui/hscroll.png", "res/ui/hscroll$bar.png", "res/ui/hscroll$down.png", "res/ui/hscroll$up.png");
skins.push("res/ui/vscroll.png", "res/ui/vscroll$bar.png", "res/ui/vscroll$down.png", "res/ui/vscroll$up.png");
Laya.loader.load(skins, Laya.Handler.create(this, onSkinLoadComplete));

function onSkinLoadComplete()
{
	placeHScroller();
	placeVScroller();
}

function placeHScroller()
{
	var hs = new Laya.HScrollBar();
	hs.skin = "res/ui/hscroll.png";
	hs.width = 300;
	hs.pos(50, 170);
	
	hs.min = 0;
	hs.max = 100;
	
	hs.changeHandler = new Laya.Handler(this, onChange);
	Laya.stage.addChild(hs);
}

function placeVScroller()
{
	var vs = new Laya.VScrollBar();
	vs.skin = "res/ui/vscroll.png";
	vs.height = 300;
	vs.pos(400, 50);
	
	vs.min = 0;
	vs.max = 100;
	
	vs.changeHandler = new Laya.Handler(this, onChange);
	Laya.stage.addChild(vs);
}

function onChange(value)
{
	console.log("滚动条的位置： value=" + value);
}