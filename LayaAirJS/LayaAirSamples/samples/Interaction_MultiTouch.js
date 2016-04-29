var rectIsDown;
var circleIsDown;
var lastRectPoint = new Laya.Point();
var lastCirclePoint = new Laya.Point();

Laya.init(550, 400);
Laya.stage.bgColor = "#ffeecc";
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

var rect = new Laya.Sprite();
rect.graphics.drawRect( 0, 0, 100, 100, "#00eeff");
rect.pos(100, 150);
rect.size(100,100);
rect.on(Laya.Event.MOUSE_DOWN, this, onRectHandler);
rect.on(Laya.Event.MOUSE_MOVE, this, onRectHandler);
rect.on(Laya.Event.MOUSE_UP, this, onRectHandler);
Laya.stage.addChild(rect);

var circle = new Laya.Sprite();
circle.graphics.drawCircle(50,50,50,"#00eeff");
circle.pos(350, 150);
circle.size(100,100);
circle.on(Laya.Event.MOUSE_DOWN,this,onCircleHandler);
circle.on(Laya.Event.MOUSE_MOVE, this, onCircleHandler);
circle.on(Laya.Event.MOUSE_UP, this, onCircleHandler);
Laya.stage.addChild(circle);

/**矩形鼠标处理*/
function onRectHandler(e)
{
	switch(e.type)
	{
		case Laya.Event.MOUSE_DOWN:
			//记录矩形按下
			rectIsDown = true;
			//记录按下时坐标点
			this.lastRectPoint.setTo(Laya.stage.mouseX,Laya.stage.mouseY);
			break;
		case Laya.Event.MOUSE_UP:
			//矩形按下重置
			rectIsDown = false;
			break;
		case Laya.Event.MOUSE_MOVE:
			if (rectIsDown)
			{
				//x轴上鼠标移动位置
				e.currentTarget.x = e.currentTarget.x + (Laya.stage.mouseX - this.lastRectPoint.x);
				//y轴上鼠标移动位置
				e.currentTarget.y = e.currentTarget.y + (Laya.stage.mouseY - this.lastRectPoint.y);
				//记录本次事件的鼠标坐标
				this.lastRectPoint.setTo(Laya.stage.mouseX,Laya.stage.mouseY);
			}
			break;
	}
}

/**圆形鼠标处理*/
function onCircleHandler(e)
{
	switch(e.type)
	{
		case Laya.Event.MOUSE_DOWN:
			//记录圆形按下
			circleIsDown = true;
			//记录按下时坐标点
			this.lastCirclePoint.setTo(Laya.stage.mouseX,Laya.stage.mouseY);
			break;
		case Laya.Event.MOUSE_UP:
			//圆形按下重置
			circleIsDown = false;
			break;
		case Laya.Event.MOUSE_MOVE:
			if (circleIsDown)
			{
				//x轴上鼠标移动位置
				e.currentTarget.x = e.currentTarget.x + (Laya.stage.mouseX - this.lastCirclePoint.x);
				//y轴上鼠标移动位置
				e.currentTarget.y = e.currentTarget.y + (Laya.stage.mouseY - this.lastCirclePoint.y);
				//记录本次事件的鼠标坐标
				this.lastCirclePoint.setTo(Laya.stage.mouseX,Laya.stage.mouseY);
			}
			break;
	}
}
