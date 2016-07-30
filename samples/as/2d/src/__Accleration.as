package 
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.device.motion.AccelerationInfo;
	import laya.device.motion.Accelerator;
	import laya.utils.Browser;
	import laya.utils.Handler;
	/**
	 * ...
	 * @author Survivor
	 */
	public class __Accleration 
	{
		private var console:Text;
		
		public function __Accleration() 
		{
			Laya.init(Browser.window, Browser.height);
			Laya.stage.frameRate = Stage.FRAME_SLOW;
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			
			createConsoleText();
			Accelerator.instance.listen(new Handler(this, onMotion));
		}
		
		private function createConsoleText():void 
		{
			console = new Text();
			Laya.stage.addChild(console);
			
			console.fontSize = 100;
			console.color = "#FFFFFF";
			console.size(Laya.stage.width, Laya.stage.height);
		}
		
		private function onMotion(acceleration:AccelerationInfo, accelerationIncludingGravity,rotationRate, interval):void
		{			
			console.text = (acceleration.x | 0) + "\t" + (acceleration.y | 0) + "\t" + (acceleration.z | 0) + "\n";
			console.text += (accelerationIncludingGravity.x | 0) + "\t" + (accelerationIncludingGravity.y | 0) + "\t" + (accelerationIncludingGravity.z | 0) + "\n";
			console.text += (rotationRate.alpha | 0) + "\t" + (rotationRate.beta |0) + "\t" + (rotationRate.gamma | 0)	 + "\n";
			console.text += interval;
		}
	}

}