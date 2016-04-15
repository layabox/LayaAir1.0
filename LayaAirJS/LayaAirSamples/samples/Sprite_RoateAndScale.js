var ape;
var scaleDelta = 0;

Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

ape = new laya.display.Sprite();
ape.loadImage("res/apes/monkey2.png");
Laya.stage.addChild(ape);
ape.pivot(55, 72);
ape.x = 275;
ape.y = 200;

Laya.timer.frameLoop(1, this, animate);

function animate(e)
{
	ape.rotation += 2;

	//心跳缩放
	scaleDelta += 0.02;
	var scaleValue = Math.sin(scaleDelta);
	ape.scale(scaleValue, scaleValue);
}
