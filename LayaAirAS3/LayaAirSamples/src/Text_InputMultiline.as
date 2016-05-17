package 
{
	import laya.display.Input;
	import laya.display.Stage;
	
	public class Text_InputMultiline 
	{
		
		public function Text_InputMultiline() 
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			var inputText:Input = new Input();
			
			// 输入期间输入框的位置偏移
			inputText.inputElementXAdjuster = -2;
			inputText.inputElementYAdjuster = -1;
			
			//多行输入
			inputText.multiline = true;
			
			inputText.size(350, 100);
			inputText.pos(100, 150);
			inputText.padding = [2,2,2,2];
			
			inputText.bgColor = "#666666";
			inputText.color = "#ffffff";
			inputText.fontSize = 20;
			
			Laya.stage.addChild(inputText);
		}
		
	}
	
}