package 
{
	import laya.display.Sprite;
	import laya.filters.BlurFilter;
	import laya.filters.ColorFilter;
	import laya.filters.GlowFilter;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class Filters_Glow 
	{
		public function Filters_Glow() 
		{
			Laya.init(550, 400, WebGL);
			
			var ape:Sprite = new Sprite();
			ape.loadImage("res/apes/monkey2.png");
			ape.pos(200, 100);
			Laya.stage.addChild(ape);
			
			//创建一个发光滤镜
			var glowFilter:GlowFilter = new GlowFilter("#ffff00", 10, 0, 0);
			//设置滤镜集合为发光滤镜
			ape.filters = [glowFilter];
		}
	}
}