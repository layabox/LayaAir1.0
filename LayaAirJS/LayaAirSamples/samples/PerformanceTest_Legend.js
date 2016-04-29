var players = [];
var width = laya.utils.Browser.width;
var height = laya.utils.Browser.height;

Laya.init(width, height, laya.webgl.WebGL);
laya.utils.Stat.show();
Laya.stage.bgColor = "#000000";
initHandler();

function initHandler()
{
	// 资源加载
	for (var i = 1; i <= 6; i++)
	{
		Laya.loader.load("res/legend/bitmap2/" + i + ".png");
	}
	for (var j = 1; j <= 6; j++)
	{
		Laya.loader.load("res/legend/bitmap3/" + j + ".png");
	}
	for (var k = 1; k <= 6; k++)
	{
		Laya.loader.load("res/legend/bitmap4/" + k + ".png");
	}

	// 显示背景
	Laya.loader.once(laya.events.Event.COMPLETE, this, loadPlayerRes);
	var background = new laya.display.Sprite();
	background.loadImage("res/legend/map.jpg", 0, 0);
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
	for (var i = 0; i < players.length; i++)
	{
		ani = players[i];
		ani.x += ani["speed"];
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
		player1.push("res/legend/bitmap2" + "/" + i + ".png");
	}
	playerList.push(player1);
	var player2 = [];
	for (var i = 1; i <= 6; i++)
	{
		player2.push("res/legend/bitmap3" + "/" + i + ".png");
	}
	playerList.push(player2);
	var player3 = [];
	for (var i = 1; i <= 6; i++)
	{
		player3.push("res/legend/bitmap4" + "/" + i + ".png");
	}
	playerList.push(player3);
	for (var j = 0; j < 500; j++)
	{
		var ani = new laya.display.Animation();
		//加载图片地址集合，组成动画
		ani.loadImages(playerList[parseInt((Math.random() * 3).toString())]);
		//设置位置
		ani.pos(Math.random() * width, Math.random() * height);
		ani.zOrder = ani.y;
		ani["speed"] = Math.random() + 0.2;
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