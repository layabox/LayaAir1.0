package
{
	import laya.display.Stage;
	import laya.ui.Button;
	import laya.ui.Dialog;
	import laya.utils.Handler;
	import laya.ui.Image;
	
	public class UI_Dialog
	{
		private const DIALOG_WIDTH:int = 220;
		private const DIALOG_HEIGHT:int = 275;
		private const CLOSE_BTN_WIDTH:int = 43;
		private const CLOSE_BTN_PADDING:int = 5;
		
		private var assets:Array;
		
		public function UI_Dialog()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		
			assets = ["res/ui/dialog (1).png", "res/ui/close.png"];
			Laya.loader.load(assets, Handler.create(this, onSkinLoadComplete));
		}
		
		private function onSkinLoadComplete():void
		{
			var dialog:Dialog = new Dialog();
			
			var bg:Image = new Image(assets[0]);
			dialog.addChild(bg);
		
			var button:Button = new Button(assets[1]);
			button.name = Dialog.CLOSE;
			button.pos(DIALOG_WIDTH - CLOSE_BTN_WIDTH - CLOSE_BTN_PADDING, CLOSE_BTN_PADDING);
			dialog.addChild(button);
			
			dialog.dragArea = "0,0," + DIALOG_WIDTH + "," + DIALOG_HEIGHT;
			dialog.show();
		}
	}
}