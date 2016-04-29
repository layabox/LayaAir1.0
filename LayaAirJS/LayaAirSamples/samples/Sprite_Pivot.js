Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

var sp1 = new Laya.Sprite();
sp1.loadImage("res/apes/monkey2.png", 0, 0);

sp1.pos(150, 200);
sp1.size(110, 145);
//设置轴心点为中心
sp1.pivot(55, 72);
Laya.stage.addChild(sp1);

//不设置轴心点默认为左上角
sp2 = new Laya.Sprite();
sp2.loadImage("res/apes/monkey2.png", 0, 0);
sp2.size(110, 145);
sp2.pos(400, 200);
Laya.stage.addChild(sp2);

Laya.timer.frameLoop(1, this, animate);
		
function animate(e)
{
	sp1.rotation += 2;
	sp2.rotation += 2;
}
