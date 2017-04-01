(function()
{
	var Stage   = Laya.Stage;
	var Button  = Laya.Button;
	var Clip    = Laya.Clip;
	var Image   = Laya.Image;
	var Handler = Laya.Handler;
	var WebGL   = Laya.WebGL;

	var buttonSkin = "../../res/ui/button-7.png";
	var clipSkin = "../../res/ui/num0-9.png";
	var bgSkin = "../../res/ui/coutDown.png";

	var counter, currFrame, controller;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(800, 600, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		Laya.loader.load([buttonSkin, clipSkin, bgSkin], laya.utils.Handler.create(this, onSkinLoaded));
	})();

	function onSkinLoaded()
	{
		showBg();
		createTimerAnimation();
		showTotalSeconds();
		createController();
	}

	function showBg()
	{
		var bg = new Image(bgSkin);
		bg.size(224, 302);
		bg.pos(Laya.stage.width - bg.width >> 1, Laya.stage.height - bg.height >> 1);
		Laya.stage.addChild(bg);
	}

	function createTimerAnimation()
	{
		counter = new Clip(clipSkin, 10, 1);
		counter.autoPlay = true;
		counter.interval = 1000;

		counter.x = (Laya.stage.width - counter.width) / 2 - 35;
		counter.y = (Laya.stage.height - counter.height) / 2 - 40;

		Laya.stage.addChild(counter);
	}

	function showTotalSeconds()
	{
		var clip = new Clip(clipSkin, 10, 1);
		clip.index = clip.clipX - 1;
		clip.pos(counter.x + 60, counter.y);
		Laya.stage.addChild(clip);
	}

	function createController()
	{
		controller = new Button(buttonSkin, "暂停");
		controller.labelBold = true;
		controller.labelColors = "#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF";
		controller.size(84, 30);

		controller.on('click', this, onClipSwitchState);

		controller.x = (Laya.stage.width - controller.width) / 2;
		controller.y = (Laya.stage.height - controller.height) / 2 + 110;
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
})();