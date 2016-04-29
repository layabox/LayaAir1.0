/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
	import Sprite = laya.display.Sprite;
	import Event = laya.events.Event;
	import Keyboard = laya.events.Keyboard;
	import TimeLine = laya.utils.TimeLine;
	import Stage = laya.display.Stage;

	export class Tween_TimeLine {
		private target: Sprite;
		private timeLine: TimeLine = new TimeLine();

		constructor() {
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			this.setup();
		}

		private setup(): void {
			this.createApe();
			this.createTimerLine();

			Laya.stage.on(Event.KEY_DOWN, this, this.keyDown);
		}

		private keyDown(e: Event): void {
			switch (e["keyCode"]) {
				case Keyboard.LEFT:
					this.timeLine.gotoLabel("turnLeft");
					break;
				case Keyboard.RIGHT:
					this.timeLine.gotoLabel("turnRight");
					break;
				case Keyboard.UP:
					this.timeLine.gotoLabel("turnUp");
					break;
				case Keyboard.DOWN:
					this.timeLine.gotoLabel("turnDown");
					break;
				case Keyboard.P:
					this.timeLine.pause();
					break;
				case Keyboard.R:
					this.timeLine.resume();
					break;
			}
		}

		private createTimerLine(): void {
			//第一事件如果起始时间为0就不会抛出。
			this.timeLine.add("turnRight", 0);
			this.timeLine.to(this.target, { x: 450, y: 100, scaleX: 0.5, scaleY: 0.5 }, 2000);
			this.timeLine.add("turnDown", 0);
			this.timeLine.to(this.target, { x: 450, y: 300, scaleX: 0.2, scaleY: 1, alpha: 1 }, 2000);
			this.timeLine.add("turnLeft", 0);
			this.timeLine.to(this.target, { x: 100, y: 300, scaleX: 1, scaleY: 0.2, alpha: 0.1 }, 2000);
			this.timeLine.add("turnUp", 0);
			this.timeLine.to(this.target, { x: 100, y: 100, scaleX: 1, scaleY: 1, alpha: 1 }, 2000);

			this.timeLine.play(0, true);

			this.timeLine.on(Event.COMPLETE, this, this.onComplete);
			this.timeLine.on(Event.LABEL, this, this.onLabel);
		}

		private onComplete(): void {
			console.log("timeLine complete!!!!");
		}

		private onLabel(label: String): void {
			console.log("LabelName:" + label);
		}

		private createApe(): void {
			this.target = new Sprite();
			this.target.loadImage("res/apes/monkey2.png");
			Laya.stage.addChild(this.target);
			this.target.pivot(55, 72);
			this.target.pos(100, 100);
		}
	}
}
new laya.Tween_TimeLine();