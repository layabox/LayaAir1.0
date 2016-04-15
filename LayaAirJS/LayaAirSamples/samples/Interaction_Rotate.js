//声明一个显示对象
var sp;
//开始时坐标点
 var lastPoint = new laya.maths.Point();
//当前坐标点
 var curPoint = new laya.maths.Point();
//mousedown触发时，记录显示对象的旋转角度
 var preDegree = 0;

//引擎初始化
Laya.init(550, 400);
//设置背景色
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
Laya.stage.bgColor = "#ffeecc";

//创建一个sprite
sp = new laya.display.Sprite();
sp.graphics.drawRect(0, 0, 200, 300, "#00eeff");

sp.pivot(100, 150);
sp.pos(275, 200);
sp.size(200, 300);

Laya.stage.addChild(sp);

sp.on(laya.events.Event.MOUSE_DOWN, this, onMouseDown);
Laya.stage.on(laya.events.Event.MOUSE_UP, this, onMouseUp);
Laya.stage.on(laya.events.Event.MOUSE_OUT, this, onMouseUp);

/**鼠标在显示对象上移到时处理*/
function onMouseMove(e)
{
		//设置当前触发坐标点
		curPoint.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
		//以sp轴心点为原点，计算开始点与原点的角度
		var startDeg = -Math.atan2(lastPoint.y - sp.y, lastPoint.x - sp.x) * 180 / Math.PI;
		//转化为 0-360度样式
		if (startDeg < 0) startDeg = startDeg + 360;
		//以sp轴心点为原点，计算当前点与原点的角度
		var curDeg = -Math.atan2(curPoint.y - sp.y, curPoint.x - sp.x) * 180 / Math.PI;
		//转化为 0-360度样式
		if (curDeg < 0) curDeg = curDeg + 360;
		//设置旋转角度
		sp.rotation = preDegree + (startDeg - curDeg);
}

/**按下事件处理*/
function onMouseDown(e)
{
	//记录坐标
	lastPoint.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
	//记录开始滑动前，显示对象的旋转角度
	preDegree = sp.rotation;
	//添加移动事件侦听
	sp.on(laya.events.Event.MOUSE_MOVE, this, onMouseMove);
}

/**鼠标收起处理*/
function onMouseUp(e)
{
	//添加移动事件侦听
	sp.off(laya.events.Event.MOUSE_MOVE, this, onMouseMove);
}
