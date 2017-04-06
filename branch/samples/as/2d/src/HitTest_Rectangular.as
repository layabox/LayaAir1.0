package 
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Rectangle;
	/**
	 * ...
	 * @author suvivor
	 */
	public class HitTest_Rectangular 
	{
		private var rect1:Sprite;
		private var rect2:Sprite;
		
		public function HitTest_Rectangular() 
		{
			Laya.init(800, 600);
			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";
			
			rect1 = createRect(100, "orange");
			rect2 = createRect(200, "purple");
			
			Laya.timer.frameLoop(1, this, loop);
		}
		
		private function createRect(size:int, color:String):Sprite
		{
			var rect:Sprite = new Sprite(); 
			rect.graphics.drawRect(0, 0, size, size, color);
			rect.size(size, size);
			Laya.stage.addChild(rect);
			
			rect.on(Event.MOUSE_DOWN, this, startDrag, [rect]);
			rect.on(Event.MOUSE_UP, this, stopDrag, [rect]);
			
			return rect;
		}
		
		private function startDrag(target:Sprite):void
		{
			target.startDrag();
		}
		
		private function stopDrag(target:Sprite):void
		{
			target.stopDrag();
		}
		
		private function loop():void
		{
			var bounds1:Rectangle = rect1.getBounds();
			var bounds2:Rectangle = rect2.getBounds();
			var hit:Boolean = bounds1.intersects(bounds2);
			rect1.alpha = rect2.alpha = hit ? 0.5 : 1;
		}
	}
}