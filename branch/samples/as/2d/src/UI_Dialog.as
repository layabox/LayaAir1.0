package
{
	import laya.display.Stage;
	import laya.ui.Button;
	import laya.ui.Dialog;
	import laya.ui.Image;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class UI_Dialog
	{
		private const DIALOG_WIDTH:int = 220;
		private const DIALOG_HEIGHT:int = 275;
		private const CLOSE_BTN_WIDTH:int = 43;
		private const CLOSE_BTN_PADDING:int = 5;
		
		private var assets:Array;
		
		public function UI_Dialog()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(800, 600, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";
		
			assets = ["../../../../res/ui/dialog (1).png", "../../../../res/ui/close.png"];
			Laya.loader.load(assets, Handler.create(this, onSkinLoadComplete));
		}
		
		private function onSkinLoadComplete(e:*=null):void
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