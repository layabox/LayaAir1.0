Laya.init(550, 400, Laya.WebGL);

var ape = new Laya.Sprite();
ape.loadImage("res/apes/monkey2.png");
ape.pos(200, 100);
Laya.stage.addChild(ape);

//创建一个发光滤镜
var glowFilter = new Laya.GlowFilter("#ffff00", 10, 0, 0);
//设置滤镜集合为发光滤镜
ape.filters = [glowFilter];