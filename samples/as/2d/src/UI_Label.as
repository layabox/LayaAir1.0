package 
{
	import laya.display.Stage;
	import laya.ui.Label;
	import laya.webgl.WebGL;
	
	public class UI_Label
	{
		public function UI_Label()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(800, 600, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			setup();			
		}

		private function setup():void
		{
			createLabel("#FFFFFF", null).pos(30, 50);
			createLabel("#00FFFF", null).pos(290, 50);
			createLabel("#FFFF00", "#FFFFFF").pos(30, 100);
			createLabel("#000000", "#FFFFFF").pos(290, 100);
			createLabel("#FFFFFF", "#00FFFF").pos(30, 150);
			createLabel("#0080FF", "#00FFFF").pos(290, 150);
		}
		
		private function createLabel(color:String, strokeColor:String):Label
		{
			const STROKE_WIDTH:int = 4;
			
			var label:Label = new Label();
			label.font = "Microsoft YaHei";
			label.text = "SAMPLE DEMO";
			label.fontSize = 30;
			label.color = color;
			
			if (strokeColor)
			{
				label.stroke = STROKE_WIDTH;
				label.strokeColor = strokeColor;
			}
			
			Laya.stage.addChild(label);
			
			return label;
		}
	}
}