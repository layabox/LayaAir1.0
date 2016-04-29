var Sprite = Laya.Sprite;
var Event = Laya.Event;
var Keyboard = Laya.Keyboard;
var TimeLine = Laya.TimeLine;

var target;
var timeLine = new TimeLine();

Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;
setup();

function setup()
{
	createApe();
	createTimerLine();

	Laya.stage.on(Event.KEY_DOWN, this, this.keyDown);
}

function keyDown(e)
{
	switch (e.keyCode)
	{
		case Keyboard.LEFT:
			timeLine.play("turnLeft");
			break;
		case Keyboard.RIGHT:
			timeLine.play("turnRight");
			break;
		case Keyboard.UP:
			timeLine.play("turnUp");
			break;
		case Keyboard.DOWN:
			timeLine.play("turnDown");
			break;
		case Keyboard.P:
			timeLine.pause();
			break;
		case Keyboard.R:
			timeLine.resume();
			break;
	}
}

function createTimerLine()
{
	//第一事件如果起始时间为0就不会抛出。
	timeLine.add("turnRight", 0);
	timeLine.to(target,
	{
		x: 450,
		y: 100,
		scaleX: 0.5,
		scaleY: 0.5
	}, 2000);
	timeLine.add("turnDown", 0);
	timeLine.to(target,
	{
		x: 450,
		y: 300,
		scaleX: 0.2,
		scaleY: 1,
		alpha: 1
	}, 2000);
	timeLine.add("turnLeft", 0);
	timeLine.to(target,
	{
		x: 100,
		y: 300,
		scaleX: 1,
		scaleY: 0.2,
		alpha: 0.1
	}, 2000);
	timeLine.add("turnUp", 0);
	timeLine.to(target,
	{
		x: 100,
		y: 100,
		scaleX: 1,
		scaleY: 1,
		alpha: 1
	}, 2000);

	timeLine.play(0, true);

	timeLine.on(Event.COMPLETE, this, this.onComplete);
	timeLine.on(Event.LABEL, this, this.onLabel);
}

function onComplete()
{
	console.log("timeLine complete!!!!");
}

function onLabel(label)
{
	console.log("LabelName:" + label);
}

function createApe()
{
	target = new Sprite();
	target.loadImage("res/apes/monkey2.png");
	Laya.stage.addChild(target);
	target.pivot(55, 72);
	target.pos(100, 100);
}