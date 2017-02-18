package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	
	public class Interaction_Scale
	{
		//上次记录的两个触模点之间距离
		private var lastDistance:Number = 0;
		private var sp:Sprite;
		
		public function Interaction_Scale()
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
			var w:int = 300, h:int = 300;
			sp.graphics.drawRect(0, 0, w, h, "#FF7F50");
			sp.size(w, h);
			sp.pivot(w / 2, h / 2);
			sp.pos(Laya.stage.width / 2, Laya.stage.height / 2);
			Laya.stage.addChild(sp);

			sp.on(Event.MOUSE_DOWN, this, onMouseDown);
		}
		
		private function onMouseDown(e:Event=null):void
		{
			var touches:Array = e.touches;

			if(touches && touches.length == 2)
			{
				lastDistance = getDistance(touches);

				Laya.stage.on(Event.MOUSE_MOVE, this, onMouseMove);
			}
		}
		
		private function onMouseMove(e:Event=null):void
		{
			var distance:Number = getDistance(e.touches);

			//判断当前距离与上次距离变化，确定是放大还是缩小
			const factor:Number = 0.01;
			sp.scaleX += (distance - lastDistance) * factor;
			sp.scaleY += (distance - lastDistance) * factor;

			lastDistance = distance;
		}

		private function onMouseUp(e:Event=null):void
		{
			Laya.stage.off(Event.MOUSE_MOVE, this, onMouseMove);
		}
		
		/**计算两个触摸点之间的距离*/
		private function getDistance(points:Array):Number
		{
			var distance:Number = 0;
            if (points && points.length == 2)
			{
				var dx:Number = points[0].stageX - points[1].stageX;
				var dy:Number = points[0].stageY - points[1].stageY;

				distance = Math.sqrt(dx * dx + dy * dy);
			}
			return distance;
		}
	}
}