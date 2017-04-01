package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.utils.Ease;
	import laya.utils.Tween;
	import laya.webgl.WebGL;
	
	public class Interaction_CustomEvent
	{
		public static const ROTATE:String = "rotate";
		
		private var sp:Sprite;
		
		public function Interaction_CustomEvent():void
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			createSprite();
		}

		private function createSprite():void
		{
			sp = new Sprite();
			sp.graphics.drawRect(0, 0, 200, 200, "#D2691E");
			sp.pivot(100, 100);

			sp.x = Laya.stage.width / 2;
			sp.y = Laya.stage.height / 2;

			sp.size(200, 200);
			Laya.stage.addChild(sp);

			sp.on(ROTATE, this, onRotate);	// 侦听自定义的事件
			sp.on(Event.CLICK, this, onSpriteClick);
		}

		private function onSpriteClick(e:Event=null):void
		{
			var randomAngle:int = Math.random() * 180;
			//发送自定义事件
			sp.event(ROTATE, [randomAngle]);
		}

		// 触发自定义的rotate事件
		private function onRotate(newAngle:int):void
		{
			Tween.to(sp, {"rotation" : newAngle }, 1000, Ease.elasticOut);
		}
	}
}
