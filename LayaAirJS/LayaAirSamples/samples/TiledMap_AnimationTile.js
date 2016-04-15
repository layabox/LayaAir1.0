	var TiledMap = laya.map.TiledMap;
	var Rectangle = laya.maths.Rectangle;

	Laya.init(1600, 800);

	createMap();

	function createMap()
	{
		var tiledMap = new TiledMap();
		tiledMap.createMap("res/tiledMap/orthogonal-test-movelayer.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), null);
	}