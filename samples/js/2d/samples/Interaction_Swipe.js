(function()
{
	var Sprite  = Laya.Sprite;
	var Stage   = Laya.Stage;
	var Event   = Laya.Event;
	var Browser = Laya.Browser;
	var Tween   = Laya.Tween;
	var WebGL   = Laya.WebGL;

	//swipe滚动范围
	var TrackLength = 200;
	//触发swipe的拖动距离
	var TOGGLE_DIST = TrackLength / 2;

	var buttonPosition, beginPosition, endPosition;
	var button;

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
		createSprtie();
		drawTrack();
	}


	function createSprtie()
	{
		const w = 50;
		const h = 30;

		button = new Sprite();
		button.graphics.drawRect(0, 0, w, h, "#FF7F50");
		button.pivot(w / 2, h / 2);
		//设置宽高（要接收鼠标事件必须设置宽高，否则不会被命中）  
		button.size(w, h);
		button.x = (Laya.stage.width - TrackLength) / 2;
		button.y = Laya.stage.height / 2;

		button.on(Event.MOUSE_DOWN, this, onMouseDown);

		Laya.stage.addChild(button);
		//左侧临界点设为圆形初始位置
		beginPosition = button.x;
		//右侧临界点设置
		endPosition = beginPosition + TrackLength;
	}


	function drawTrack()
	{
		var graph = new Sprite();
		Laya.stage.graphics.drawLine(
			beginPosition, Laya.stage.height / 2,
			endPosition, Laya.stage.height / 2,
			"#FFFFFF", 20);
		Laya.stage.addChild(graph);
	}

	/**按下事件处理*/
	function onMouseDown(e)
	{
		//添加鼠标移到侦听
		Laya.stage.on(Event.MOUSE_MOVE, this, onMouseMove);
		buttonPosition = button.x;

		Laya.stage.on(Event.MOUSE_UP, this, onMouseUp);
		Laya.stage.on(Event.MOUSE_OUT, this, onMouseUp);
	}
	/**移到事件处理*/
	function onMouseMove(e)
	{
		button.x = Math.max(Math.min(Laya.stage.mouseX, endPosition), beginPosition);
	}


	/**抬起事件处理*/
	function onMouseUp(e)
	{
		Laya.stage.off(Event.MOUSE_MOVE, this, onMouseMove);
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUp);
		Laya.stage.off(Event.MOUSE_OUT, this, onMouseUp);

		// 滑动到目的地
		var dist = Laya.stage.mouseX - buttonPosition;

		var targetX = beginPosition;
		if (dist > TOGGLE_DIST)
			targetX = endPosition;
		Tween.to(button,
		{
			x: targetX
		}, 100);
	}
})();