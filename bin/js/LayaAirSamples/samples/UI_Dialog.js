(function()
{
	var Stage = Laya.Stage;
	var Button = Laya.Button;
	var Dialog = Laya.Dialog;
	var Image = Laya.Image;
	var Handler = Laya.Handler;
	var WebGL = Laya.WebGL;

	var DIALOG_WIDTH = 220;
	var DIALOG_HEIGHT = 275;
	var CLOSE_BTN_WIDTH = 43;
	var CLOSE_BTN_PADDING = 5;

	var assets;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(800, 600, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		assets = ["res/ui/dialog (1).png", "res/ui/close.png"];
		Laya.loader.load(assets, Handler.create(this, onSkinLoadComplete));
	})();

	function onSkinLoadComplete()
	{
		var dialog = new Dialog();

		var bg = new Image(assets[0]);
		dialog.addChild(bg);

		var button = new Button(assets[1]);
		button.name = Dialog.CLOSE;
		button.pos(DIALOG_WIDTH - CLOSE_BTN_WIDTH - CLOSE_BTN_PADDING, CLOSE_BTN_PADDING);
		dialog.addChild(button);

		dialog.dragArea = "0,0," + DIALOG_WIDTH + "," + DIALOG_HEIGHT;
		dialog.show();
	}
})();