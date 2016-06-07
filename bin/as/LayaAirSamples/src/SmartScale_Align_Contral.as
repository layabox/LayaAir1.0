package 
{
	import laya.display.Stage;

	public class SmartScale_Align_Contral
	{
		public function SmartScale_Align_Contral() 
		{
			Laya.init(100, 100);
			Laya.stage.scaleMode = Stage.SCALE_NOSCALE;
			
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;

			Laya.stage.bgColor = "#232628";
		}
	}
}