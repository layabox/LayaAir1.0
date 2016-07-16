(function()
{
	var Stage = Laya.Stage;
	var Image = Laya.Image;
	var WebGL = Laya.WebGL;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(550, 400, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		setup();
	})();

	function setup()
	{
		var dialog = new Image("../../res/ui/dialog (3).png");
		dialog.pos(165, 62.5);
		Laya.stage.addChild(dialog);
	}
})();