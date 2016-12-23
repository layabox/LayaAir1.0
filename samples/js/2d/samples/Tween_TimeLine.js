(function ()
{
	var Sprite = Laya.Sprite;
	var Stage = Laya.Stage;
	var Event = Laya.Event;
	var Keyboard = Laya.Keyboard;
	var TimeLine = Laya.TimeLine;
	var WebGL = Laya.WebGL;


	var target;
	var timeLine = new TimeLine();
	(function ()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(550, 400, WebGL);
		
		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;
		
		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";
		
		setup();
	})();
	function setup()
	{	
		createApe();
		createTimerLine();
		Laya.stage.on( Event.KEY_DOWN, this, this.keyDown);
	}
	function createApe()
	{
		target = new Sprite();
		target.loadImage("../../res/apes/monkey2.png");
		Laya.stage.addChild(target);
		target.pivot(55, 72);
		target.pos(100,100);
	}
	
	function createTimerLine()
	{
		
		timeLine.addLabel("turnRight",0).to(target,{x:450, y:100, scaleX:0.5, scaleY:0.5},2000,null,0)
				.addLabel("turnDown",0).to(target,{x:450, y:300, scaleX:0.2, scaleY:1, alpha:1},2000,null,0)
				.addLabel("turnLeft",0).to(target,{x:100, y:300, scaleX:1, scaleY:0.2, alpha:0.1},2000,null,0)
				.addLabel("turnUp",0).to(target,{x:100, y:100, scaleX:1, scaleY:1, alpha:1},2000,null,0);
		timeLine.play(0,true);
		timeLine.on(Event.COMPLETE,this,this.onComplete);
		timeLine.on(Event.LABEL, this, this.onLabel);
	}	
	function onComplete()
	{
		console.log("timeLine complete!!!!");
	}
	function onLabel(label)
	{
		console.log("LabelName:" + label);
	}
	function keyDown(e)
	{
		switch(e.keyCode)
		{
			case Keyboard.LEFT:
				timeLine.play("turnLeft");
				break;
			case Keyboard.RIGHT:
				timeLine.play("turnRight");
				break;
			case Keyboard.UP:
				timeLine.play("turnUp");
				break;
			case Keyboard.DOWN:
				timeLine.play("turnDown");
				break;
			case Keyboard.P:
				timeLine.pause();
				break;
			case Keyboard.R:
				timeLine.resume();
				break;
		}
	}
})();