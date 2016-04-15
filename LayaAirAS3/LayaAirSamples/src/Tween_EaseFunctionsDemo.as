package
{
	import laya.display.Input;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	
	import laya.ui.List;
	import laya.utils.Ease;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	public class Tween_EaseFunctionsDemo
	{
		private var character:Sprite;
		private var duration:int = 2000;
		private var tween:Tween;
		
		public function Tween_EaseFunctionsDemo() 
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#3D3D3D";
			
			createCharacter();
			createEaseFunctionList();
			createDurationCrontroller();
		}

		private function createCharacter():void 
		{
			character = new Sprite();
			character.loadImage("res/cartoonCharacters/1.png");
			character.pos(100, 50);
			Laya.stage.addChild(character);
		}
		
		private function createEaseFunctionList():void
		{
			var easeFunctionsList:List = new List();
			
			easeFunctionsList.itemRender = ListItemRender;
			easeFunctionsList.pos(5,5);

			easeFunctionsList.repeatX = 1;
			easeFunctionsList.repeatY = 20;

			easeFunctionsList.vScrollBarSkin = '';

			easeFunctionsList.selectEnable = true;
			easeFunctionsList.selectHandler = new Handler(this, onEaseFunctionChange, [easeFunctionsList]);
			easeFunctionsList.renderHandler = new Handler(this, renderList);
			Laya.stage.addChild(easeFunctionsList);

			var data:Array = [];
			data.push('backIn', 'backOut', 'backInOut');
			data.push('bounceIn', 'bounceOut', 'bounceInOut');
			data.push('circIn', 'circOut', 'circInOut');
			data.push('cubicIn', 'cubicOut', 'cubicInOut');
			data.push('elasticIn', 'elasticOut', 'elasticInOut');
			data.push('expoIn', 'expoOut', 'expoInOut');
			data.push('linearIn', 'linearOut', 'linearInOut');
			data.push('linearNone');
			data.push('QuadIn', 'QuadOut', 'QuadInOut');
			data.push('quartIn', 'quartOut', 'quartInOut');
			data.push('quintIn', 'quintOut', 'quintInOut');
			data.push('sineIn', 'sineOut', 'sineInOut');
			data.push('strongIn', 'strongOut', 'strongInOut');

			easeFunctionsList.array = data;
		}

		private function renderList(item:ListItemRender):void
		{
			item.setLabel(item.dataSource);
		}
		
		private function onEaseFunctionChange(list:List):void
		{
			character.pos(100, 50);
			
			tween && tween.clear();
			tween = Tween.to(character, { x : 350, y:250 }, duration, Ease[list.selectedItem]);
		}
		
		private function createDurationCrontroller():void
		{
			var durationInput:Input = createInputWidthLabel("Duration:", '2000', 400, 10);
			durationInput.on(Event.INPUT, this, function():void
			{
				duration = parseInt(durationInput.text);
			});
		}
		
		private function createInputWidthLabel(label:String, prompt:String, x:int, y:int):Input
		{
			var text:Text = new Text();
			text.text = label;
			text.color = "white";
			Laya.stage.addChild(text);
			text.pos(x, y);
			
			var input:Input = new Input();
			input.size(50,20);
			input.text = prompt;
			Laya.stage.addChild(input);
			input.color = "white";
			input.borderColor = "white";
			input.pos(text.x + text.width + 10, text.y - 3);
			input.inputElementXAdjuster = -1;
			input.inputElementYAdjuster = 1;
			
			return input
		}
	}
}

import laya.ui.Box;
import laya.ui.Label;
class ListItemRender extends Box
{
	private var label:Label;
	
	public function ListItemRender()
	{
		size(100, 20);
		
		label = new Label();
		label.fontSize = 12;
		label.color = "#FFFFFF";
		addChild(label);
	}
	
	public function setLabel(value:String):void
	{
		label.text = value;
	}
}