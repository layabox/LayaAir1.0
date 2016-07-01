(function()
{
	var Sprite  = laya.display.Sprite;
	var Stage   = laya.display.Stage;
	var Event   = laya.events.Event;
	var Browser = laya.utils.Browser;
	var WebGL   = laya.webgl.WebGL;

	//上次记录的两个触模点之间距离
	var lastDistance = 0;
	var sp;

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
		var w = 300,
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

		if (touches && touches.length == 2)
		{
			lastDistance = getDistance(touches);

			Laya.stage.on(Event.MOUSE_MOVE, this, onMouseMove);
		}
	}

	function onMouseMove(e)
	{
		var distance = getDistance(e.touches);

		//判断当前距离与上次距离变化，确定是放大还是缩小
		const factor = 0.01;
		sp.scaleX += (distance - lastDistance) * factor;
		sp.scaleY += (distance - lastDistance) * factor;

		lastDistance = distance;
	}

	function onMouseUp(e)
	{
		Laya.stage.off(Event.MOUSE_MOVE, this, onMouseMove);
	}

	/**计算两个触摸点之间的距离*/
	function getDistance(points)
	{
		var distance = 0;
		if (points && points.length == 2)
		{
			var dx = points[0].stageX - points[1].stageX;
			var dy = points[0].stageY - points[1].stageY;

			distance = Math.sqrt(dx * dx + dy * dy);
		}
		return distance;
	}
})();