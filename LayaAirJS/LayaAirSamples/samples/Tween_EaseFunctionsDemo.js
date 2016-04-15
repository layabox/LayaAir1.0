(function(_super)
{
	function ListItemRender()
	{
		var label = null;
		ListItemRender.__super.call(this);

		this.size(100, 20);
		
		label = new laya.ui.Label();
		label.fontSize = 12;
		label.color = "#FFFFFF";
		this.addChild(label);

		this.setLabel = function(value)
		{
			label.text = value;
		}
	}

	Laya.class(ListItemRender, "ListItemRender", _super);
})(laya.ui.Box);


var character;
var duration = 2000;
var tween;
	
Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
Laya.stage.bgColor = "#3D3D3D";

createCharacter();
createEaseFunctionList();
createDurationCrontroller();

function createCharacter()
{
	character = new laya.display.Sprite();
	character.loadImage("res/cartoonCharacters/1.png");
	character.pos(100, 50);
	Laya.stage.addChild(character);
}
	
function createEaseFunctionList()
{
	var easeFunctionsList = new laya.ui.List();
	
	easeFunctionsList.itemRender = ListItemRender;
	easeFunctionsList.pos(5,5);

	easeFunctionsList.repeatX = 1;
	easeFunctionsList.repeatY = 20;

	easeFunctionsList.vScrollBarSkin = '';

	easeFunctionsList.selectEnable = true;
	easeFunctionsList.selectHandler = new laya.utils.Handler(this, onEaseFunctionChange, [easeFunctionsList]);
	easeFunctionsList.renderHandler = new laya.utils.Handler(this, renderList);
	Laya.stage.addChild(easeFunctionsList);

	var data = [];
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

function renderList(item)
{
	item.setLabel(item.dataSource);
}

function onEaseFunctionChange(list)
{
	character.pos(100, 50);
	
	tween && tween.clear();
	tween = laya.utils.Tween.to(character, { x : 350, y:250 }, duration, laya.utils.Ease[list.selectedItem]);
}

function createDurationCrontroller()
{
	var durationInput = createInputWidthLabel("Duration:", '2000', 400, 10);
	durationInput.on(laya.events.Event.INPUT, this, function()
	{
		duration = parseInt(durationInput.text);
	});
}

function createInputWidthLabel(label, prompt, x, y)
{
	var text = new laya.display.Text();
	text.text = label;
	text.color = "white";
	Laya.stage.addChild(text);
	text.pos(x, y);
	
	var input = new laya.display.Input();
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