package
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.webgl.WebGL;
	
	public class Text_Underline
	{
		
		public function Text_Underline()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(600, 400, WebGL);
			
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";
				
			createTexts();
		}
		
		private function createTexts():void
		{
			createText('left', 1, null, 100, 10);
			createText('center', 2, "#00BFFF", 155, 150);
			createText('right', 3, "#FF7F50", 210, 290);
		}
	
		private function createText(align:String, underlineWidth:int, underlineColor:int, x:int, y:int):Text
		{
			var txt:Text = new Text();
			
			txt.text = "Layabox\n是HTML5引擎技术提供商\n与优秀的游戏发行商\n	面向AS/JS/TS开发者提供HTML5开发技术方案";
			
			txt.size(300, 50);
			txt.fontSize = 20;
			txt.color = "#ffffff";
			txt.align = align;
			txt.underline = true;
			txt.underlineWidth = underlineWidth;
			txt.underlineColor = underlineColor;
			txt.pos(x, y);
			
			Laya.stage.addChild(txt);

			return txt;
		}
	}

}