package
{
	import laya.display.Input;
	import laya.display.Stage;
	import laya.events.Event;
	
	public class Text_Prompt
	{
		private const PROMPT:String = "请输入名字...";
		private const PROMPT_COLOR:String = "gray";
		private const NORMAL_COLOR:String = "black";
		
		private var input:Input;
		
		public function Text_Prompt()
		{
			Laya.init(550, 400);
			
			createInput();
		}
		
		private function createInput():void
		{
			input = new Input();
			
			input.size(350, 100);
			input.pos(100, 150);
			
			input.inputElementXAdjuster = -1;
			input.inputElementYAdjuster = 1;
			
			input.bold = true;
			input.bgColor = "#FFFFFF";
			input.fontSize = 20;
			
			setPromptColor();
			input.text = PROMPT;
			input.on(Event.FOCUS, this, onInputFocusIn);
			input.on(Event.BLUR, this, onInputFocusOut);
			
			Laya.stage.addChild(input);
		}
		
		private function onInputFocusIn():void
		{
			if (input.text == PROMPT)
			{
				setNormalColor();
				input.text = "";
			}
		}
		
		private function onInputFocusOut():void
		{
			if (input.text.length == 0)
			{
				setPromptColor();
				input.text = PROMPT;
			}
		}
		
		private function setPromptColor():void
		{
			input.color = PROMPT_COLOR;
		}
		
		private function setNormalColor():void
		{
			input.color = NORMAL_COLOR;
		}
	}
}