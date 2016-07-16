(function()
{
	var Sprite = laya.display.Sprite;
	var Stage = laya.display.Stage;
	var Event = laya.events.Event;
	var Rectangle = laya.maths.Rectangle;
	var Texture = laya.resource.Texture;
	var Browser = laya.utils.Browser;
	var Handler = laya.utils.Handler;
	var WebGL = laya.webgl.WebGL;

	var ApePath = "../../res/apes/monkey2.png";

	var ape, dragRegion;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		Laya.loader.load(ApePath, Handler.create(this, setup));
	})();

	function setup()
	{
		createApe();
		showDragRegion();
	}

	function createApe()
	{
		ape = new Sprite();

		ape.loadImage(ApePath);
		Laya.stage.addChild(ape);

		var texture = Laya.loader.getRes(ApePath);
		ape.pivot(texture.width / 2, texture.height / 2);
		ape.x = Laya.stage.width / 2;
		ape.y = Laya.stage.height / 2;

		ape.on(Event.MOUSE_DOWN, this, onStartDrag);
	}

	function showDragRegion()
	{
		//拖动限制区域
		var dragWidthLimit = 350;
		var dragHeightLimit = 200;
		dragRegion = new Rectangle(Laya.stage.width - dragWidthLimit >> 1, Laya.stage.height - dragHeightLimit >> 1, dragWidthLimit, dragHeightLimit);

		//画出拖动限制区域
		Laya.stage.graphics.drawRect(
			dragRegion.x, dragRegion.y, dragRegion.width, dragRegion.height,
			null, "#FFFFFF", 2);
	}

	function onStartDrag(e)
	{
		//鼠标按下开始拖拽(设置了拖动区域和超界弹回的滑动效果)
		ape.startDrag(dragRegion, true, 100);
	}
})();