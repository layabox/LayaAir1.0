package {
	import laya.ani.bone.EventData;
	import laya.ani.bone.Skeleton;
	import laya.ani.bone.Templet;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.utils.Tween;
	import laya.webgl.WebGL;
	
	public class Skeleton_SpineEvent {
		
		private var mAniPath:String;
		private var mStartX:Number = 400;
		private var mStartY:Number = 500;
		private var mFactory:Templet;
		private var mActionIndex:int = 0;
		private var mCurrIndex:int = 0;
		private var mArmature:Skeleton;
		private var mCurrSkinIndex:int = 0;
		
		private var mFactory2:Templet;
		private var mLabelSprite:Sprite;
		
		public function Skeleton_SpineEvent() {
			WebGL.enable();
			Laya.init(Browser.width, Browser.height);
			Laya.stage.bgColor = "#ffffff";
			Stat.show();
			mLabelSprite = new Sprite();
			startFun();
		}
		
		public function startFun():void
		{
			mAniPath = "../../../../res/spine/spineRes6/alien.sk";
			mFactory = new Templet();
			mFactory.on(Event.COMPLETE, this, parseComplete);
			mFactory.on(Event.ERROR, this, onError);
			mFactory.loadAni(mAniPath);
		}
		
		private function onError():void
		{
			trace("error");
		}
		
		private function parseComplete(fac:Templet):void {
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
		
		private function completeHandler():void
		{
			play();
		}
		
		private function play():void
		{
			mCurrIndex++;
			if (mCurrIndex >= mArmature.getAnimNum())
			{
				mCurrIndex = 0;
			}
			mArmature.play(mCurrIndex,false);
			
		}
		
		private function onEvent(e:*):void
		{
			var tEventData:EventData = e as EventData;
			
			Laya.stage.addChild(mLabelSprite);
			mLabelSprite.x = mStartX;
			mLabelSprite.y = mStartY;
			mLabelSprite.graphics.clear();
			mLabelSprite.graphics.fillText(tEventData.name, 0, 0, "20px Arial", "#ff0000", "center");
			Tween.to(mLabelSprite, { y:mStartY - 200 }, 1000, null,Handler.create(this,playEnd))
		}
		
		private function playEnd():void
		{
			mLabelSprite.removeSelf();
		}
	
	}

}