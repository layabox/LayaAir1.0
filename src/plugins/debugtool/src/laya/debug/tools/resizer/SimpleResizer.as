package laya.debug.tools.resizer 
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Point;
	/**
	 * ...
	 * @author ww
	 */
	public class SimpleResizer 
	{
		
		public function SimpleResizer() 
		{
			
		}
		public static function setResizeAble(clickItem:Sprite, tar:Sprite,minWidth:int=150,minHeight:int=150):void
		{
			clickItem.on(Event.MOUSE_DOWN, null, onMouseDown,[tar,minWidth,minHeight]);
		}
		private static function onMouseDown(tar:Sprite,minWidth:int,minHeight:int,e:Event):void
		{
			clearEvents();
			if (!tar) return;
			preMousePoint.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
			preTarSize.setTo(tar.width, tar.height);
			preScale.setTo(1, 1);
			var rTar:Sprite;
			rTar = tar;
			while (rTar&&rTar!=Laya.stage)
			{
				preScale.x *= rTar.scaleX;
				preScale.y *= rTar.scaleY;
				rTar = rTar.parent as Sprite;
			}
			//trace("scale:", preScale.x, preScale.y);
			//preScale.setTo(2, 2);
			//Laya.stage.on(Event.MOUSE_MOVE, null, onMouseMoving,[tar]);
			Laya.stage.on(Event.MOUSE_UP, null, onMouseMoveEnd);
			Laya.timer.loop(100, null, onMouseMoving, [tar,minWidth,minHeight]);
		}
		private static var preMousePoint:Point = new Point();
		private static var preTarSize:Point = new Point();
		private static var preScale:Point = new Point();
		private static function onMouseMoving(tar:Sprite,minWidth:int,minHeight:int,e:Event):void
		{
			var tWidth:int = (Laya.stage.mouseX - preMousePoint.x) / preScale.x + preTarSize.x;
			var tHeight:int=(Laya.stage.mouseY - preMousePoint.y)/preScale.y + preTarSize.y;
			tar.width = tWidth > minWidth?tWidth:minWidth;
			tar.height = tHeight>minHeight?tHeight:minHeight;
		}
		private static function onMouseMoveEnd(e:Event):void
		{
			clearEvents();
		}
		private static function clearEvents():void
		{
			Laya.timer.clear(null, onMouseMoving);
			//Laya.stage.off(Event.MOUSE_MOVE, null, onMouseMoving);
			Laya.stage.off(Event.MOUSE_UP, null, onMouseMoveEnd);
		}
	}

}