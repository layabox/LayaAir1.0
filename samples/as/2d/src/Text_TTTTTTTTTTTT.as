package 
{
	import laya.display.Input;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	
	public class Text_InputSingleline 
	{
		
		public function Text_InputSingleline() 
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			createInput(0,0,false);
			createInput(0,200,true);
		}
		
		private function createInput(x:int, y:int, m:Boolean):void
		{
			
			var inputText:Input = new Input();
			
			inputText.size(350, 100);
			inputText.pos(x, y);
			
			// 移动端输入提示符
			inputText.multiline = m;
			inputText.prompt = "Type some word...";
			//inputText.text = '1\nssssssssssssssssssss';
			
			// 输入期间输入框的位置偏移
			inputText.inputElementXAdjuster = 0;
			inputText.inputElementYAdjuster = 1;
			// 设置字体样式
			inputText.bold = true;
			inputText.bgColor = "#666666";
			inputText.color = "#ffffff";
			inputText.fontSize = 20;
			
			trace(inputText.textWidth);
			Laya.stage.addChild(inputText);
		}
	}
}