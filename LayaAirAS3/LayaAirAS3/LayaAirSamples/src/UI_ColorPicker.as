package
{
	import laya.display.Stage;
	import laya.ui.ColorPicker;
	import laya.utils.Handler;
	
	public class UI_ColorPicker
	{
		private var skin:String = "res/ui/colorPicker.png";
		
		public function UI_ColorPicker()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.loader.load(skin, Handler.create(this, onColorPickerSkinLoaded));
		}
		
		private function onColorPickerSkinLoaded():void
		{
			var colorPicker:ColorPicker = new ColorPicker();
			colorPicker.selectedColor = "#ff0033";
			colorPicker.skin = skin;
			colorPicker.pos(100, 100);
			colorPicker.changeHandler = new Handler(this, onChangeColor, [colorPicker]);
			Laya.stage.addChild(colorPicker);
			
			onChangeColor(colorPicker);
		}
		
		private function onChangeColor(colorPicker:ColorPicker):void
		{
			trace(colorPicker.selectedColor);
		}
	}
}