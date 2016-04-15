var txt;

Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
Laya.stage.bgColor = "#ffeecc";

var keyDownList = [];

//添加键盘按下事件,一直按着某按键则会不断触发
Laya.stage.on(laya.events.Event.KEY_DOWN, this, onKeyDown);
//添加键盘抬起事件
Laya.stage.on(laya.events.Event.KEY_UP, this, onKeyUp);

Laya.timer.frameLoop(1, this, keyboardInspector);

//添加提示文本
createTxt();

/**键盘按下处理*/
function onKeyDown(e)
{
	keyDownList[e.keyCode] = true;
}

/**键盘抬起处理*/
function onKeyUp(e)
{
	delete keyDownList[e.keyCode];
}

function keyboardInspector()
{
	var numKeyDown = keyDownList.length;
	
	txt.text = "按下了下列键\n";
	for (var i = 0; i < numKeyDown; i++)
	{
		if (keyDownList[i])
		{
			txt.text += i + " ";
		}
	}
}

/**添加提示文本*/
function createTxt()
{
	txt = new laya.display.Text();
	
	txt.size(550, 300);
	txt.fontSize = 20;
	txt.font = "SimHei";
	txt.wordWrap = true;
	txt.color = "#000000";
	txt.align = 'center';
	txt.pos(0, 150);
	
	Laya.stage.addChild(txt);
}