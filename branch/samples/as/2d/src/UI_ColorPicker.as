package
{
	import laya.display.Stage;
	import laya.ui.ColorPicker;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class UI_ColorPicker
	{
		private var skin:String = "../../../../res/ui/colorPicker.png";
		
		public function UI_ColorPicker()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			Laya.loader.load(skin, Handler.create(this, onColorPickerSkinLoaded));
		}
		
		private function onColorPickerSkinLoaded(e:*=null):void
		{
			var colorPicker:ColorPicker = new ColorPicker();
			colorPicker.selectedColor = "#ff0033";
			colorPicker.skin = skin;
			
			colorPicker.pos(100, 100);
			colorPicker.changeHandler = new Handler(this, onChangeColor, [colorPicker]);
			Laya.stage.addChild(colorPicker);
			
			onChangeColor(colorPicker);
		}
		
		private function onChangeColor(colorPicker:ColorPicker,e:*=null):void
		{
			trace(colorPicker.selectedColor);
		}
	}
}