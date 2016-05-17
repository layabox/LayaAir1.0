Laya.init(550, 400, Laya.WebGL);

var ape = new Laya.Sprite();
ape.loadImage("res/apes/monkey2.png");
ape.pos(200, 100);
Laya.stage.addChild(ape);

var blurFilter = new Laya.BlurFilter();
blurFilter.strength = 5;
ape.filters = [blurFilter];