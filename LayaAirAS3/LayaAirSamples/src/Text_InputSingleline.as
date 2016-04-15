package 
{
	import laya.display.Input;
	import laya.display.Stage;
	
	public class Text_InputSingleline 
	{
		
		public function Text_InputSingleline() 
		{
			Laya.init(550, 400);
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			var inputText:Input = new Input();
			
			inputText.size(350, 100);
			inputText.pos(100, 150);
			
			// 输入期间输入框的位置偏移
			inputText.inputElementXAdjuster = -1;
			inputText.inputElementYAdjuster = 1;
			
			// 设置字体样式
			inputText.bold = true;
			inputText.bgColor = "#666666";
			inputText.color = "#ffffff";
			inputText.fontSize = 20;
			
			Laya.stage.addChild(inputText);
		}
	}
}