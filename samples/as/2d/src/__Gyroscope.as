package 
{
	import laya.device.motion.RotationInfo;
	import laya.display.Text;
	import laya.device.motion.Gyroscope;
	import laya.utils.Handler;
	/**
	 * ...
	 * @author Survivor
	 */
	public class __Gyroscope 
	{
		private  var text:Text;
		
		public function __Gyroscope() 
		{
			Laya.init(800, 600);
			
			text = new Text();
			text.fontSize = 50;
			text.color = "#FFFFFF";
			Laya.stage.addChild(text);
			text.text = "sdfadsf";
			
			Gyroscope.instance.listen(new Handler(this, onupdate));
		}
		
		private function onupdate(absolute, gyroscopeInfo:RotationInfo):void 
		{
			text.text = "abs: " + absolute+ "\n" +
			"alpha: " + gyroscopeInfo.alpha + "\n" +
			"beta: " + gyroscopeInfo.beta + "\n" +
			"gamma: " + gyroscopeInfo.gamma;
		}
		
	}

}