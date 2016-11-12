package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.events.Keyboard;
	import laya.utils.TimeLine;
	import laya.webgl.WebGL;

	public class Tween_TimeLine
	{
		private var target:Sprite;
		private var timeLine:TimeLine = new TimeLine();
		public function Tween_TimeLine()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(550, 400, WebGL);
			
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";
			
			setup();
		}
		
		private function setup():void
		{	
			createApe();
			createTimerLine();
			Laya.stage.on( Event.KEY_DOWN, this, this.keyDown);
		}
		private function createApe():void
		{
			target = new Sprite();
			target.loadImage("../../../../res/apes/monkey2.png");
			Laya.stage.addChild(target);
			target.pivot(55, 72);
			target.pos(100,100);
		}
		
		private function createTimerLine():void
		{
			
			timeLine.addLabel("turnRight",0).to(target,{x:450, y:100, scaleX:0.5, scaleY:0.5},2000,null,0)
						.addLabel("turnDown",0).to(target,{x:450, y:300, scaleX:0.2, scaleY:1, alpha:1},2000,null,0)
						.addLabel("turnLeft",0).to(target,{x:100, y:300, scaleX:1, scaleY:0.2, alpha:0.1},2000,null,0)
						.addLabel("turnUp",0).to(target,{x:100, y:100, scaleX:1, scaleY:1, alpha:1},2000,null,0);
			timeLine.play(0,true);
			timeLine.on(Event.COMPLETE,this,this.onComplete);
			timeLine.on(Event.LABEL, this, this.onLabel);
		}	
		private function onComplete():void
		{
			trace("timeLine complete!!!!");
		}
		private function onLabel(label:String):void
		{
			trace("LabelName:" + label);
		}
		private function keyDown(e:Event):void
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
	}
}