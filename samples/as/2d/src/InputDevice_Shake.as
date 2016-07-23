package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.inputDevice.Shake;
	import laya.utils.Browser;
	import laya.utils.Handler;
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
			if (Shake.supported() == false)
			{
				alert("当前设备或浏览器不支持该功能");
				return;
			}
			
			Shake.start(5, 500, new Handler(this, callback));
			console.text = '开始接收设备摇动\n';
		}
		
		private function callback():void
		{
			shakeCount++;
			
			console.text += "设备摇晃了" + shakeCount + "次\n";
			
			if (shakeCount >= 3)
			{
				Shake.stop();
				
				console.text += "停止接收设备摇动";
			}
		}
	}
}