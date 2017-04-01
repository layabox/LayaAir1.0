package
{
	import laya.display.Stage;
	import laya.ui.ComboBox;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class UI_ComboBox	
	{
		private var skin:String = "../../../../res/ui/combobox.png";
		
		public function UI_ComboBox() 
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(800, 600, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			Laya.loader.load(skin, Handler.create(this, onLoadComplete));
		}
		
		private function onLoadComplete(e:*=null):void
		{
			var cb:ComboBox = createComboBox(skin);
			cb.autoSize = true;
			cb.pos((Laya.stage.width - cb.width) / 2, 100);
			cb.autoSize = false;
		}
		
		private function createComboBox(skin:String):ComboBox
		{
			var comboBox:ComboBox = new ComboBox(skin, "item0,item1,item2,item3,item4,item5");
			comboBox.labelSize = 30;
			comboBox.itemSize = 25;
			comboBox.selectHandler = new Handler(this, onSelect, [comboBox]);
			Laya.stage.addChild(comboBox);
			
			return comboBox;
		}
		
		private function onSelect(cb:ComboBox,e:*=null):void
		{
			trace("选中了： " + cb.selectedLabel);
		}
	}
}