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
			WebGL.enable();
			Laya.init(550, 400);
			
			Laya.loader.load("res/apes/monkey2.png", Handler.create(this, onAssetLoaded));
		}
		
		private function onAssetLoaded():void
		{
			var img:* = Laya.loader.getRes("res/apes/monkey2.png");
			
			//创建一个发光滤镜
			var glowFilter:GlowFilter = new GlowFilter("#ffff00", 20, 5, 5);
			
			var ape:Sprite = new Sprite();
			ape.size(100, 100);
			ape.pos(220, 120);
			//绘制一张图片
			ape.graphics.drawTexture(img,0,0);
			
			//设置滤镜集合为发光滤镜
			Laya.stage.filters = [glowFilter];
			
			Laya.stage.addChild(ape);
		}
	}
}