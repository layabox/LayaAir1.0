(function()
{
	var EventData = Laya.EventData;
	var Skeleton  = Laya.Skeleton;
	var Templet   = Laya.Templet;
	var Sprite    = Laya.Sprite;
	var Event     = Laya.Event;
	var Browser   = Laya.Browser;
	var Handler   = Laya.Handler;
	var Stat      = Laya.Stat;
	var Tween     = Laya.Tween;
	var WebGL     = Laya.WebGL;

	var mAniPath;
	var mStartX = 400;
	var mStartY = 500;
	var mFactory;
	var mActionIndex = 0;
	var mCurrIndex = 0;
	var mArmature;
	var mCurrSkinIndex = 0;
	var mFactory2;
	var mLabelSprite;
	(function(){
		Laya.init(Browser.width, Browser.height,WebGL);
		Laya.stage.bgColor = "#ffffff";
		Stat.show();
		mLabelSprite = new Sprite();
		startFun();
	})();
	function startFun()
	{
		mAniPath = "../../res/spine/spineRes6/alien.sk";
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
		mArmature.on(Event.LABEL, this, onEvent);
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
	
	function onEvent(e)
	{
		var tEventData = e;
		
		Laya.stage.addChild(mLabelSprite);
		mLabelSprite.x = mStartX;
		mLabelSprite.y = mStartY;
		mLabelSprite.graphics.clear();
		mLabelSprite.graphics.fillText(tEventData.name, 0, 0, "20px Arial", "#ff0000", "center");
		Tween.to(mLabelSprite, { y:mStartY - 200 }, 1000, null,Handler.create(this,playEnd))
	}
	
	function playEnd()
	{
		mLabelSprite.removeSelf();
	}
})();