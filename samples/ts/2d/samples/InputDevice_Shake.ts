module laya {
	import Sprite  = laya.display.Sprite;
	import Stage   = laya.display.Stage;
	import Text    = laya.display.Text;
	import Shake   = laya.device.Shake;
	import Browser = laya.utils.Browser;
	import Handler = laya.utils.Handler;
	import Event   = laya.events.Event;

	 export class InputDevice_Shake {
		private picW:number = 484;
		private picH:number = 484;
		private console:Text;
		
		private shakeCount:number = 0;
		constructor() {
			Laya.init(this.picW, Browser.height * this.picW / Browser.width);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			this.showShakePic();
			this.showConsoleText();
			this.startShake();
		}
		private showShakePic():void 
		{
			var shakePic:Sprite = new Sprite();
			shakePic.loadImage("../../res/inputDevice/shake.png");
			Laya.stage.addChild(shakePic);
		}
		
		private showConsoleText():void
		{
			this.console = new Text();
			Laya.stage.addChild(this.console);
			
			this.console.y = this.picH + 10;
			this.console.width = Laya.stage.width;
			this.console.height = Laya.stage.height - this.console.y;
			this.console.color = "#FFFFFF";
			this.console.fontSize = 50;
			this.console.align = "center";
			this.console.valign = 'middle';
			this.console.leading = 10;
		}
		
		private startShake():void 
		{
			Shake.instance.start(5, 500);
			Shake.instance.on(Event.CHANGE, this, this.callback);
			this.console.text = '开始接收设备摇动\n';
		}
		
		private callback():void
		{
			this.shakeCount++;
			
			this.console.text += "设备摇晃了" + this.shakeCount + "次\n";
			
			if (this.shakeCount >= 3)
			{
				Shake.instance.stop();
				
				this.console.text += "停止接收设备摇动";
			}
		}
	 }
}
new laya.InputDevice_Shake();