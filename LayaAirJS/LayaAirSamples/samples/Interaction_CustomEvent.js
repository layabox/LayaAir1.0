var MY_EVENT = "myEvent";

Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;
Laya.stage.bgColor = "#ffeecc";

var sp = new Laya.Sprite();
//给sp增加一个自定义的事件侦听
sp.on(MY_EVENT, this, onCustomTest);

//添加信息文本
createTxt();
//添加一个触发方块
createRect();

/**自定义事件侦听的回调方法*/
function onCustomTest(param1, param2)
{
	txt.text = "sp收到自定义事件携带参数为：\n 参数1:"+param1+"\n 参数2:"+param2;
}

/**添加文本*/
function createTxt()
{
	txt = new Laya.Text();
	txt.text = "点击蓝色方块触发自定义事件";

	txt.fontSize = 20;
	txt.color = "#000000";

	Laya.stage.addChild(txt);
}

/**添加一个显示对象*/
function createRect()
{
	var rect = new Laya.Sprite();
	rect.graphics.drawRect(0, 0, 100, 100, "#00eeff");

	rect.pos(225, 150);
	rect.size(100, 100);

	rect.on(Laya.Event.MOUSE_DOWN, this, onDown);

	Laya.stage.addChild(rect);
}

/**按下处理*/
function onDown(e)
{
	//发送自定义事件
	sp.event(MY_EVENT, ["我是自定义事件！","my customize event."]);
}
