/// <reference path="../../libs/LayaAir.d.ts" />
import Input = laya.display.Input;

class Text_Restrict 
{
	public constructor() 
	{
		Laya.init(550, 400);
		
		this.createLabel("只允许输入数字：").pos(50, 20);
		var input:Input = this.createInput();
		input.pos(50, 50);
		input.restrict = "0-9";
		
		this.createLabel("只允许输入字母：").pos(50, 100);
		input = this.createInput();
		input.pos(50, 130);
		input.restrict = "a-zA-Z";
		
		this.createLabel("只允许输入中文字符：").pos(50, 180);
		input = this.createInput();
		input.pos(50, 210);
		input.restrict = "^\\x00-\\xFF";
	}
	
	private createLabel(text: string): laya.display.Text
	{
		var label: laya.display.Text = new laya.display.Text();
		label.text = text;
		label.color = "white";
		label.fontSize = 20;
		Laya.stage.addChild(label);
		return label;
	}
	
	private createInput():Input 
	{
		var input:Input = new Input();
		input.size(200, 30);

		input.borderColor = "#FFFF00";
		input.bold = true; 
		input.fontSize = 20;
		input.color = "#FFFFFF";
		input.padding = [0, 4, 0, 4];
		
		input.inputElementYAdjuster = 1;
		Laya.stage.addChild(input);
		return input;
	}
}
new Text_Restrict();