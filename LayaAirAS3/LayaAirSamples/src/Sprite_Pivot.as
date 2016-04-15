package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import text.TextComplexStyle;
	
	public class Sprite_Pivot
	{
		private var sp1:Sprite;
		private var sp2:Sprite;
		
		public function Sprite_Pivot() 
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			sp1 = new Sprite();
			sp1.loadImage("res/apes/monkey2.png", 0, 0);
			
			sp1.pos(150, 200);
			//设置轴心点为中心
			sp1.pivot(55, 72);
			Laya.stage.addChild(sp1);
			
			Laya.timer.once(1000, this, function():void
			{
				trace(sp1.width);
			});
			
			//不设置轴心点默认为左上角
			sp2 = new Sprite();
			sp2.loadImage("res/apes/monkey2.png", 0, 0);
			sp2.size(110, 145);
			sp2.pos(400, 200);
			Laya.stage.addChild(sp2);
			
			Laya.timer.frameLoop(1, this, animate);
		}
		
		private function animate(e:Event):void 
		{
			sp1.rotation += 2;
			sp2.rotation += 2;
		}
	}
	
}