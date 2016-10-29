(function()
{
	var Skeleton = Laya.Skeleton;
	var Templet  = Laya.Templet;
	var Event    = Laya.Event;
	var Browser  = Laya.Browser;
	var Stat     = Laya.Stat;
	var WebGL    = Laya.WebGL;


	var mAniPath;
	var mStartX = 400;
	var mStartY = 500;
	var mFactory;
	var mActionIndex = 0;
	var mCurrIndex = 0;
	var mArmature;
	var mCurrSkinIndex = 0;
	var mSkinList = ["goblin","goblingirl"];
	(function()
	{
		WebGL.enable();
		Laya.init(Browser.width, Browser.height);
		Laya.stage.bgColor = "#ffffff";
		Stat.show();
		startFun();
	})();
    function startFun()
	{
		mAniPath = "../../res/spine/spineRes2/goblins.sk";
		mFactory = new Templet();
		mFactory.on(Event.COMPLETE, this, parseComplete);
		mFactory.on(Event.ERROR, this, onError);
		mFactory.loadAni(mAniPath);
	}
	
	function onError()
	{
		trace("error");
	}
	
	function parseComplete() {
		//创建模式为1，可以启用换装
		mArmature = mFactory.buildArmature(1);
		mArmature.x = mStartX;
		mArmature.y = mStartY;
		Laya.stage.addChild(mArmature);
		mArmature.on(Event.STOPPED, this, completeHandler);
		play();
		changeSkin();
		Laya.timer.loop(1000, this, changeSkin);
	}
	
	function changeSkin()
	{
		mCurrSkinIndex++;
		if (mCurrSkinIndex >= mSkinList.length)
		{
			mCurrSkinIndex = 0;
		}
		mArmature.showSkinByName(mSkinList[mCurrSkinIndex]);
	}
	
	function completeHandler()
	{
		play();
	}
	
	function play()
	{
		mCurrIndex++;
		if (mCurrIndex >= mArmature.getAnimNum())
		{
			mCurrIndex = 0;
		}
		mArmature.play(mCurrIndex,false);
		
	}
})();