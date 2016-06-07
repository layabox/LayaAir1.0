package 
{
	import laya.display.Sprite;
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

		private var characterGroup:Array;
		
		public function PerformanceTest_Cartoon() 
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.width, Browser.height, WebGL);
			Laya.stage.bgColor = "#232628";
			
			Stat.show();
			
			Laya.loader.load("res/cartoonCharacters/cartoonCharactors.json", Handler.create(this, createCharacters), null, Loader.ATLAS);
		}
		
		private function createCharacters():void
		{
			characterGroup = [];

			for(var i:int = 0; i < colAmount; ++i)
			{
				var tx:int = (Laya.stage.width + extraSpace * 2) / colAmount * i - extraSpace;
				var tr:int = 360 / colAmount * i;
				var startY:int = (Laya.stage.height - 500) / 2;

				createCharacter("cartoonCharactors/1.png", 46, 50, tr).pos(tx, 50  + startY);
				createCharacter("cartoonCharactors/2.png", 34, 50, tr).pos(tx, 150 + startY);
				createCharacter("cartoonCharactors/3.png", 42, 50, tr).pos(tx, 250 + startY);
				createCharacter("cartoonCharactors/4.png", 48, 50, tr).pos(tx, 350 + startY);
				createCharacter("cartoonCharactors/5.png", 36, 50, tr).pos(tx, 450 + startY);
			}

			Laya.timer.frameLoop(1, this, animate);
		}
		
		private function createCharacter(skin:String, pivotX:int, pivotY:int, rotation:int):Sprite
		{
			var charactor:Sprite = new Sprite();
			charactor.loadImage(skin);
			charactor.rotation = rotation;
			charactor.pivot(pivotX, pivotY);
			Laya.stage.addChild(charactor);
			characterGroup.push(charactor);

			return charactor;
		}

		private function animate():void
		{
			for(var i:int = characterGroup.length - 1; i >= 0; --i)
			{
				animateCharactor(characterGroup[i]);
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