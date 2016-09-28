package 
{
	import laya.display.Input;
	import laya.display.Stage;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	/**
	 * ...
	 * @author Survivor
	 */
	public class Text_InputType 
	{
		
		public function Text_InputType() 
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(550, 600);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#FFFFFF";
			
			createInput(Input.TYPE_TEXT);
			createInput(Input.TYPE_DATE).y = 50;
			createInput(Input.TYPE_MONTH).y = 100;
			createInput(Input.TYPE_WEEK).y = 150;
			createInput(Input.TYPE_TIME).y = 200;
			createInput(Input.TYPE_DATE_TIME).y = 250;
			createInput(Input.TYPE_DATE_TIME_LOCAL).y = 300;
			createInput(Input.TYPE_EMAIL).y = 350;
			createInput(Input.TYPE_URL).y = 400;
			createInput(Input.TYPE_NUMBER).y = 450;
			createInput(Input.TYPE_RANGE).y = 500;
			createInput(Input.TYPE_SEARCH).y = 550;
		}
		
		private function createInput(type:String):Input
		{
			var inputText:Input = new Input();
			
			inputText.type = type;
			inputText.prompt = "type - " + type;
			
			inputText.size(550, 50);
			
			// 设置字体样式
			inputText.bold = true;
			inputText.borderColor = "#000000";
			inputText.fontSize = 20;
			
			Laya.stage.addChild(inputText);
			
			return inputText;
		}
	}

}