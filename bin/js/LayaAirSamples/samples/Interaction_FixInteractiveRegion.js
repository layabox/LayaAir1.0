(function()
{
	var Sprite  = laya.display.Sprite;
	var Stage   = laya.display.Stage;
	var Text    = laya.display.Text;
	var Event   = laya.events.Event;
	var Browser = laya.utils.Browser;
	var WebGL   = laya.webgl.WebGL;

	var logger;

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
		buildWorld();
		createLogger();
	}

	function buildWorld()
	{
		createCoralRect();
		createDeepSkyblueRect();
		createDarkOrchidRect();

		// 设置舞台
		Laya.stage.name = "暗灰色舞台"
		Laya.stage.on(Event.MOUSE_DOWN, this, onDown);
	}

	function createCoralRect()
	{
		var coralRect = new Sprite();
		coralRect.graphics.drawRect(0, 0, Laya.stage.width, Laya.stage.height / 2, "#FF7F50");

		//设置名称
		coralRect.name = "珊瑚色容器";
		coralRect.size(Laya.stage.width, Laya.stage.height / 2);
		Laya.stage.addChild(coralRect);

		coralRect.on(Event.MOUSE_DOWN, this, onDown);
	}

	function createDeepSkyblueRect()
	{
		var deepSkyblueRect = new Sprite();
		deepSkyblueRect.graphics.drawRect(0, 0, 100, 100, "#00BFFF");
		//设置名称
		deepSkyblueRect.name = "天蓝色矩形";
		//设置宽高（要接收鼠标事件必须设置宽高，否则不会被命中）  
		deepSkyblueRect.size(100, 100);
		deepSkyblueRect.pos(10, 10);
		Laya.stage.addChild(deepSkyblueRect);

		deepSkyblueRect.on(Event.MOUSE_DOWN, this, onDown);
	}

	function createDarkOrchidRect()
	{
		var darkOrchidRect = new Sprite();
		darkOrchidRect.name = "暗紫色矩形容器";
		darkOrchidRect.graphics.drawRect(-100, -100, 200, 200, "#9932CC");

		darkOrchidRect.pos(Laya.stage.width / 2, Laya.stage.height / 2);
		Laya.stage.addChild(darkOrchidRect);

		// 为true时，碰撞区域会被修正为实际显示边界
		// mouseThrough命名真是具有强烈的误导性
		darkOrchidRect.mouseThrough = true;
		darkOrchidRect.on(Event.MOUSE_DOWN, this, onDown);
	}

	function createLogger()
	{
		logger = new Text();
		logger.size(Laya.stage.width, Laya.stage.height);
		logger.align = 'right';
		logger.fontSize = 20;
		logger.color = "#FFFFFF";
		Laya.stage.addChild(logger);
	}

	/**侦听处理方法*/
	function onDown(e)
	{
		logger.text += "点击 - " + e.target.name + "\n";
	}
})();