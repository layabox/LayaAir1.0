Laya.init(550, 400,Laya.WebGL);
// Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

//加载资源
Laya.loader.load("res/apes/monkey2.png", Laya.Handler.create(this, onAssetLoaded));

function onAssetLoaded()
{
	//创建一个发光滤镜
	var glowFilter = new Laya.GlowFilter("#ffff00", 20, 5, 5);

	var ape = new Laya.Sprite();
	ape.pos(220, 120);
	
	ape.loadImage("res/apes/monkey2.png");

	//设置滤镜集合为发光滤镜
	ape.filters = [glowFilter];

	Laya.stage.addChild(ape);
}