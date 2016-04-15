//上次记录的两个触模点之间距离
var lastDistance = 0;
//一个精灵对象
var rect;

//引擎初始化
Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
//设置背景色
Laya.stage.bgColor = "#ffeecc";

//创建精灵对象，默认mouseEnabled属性为false，在增加鼠标监听后会自动设为true;
rect = new laya.display.Sprite();
rect.graphics.drawRect(0, 0, 300, 300, "#00eeff");

rect.pivot(150,150);
rect.pos(275, 200);
rect.size(300, 300);

rect.on(laya.events.Event.MOUSE_DOWN, this, onMouseDown);
rect.on(laya.events.Event.MOUSE_MOVE, this, onMouseMove);

Laya.stage.addChild(rect);

/**按下处理*/
function onMouseDown(e)
{
	//计算两触发点距离
	lastDistance = getDistance(e);
}

/**移到处理*/
function onMouseMove(e)
{
	////计算两触发点距离
	var distance = getDistance(e);
	//判断当前距离与上次距离变化，确定是放大还是缩小
	if (distance - lastDistance > 1)
	{
		//圆形放大
		rect.scale(rect.scaleX + 0.01, rect.scaleX + 0.01);
	}
	else if (distance - lastDistance < -1)
	{
		//圆形缩小
		rect.scale(rect.scaleX - 0.01, rect.scaleX - 0.01);
	}
	//记录距离
	lastDistance = distance;
}

/**计算两个触摸点之间的距离 主要是使用event的touches*/
function getDistance(e)
{
	//定义变量
	var distance = 0;
	//获取触发点信息数组
	var touches = e.touches;
	//判断数组长度
	if (touches && touches.length > 1)
	{
		//x轴距离
		var x = touches[0].stageX - touches[1].stageX;
		//y轴距离
		var y = touches[0].stageY - touches[1].stageY;
		//计算两点距离
		distance = Math.sqrt(x * x + y * y);
	}
	//返回距离
	return distance;
}
