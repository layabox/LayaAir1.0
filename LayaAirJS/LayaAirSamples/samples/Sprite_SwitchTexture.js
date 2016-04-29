(function()
{
	var texture1 = "res/apes/monkey2.png";
	var texture2 = "res/apes/monkey3.png";
	var flag = false;

	var ape;

	Laya.init(550, 400);
	Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

	Laya.loader.load([texture1, texture2], Laya.Handler.create(this, onAssetsLoaded));

	function onAssetsLoaded()
	{
		ape = new Laya.Sprite();
		Laya.stage.addChild(ape);

		// 显示默认纹理
		switchTexture(texture1);

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