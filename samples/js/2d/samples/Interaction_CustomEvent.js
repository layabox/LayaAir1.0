(function()
{
	var Sprite  = laya.display.Sprite;
	var Stage   = laya.display.Stage;
	var Event   = laya.events.Event;
	var Browser = laya.utils.Browser;
	var Ease    = laya.utils.Ease;
	var Tween   = laya.utils.Tween;
	var WebGL   = laya.webgl.WebGL;

	var ROTATE = "rotate";
	var sp;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		createSprite();
	})();


	function createSprite()
	{
		sp = new Sprite();
		sp.graphics.drawRect(0, 0, 200, 200, "#D2691E");
		sp.pivot(100, 100);

		sp.x = Laya.stage.width / 2;
		sp.y = Laya.stage.height / 2;

		sp.size(200, 200);
		Laya.stage.addChild(sp);

		sp.on(ROTATE, this, onRotate); // 侦听自定义的事件
		sp.on(Event.CLICK, this, onSpriteClick);
	}


	function onSpriteClick(e)
	{
		var randomAngle = Math.random() * 180;
		//发送自定义事件
		sp.event(ROTATE, [randomAngle]);
	}

	// 触发自定义的rotate事件
	function onRotate(newAngle)
	{
		Tween.to(sp,
		{
			"rotation": newAngle
		}, 1000, Ease.elasticOut);
	}
})();