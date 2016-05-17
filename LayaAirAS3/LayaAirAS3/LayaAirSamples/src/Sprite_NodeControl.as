package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.webgl.WebGL;

	public class Sprite_NodeControl 
	{
		private var ape1:Sprite;
		private var ape2:Sprite;
		
		public function Sprite_NodeControl() 
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			//显示两只猩猩
			ape1 = new Sprite();
			ape2 = new Sprite();
			ape1.loadImage("res/apes/monkey2.png");
			ape2.loadImage("res/apes/monkey2.png");
			
			ape1.pivot(55, 72);
			ape2.pivot(55, 72);
			
			ape1.pos(275, 200);
			ape2.pos(200, 0);
			
			//一只猩猩在舞台上，另一只被添加成第一只猩猩的子级
			Laya.stage.addChild(ape1);
			ape1.addChild(ape2);
			
			Laya.timer.frameLoop(1, this, animate);
		}
		
		private function animate(e:Event):void 
		{
			ape1.rotation += 2;
			ape2.rotation -= 4;
		}
		
	}
	
}