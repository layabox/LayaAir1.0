var rotateTimeBasedText;
var rotateFrameRateBasedText;

Laya.init(550 , 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

rotateTimeBasedText = createText("基于时间旋转", 120, 170);
rotateFrameRateBasedText = createText("基于帧频旋转", 350, 170);

Laya.timer.loop(200, this, animateTimeBased);
Laya.timer.frameLoop(2, this, animateFrameRateBased);

function createText(text, x, y)
{
	var t = new laya.display.Text();
	t.text = text;
	t.fontSize = 30;
	t.color = "white";
	t.bold = true;
	t.pivot(t.width / 2, t.height / 2);
	t.pos(x, y);
	Laya.stage.addChild(t);
	
	return t;
}

function animateTimeBased()
{
	rotateTimeBasedText.rotation += 1;
}

function animateFrameRateBased()
{
	rotateFrameRateBasedText.rotation += 1;
}