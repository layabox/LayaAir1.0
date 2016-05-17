package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	
	public class Sprite_SimpleMask
	{
		public function Sprite_SimpleMask()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			// 显示猩猩
			var ape:Sprite = new Sprite();
			ape.loadImage("res/apes/monkey2.png");
			ape.pos(100, 100);
			Laya.stage.addChild(ape);
			
			//创建一个名为maskSp的Sprite对象作为mask
			var maskSp:Sprite = new Sprite();
			//绘制mask区域
			maskSp.graphics.drawCircle(0, 0, 50, "#FF0000");
			maskSp.pos(60, 50);
			
			//设置猩猩的mask
			ape.mask = maskSp;
		}
		
	}
	
}	