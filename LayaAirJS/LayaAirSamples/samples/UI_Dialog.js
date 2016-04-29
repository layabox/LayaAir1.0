var DIALOG_WIDTH = 220;
var DIALOG_HEIGHT = 275;
var CLOSE_BTN_WIDTH = 43;
var CLOSE_BTN_PADDING = 5;

var assets;

Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

assets = ["res/ui/dialog (1).png", "res/ui/close.png"];
Laya.loader.load(assets, Laya.Handler.create(this, onSkinLoadComplete));

function onSkinLoadComplete()
{
	var dialog = new Laya.Dialog();
	
	var bg = new Laya.Image(assets[0]);
	dialog.addChild(bg);

	var button = new Laya.Button(assets[1]);
	button.name = Laya.Dialog.CLOSE;
	button.pos(DIALOG_WIDTH - CLOSE_BTN_WIDTH - CLOSE_BTN_PADDING, CLOSE_BTN_PADDING);
	dialog.addChild(button);
	
	dialog.dragArea = "0,0," + DIALOG_WIDTH + "," + DIALOG_HEIGHT;
	dialog.show();
}
