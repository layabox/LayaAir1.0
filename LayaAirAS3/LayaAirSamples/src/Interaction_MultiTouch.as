package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.maths.Point;
	import laya.events.Event;
	
	public class Interaction_MultiTouch 
	{
		private var rectIsDown:Boolean;
		private var circleIsDown:Boolean;
		private var lastRectPoint:Point = new Point();
		private var lastCirclePoint:Point = new Point();
		
		public function Interaction_MultiTouch() 
		{
			Laya.init(550, 400);
			Laya.stage.bgColor = "#ffeecc";
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			//创建一个精灵对象，默认mouseEnabled属性为false，在增加鼠标监听后会自动设为true;
			var rect:Sprite = new Sprite();
			//绘制矩形
			rect.graphics.drawRect( 0, 0, 100, 100, "#00eeff");
			//设置坐标点
			rect.pos(100, 150);
			//设置宽高（要接收鼠标事件必须设置宽高，否则不会被命中）  
			rect.size(100,100);
			//添加按下侦听
			rect.on(Event.MOUSE_DOWN, this, onRectHandler);
			//添加移到侦听
			rect.on(Event.MOUSE_MOVE, this, onRectHandler);
			//添加抬起侦听
			rect.on(Event.MOUSE_UP, this, onRectHandler);
			//将矩形对象添加到舞台
			Laya.stage.addChild(rect);
			
			//创建一个精灵对象，默认mouseEnabled属性为false，在增加鼠标监听后会自动设为true;
			var circle:Sprite = new Sprite();
			//绘制矩形
			circle.graphics.drawCircle(50,50,50,"#00eeff");
			//设置坐标点
			circle.pos(350, 150);
			//设置宽高（要接收鼠标事件必须设置宽高，否则不会被命中）  
			circle.size(100,100);
			//添加按下侦听
			circle.on(Event.MOUSE_DOWN,this,onCircleHandler);
			//添加移到侦听
			circle.on(Event.MOUSE_MOVE, this, onCircleHandler);
			//添加抬起侦听
			circle.on(Event.MOUSE_UP, this, onCircleHandler);
			//将矩形对象添加到舞台
			Laya.stage.addChild(circle);
		}
		
		/**矩形鼠标处理*/
		private function onRectHandler(e:Event):void
		{
			switch(e.type)
			{
				case Event.MOUSE_DOWN:
					//记录矩形按下
					rectIsDown = true;
					//记录按下时坐标点
					lastRectPoint.setTo(Laya.stage.mouseX,Laya.stage.mouseY);
					break;
				case Event.MOUSE_UP:
					//矩形按下重置
					rectIsDown = false;
					break;
				case Event.MOUSE_MOVE:
					if (rectIsDown)
					{
						//x轴上鼠标移动位置
						e.currentTarget.x = e.currentTarget.x + (Laya.stage.mouseX - lastRectPoint.x);
						//y轴上鼠标移动位置
						e.currentTarget.y = e.currentTarget.y + (Laya.stage.mouseY - lastRectPoint.y);
						//记录本次事件的鼠标坐标
						lastRectPoint.setTo(Laya.stage.mouseX,Laya.stage.mouseY);
					}
					break;
			}
		}
		
		/**圆形鼠标处理*/
		private function onCircleHandler(e:Event):void
		{
			switch(e.type)
			{
				case Event.MOUSE_DOWN:
					//记录圆形按下
					circleIsDown = true;
					//记录按下时坐标点
					lastCirclePoint.setTo(Laya.stage.mouseX,Laya.stage.mouseY);
					break;
				case Event.MOUSE_UP:
					//圆形按下重置
					circleIsDown = false;
					break;
				case Event.MOUSE_MOVE:
					if (circleIsDown)
					{
						//x轴上鼠标移动位置
						e.currentTarget.x = e.currentTarget.x + (Laya.stage.mouseX - lastCirclePoint.x);
						//y轴上鼠标移动位置
						e.currentTarget.y = e.currentTarget.y + (Laya.stage.mouseY - lastCirclePoint.y);
						//记录本次事件的鼠标坐标
						lastCirclePoint.setTo(Laya.stage.mouseX,Laya.stage.mouseY);
					}
					break;
			}
		}
	}
}