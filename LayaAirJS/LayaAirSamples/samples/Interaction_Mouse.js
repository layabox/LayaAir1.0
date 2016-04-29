var txt;
		
Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;
Laya.stage.bgColor = "#ffeecc";

var rect = new Laya.Sprite();
rect.graphics.drawRect( 0, 0, 100, 100, "#00eeff");
rect.pos(250, 170);
rect.size(100,100);
Laya.stage.addChild(rect);

//增加鼠标事件
rect.on(Laya.Event.MOUSE_DOWN, this, mouseHandler);
rect.on(Laya.Event.MOUSE_UP, this, mouseHandler);
rect.on(Laya.Event.CLICK, this, mouseHandler);
rect.on(Laya.Event.RIGHT_MOUSE_DOWN, this, mouseHandler);
rect.on(Laya.Event.RIGHT_MOUSE_UP, this, mouseHandler);
rect.on(Laya.Event.RIGHT_CLICK, this, mouseHandler);
rect.on(Laya.Event.MOUSE_MOVE, this, mouseHandler);
rect.on(Laya.Event.MOUSE_OVER, this, mouseHandler);
rect.on(Laya.Event.MOUSE_OUT, this, mouseHandler);
rect.on(Laya.Event.DOUBLE_CLICK, this, mouseHandler);
rect.on(Laya.Event.MOUSE_WHEEL, this, mouseHandler);

//添加提示文本
createTxt();
		
/**
 * 鼠标响应事件处理
 */	
function mouseHandler(e)
{
	switch(e.type)
	{
		case Laya.Event.MOUSE_DOWN:
			appendText("\n————————\n左键按下");
			break;
		case Laya.Event.MOUSE_UP:
			appendText("\n左键抬起");
			break;
		case Laya.Event.CLICK:
			appendText("\n左键点击\n————————");
			break;
		case Laya.Event.RIGHT_MOUSE_DOWN:
			appendText("\n————————\n右键按下");
			break;
		case Laya.Event.RIGHT_MOUSE_UP:
			appendText("\n右键抬起");
			break;
		case Laya.Event.RIGHT_CLICK:
			appendText("\n右键单击\n————————");
			break;
		case Laya.Event.MOUSE_MOVE:
			// 如果上一个操作是移动，提示信息仅加入.字符
			if (/鼠标移动\.*$/.test(txt.text))
				appendText(".");
			else
				appendText("\n鼠标移动");
			break;
		case Laya.Event.MOUSE_OVER:
			appendText("\n鼠标经过目标");
			break;
		case Laya.Event.MOUSE_OUT:
			appendText("\n鼠标移出目标");
			break;
		case Laya.Event.DOUBLE_CLICK:
			appendText("\n鼠标左键双击\n————————");
			break;
		case Laya.Event.MOUSE_WHEEL:
			appendText("\n鼠标滚轮滚动");
			break;
	}
}

 function appendText(value)
{
	txt.text += value;
	txt.scrollY = txt.maxScrollY;
}

/**添加提示文本*/
 function createTxt()
{
	txt = new Laya.Text();
	
	txt.overflow = Laya.Text.SCROLL;
	txt.text = "请把鼠标移到到矩形方块,左右键操作触发相应事件\n";
	txt.size(550, 300);
	txt.pos(10, 50);
	txt.fontSize = 20;
	txt.wordWrap = true;
	txt.color = "#000000";
	
	Laya.stage.addChild(txt);
}