(function()
{
	var Stage     = Laya.Stage;
	var Event     = Laya.Event;
	var TiledMap  = Laya.TiledMap;
	var Rectangle = Laya.Rectangle;
	var Browser   = Laya.Browser;
	var Handler   = Laya.Handler;
	var Stat      = Laya.Stat;
	var WebGL     = Laya.WebGL;

	var tiledMap;
	var mLastMouseX = 0;
	var mLastMouseY = 0;

	var mX = 0;
	var mY = 0;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
		Laya.stage.scaleMode = Stage.SCALE_FULL;
		Stat.show();

		createMap();

		Laya.stage.on(Event.MOUSE_DOWN, this, mouseDown);
		Laya.stage.on(Event.MOUSE_UP, this, mouseUp);
	})();

	//创建地图
	function createMap()
	{
		//创建地图对象
		tiledMap = new TiledMap();

		mX = mY = 0;
		//创建地图，适当的时候调用destory销毁地图
		tiledMap.createMap("../../res/tiledMap/desert.json", new Rectangle(0, 0, Browser.width, Browser.height), new Handler(this, completeHandler));
	}

	/**
	 * 地图加载完成的回调
	 */
	function completeHandler()
	{
		Laya.stage.on(Event.RESIZE, this, resize);
		resize();
	}

	//鼠标按下拖动地图
	function mouseDown()
	{
		mLastMouseX = Laya.stage.mouseX;
		mLastMouseY = Laya.stage.mouseY;
		Laya.stage.on(Event.MOUSE_MOVE, this, mouseMove);
	}

	function mouseMove()
	{
		//移动地图视口
		tiledMap.moveViewPort(mX - (Laya.stage.mouseX - mLastMouseX), mY - (Laya.stage.mouseY - mLastMouseY));
	}

	function mouseUp()
	{
		mX = mX - (Laya.stage.mouseX - mLastMouseX);
		mY = mY - (Laya.stage.mouseY - mLastMouseY);
		Laya.stage.off(Event.MOUSE_MOVE, this, mouseMove);
	}

	// 窗口大小改变，把地图的视口区域重设下
	function resize()
	{
		//改变地图视口大小
		tiledMap.changeViewPort(mX, mY, Browser.width, Browser.height);
	}
})();