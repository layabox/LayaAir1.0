Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

//显示两只猩猩
var ape1 = new Laya.Sprite();
var ape2 = new Laya.Sprite();

ape1.loadImage("res/apes/monkey2.png");
ape2.loadImage("res/apes/monkey2.png");

ape1.pivot(55, 72);
ape2.pivot(55, 72);

ape1.pos(275, 200);
ape2.pos(200, 0);

//一只猩猩在舞台上，另一只被添加成第一只猩猩的子级
Laya.stage.addChild(ape1);
ape1.addChild(ape2);

Laya.timer.frameLoop(1, this, animate);

function animate(e)
{
	ape1.rotation += 2;
	ape2.rotation -= 4;
}
