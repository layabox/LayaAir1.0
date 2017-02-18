package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.ui.Image;
	import laya.ui.Panel;
	import laya.utils.Browser;
	/**
	 * ...
	 * @author suvivor
	 */
	public class UI_Panel 
	{
		
		public function UI_Panel() 
		{
			Laya.init(800, 600);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";
			
			setup();
		}
		
		private function setup():void 
		{
			var panel:Panel = new Panel();
			panel.hScrollBarSkin = "../../../../res/ui/hscroll.png";
			panel.hScrollBar.hide = true;
			panel.size(600, 275);
			panel.x = (Laya.stage.width - panel.width) / 2;
			panel.y = (Laya.stage.height - panel.height) / 2;
			Laya.stage.addChild(panel);
			
			var img:Image;
			for (var i:int = 0; i < 4; i++) 
			{
				img = new Image("../../../../res/ui/dialog (1).png");
				img.x = i * 250;
				panel.addChild(img);
			}
		}
		
	}

}