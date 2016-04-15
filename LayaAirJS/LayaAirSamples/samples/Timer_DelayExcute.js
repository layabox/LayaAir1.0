Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

var spBtn1 = new laya.display.Sprite();
spBtn1.size(200, 100);
spBtn1.pos(27, 29);

spBtn1.graphics.drawRect(0, 0, 200, 100, "#ff0000");
spBtn1.graphics.fillText("点我3秒之后 alpha - 0.5", 5, 20, "", "#ffffff", "left");

spBtn1.mouseEnabled = true;
spBtn1.on(laya.events.Event.CLICK, this, onMinusAlpha1);
Laya.stage.addChild(spBtn1);

var spBtn2 = new laya.display.Sprite();
spBtn2.size(200, 100);
spBtn2.pos(250, 29);

spBtn2.graphics.drawRect(0, 0, 200, 100, "#ff0000");
spBtn2.graphics.fillText("点我60帧之后 alpha - 0.5", 5, 20, "", "#ffffff", "left");

//接受鼠标事件
spBtn2.mouseEnabled = true;
spBtn2.on(laya.events.Event.CLICK, this, onMinusAlpha2);

Laya.stage.addChild(spBtn2);
		
function onMinusAlpha1(e)
{
	//移除鼠标单击事件
	spBtn1.off(laya.events.Event.CLICK, this, onMinusAlpha1);
	//定时执行一次(间隔时间)
	Laya.timer.once(3000, this, onComplete1);
}
		
function onMinusAlpha2(e)
{
	//移除鼠标单击事件
	spBtn2.off(laya.events.Event.CLICK, this, onMinusAlpha2);
	//定时执行一次(基于帧率)
	Laya.timer.frameOnce(60, this, onComplete2);
}

function onComplete1()
{
	//spBtn1的透明度减少0.5
	spBtn1.alpha -= 0.5;
}

function onComplete2()
{
	//spBtn2的透明度减少0.5
	spBtn2.alpha -= 0.5;
}