 package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.net.Loader;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	public class PerformanceTest_Cartoon 
	{
		private var colAmount:int = 100;
		private var extraSpace:int = 50;
		private var moveSpeed:int = 2;
		private var rotateSpeed:int = 2;

		private var charactorGroup:Array;
		
		public function PerformanceTest_Cartoon() 
		{
			Laya.init(Browser.width, Browser.height, WebGL);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			Stat.show();
			
			Laya.loader.load("res/cartoonCharacters/cartoonCharactors.json", Handler.create(this, initCharactors), null, Loader.ATLAS);
		}
		
		private function initCharactors():void 
		{
			charactorGroup = [];

			for(var i:int = 0; i < colAmount; ++i)
			{
				var tx:int = (Laya.stage.width + extraSpace * 2) / colAmount * i - extraSpace;
				var tr:int = 360 / colAmount * i;

				createCharactor("cartoonCharactors/1.png", 46, 50, tr).pos(tx, 50);
				createCharactor("cartoonCharactors/2.png", 34, 50, tr).pos(tx, 150);
				createCharactor("cartoonCharactors/3.png", 42, 50, tr).pos(tx, 250);
				createCharactor("cartoonCharactors/4.png", 48, 50, tr).pos(tx, 350);
				createCharactor("cartoonCharactors/5.png", 36, 50, tr).pos(tx, 450);
			}

			Laya.timer.frameLoop(1, this, animate);
		}
		
		private function createCharactor(skin:String, pivotX:int, pivotY:int, rotation:int):Sprite
		{
			var charactor:Sprite = new Sprite();
			charactor.loadImage(skin);
			charactor.rotation = rotation;
			charactor.pivot(pivotX, pivotY);
			Laya.stage.addChild(charactor);
			charactorGroup.push(charactor);

			return charactor;
		}

		private function animate():void
		{
			for(var i:int = charactorGroup.length - 1; i >= 0; --i)
			{
				animateCharactor(charactorGroup[i]);
			}
		}

		private function animateCharactor(charactor:Sprite):void
		{
			charactor.x += moveSpeed;
			charactor.rotation += rotateSpeed;

			if(charactor.x > Laya.stage.width + extraSpace)
			{
				charactor.x = -extraSpace;
			}
		}
	}

}