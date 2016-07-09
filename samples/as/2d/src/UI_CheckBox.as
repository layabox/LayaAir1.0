package
{
	import laya.display.Stage;
	import laya.ui.CheckBox;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class UI_CheckBox
	{
		private const COL_AMOUNT:int = 2;
		private const ROW_AMOUNT:int = 3;
		private const HORIZONTAL_SPACING:int = 200;
		private const VERTICAL_SPACING:int = 100;
		private const X_OFFSET:int = 100;
		private const Y_OFFSET:int = 50;
		
		private var skins:Array;
		

		public function UI_CheckBox()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(800, 600, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			skins = ["res/ui/checkbox (1).png", "res/ui/checkbox (2).png", "res/ui/checkbox (3).png", "res/ui/checkbox (4).png", "res/ui/checkbox (5).png", "res/ui/checkbox (6).png"];
			
			Laya.loader.load(skins, Handler.create(this,onCheckBoxSkinLoaded));
		}
		
		private function onCheckBoxSkinLoaded(e:*=null):void 
		{
			var cb:CheckBox;
			for (var i:int = 0; i < COL_AMOUNT; ++i)
			{
				for (var j:int = 0; j < ROW_AMOUNT; ++j)
				{
					cb = createCheckBox(skins[i * ROW_AMOUNT + j]);
					cb.selected = true;
					
					cb.x = HORIZONTAL_SPACING * i + X_OFFSET;
					cb.y += VERTICAL_SPACING * j + Y_OFFSET;
					
					// 给左边的三个CheckBox添加事件使其能够切换标签
					if (i == 0)
					{
						cb.y += 20;
						cb.on("change", this, updateLabel, [cb]);
						updateLabel(cb);
					}
				}
			}
		}
		
		private function createCheckBox(skin:String):CheckBox
		{
			var cb:CheckBox = new CheckBox(skin);
			Laya.stage.addChild(cb);

			cb.labelColors = "white";
			cb.labelSize = 20;
			cb.labelFont = "Microsoft YaHei";
			cb.labelPadding = "3,0,0,5";
			
			return cb;
		}
		
		private function updateLabel(checkBox:CheckBox):void 
		{
			checkBox.label = checkBox.selected ? "已选中" : "未选中";
		}
	}
}