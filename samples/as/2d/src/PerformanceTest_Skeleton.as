package 
{
	import laya.ani.bone.Skeleton;
	import laya.ani.bone.Templet;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	public class PerformanceTest_Skeleton
	{
		private var mArmature:Skeleton;
		private var fileName:String = "Dragon";
		private var mTexturePath:String;
		private var mAniPath:String;
		
		private var rowCount:int = 10;
		private var colCount:int = 10;
		private var xOff:int = 50;
		private var yOff:int = 100;
		private var mSpacingX:int;
		private var mSpacingY:int;
		
		private var mAnimationArray:Array = [];
		
		private var mFactory:Templet;
		
		public function PerformanceTest_Skeleton()
		{
			mSpacingX = Browser.width / colCount;
			mSpacingY = Browser.height / rowCount;
			
			Laya.init(Browser.width, Browser.height, WebGL);
			Stat.show();
			
			mTexturePath = "../../../../res/skeleton/" + fileName + "/" + fileName + ".png";
			mAniPath = "../../../../res/skeleton/" + fileName + "/" + fileName + ".sk";
			Laya.loader.load([{url:mTexturePath, type: Loader.IMAGE}, {url:mAniPath, type: Loader.BUFFER}], Handler.create(this, onAssetsLoaded));
		}
		
		public function onAssetsLoaded(e:*=null):void
		{
			var tTexture:Texture = Loader.getRes(mTexturePath);
			var arraybuffer:ArrayBuffer = Loader.getRes(mAniPath);      
			mFactory = new Templet();
			mFactory.on(Event.COMPLETE, this, parseComplete);
			mFactory.parseData(tTexture, arraybuffer,10);
		}
		
		private function parseComplete(e:*=null):void
		{
			for (var i:int = 0; i < rowCount; i++)
			{
				for (var j:int = 0; j < colCount; j++)
				{
					mArmature = mFactory.buildArmature(1);
					mArmature.x = xOff + j * mSpacingX;
					mArmature.y = yOff + i * mSpacingY;
					mAnimationArray.push(mArmature);
					mArmature.play(0, true);
					Laya.stage.addChild(mArmature);
				}
			}
			Laya.stage.on(Event.CLICK, this, toggleAction);
		}
		
		private var mActionIndex:int = 0;
		
		public function toggleAction(e:*=null):void
		{
			mActionIndex++;
			var tAnimNum:int = mArmature.getAnimNum();
			if (mActionIndex >= tAnimNum)
			{
				mActionIndex = 0;
			}
			for (var i:int = 0, n:int = mAnimationArray.length; i < n; i++)
			{
				mAnimationArray[i].play(mActionIndex, true);
			}
		}
	}
}