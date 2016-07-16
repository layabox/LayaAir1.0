(function()
{
	var Sprite = laya.display.Sprite;
	var Stage = laya.display.Stage;
	var Event = laya.events.Event;
	var Texture = laya.resource.Texture;
	var Browser = laya.utils.Browser;
	var Ease = laya.utils.Ease;
	var Handler = laya.utils.Handler;
	var Tween = laya.utils.Tween;
	var WebGL = laya.webgl.WebGL;

	const HOLD_TRIGGER_TIME = 1000;
	const apePath = "../../res/apes/monkey2.png";

	//触发hold事件时间为1秒
	var ape, isApeHold;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		Laya.loader.load(apePath, Handler.create(this, createApe));
	})();

	function createApe()
	{
		// 添加一只猩猩
		ape = new Sprite();
		ape.loadImage(apePath);

		var texture = Laya.loader.getRes(apePath);
		ape.pivot(texture.width / 2, texture.height / 2);
		ape.pos(Laya.stage.width / 2, Laya.stage.height / 2);
		ape.scale(0.8, 0.8);
		Laya.stage.addChild(ape);

		// 鼠标交互
		ape.on(Event.MOUSE_DOWN, this, onApePress);
	}

	function onApePress(e)
	{
		// 鼠标按下后，HOLD_TRIGGER_TIME毫秒后hold
		Laya.timer.once(HOLD_TRIGGER_TIME, this, onHold);
		Laya.stage.on(Event.MOUSE_UP, this, onApeRelease);
	}

	function onHold()
	{
		Tween.to(ape,
		{
			"scaleX": 1,
			"scaleY": 1
		}, 500, Ease.bounceOut);
		isApeHold = true;
	}

	/** 鼠标放开后停止hold */
	function onApeRelease()
	{
		// 鼠标放开时，如果正在hold，则播放放开的效果
		if (isApeHold)
		{
			isApeHold = false;
			Tween.to(ape,
			{
				"scaleX": 0.8,
				"scaleY": 0.8
			}, 300);
		}
		else // 如果未触发hold，终止触发hold
			Laya.timer.clear(this, onHold);

		Laya.stage.off(Event.MOUSE_UP, this, onApeRelease);
	}
})();