package
{
	import laya.display.Stage;
	import laya.ui.RadioGroup;
	import laya.utils.Handler;
	
	public class UI_RadioGroup
	{
		private const SPACING:int = 150;
		private const X_OFFSET:int = 60;
		private const Y_OFFSET:int = 120;
		
		private var skins:Array;
		
		public function UI_RadioGroup()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			skins = ["res/ui/radioButton (1).png", "res/ui/radioButton (2).png", "res/ui/radioButton (3).png"];
			Laya.loader.load(skins, Handler.create(this, initRadioGroups));
		}

		private function initRadioGroups():void
		{
			for (var i:int = 0; i < skins.length;++i)
			{
				var rg:RadioGroup = createRadioGroup(skins[i]);
				rg.selectedIndex = i;
				rg.x = i * SPACING + X_OFFSET;
				rg.y = Y_OFFSET;
			}
		}
		
		private function createRadioGroup(skin:String):RadioGroup
		{
			var rg:RadioGroup = new RadioGroup();
			rg.skin = skin;
			
			rg.space = 70;
			rg.direction = "v";
				
			rg.labels = "Item1, Item2, Item3";
			rg.labelColors = "#787878,#d3d3d3,#FFFFFF";
			rg.labelSize = 20;
			rg.labelBold = true;
			rg.labelPadding = "5,0,0,5";
			
			rg.selectHandler = new Handler(this, onSelectChange);
			Laya.stage.addChild(rg);

			return rg;
		}

		private function onSelectChange(index:int):void
		{
			trace("你选择了第 " + (index + 1) + " 项");
		}
	}
}