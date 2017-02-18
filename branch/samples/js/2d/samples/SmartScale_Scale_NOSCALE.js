(function()
{
	var Sprite = Laya.Sprite;
	var Stage  = Laya.Stage;

	var rect;

	(function()
	{
		Laya.init(550, 400);
		Laya.stage.scaleMode = Stage.SCALE_NOSCALE;
		Laya.stage.bgColor = "#232628";
		createCantralRect();
	})();

	function createCantralRect()
	{
		rect = new Sprite();
		rect.graphics.drawRect(-100, -100, 200, 200, "gray");
		Laya.stage.addChild(rect);

		updateRectPos();
	}

	function updateRectPos()
	{
		rect.x = Laya.stage.width / 2;
		rect.y = Laya.stage.height / 2;
	}
})();