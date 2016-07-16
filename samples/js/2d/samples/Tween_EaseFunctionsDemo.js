(function()
{
	// 项渲染器
	var Box   = Laya.Box;
	var Label = Laya.Label;

	function ListItemRender()
	{
		var label = null;
		ListItemRender.__super.call(this);

		this.size(100, 20);

		label = new Label();
		label.fontSize = 12;
		label.color = "#FFFFFF";
		this.addChild(label);

		this.setLabel = function(value)
		{
			label.text = value;
		}
	}

	Laya.class(ListItemRender, "ListItemRender", Box);


	// 主要逻辑代码
	var Input   = Laya.Input;
	var Sprite  = Laya.Sprite;
	var Stage   = Laya.Stage;
	var Text    = Laya.Text;
	var Event   = Laya.Event;
	var List    = Laya.List;
	var Browser = Laya.Browser;
	var Ease    = Laya.Ease;
	var Handler = Laya.Handler;
	var Tween   = Laya.Tween;
	var WebGL   = Laya.WebGL;

	var character;
	var duration = 2000;
	var tween;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(550, 400, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		setup();
	})();

	function setup()
	{
		createCharacter();
		createEaseFunctionList();
		createDurationCrontroller();
	}

	function createCharacter()
	{
		character = new Sprite();
		character.loadImage("../../res/cartoonCharacters/1.png");
		character.pos(100, 50);
		Laya.stage.addChild(character);
	}

	function createEaseFunctionList()
	{
		var easeFunctionsList = new List();

		easeFunctionsList.itemRender = ListItemRender;
		easeFunctionsList.pos(5, 5);

		easeFunctionsList.repeatX = 1;
		easeFunctionsList.repeatY = 20;

		easeFunctionsList.vScrollBarSkin = '';

		easeFunctionsList.selectEnable = true;
		easeFunctionsList.selectHandler = new Handler(this, onEaseFunctionChange, [easeFunctionsList]);
		easeFunctionsList.renderHandler = new Handler(this, renderList);
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
		tween = Tween.to(character,
		{
			x: 350,
			y: 250
		}, duration, Ease[list.selectedItem]);
	}

	function createDurationCrontroller()
	{
		var durationInput = createInputWidthLabel("Duration:", '2000', 400, 10);
		durationInput.on(Event.INPUT, this, function()
		{
			duration = parseInt(durationInput.text);
		});
	}

	function createInputWidthLabel(label, prompt, x, y)
	{
		var text = new Text();
		text.text = label;
		text.color = "white";
		Laya.stage.addChild(text);
		text.pos(x, y);

		var input = new Input();
		input.size(50, 20);
		input.text = prompt;
		input.align = 'center';
		Laya.stage.addChild(input);
		input.color = "#FFFFFF";
		input.borderColor = "#FFFFFF";
		input.pos(text.x + text.width + 10, text.y - 3);
		input.inputElementYAdjuster = 1;

		return input
	}
})();