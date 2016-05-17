package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.utils.Ease;
	import laya.utils.Tween;
	import laya.events.Event;

	public class Interaction_Hold
	{
		//触发hold事件时间为1秒
		private const HOLD_TRIGGER_TIME:int = 1000;
		private var ape:Sprite;
		private var isApeHold:Boolean;

		public function Interaction_Hold()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#ffeecc";

			// 添加一只猩猩
			ape = new Sprite();
			ape.loadImage("res/apes/monkey2.png");
			ape.pos(260, 180);
			ape.pivot(55, 72);
			ape.scale(0.8, 0.8);
			Laya.stage.addChild(ape);

			// 鼠标交互
			ape.on(Event.MOUSE_DOWN, this, onApePress);
		}

		private function onApePress(e:Event):void
		{
			// 鼠标按下后，HOLD_TRIGGER_TIME毫秒后hold
			Laya.timer.once(HOLD_TRIGGER_TIME, this, onHold);
			Laya.stage.on(Event.MOUSE_UP, this, onApeRelease);
		}

		private function onHold():void
		{
			Tween.to(ape, { "scaleX":1, "scaleY":1 }, 500, Ease.bounceOut);
			isApeHold = true;
		}

		/** 鼠标放开后停止hold */
		private function onApeRelease():void
		{
			// 鼠标放开时，如果正在hold，则播放放开的效果
			if (isApeHold)
			{
				isApeHold = false;
				Tween.to(ape, { "scaleX":0.8, "scaleY":0.8 }, 300);
			}
			else // 如果未触发hold，终止触发hold
				Laya.timer.clear(this, onHold);

			Laya.stage.off(Event.MOUSE_UP, this, onApeRelease);
		}
	}
}