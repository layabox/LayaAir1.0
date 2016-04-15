package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.maths.Point;
	import laya.events.Event;
	
	public class Interaction_Rotate
	{
		//声明一个显示对象
		private var sp:Sprite;
		//开始时坐标点
		private var lastPoint:Point = new Point();
		//当前坐标点
		private var curPoint:Point = new Point();
		//mousedown触发时，记录显示对象的旋转角度
		private var preDegree:Number = 0;
		
		public function Interaction_Rotate()
		{
			//引擎初始化
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#ffeecc";
			
			//创建一个sprite
			sp = new Sprite();
			sp.graphics.drawRect(0, 0, 200, 300, "#00eeff");
			
			sp.pivot(100, 150);
			sp.pos(275, 200);
			sp.size(200, 300);
			
			Laya.stage.addChild(sp);
			
			sp.on(Event.MOUSE_DOWN, this, onMouseDown);
			Laya.stage.on(Event.MOUSE_UP, this, onMouseUp);
			Laya.stage.on(Event.MOUSE_OUT, this, onMouseUp);
		}
		
		/**鼠标在显示对象上移到时处理*/
		private function onMouseMove(e:Event):void
		{
			//设置当前触发坐标点
			curPoint.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
			//以sp轴心点为原点，计算开始点与原点的角度
			var startDeg:Number = -Math.atan2(lastPoint.y - sp.y, lastPoint.x - sp.x) * 180 / Math.PI;
			//转化为 0-360度样式
			if (startDeg < 0) startDeg = startDeg + 360;
			//以sp轴心点为原点，计算当前点与原点的角度
			var curDeg:Number = -Math.atan2(curPoint.y - sp.y, curPoint.x - sp.x) * 180 / Math.PI;
			//转化为 0-360度样式
			if (curDeg < 0) curDeg = curDeg + 360;
			//设置旋转角度
			sp.rotation = preDegree + (startDeg - curDeg);
		}
		
		/**按下事件处理*/
		private function onMouseDown(e:Event):void
		{
			//记录坐标
			lastPoint.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
			//记录开始滑动前，显示对象的旋转角度
			preDegree = sp.rotation;
			//添加移动事件侦听
			sp.on(Event.MOUSE_MOVE, this, onMouseMove);
		}
		
		/**鼠标收起处理*/
		private function onMouseUp(e:Event):void
		{
			//添加移动事件侦听
			sp.off(Event.MOUSE_MOVE, this, onMouseMove);
		}
	}
}