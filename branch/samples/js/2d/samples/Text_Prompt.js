(function()
{
	var Input = Laya.Input;
	var Stage = Laya.Stage;
	var WebGL = Laya.WebGL;
	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(550, 400, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		createInput();
	})();
	function createInput()
	{
		var inputText = new Input();
			
		inputText.size(350, 100);
		inputText.x = Laya.stage.width - inputText.width >> 1;
		inputText.y = Laya.stage.height - inputText.height >> 1;
		
		inputText.inputElementXAdjuster = -1;
		inputText.inputElementYAdjuster = 1;
		
		// 设置字体样式
		inputText.bold = true;
		inputText.bgColor = "#666666";
		inputText.color = "#ffffff";
		inputText.fontSize = 20;
		
		// 设置提示符
		inputText.prompt = "输入用户名";
		inputText.promptColor = "#000000";
		
		Laya.stage.addChild(inputText);
	}
})();
