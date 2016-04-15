var colAmount = 100;		
var extraSpace = 50;
var moveSpeed = 2;
var rotateSpeed = 2;
var charactorGroup;
		
Laya.init(laya.utils.Browser.width, laya.utils.Browser.height, laya.webgl.WebGL);
laya.utils.Stat.show();

Laya.loader.load("res/cartoonCharacters/cartoonCharactors.json", laya.utils.Handler.create(this, initCharactors), null, laya.net.Loader.ATLAS);

function initCharactors()
{
	charactorGroup = [];

	for(var i = 0; i < colAmount; ++i)
	{
		var tx = (Laya.stage.width + extraSpace * 2) / colAmount * i - extraSpace;
		var tr = 360 / colAmount * i;
		
		createCharactor("cartoonCharactors/1.png", 46, 50, tr).pos(tx, 50);
		createCharactor("cartoonCharactors/2.png", 34, 50, tr).pos(tx, 150);
		createCharactor("cartoonCharactors/3.png", 42, 50, tr).pos(tx, 250);
		createCharactor("cartoonCharactors/4.png", 48, 50, tr).pos(tx, 350);
		createCharactor("cartoonCharactors/5.png", 36, 50, tr).pos(tx, 450);
	}

	Laya.timer.frameLoop(1, this, animate);
}

function createCharactor(skin, pivotX, pivotY, rotation)
{
	var charactor = new laya.display.Sprite();
	charactor.loadImage(skin);
	charactor.rotation = rotation;
	charactor.pivot(pivotX, pivotY);
	Laya.stage.addChild(charactor);
	charactorGroup.push(charactor);

	return charactor;
}

function animate()
{
	for(var i = charactorGroup.length - 1; i >= 0; --i)
	{
		animateCharactor(charactorGroup[i]);
	}
}

function animateCharactor(charactor)
{
	charactor.x += moveSpeed;
	charactor.rotation += rotateSpeed;

	if(charactor.x > Laya.stage.width + extraSpace)
	{
		charactor.x = -extraSpace;
	}
}