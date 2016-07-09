package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	
	public class Timer_DelayExcute
	{
		private var button1:Sprite;
		private var button2:Sprite;
		
		public function Timer_DelayExcute()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			setup();
		}

		private function setup():void
		{
			var vGap:int = 100;

			button1 = createButton("点我3秒之后 alpha - 0.5");
			button1.x = (Laya.stage.width - button1.width) / 2;
			button1.y = (Laya.stage.height - button1.height - vGap) / 2;
			Laya.stage.addChild(button1);
			button1.on(Event.CLICK, this, onDecreaseAlpha1);
			
			button2 = createButton("点我60帧之后 alpha - 0.5");
			button2.pos(button1.x, button1.y + vGap);
			Laya.stage.addChild(button2);
			button2.on(Event.CLICK, this, onDecreaseAlpha2);
		}

		private function createButton(label:String):Sprite
		{
			var w:int = 300, h:int = 60;

			var button:Sprite = new Sprite();
			button.graphics.drawRect(0, 0, w, h, "#FF7F50");
			button.size(w, h);
			button.graphics.fillText(label, w / 2, 17, "20px simHei", "#ffffff", "center");
			return button;
		}
		
		private function onDecreaseAlpha1(e:Event=null):void
		{
			//移除鼠标单击事件
			button1.off(Event.CLICK, this, onDecreaseAlpha1);
			//定时执行一次(间隔时间)
			Laya.timer.once(3000, this, onComplete1);
		}
		
		private function onDecreaseAlpha2(e:Event=null):void
		{
			//移除鼠标单击事件
			button2.off(Event.CLICK, this, onDecreaseAlpha2);
			//定时执行一次(基于帧率)
			Laya.timer.frameOnce(60, this, onComplete2);
		}
		
		private function onComplete1():void
		{
			//spBtn1的透明度减少0.5
			button1.alpha -= 0.5;
		}
		
		private function onComplete2():void
		{
			//spBtn2的透明度减少0.5
			button2.alpha -= 0.5;
		}
	}
}