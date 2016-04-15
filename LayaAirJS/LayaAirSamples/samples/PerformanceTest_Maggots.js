var texturePath = "res/tinyMaggot.png";

var padding = 100;
var maggotAmount = 5000;

var tick = 0;
var maggots = [];
var wrapBounds;
var maggotTexture;

Laya.init(laya.utils.Browser.width, laya.utils.Browser.height, laya.webgl.WebGL);
laya.utils.Stat.show();

wrapBounds = new laya.maths.Rectangle(-padding, -padding, Laya.stage.width + padding * 2, Laya.stage.height + padding * 2);

Laya.loader.load(texturePath, laya.utils.Handler.create(this, onTextureLoaded));

function onTextureLoaded()
{
	maggotTexture = Laya.loader.getRes(texturePath);
	initMaggots();
	Laya.timer.frameLoop(1, this, animate);
}

function initMaggots()
{
	var maggotContainer;
	for (var i = 0; i < maggotAmount; i++)
	{
		if (i % 16000 == 0)
			maggotContainer = createNewContainer();

		var maggot = newMaggot();
		maggotContainer.addChild(maggot);
		maggots.push(maggot);
	}
}

function createNewContainer()
{
	var container = new laya.display.Sprite();
	container.size(1000, 800);
	// 此处cacheAsBitmap主要是为了创建新画布
	// 解除IBQuadrangle数量限制
	// 在显示虫子数量超过16383时需要打开下面一行
	// container.cacheAsBitmap = true;
	Laya.stage.addChild(container);
	return container;
}

function newMaggot()
{
	var maggot = new laya.display.Sprite();
	maggot.graphics.drawTexture(maggotTexture, 0, 0);

	maggot.pivot(16.5, 35);

	var rndScale = 0.8 + Math.random() * 0.3;
	maggot.scale(rndScale, rndScale);
	maggot.rotation = 0.1;
	maggot.x = Math.random() * Laya.stage.width;
	maggot.y = Math.random() * Laya.stage.height;

	maggot.direction = Math.random() * Math.PI;
	maggot.turningSpeed = Math.random() - 0.8;
	maggot.speed = (2 + Math.random() * 2) * 0.2;
	maggot.offset = Math.random() * 100;

	return maggot;
}

function animate()
{
	var maggot;
	var wb = this.wrapBounds;
	var angleUnit = 180 / Math.PI;
	var dir, x = 0.0, y = 0.0;
	for (var i = 0; i < maggotAmount; i++)
	{
		maggot = maggots[i];

		maggot.scaleY = 0.90 + Math.sin(tick + maggot.offset) * 0.1;

		maggot.direction += maggot.turningSpeed * 0.01;
		dir = maggot.direction;
		x = maggot.x;
		y = maggot.y;

		x += Math.sin(dir) * (maggot.speed * maggot.scaleY);
		y += Math.cos(dir) * (maggot.speed * maggot.scaleY);

		maggot.rotation = (-dir + Math.PI) * angleUnit;

		if (x < wb.x)
			x += wb.width;
		else if (x > wb.x + wb.width)
			x -= wb.width;
		if (y < wb.y)
			y += wb.height;
		else if (y > wb.y + wb.height)
			y -= wb.height;

		maggot.pos(x, y);
	}

	tick += 0.1;
}