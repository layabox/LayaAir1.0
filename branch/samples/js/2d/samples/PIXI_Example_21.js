(function()
{
	var Graphics = Laya.Graphics;
	var Sprite = Laya.Sprite;
	var Browser = Laya.Browser;
	var WebGL = Laya.WebGL;

	var colors = ["#5D0776", "#EC8A49", "#AF3666", "#F6C84C", "#4C779A"];
	var colorCount = 0;
	var isDown = false;
	var path = [];
	var color = colors[0];
	var liveGraphics;
	var canvasGraphics;

	(function()
	{
		Laya.init(Browser.width, Browser.height, WebGL);
		Laya.stage.bgColor = "#3da8bb";

		createCanvases();

		Laya.timer.frameLoop(1, this, animate);

		Laya.stage.on('mousedown', this, onMouseDown);
		Laya.stage.on('mousemove', this, onMouseMove);
		Laya.stage.on('mouseup', this, onMouseUp);
	})();

	function createCanvases()
	{
		var graphicsCanvas = new Sprite();
		Laya.stage.addChild(graphicsCanvas);
		var liveGraphicsCanvas = new Sprite();
		Laya.stage.addChild(liveGraphicsCanvas);

		liveGraphics = liveGraphicsCanvas.graphics;
		canvasGraphics = graphicsCanvas.graphics;
	}

	function onMouseDown()
	{
		isDown = true;
		color = colors[colorCount++ % colors.length];
		path.length = 0;
	}

	function onMouseMove()
	{
		if (!isDown) return;

		path.push(Laya.stage.mouseX);
		path.push(Laya.stage.mouseY);
	}

	function onMouseUp()
	{
		isDown = false;
		canvasGraphics.drawPoly(0, 0, path.concat(), color);
	}

	function animate()
	{
		liveGraphics.clear();
		liveGraphics.drawPoly(0, 0, path, color);
	}
})();