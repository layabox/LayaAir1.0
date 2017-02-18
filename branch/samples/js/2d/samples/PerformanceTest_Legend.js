(function()
{
	var Animation = Laya.Animation;
	var Sprite    = Laya.Sprite;
	var Event     = Laya.Event;
	var Browser   = Laya.Browser;
	var Stat      = Laya.Stat;
	var WebGL     = Laya.WebGL;

	var players = [];
	var width = Browser.width;
	var height = Browser.height;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.width, Browser.height, WebGL);
		Stat.show()
		
		initHandler();
	})();

	function initHandler()
	{
		// 资源加载
		for (var i = 1; i <= 6; i++)
		{
			Laya.loader.load("../../res/legend/bitmap2/" + i + ".png");
		}
		for (var j = 1; j <= 6; j++)
		{
			Laya.loader.load("../../res/legend/bitmap3/" + j + ".png");
		}
		for (var k = 1; k <= 6; k++)
		{
			Laya.loader.load("../../res/legend/bitmap4/" + k + ".png");
		}

		Laya.loader.once(Event.COMPLETE, this, loadPlayerRes);

		// 显示背景
		var background = new Sprite();
		background.loadImage("../../res/legend/map.jpg", 0, 0);
		background.scale(width / 600, height / 600);
		Laya.stage.addChild(background);
	}

	function loadPlayerRes()
	{
		createPlayers();
		Laya.timer.frameLoop(1, this, animateHandler);
	}

	function animateHandler()
	{
		var ani;
		var numChildren = players.length;
		for (var i = 0; i < numChildren; i++)
		{
			ani = players[i];
			ani.x += i / numChildren * 3 + 2;
			if (ani.x > width)
			{
				ani.x = -100;
			}
		}
	}

	function createPlayers()
	{
		var playerList = [];
		var player1 = [];
		for (var i = 1; i <= 6; i++)
		{
			player1.push("../../res/legend/bitmap2" + "/" + i + ".png");
		}
		playerList.push(player1);
		var player2 = [];
		for (var i = 1; i <= 6; i++)
		{
			player2.push("../../res/legend/bitmap3" + "/" + i + ".png");
		}
		playerList.push(player2);
		var player3 = [];
		for (var i = 1; i <= 6; i++)
		{
			player3.push("../../res/legend/bitmap4" + "/" + i + ".png");
		}
		playerList.push(player3);
		for (var j = 0; j < 500; j++)
		{
			var ani = new Animation();
			//加载图片地址集合，组成动画
			ani.loadImages(playerList[parseInt((Math.random() * 3).toString())]);
			//设置位置
			ani.pos(Math.random() * width, Math.random() * height);
			ani.zOrder = ani.y;
			//设置播放间隔（单位：毫秒）
			ani.interval = 100;
			//当前播放索引
			ani.index = 1;
			//播放图集动画
			ani.play();
			Laya.stage.addChild(ani);
			players.push(ani);
		}
	}
})();