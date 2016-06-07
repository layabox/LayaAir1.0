(function()
{
	var Sprite  = Laya.Sprite;
	var Stage   = Laya.Stage;
	var Texture = Laya.Texture;
	var Browser = Laya.Browser;
	var Handler = Laya.Handler;
	var WebGL   = Laya.WebGL;

	var texture1 = "res/apes/monkey2.png";
	var texture2 = "res/apes/monkey3.png";
	var flag = false;

	var ape;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		Laya.loader.load([texture1, texture2], Handler.create(this, onAssetsLoaded));
	})();

	function onAssetsLoaded()
	{
		ape = new Sprite();
		Laya.stage.addChild(ape);
		ape.pivot(55, 72);
		ape.pos(Laya.stage.width / 2, Laya.stage.height / 2);

		// 显示默认纹理
		switchTexture();

		ape.on("click", this, switchTexture);
	}

	function switchTexture()
	{
		var textureUrl = (flag = !flag) ? texture1 : texture2;

		// 更换纹理
		ape.graphics.clear();
		var texture = Laya.loader.getRes(textureUrl);
		ape.graphics.drawTexture(texture, 0, 0);

		// 设置交互区域
		ape.size(texture.width, texture.height);
	}
})();