var buttonSkin = "res/ui/button-7.png";
var clipSkin = "res/ui/num0-9.png";
var bgSkin = "res/ui/coutDown.png";

var counter;
var currFrame;
var controller;

Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

Laya.loader.load([buttonSkin, clipSkin, bgSkin], Laya.Handler.create(this,onSkinLoaded));

function onSkinLoaded()
{
	showBg();
	createTimerAnimation();
	showTotalSeconds();
	createController();
}

function showBg() 
{
	var bg = new Laya.Image(bgSkin);
	bg.pos(163, 50);
	Laya.stage.addChild(bg);
}

function createTimerAnimation()
{
	counter = new Laya.Clip(clipSkin, 10, 1);
	counter.autoPlay = true;
	counter.interval = 1000;
	
	counter.pos(223, 130);
	
	Laya.stage.addChild(counter);
}

function showTotalSeconds() 
{
	var clip = new Laya.Clip(clipSkin, 10, 1);
	clip.index = clip.clipX - 1;
	clip.pos(285, 130);
	Laya.stage.addChild(clip);
}

function createController() 
{
	controller = new Laya.Button(buttonSkin, "暂停");
	controller.labelBold = true;
	controller.labelColors = "#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF";
	
	controller.on('click', this, onClipSwitchState);
	
	controller.pos(230, 300);
	Laya.stage.addChild(controller);
}

function onClipSwitchState() 
{
	if (counter.isPlaying)
	{
		counter.stop();
		currFrame = counter.index;
		controller.label = "播放";
	}
	else
	{
		counter.play();
		counter.index = currFrame;
		controller.label = "暂停";
	}
}	