(function()
{
	var Sprite  = laya.display.Sprite;
	var Stage   = laya.display.Stage;
	var Event   = laya.events.Event;
	var Browser = laya.utils.Browser;
	var WebGL   = laya.webgl.WebGL;

	var sp;
	var preRadian = 0;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		setup();
	})();

	function setup()
	{
		createSprite();

		Laya.stage.on(Event.MOUSE_UP, this, onMouseUp);
		Laya.stage.on(Event.MOUSE_OUT, this, onMouseUp);
	}

	function createSprite()
	{
		sp = new Sprite();
		var w = 200,
			h = 300;
		sp.graphics.drawRect(0, 0, w, h, "#FF7F50");
		sp.size(w, h);
		sp.pivot(w / 2, h / 2);
		sp.pos(Laya.stage.width / 2, Laya.stage.height / 2);
		Laya.stage.addChild(sp);

		sp.on(Event.MOUSE_DOWN, this, onMouseDown);
	}

	function onMouseDown(e)
	{
		var touches = e.touches;

		if (touches.length == 2)
		{
			preRadian = Math.atan2(
				touches[0].stageY - touches[1].stageY,
				touches[0].stageX - touches[1].stageX);

			Laya.stage.on(Event.MOUSE_MOVE, this, onMouseMove);
		}
	}

	function onMouseMove(e)
	{
		var touches = e.touches;
		var nowRadian = Math.atan2(
			touches[0].stageY - touches[1].stageY,
			touches[0].stageX - touches[1].stageX);

		sp.rotation += 180 / Math.PI * (nowRadian - preRadian);

		preRadian = nowRadian;
	}

	function onMouseUp(e)
	{
		Laya.stage.off(Event.MOUSE_MOVE, this, onMouseMove);
	}
})();