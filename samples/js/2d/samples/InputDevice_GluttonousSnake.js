(function()
{
	var Sprite           = laya.display.Sprite;
	var AccelerationInfo = laya.device.motion.AccelerationInfo;
	var Accelerator      = laya.device.motion.Accelerator;
	var Point            = laya.maths.Point;
	var Browser          = laya.utils.Browser;
	var Handler          = laya.utils.Handler;
	var WebGL            = laya.webgl.WebGL;

	function Segment(width, height)
	{
		Segment.super(this);

		Segment.prototype.init = function()
		{
			this.graphics.drawRect(-height / 2, -height / 2, width + height, height, "#FF7F50");
		}
		// 获取关节另一头位置
		Segment.prototype.getPinPosition = function()
		{
			var radian = this.rotation * Math.PI / 180;
			var tx = this.x + Math.cos(radian) * this.width;
			var ty = this.y + Math.sin(radian) * this.width;
			
			return new Point(tx, ty);
		}

		this.size(width, height);
		this.init();
	}
	Laya.class(Segment, "Segment", Sprite);

	var seg;
	var segments = [];
	var foods = [];
	var initialSegmentsAmount = 5;
	var vx = 0, vy = 0;
	var targetPosition;
	(function()
	{
		Laya.init(Browser.width, Browser.height, WebGL);
			
		// 初始化蛇
		initSnake();
		// 监视加速器状态
		Accelerator.instance.on(Laya.Event.CHANGE, this, monitorAccelerator);
		// 游戏循环
		Laya.timer.frameLoop(1, this, animate);
		// 食物生产
		Laya.timer.loop(3000, this, produceFood);
		// 游戏开始时有一个食物
		produceFood();
	})()

	function initSnake()
	{
		for (var i = 0; i < initialSegmentsAmount; i++)
		{
			addSegment();
			
			// 蛇头部设置
			if (i == 0)
			{
				var header = segments[0];
				
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
		
	function monitorAccelerator(acceleration, accelerationIncludingGravity, rotationRate, interval)
	{
		vx = accelerationIncludingGravity.x;
		vy = accelerationIncludingGravity.y;
	}
			
	function addSegment()
	{
		var seg = new Segment(40, 30);
		Laya.stage.addChildAt(seg, 0);
		
		// 蛇尾与上一节身体对齐
		if (segments.length > 0)
		{
			var prevSeg = segments[segments.length - 1];
			seg.rotation = prevSeg.rotation;
			var point = seg.getPinPosition();
			seg.x = prevSeg.x - point.x;
			seg.y = prevSeg.y - point.y;
		}
		
		segments.push(seg);
	}
			
	function animate()
	{
		var seg = segments[0];
		
		// 更新蛇的位置
		targetPosition.x += vx;
		targetPosition.y += vy;
		
		// 限制蛇的移动范围
		limitMoveRange();
		// 检测觅食
		checkEatFood();
		
		// 更新所有关节位置
		var targetX = targetPosition.x;
		var targetY = targetPosition.y;
		
		for (var i = 0, len = segments.length; i < len; i++)
		{
			seg = segments[i];
			
			var dx = targetX - seg.x;
			var dy = targetY - seg.y;
			
			var radian = Math.atan2(dy, dx);
			seg.rotation = radian * 180 / Math.PI;
			
			var pinPosition = seg.getPinPosition();
			var w = pinPosition.x - seg.x;
			var h = pinPosition.y - seg.y;
			
			seg.x = targetX - w;
			seg.y = targetY - h;
			
			targetX = seg.x;
			targetY = seg.y;
		}
	}
			
	function limitMoveRange()
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
			
	function checkEatFood()
	{
		var food;
		for (var i = foods.length - 1; i >= 0; i--)
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
			
	function produceFood()
	{
		// 最多五个食物同屏
		if (foods.length == 5)
			return;
		
		var food = new Sprite();
		Laya.stage.addChild(food);
		foods.push(food);
		
		const foodSize = 40;
		food.size(foodSize, foodSize);
		food.graphics.drawRect(0, 0, foodSize, foodSize, "#00BFFF");
		
		food.x = Math.random() * Laya.stage.width;
		food.y = Math.random() * Laya.stage.height;
	}
})()