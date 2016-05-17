package 
{
	import laya.display.Sprite;
	import laya.filters.BlurFilter;
	import laya.webgl.WebGL;
	
	public class Filters_Blur 
	{
		
		public function Filters_Blur() 
		{
			Laya.init(550, 400, WebGL);
			
			var ape:Sprite = new Sprite();
			ape.loadImage("res/apes/monkey2.png");
			ape.pos(200, 100);
			Laya.stage.addChild(ape);
			
			var blurFilter:BlurFilter = new BlurFilter();
			blurFilter.strength = 5;
			ape.filters = [blurFilter];
		}
		
	}

}