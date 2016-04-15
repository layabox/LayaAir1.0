const HOLD_TRIGGER_TIME = 1000;
var isApeHold;

Laya.init(550, 400);
Laya.stage.bgColor = "#ffeecc";
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

// 添加一只猩猩
var ape = new laya.display.Sprite();
ape.loadImage("res/apes/monkey2.png");
ape.pos(260, 180);
ape.pivot(55, 72);
ape.scale(0.8, 0.8);
Laya.stage.addChild(ape);

// 鼠标交互
ape.on(laya.events.Event.MOUSE_DOWN, this, onApePress);

function onApePress(e)
{
	// 鼠标按下后，HOLD_TRIGGER_TIME毫秒后hold
	Laya.timer.once(HOLD_TRIGGER_TIME, this, onHold);
	Laya.stage.on(laya.events.Event.MOUSE_UP, this, onApeRelease);
}

function onHold()
{
	laya.utils.Tween.to(ape, { "scaleX":1, "scaleY":1 }, 500, laya.utils.Ease.bounceOut);
	isApeHold = true;
}

/** 鼠标放开后停止hold */
function onApeRelease()
{
	// 鼠标放开时，如果正在hold，则播放放开的效果
	if (isApeHold)
	{
		isApeHold = false;
		laya.utils.Tween.to(ape, { "scaleX":.8, "scaleY":.8 }, 300);
	}
	else // 如果未触发hold，终止触发hold
		Laya.timer.clear(this, onHold);

	Laya.stage.off(laya.events.Event.MOUSE_UP, this, onApeRelease);
}
