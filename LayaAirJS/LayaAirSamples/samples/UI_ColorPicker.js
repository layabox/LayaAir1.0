var skin = "res/ui/colorPicker.png";

Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
Laya.loader.load(skin, laya.utils.Handler.create(this,onColorPickerSkinLoaded));

function onColorPickerSkinLoaded()
{
	var colorPicker = new laya.ui.ColorPicker();
	colorPicker.skin = skin;
	colorPicker.selectedColor = "#ff0033";
	colorPicker.pos(100, 100);
	colorPicker.changeHandler = new laya.utils.Handler(this, onChangeColor,[colorPicker]);
	Laya.stage.addChild(colorPicker);
	
	onChangeColor(colorPicker);
}

function onChangeColor(colorPicker)
{
	console.log("你选中的颜色：" + colorPicker.selectedColor);
}