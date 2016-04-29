Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

// 显示猩猩
var ape = new Laya.Sprite();
ape.loadImage("res/apes/monkey2.png");
ape.pos(100, 100);
Laya.stage.addChild(ape);

//创建一个名为maskSp的Sprite对象作为mask
var maskSp = new Laya.Sprite();
//绘制mask区域
maskSp.graphics.drawCircle(0, 0, 50, "#FF0000");
maskSp.pos(60, 50);

//设置猩猩的mask
ape.mask = maskSp;
