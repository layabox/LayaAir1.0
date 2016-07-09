(function()
{
	var Skeleton = laya.ani.bone.Skeleton;
	var Templet = laya.ani.bone.Templet;
	var Event = laya.events.Event;
	var GlowFilter = laya.filters.GlowFilter;
	var Loader = laya.net.Loader;
	var Texture = laya.resource.Texture;
	var Browser = laya.utils.Browser;
	var Handler = laya.utils.Handler;
	var Stat = laya.utils.Stat;
	var WebGL = laya.webgl.WebGL;

	var mArmature;
	var fileName = "Dragon";
	var mTexturePath;
	var mAniPath;

	var rowCount = 10;
	var colCount = 10;
	var xOff = 50;
	var yOff = 100;

	var mSpacingX;
	var mSpacingY;
	var mAnimationArray = [];
	var mFactory;

	function init()
	{
		mSpacingX = Browser.width / colCount;
		mSpacingY = Browser.height / rowCount;

		Laya.init(Browser.width, Browser.height, WebGL);
		Stat.show();

		mTexturePath = "res/skeleton/" + fileName + "/texture.png";
		mAniPath = "res/skeleton/" + fileName + "/" + fileName + ".sk";
		Laya.loader.load([
		{
			url: mTexturePath,
			type: Loader.IMAGE
		},
		{
			url: mAniPath,
			type: Loader.BUFFER
		}], Handler.create(this, onAssetsLoaded));
	}
	init();

	function onAssetsLoaded()
	{
		var tTexture = Loader.getRes(mTexturePath);
		var arraybuffer = Loader.getRes(mAniPath);
		mFactory = new Templet();
		mFactory.on(Event.COMPLETE, this, parseComplete);
		mFactory.parseData(tTexture, arraybuffer, 10);
	}


	function parseComplete()
	{
		for (var i = 0; i < rowCount; i++)
		{
			for (var j = 0; j < colCount; j++)
			{
				mArmature = mFactory.buildArmature();
				mArmature.x = xOff + j * mSpacingX;
				mArmature.y = yOff + i * mSpacingY;
				mAnimationArray.push(mArmature);
				mArmature.play(0, true);
				Laya.stage.addChild(mArmature);
			}
		}
		Laya.stage.on(Event.CLICK, this, toggleAction);
	}


	var mActionIndex = 0;

	function toggleAction(e)
	{
		mActionIndex++;
		var tAnimNum = mArmature.getAnimNum();
		if (mActionIndex >= tAnimNum)
		{
			mActionIndex = 0;
		}
		for (var i = 0, n = mAnimationArray.length; i < n; i++)
		{
			mAnimationArray[i].play(mActionIndex, true);
		}
	}
})();