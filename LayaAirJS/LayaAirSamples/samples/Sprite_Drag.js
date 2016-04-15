var ape;
var dragRect;

Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

ape = new laya.display.Sprite();

ape.loadImage("res/apes/monkey2.png");
Laya.stage.addChild(ape);

ape.x = 275;
ape.y = 200;
ape.pivot(55, 72);

//拖动限制区域
dragRect = new laya.maths.Rectangle(100, 100, 350, 200);

//画出拖动限制区域
Laya.stage.graphics.drawRect(
	dragRect.x, dragRect.y, dragRect.width, dragRect.height,
	null, "#FFFFFF", 5);

ape.on(laya.events.Event.MOUSE_DOWN, this, onStartDrag);

function onStartDrag(e)
{
	//鼠标按下开始拖拽(设置了拖动区域和超界弹回的滑动效果)
	ape.startDrag(dragRect, true, 100);
	console.log(e.target.name)
}
