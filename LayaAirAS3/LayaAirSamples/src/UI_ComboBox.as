package
{
	import laya.display.Stage;
	import laya.ui.ComboBox;
	import laya.utils.Handler;
	
	public class UI_ComboBox	
	{
		private var skin:String = "res/ui/comboBox.png";
		
		public function UI_ComboBox() 
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			Laya.loader.load(skin, Handler.create(this, onLoadComplete));
		}
		
		private function onLoadComplete():void
		{
			var cb:ComboBox = createComboBox(skin);
			cb.pos(120, 100);
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
		
		private function onSelect(cb:ComboBox):void
		{
			trace("选中了： " + cb.selectedLabel);
		}
	}
}