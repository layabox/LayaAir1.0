(function()
{
	var Sprite = Laya.Sprite;
	var Event = Laya.Event;
	var Rectangle = Laya.Rectangle;


	var rect1;
	var rect2;

	(function()
	{
		Laya.init(800, 600);
		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		rect1 = createRect(100, "orange");
		rect2 = createRect(200, "purple");

		Laya.timer.frameLoop(1, this, loop);
	})();


	function createRect(size, color)
	{
		var rect = new Sprite();
		rect.graphics.drawRect(0, 0, size, size, color);
		rect.size(size, size);
		Laya.stage.addChild(rect);

		rect.on(Event.MOUSE_DOWN, this, startDrag, [rect]);
		rect.on(Event.MOUSE_UP, this, stopDrag, [rect]);

		return rect;
	}


	function startDrag(target)
	{
		target.startDrag();
	}


	function stopDrag(target)
	{
		target.stopDrag();
	}


	function loop()
	{
		var bounds1 = rect1.getBounds();
		var bounds2 = rect2.getBounds();
		var hit = bounds1.intersects(bounds2);
		rect1.alpha = rect2.alpha = hit ? 0.5 : 1;
	}
})();