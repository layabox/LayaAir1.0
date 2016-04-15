package
 {
	import laya.display.Stage;
	import laya.ui.Image;	
	
	public class UI_Image
	{
		public function UI_Image()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			var dialog:Image = new Image("res/ui/dialog (3).png");
			dialog.pos(165, 62.5);
			Laya.stage.addChild(dialog);
		}
	}
 }