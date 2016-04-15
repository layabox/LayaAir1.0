package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.utils.Ease;
	import laya.utils.Tween;
	import laya.events.Event;
	
	public class Swipe
	{
		//swipe滚动范围
		private const RULE:int = 200;
		//触发swipe的拖动距离
		private const SWIPE_DIS:int = 10;
		//鼠标按下时坐标x
		private var downPoint:int;
		//左侧点
		private var leftPoint:int;
		//右侧点
		private var rightPoint:int;
		
		public function Swipe()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#ffeecc";
			
			//创建一个精灵对象，默认mouseEnabled属性为false，在增加鼠标监听后会自动设为true;
			var circle:Sprite = new Sprite();
			circle.graphics.drawCircle(50, 50, 50, "#00eeff");
			
			circle.pos(120, 150);
			//设置宽高（要接收鼠标事件必须设置宽高，否则不会被命中）  
			circle.size(100, 100);
			
			circle.on(Event.MOUSE_DOWN, this, onMouseDown, [circle]);
			Laya.stage.on(Event.MOUSE_UP, this, onMouseUp, [circle]);
			Laya.stage.on(Event.MOUSE_OUT, this, onMouseUp, [circle]);
			
			Laya.stage.addChild(circle);
			//左侧临界点设为圆形初始位置
			leftPoint = circle.x;
			//右侧临界点设置
			rightPoint = leftPoint + RULE;
		}
		
		/**按下事件处理*/
		private function onMouseDown(circle:Sprite, e:Event):void
		{
			//添加鼠标移到侦听
			circle.on(Event.MOUSE_MOVE, this, onMouseMove, [circle]);
			//记录按下时坐标点
			downPoint = Laya.stage.mouseX;
		}
		
		/**抬起事件处理*/
		private function onMouseUp(circle:Sprite, e:Event):void
		{
			//添加鼠标移到侦听
			circle.off(Event.MOUSE_MOVE, this, onMouseMove, [circle]);
		}
		
		/**移到事件处理*/
		private function onMouseMove(circle:Sprite, e:Event):void
		{
			//移到到的点与按下点x轴距离
			var value:int = Laya.stage.mouseX - downPoint;
			//判断是否满足触发距离
			if (Math.abs(value) >= SWIPE_DIS)//可以触发滚动
			{
				//向右拖	
				if (value > 0)
				{
					//当前位置小于右侧临界点
					if (circle.x < rightPoint)
					{
						//实现圆形缓动
						Tween.to(circle, {x: rightPoint}, 100);
					}
				}
				else//向左拖
				{
					//当前位置大于左侧临界点
					if (circle.x > leftPoint)
					{
						//实现圆形缓动
						Tween.to(circle, {x: leftPoint}, 100);
					}
				}
			}
		}
	}

}