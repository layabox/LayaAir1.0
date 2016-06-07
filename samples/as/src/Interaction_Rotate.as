package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	
	public class Interaction_Rotate
	{
		private var sp:Sprite;
		private var preRadian:Number = 0;
		
		public function Interaction_Rotate()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";
			
			setup();
		}
		
		private function setup():void
		{
			createSprite();

			Laya.stage.on(Event.MOUSE_UP, this, onMouseUp);
			Laya.stage.on(Event.MOUSE_OUT, this, onMouseUp);
		}

		private function createSprite():void
		{
			sp = new Sprite();
			var w:int = 200, h:int = 300;
			sp.graphics.drawRect(0, 0, w, h, "#FF7F50");
			sp.size(w, h);
			sp.pivot(w / 2, h / 2);
			sp.pos(Laya.stage.width / 2, Laya.stage.height / 2);
			Laya.stage.addChild(sp);
			
			sp.on(Event.MOUSE_DOWN, this, onMouseDown);
		}
		
		private function onMouseDown(e:Event):void
		{
			var touches:Array = e.touches;

			if(touches.length == 2)
			{
				preRadian = Math.atan2(
					touches[0].stageY - touches[1].stageY, 
					touches[0].stageX - touches[1].stageX);

				Laya.stage.on(Event.MOUSE_MOVE, this, onMouseMove);
			}
		}

		private function onMouseMove(e:Event):void
		{
			var touches:Array = e.touches;
			var nowRadian:Number = Math.atan2(
					touches[0].stageY - touches[1].stageY, 
					touches[0].stageX - touches[1].stageX);

			sp.rotation += 180 / Math.PI * (nowRadian - preRadian);

			preRadian = nowRadian;
		}
		
		private function onMouseUp(e:Event):void
		{
			Laya.stage.off(Event.MOUSE_MOVE, this, onMouseMove);
		}
	}
}