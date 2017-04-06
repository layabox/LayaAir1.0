(function()
{
	var Sprite = Laya.Sprite;

	var rect;

	(function()
	{
		Laya.init(800, 600);
		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		var size = 200;
		var color = "orange";
		rect = new Sprite();
		rect.graphics.drawRect(0, 0, size, size, color);
		rect.size(size, size);
		rect.x = (Laya.stage.width - rect.width) / 2;
		rect.y = (Laya.stage.height - rect.height) / 2;
		Laya.stage.addChild(rect);

		Laya.timer.frameLoop(1, this, loop);
	})();

	function loop()
	{
		var hit = rect.hitTestPoint(Laya.stage.mouseX, Laya.stage.mouseY);
		rect.alpha = hit ? 0.5 : 1;
	}
})();