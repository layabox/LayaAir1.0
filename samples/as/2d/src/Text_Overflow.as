package
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.utils.Browser;
	import laya.webgl.WebGL;

	public class Text_Overflow
	{
		public function Text_Overflow()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(600, 300, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			createTexts();
		}

		private function createTexts():void
		{
			var t1:Text = createText();
			t1.overflow = Text.VISIBLE;
			t1.pos(10, 10);

			var t2:Text = createText();
			t2.overflow = Text.SCROLL;
			t2.pos(10, 110);

			var t3:Text = createText();
			t3.overflow = Text.HIDDEN;
			t3.pos(10, 210);
		}

		private function createText():Text
		{
			var txt:Text = new Text();
			
			txt.text = 
				"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！";
			
			txt.borderColor = "#FFFF00";
			
			txt.size(300, 50);
			txt.fontSize = 20;
			txt.color = "#ffffff";
			
			Laya.stage.addChild(txt);

			return txt;
		}
	}
}