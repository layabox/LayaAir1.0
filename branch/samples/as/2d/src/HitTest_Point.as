package 
{
	import laya.display.Sprite;
	/**
	 * ...
	 * @author suvivor
	 */
	public class HitTest_Point 
	{
		private var rect:Sprite;
		
		public function HitTest_Point() 
		{
			Laya.init(800, 600);
			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";
			
			var size:int = 200;
			var color:String = "orange";
			rect = new Sprite(); 
			rect.graphics.drawRect(0, 0, size, size, color);
			rect.size(size, size);
			rect.x = (Laya.stage.width - rect.width)/ 2;
			rect.y = (Laya.stage.height - rect.height) / 2;
			Laya.stage.addChild(rect);
			
			Laya.timer.frameLoop(1, this, loop);
		}
		
		private function loop():void 
		{
			var hit:Boolean = rect.hitTestPoint(Laya.stage.mouseX, Laya.stage.mouseY);
			rect.alpha = hit ? 0.5 : 1;
		}
	}
}