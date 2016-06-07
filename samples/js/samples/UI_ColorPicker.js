(function()
{
	var Stage       = Laya.Stage;
	var ColorPicker = Laya.ColorPicker;
	var Browser     = Laya.Browser;
	var Handler     = Laya.Handler;
	var WebGL       = Laya.WebGL;

	var skin = "res/ui/colorPicker.png";

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		Laya.loader.load(skin, Handler.create(this, onColorPickerSkinLoaded));
	})();

	function onColorPickerSkinLoaded()
	{
		var colorPicker = new ColorPicker();
		colorPicker.selectedColor = "#ff0033";
		colorPicker.skin = skin;

		colorPicker.pos(100, 100);
		colorPicker.changeHandler = new Handler(this, onChangeColor, [colorPicker]);
		Laya.stage.addChild(colorPicker);

		onChangeColor(colorPicker);
	}

	function onChangeColor(colorPicker)
	{
		console.log(colorPicker.selectedColor);
	}
})();