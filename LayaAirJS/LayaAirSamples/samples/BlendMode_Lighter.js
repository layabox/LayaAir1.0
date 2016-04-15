var Animation = laya.display.Animation;
var Sprite = laya.display.Sprite;
var Handler = laya.utils.Handler;
var Tween = laya.utils.Tween;
var Utils = laya.utils.Utils;

var w = 1000;
var h = 400;
var tween = new Tween();
var duration = 2000;
var obj = {
	r: 99,
	g: 0,
	b: 0xFF
};

Laya.init(w, h);

createAnimation().blendMode = "lighter";
createAnimation().pos(500, 0);
evalBgColor();

Laya.timer.frameLoop(1, this, renderBg);

function createAnimation()
{
	var animation = Animation.fromUrl("res/phoenix/phoenix{0001}.jpg", 25);
	Laya.stage.addChild(animation);

	var clips = animation.frames.concat();
	// 反转帧
	clips = clips.reverse();
	// 添加到已有帧末尾
	animation.frames = animation.frames.concat(clips);

	animation.play();

	return animation;
}

function evalBgColor()
{
	var color = Math.random() * 0xFFFFFF;
	var channels = getColorChannals(color);
	tween.to(obj,
	{
		r: channels[0],
		g: channels[1],
		b: channels[2]
	}, duration, null, Handler.create(this, onTweenComplete));
}

function getColorChannals(color)
{
	var result = [];
	result.push(color >> 16);
	result.push(color >> 8 & 0xFF);
	result.push(color & 0xFF);
	return result;
}

function onTweenComplete()
{
	evalBgColor();
}

function renderBg()
{
	Laya.stage.graphics.drawRect(0, 0, w, h, getColor());
}

function getColor()
{
	obj.r = Math.floor(obj.r);
	// 绿色通道使用0
	obj.g = 0;
	//obj.g = Math.floor(obj.g);
	obj.b = Math.floor(obj.b);

	var r = obj.r.toString(16);
	r = r.length == 2 ? r : "0" + r;
	var g = obj.g.toString(16);
	g = g.length == 2 ? g : "0" + g;
	var b = obj.b.toString(16);
	b = b.length == 2 ? b : "0" + b;
	return "#" + r + g + b;
}