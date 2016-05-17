package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.maths.Rectangle;
	import laya.webgl.WebGL;
	
	public class Sprite_Drag
	{
		private var ape:Sprite;
		private var dragRect:Rectangle;
		
		public function Sprite_Drag()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			ape = new Sprite();
			
			ape.loadImage("res/apes/monkey2.png");
			Laya.stage.addChild(ape);
			
			ape.x = 275;
			ape.y = 200;
			ape.pivot(55, 72);
			
			//拖动限制区域
			dragRect = new Rectangle(100, 100, 350, 200);
			
			//画出拖动限制区域
			Laya.stage.graphics.drawRect(
				dragRect.x, dragRect.y, dragRect.width, dragRect.height,
				null, "#FFFFFF", 5);
			
			ape.on(Event.MOUSE_DOWN, this, onStartDrag);
		}
		
		private function onStartDrag(e:Event):void
		{
			//鼠标按下开始拖拽(设置了拖动区域和超界弹回的滑动效果)
			ape.startDrag(dragRect, true, 100);
		}
	}
}