package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	
	public class Timer_DelayExcute
	{
		private var spBtn1:Sprite;
		private var spBtn2:Sprite;
		
		public function Timer_DelayExcute()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			spBtn1 = new Sprite();
			spBtn1.size(200, 100);
			spBtn1.pos(27, 29);
			
			spBtn1.graphics.drawRect(0, 0, 200, 100, "#ff0000");
			spBtn1.graphics.fillText("点我3秒之后 alpha - 0.5", 5, 20, "", "#ffffff", "left");
			spBtn1.mouseEnabled = true;
			
			spBtn1.on(Event.CLICK, this, onMinusAlpha1);
			Laya.stage.addChild(spBtn1);
			
			spBtn2 = new Sprite();
			spBtn2.size(200, 100);
			spBtn2.pos(250, 29);
			
			spBtn2.graphics.drawRect(0, 0, 200, 100, "#ff0000");
			spBtn2.graphics.fillText("点我60帧之后 alpha - 0.5", 5, 20, "", "#ffffff", "left");
			
			//接受鼠标事件
			spBtn2.mouseEnabled = true;
			spBtn2.on(Event.CLICK, this, onMinusAlpha2);
			
			Laya.stage.addChild(spBtn2);
		}
		
		private function onMinusAlpha1(e:Event):void
		{
			//移除鼠标单击事件
			spBtn1.off(Event.CLICK, this, onMinusAlpha1);
			//定时执行一次(间隔时间)
			Laya.timer.once(3000, this, onComplete1);
		}
		
		private function onMinusAlpha2(e:Event):void
		{
			//移除鼠标单击事件
			spBtn2.off(Event.CLICK, this, onMinusAlpha2);
			//定时执行一次(基于帧率)
			Laya.timer.frameOnce(60, this, onComplete2);
		}
		
		private function onComplete1():void
		{
			//spBtn1的透明度减少0.5
			spBtn1.alpha -= 0.5;
		}
		
		private function onComplete2():void
		{
			//spBtn2的透明度减少0.5
			spBtn2.alpha -= 0.5;
		}
	}
}