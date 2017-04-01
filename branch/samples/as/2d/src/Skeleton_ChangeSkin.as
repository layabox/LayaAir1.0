package {
	import laya.ani.bone.Skeleton;
	import laya.ani.bone.Templet;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	public class Skeleton_ChangeSkin {
		
		private var mAniPath:String;
		private var mStartX:Number = 400;
		private var mStartY:Number = 500;
		private var mFactory:Templet;
		private var mActionIndex:int = 0;
		private var mCurrIndex:int = 0;
		private var mArmature:Skeleton;
		private var mCurrSkinIndex:int = 0;
		private var mSkinList:Array = ["goblin","goblingirl"];
		
		public function Skeleton_ChangeSkin() {
			WebGL.enable();
			Laya.init(Browser.width, Browser.height);
			Laya.stage.bgColor = "#ffffff";
			Stat.show();
			startFun();
		}
		
		public function startFun():void
		{
			mAniPath = "../../../../res/spine/spineRes2/goblins.sk";
			mFactory = new Templet();
			mFactory.on(Event.COMPLETE, this, parseComplete);
			mFactory.on(Event.ERROR, this, onError);
			mFactory.loadAni(mAniPath);
		}
		
		private function onError(e:*):void
		{
			trace("error");
		}
		
		private function parseComplete(fac:*):void {
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
		
		private function changeSkin():void
		{
			mCurrSkinIndex++;
			if (mCurrSkinIndex >= mSkinList.length)
			{
				mCurrSkinIndex = 0;
			}
			mArmature.showSkinByName(mSkinList[mCurrSkinIndex]);
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
	
	}

}