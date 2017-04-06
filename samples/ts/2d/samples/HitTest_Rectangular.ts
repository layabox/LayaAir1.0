module laya
{
	import Sprite = laya.display.Sprite;
	import Event = laya.events.Event;
	import Rectangle = laya.maths.Rectangle;

	export class HitTest_Rectangular 
	{
		private rect1:Sprite;
		private rect2:Sprite;
		
		constructor()
		{
			Laya.init(800, 600);
			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";
			
			this.rect1 = this.createCircle(100, "orange");
			this.rect2 = this.createCircle(200, "purple");
			
			Laya.timer.frameLoop(1, this, this.loop);
		}
		
		private createCircle(radius:number, color:string):Sprite
		{
			var rect:Sprite = new Sprite(); 
			rect.graphics.drawRect(0, 0, radius, radius, color);
			rect.size(radius * 2, radius * 2);
			Laya.stage.addChild(rect);
			
			rect.on(Event.MOUSE_DOWN, this, this.startDrag, [rect]);
			rect.on(Event.MOUSE_UP, this, this.stopDrag, [rect]);
			
			return rect;
		}
		
		private startDrag(target:Sprite):void
		{
			target.startDrag();
		}
		
		private stopDrag(target:Sprite):void
		{
			target.stopDrag();
		}
		
		private loop():void
		{
			var bounds1:Rectangle = this.rect1.getBounds();
			var bounds2:Rectangle = this.rect2.getBounds();
			var hit:Boolean = bounds1.intersects(bounds2);
			this.rect1.alpha = this.rect2.alpha = hit ? 0.5 : 1;
		}
	}
}
new laya.HitTest_Rectangular();