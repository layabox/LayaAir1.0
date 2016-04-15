//swipe滚动范围
const RULE = 200;
//触发swipe的拖动距离
const SWIPE_DIS = 10;
//鼠标按下时坐标x
var downPoint;
//左侧点
var leftPoint;
//右侧点
var rightPoint;

Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
//设置背景色
Laya.stage.bgColor = "#ffeecc";

//创建一个精灵对象，默认mouseEnabled属性为false，在增加鼠标监听后会自动设为true;
var circle = new laya.display.Sprite();
circle.graphics.drawCircle(50, 50, 50, "#00eeff");

circle.pos(120, 150);
//设置宽高（要接收鼠标事件必须设置宽高，否则不会被命中）  
circle.size(100, 100);

circle.on(laya.events.Event.MOUSE_DOWN, this, onMouseDown, [circle]);
Laya.stage.on(laya.events.Event.MOUSE_UP, this, onMouseUp, [circle]);
Laya.stage.on(laya.events.Event.MOUSE_OUT, this, onMouseUp, [circle]);

Laya.stage.addChild(circle);
//左侧临界点设为圆形初始位置
leftPoint = circle.x;
//右侧临界点设置
rightPoint = leftPoint + RULE;

/**按下事件处理*/
function onMouseDown(circle, e)
{
	//添加鼠标移到侦听
	circle.on(laya.events.Event.MOUSE_MOVE, this, onMouseMove, [circle]);
	//记录按下时坐标点
	downPoint = Laya.stage.mouseX;
}

/**抬起事件处理*/
function onMouseUp(circle, e)
{
	//添加鼠标移到侦听
	circle.off(laya.events.Event.MOUSE_MOVE, this, onMouseMove, [circle]);
}

/**移到事件处理*/
function onMouseMove(circle, e)
{
	//移到到的点与按下点x轴距离
	var value = Laya.stage.mouseX - downPoint;
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
				laya.utils.Tween.to(circle, {x: rightPoint}, 100);
			}
		}
		else//向左拖
		{
			//当前位置大于左侧临界点
			if (circle.x > leftPoint)
			{
				//实现圆形缓动
				laya.utils.Tween.to(circle, {x: leftPoint}, 100);
			}
		}
	}
}
