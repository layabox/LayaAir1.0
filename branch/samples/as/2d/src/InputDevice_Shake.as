package 
{
	import laya.device.Shake;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	import laya.utils.Browser;
	/**
	 * ...
	 * @author Survivor
	 */
	public class InputDevice_Shake 
	{
		private var picW:int = 824;
		private var picH:int = 484;
		private var console:Text;
		
		private var shakeCount:int = 0;
		
		public function InputDevice_Shake() 
		{
			Laya.init(picW, Browser.height * picW / Browser.width);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			showShakePic();
			showConsoleText();
			startShake();
		}
		
		private function showShakePic():void 
		{
			var shakePic:Sprite = new Sprite();
			shakePic.loadImage("../../../../res/inputDevice/shake.png");
			Laya.stage.addChild(shakePic);
		}
		
		private function showConsoleText():void
		{
			console = new Text();
			Laya.stage.addChild(console);
			
			console.y = picH + 10;
			console.width = Laya.stage.width;
			console.height = Laya.stage.height - console.y;
			console.color = "#FFFFFF";
			console.fontSize = 50;
			console.align = "center";
			console.valign = 'middle';
			console.leading = 10;
		}
		
		private function startShake():void 
		{
			Shake.instance.start(5, 500);
			Shake.instance.on(Event.CHANGE, this, onShake);
			
			console.text = '开始接收设备摇动\n';
		}
		
		private function onShake():void
		{
			shakeCount++;
			
			console.text += "设备摇晃了" + shakeCount + "次\n";
			
			if (shakeCount >= 3)
			{
				Shake.instance.stop();
				
				console.text += "停止接收设备摇动";
			}
		}
	}
}