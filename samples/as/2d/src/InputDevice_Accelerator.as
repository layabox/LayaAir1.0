package
{
	import laya.inputDevice.motion.AccelerationInfo;
	import laya.inputDevice.motion.Accelerator;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	/**
	 * ...
	 * @author Survivor
	 */
	public class InputDevice_Accelerator
	{
		private var seg:Segment;
		private var segments:Array = [];
		private var foods:Array = [];
		
		private var initialSegmentsAmount:int = 5;
		private var vx:Number = 0, vy:Number = 0;
		private var targetPosition:Point;
		
		public function InputDevice_Accelerator()
		{
			Laya.init(Browser.width, Browser.height, WebGL);
			
			// 初始化蛇
			initSnake();
			// 监视加速器状态
			Accelerator.listen(new Handler(this, monitorAccelerator));
			// 游戏循环
			Laya.timer.frameLoop(1, this, animate);
			// 食物生产
			Laya.timer.loop(3000, this, produceFood);
			// 游戏开始时有一个食物
			produceFood();
		}
		
		private function initSnake():void
		{
			for (var i:int = 0; i < initialSegmentsAmount; i++)
			{
				addSegment();
				
				// 蛇头部设置
				if (i == 0)
				{
					var header:Segment = segments[0];
					
					// 初始化位置
					header.rotation = 180;
					targetPosition = new Point();
					targetPosition.x = Laya.stage.width / 2;
					targetPosition.y = Laya.stage.height / 2;
					
					header.pos(targetPosition.x + header.width, targetPosition.y);
					
					// 蛇眼睛绘制
					header.graphics.drawCircle(header.width, 5, 3, "#000000");
					header.graphics.drawCircle(header.width, -5, 3, "#000000");
				}
			}
		}
		
		private function monitorAccelerator(acceleration:AccelerationInfo, accelerationIncludingGravity:AccelerationInfo, rotationRate:Object, interval:Number):void
		{
			vx = accelerationIncludingGravity.x;
			vy = accelerationIncludingGravity.y;
		}
		
		private function addSegment():void
		{
			var seg:Segment = new Segment(40, 30);
			Laya.stage.addChildAt(seg, 0);
			
			// 蛇尾与上一节身体对齐
			if (segments.length > 0)
			{
				var prevSeg:Segment = segments[segments.length - 1];
				seg.rotation = prevSeg.rotation;
				var point:Point = seg.getPinPosition();
				seg.x = prevSeg.x - point.x;
				seg.y = prevSeg.y - point.y;
			}
			
			segments.push(seg);
		}
		
		private function animate():void
		{
			var seg:Segment = segments[0];
			
			// 更新蛇的位置
			targetPosition.x += vx;
			targetPosition.y += vy;
			
			// 限制蛇的移动范围
			limitMoveRange();
			// 检测觅食
			checkEatFood();
			
			// 更新所有关节位置
			var targetX:int = targetPosition.x;
			var targetY:int = targetPosition.y;
			
			for (var i:int = 0, len:int = segments.length; i < len; i++)
			{
				seg = segments[i];
				
				var dx:int = targetX - seg.x;
				var dy:int = targetY - seg.y;
				
				var radian:Number = Math.atan2(dy, dx);
				seg.rotation = radian * 180 / Math.PI;
				
				var pinPosition:Point = seg.getPinPosition();
				var w:int = pinPosition.x - seg.x;
				var h:int = pinPosition.y - seg.y;
				
				seg.x = targetX - w;
				seg.y = targetY - h;
				
				targetX = seg.x;
				targetY = seg.y;
			}
		}
		
		private function limitMoveRange():void
		{
			if (targetPosition.x < 0)
				targetPosition.x = 0;
			else if (targetPosition.x > Laya.stage.width)
				targetPosition.x = Laya.stage.width;
			if (targetPosition.y < 0)
				targetPosition.y = 0;
			else if (targetPosition.y > Laya.stage.height)
				targetPosition.y = Laya.stage.height;
		}
		
		private function checkEatFood():void
		{
			var food:Sprite;
			for (var i:int = foods.length - 1; i >= 0; i--)
			{
				food = foods[i];
				if (food.hitTestPoint(targetPosition.x, targetPosition.y))
				{
					addSegment();
					Laya.stage.removeChild(food);
					foods.splice(i, 1);
				}
			}
		}
		
		private function produceFood():void
		{
			// 最多五个食物同屏
			if (foods.length == 5)
				return;
			
			var food:Sprite = new Sprite();
			Laya.stage.addChild(food);
			foods.push(food);
			
			const foodSize:int = 40;
			food.size(foodSize, foodSize);
			food.graphics.drawRect(0, 0, foodSize, foodSize, "#00BFFF");
			
			food.x = Math.random() * Laya.stage.width;
			food.y = Math.random() * Laya.stage.height;
		}
	}
}
import laya.display.Sprite;
import laya.maths.Point;

class Segment extends Sprite
{
	public function Segment(width:int, height:int)
	{
		this.size(width, height);
		init();
	}
	
	private function init():void
	{
		graphics.drawRect(-height / 2, -height / 2, width + height, height, "#FF7F50");
	}
	
	// 获取关节另一头位置
	public function getPinPosition():Point
	{
		var radian:Number = rotation * Math.PI / 180;
		var tx:Number = x + Math.cos(radian) * width;
		var ty:Number = y + Math.sin(radian) * width;
		
		return new Point(tx, ty);
	}
}