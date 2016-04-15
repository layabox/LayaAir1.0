package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;

	public class Sprite_RoateAndScale 
	{
		private var ape:Sprite;
		private var scaleDelta:Number = 0;
		
		public function Sprite_RoateAndScale() 
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			ape = new Sprite();
			
			ape.loadImage("res/apes/monkey2.png");
			Laya.stage.addChild(ape);
			ape.pivot(55, 72);
			ape.x = 275;
			ape.y = 200;
			
			Laya.timer.frameLoop(1, this, animate);
		}
		
		private function animate(e:Event):void
		{
			ape.rotation += 2;
			
			//心跳缩放
			scaleDelta += 0.02;
			var scaleValue:Number = Math.sin(scaleDelta);
			ape.scale(scaleValue, scaleValue);
		}
	}
}