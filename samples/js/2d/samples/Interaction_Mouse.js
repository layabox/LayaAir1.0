(function()
{
	var Sprite  = Laya.Sprite;
	var Stage   = Laya.Stage;
	var Text    = Laya.Text;
	var Event   = Laya.Event;
	var Browser = Laya.Browser;
	var WebGL   = Laya.WebGL;

	var txt;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		setup();
	})();

	function setup()
	{
		createInteractiveTarget();
		createLogger();
	}

	function createInteractiveTarget()
	{
		var rect = new Sprite();
		rect.graphics.drawRect(0, 0, 200, 200, "#D2691E");

		rect.size(200, 200);
		rect.x = (Laya.stage.width - 200) / 2;
		rect.y = (Laya.stage.height - 200) / 2;
		Laya.stage.addChild(rect);

		//增加鼠标事件
		rect.on(Event.MOUSE_DOWN, this, mouseHandler);
		rect.on(Event.MOUSE_UP, this, mouseHandler);
		rect.on(Event.CLICK, this, mouseHandler);
		rect.on(Event.RIGHT_MOUSE_DOWN, this, mouseHandler);
		rect.on(Event.RIGHT_MOUSE_UP, this, mouseHandler);
		rect.on(Event.RIGHT_CLICK, this, mouseHandler);
		rect.on(Event.MOUSE_MOVE, this, mouseHandler);
		rect.on(Event.MOUSE_OVER, this, mouseHandler);
		rect.on(Event.MOUSE_OUT, this, mouseHandler);
		rect.on(Event.DOUBLE_CLICK, this, mouseHandler);
		rect.on(Event.MOUSE_WHEEL, this, mouseHandler);
	}

	/**
	 * 鼠标响应事件处理
	 */
	function mouseHandler(e)
	{
		switch (e.type)
		{
			case Event.MOUSE_DOWN:
				appendText("\n————————\n左键按下");
				break;
			case Event.MOUSE_UP:
				appendText("\n左键抬起");
				break;
			case Event.CLICK:
				appendText("\n左键点击\n————————");
				break;
			case Event.RIGHT_MOUSE_DOWN:
				appendText("\n————————\n右键按下");
				break;
			case Event.RIGHT_MOUSE_UP:
				appendText("\n右键抬起");
				break;
			case Event.RIGHT_CLICK:
				appendText("\n右键单击\n————————");
				break;
			case Event.MOUSE_MOVE:
				// 如果上一个操作是移动，提示信息仅加入.字符
				if (/鼠标移动\.*$/.test(txt.text))
					appendText(".");
				else
					appendText("\n鼠标移动");
				break;
			case Event.MOUSE_OVER:
				appendText("\n鼠标经过目标");
				break;
			case Event.MOUSE_OUT:
				appendText("\n鼠标移出目标");
				break;
			case Event.DOUBLE_CLICK:
				appendText("\n鼠标左键双击\n————————");
				break;
			case Event.MOUSE_WHEEL:
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
	function createLogger()
	{
		txt = new Text();

		txt.overflow = Text.SCROLL;
		txt.text = "请把鼠标移到到矩形方块,左右键操作触发相应事件\n";
		txt.size(Laya.stage.width, Laya.stage.height);
		txt.pos(10, 50);
		txt.fontSize = 20;
		txt.wordWrap = true;
		txt.color = "#FFFFFF";

		Laya.stage.addChild(txt);
	}
})();