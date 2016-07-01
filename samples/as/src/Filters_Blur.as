package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.filters.BlurFilter;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class Filters_Blur 
	{
		private const apePath:String = "res/apes/monkey2.png";
		
		public function Filters_Blur() 
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			Laya.loader.load(apePath, Handler.create(this, createApe));
		}

		private function createApe(_e:*=null):void
		{
			var ape:Sprite = new Sprite();
			ape.loadImage(apePath);

			ape.x = (Laya.stage.width - ape.width) / 2;
			ape.y = (Laya.stage.height - ape.height) / 2;

			Laya.stage.addChild(ape);

			applayFilter(ape);
		}

		private function applayFilter(ape:Sprite):void
		{
			var blurFilter:BlurFilter = new BlurFilter();
			blurFilter.strength = 5;
			ape.filters = [blurFilter];
		}
	}
}