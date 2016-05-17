package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.maths.Point;
	import laya.events.Event;
	
	public class Interaction_Drag
	{
		private var rect:Sprite;
		
		public function Interaction_Drag()
		{
			Laya.init(550, 400);
			Laya.stage.bgColor = "#ffeecc";
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			rect = new Sprite();
			rect.graphics.drawRect(0, 0, 100, 100, "#00eeff");
			rect.pos(200, 80);
			rect.size(100, 100);
			
			rect.on(Event.MOUSE_DOWN, this, onMouseDown);
			
			Laya.stage.addChild(rect);
		}
		private function onMouseDown(e:Event):void {
			rect.startDrag();
		}
	}
}