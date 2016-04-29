(function()
{
	Laya.init(550, 400);
	Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

	// 方法1：使用loadImage
	var ape = new Laya.Sprite();
	Laya.stage.addChild(ape);
	ape.loadImage("res/apes/monkey3.png");

	// 方法2：使用drawTexture
	Laya.loader.load("res/apes/monkey2.png", Laya.Handler.create(this, function()
	{
		var t = Laya.loader.getRes("res/apes/monkey2.png");
		var ape = new Laya.Sprite();
		ape.graphics.drawTexture(t, 0, 0);
		Laya.stage.addChild(ape);
		ape.pos(200, 0);
	}));
})();