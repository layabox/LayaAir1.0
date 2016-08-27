(function()
{
	var Skeleton = laya.ani.bone.Skeleton;
	var Templet  = laya.ani.bone.Templet;
	var Event    = laya.events.Event;
	var Browser  = laya.utils.Browser;
	var Stat     = laya.utils.Stat;
	var WebGL    = laya.webgl.WebGL;

    var mAniPath;
	var mStartX = 400;
	var mStartY = 500;
	var mFactory;
	var mActionIndex = 0;
	var mCurrIndex = 0;
	var mArmature;
	var mCurrSkinIndex = 0;
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
		mAniPath = "../../res/spine/spineRes3/raptor.sk";
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
		mArmature.scale(0.5, 0.5);
		Laya.stage.addChild(mArmature);
		mArmature.on(Event.STOPPED, this, completeHandler);
		play();
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