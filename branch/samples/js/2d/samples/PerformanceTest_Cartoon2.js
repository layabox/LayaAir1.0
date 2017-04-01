(function()
{
	var Stage = Laya.Stage;
	var Text = Laya.Text;
	var Stat = Laya.Stat;
	var WebGL = Laya.WebGL;
	var Sprite = Laya.Sprite;
	var Animation = Laya.Animation;

	// Class Character
	function Character(images)
	{
		Character.super(this);

		Character.WIDTH = 110;
		Character.HEIGHT = 110;

		var bloodBar;
		var animation;
		var nameLabel;

		Character.prototype.createAnimation = function(images)
		{
			animation = new Animation();
			animation.loadImages(images);
			animation.interval = 70;
			animation.play(0);
			this.addChild(animation);
		}

		
		Character.prototype.createBloodBar = function()
		{
			bloodBar = new Sprite();
			bloodBar.loadImage("../../res/cartoon2/blood_1_r.png");
			bloodBar.x = 20;
			this.addChild(bloodBar);
		}

		Character.prototype.createNameLabel = function()
		{
			nameLabel = new Text();
			nameLabel.color = "#FFFFFF";
			nameLabel.text = "Default";
			nameLabel.fontSize = 13;
			nameLabel.width = Character.WIDTH;
			nameLabel.align = "center";
			this.addChild(nameLabel);
		}

		Character.prototype.setSpeed = function(value)
		{
			this.speed = value;
		}

		Character.prototype.setName = function(value)
		{
			nameLabel.text = value;
		}

		Character.prototype.update = function()
		{
			this.x += this.speed;
			if (this.x >= Laya.stage.width + Character.WIDTH)
				this.x = -Character.WIDTH;
		}

		this.createAnimation(images);
		this.createBloodBar();
		this.createNameLabel();
	}
	Laya.class(Character, "Character", Sprite);

	// Main
	var amount = 500;

	var character1 = [
		"../../res/cartoon2/yd-6_01.png",
		"../../res/cartoon2/yd-6_02.png",
		"../../res/cartoon2/yd-6_03.png",
		"../../res/cartoon2/yd-6_04.png",
		"../../res/cartoon2/yd-6_05.png",
		"../../res/cartoon2/yd-6_06.png",
		"../../res/cartoon2/yd-6_07.png",
		"../../res/cartoon2/yd-6_08.png",
	];
	var character2 = [
		"../../res/cartoon2/yd-3_01.png",
		"../../res/cartoon2/yd-3_02.png",
		"../../res/cartoon2/yd-3_03.png",
		"../../res/cartoon2/yd-3_04.png",
		"../../res/cartoon2/yd-3_05.png",
		"../../res/cartoon2/yd-3_06.png",
		"../../res/cartoon2/yd-3_07.png",
		"../../res/cartoon2/yd-3_08.png",
	];
	var character3 = [
		"../../res/cartoon2/yd-2_01.png",
		"../../res/cartoon2/yd-2_02.png",
		"../../res/cartoon2/yd-2_03.png",
		"../../res/cartoon2/yd-2_04.png",
		"../../res/cartoon2/yd-2_05.png",
		"../../res/cartoon2/yd-2_06.png",
		"../../res/cartoon2/yd-2_07.png",
		"../../res/cartoon2/yd-2_08.png",
	];
	var character4 = [
		"../../res/cartoon2/wyd-1_01.png",
		"../../res/cartoon2/wyd-1_02.png",
		"../../res/cartoon2/wyd-1_03.png",
		"../../res/cartoon2/wyd-1_04.png",
		"../../res/cartoon2/wyd-1_05.png",
		"../../res/cartoon2/wyd-1_06.png",
		"../../res/cartoon2/wyd-1_07.png",
		"../../res/cartoon2/wyd-1_08.png",
	];

	var characterSkins = [character1, character2, character3, character4];

	var characters = [];
	var text;

	// Constructor
	(function()
	{
		Laya.init(1280, 720, WebGL);
		Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
		Stat.enable();
		Laya.stage.loadImage("../../res/cartoon2/background.jpg", 0, 0, 1280, 900);

		createCharacters();

		text = new Text();
		text.zOrder = 10000;
		text.fontSize = 60;
		text.color = "#ff0000"
		Laya.stage.addChild(text);

		Laya.timer.frameLoop(1, this, gameLoop);
	})();

	function createCharacters()
	{
		var char;
		var charSkin;
		for (var i = 0; i < amount; i++)
		{
			charSkin = characterSkins[Math.floor(Math.random() * characterSkins.length)];
			char = new Character(charSkin);

			char.x = Math.random() * (Laya.stage.width + Character.WIDTH * 2);
			char.y = Math.random() * (Laya.stage.height - Character.HEIGHT);
			char.zOrder = char.y;

			char.setSpeed(Math.round(Math.random() * 2 + 3));
			char.setName(i.toString());

			Laya.stage.addChild(char);
			characters.push(char);
		}
	}

	function gameLoop()
	{
		for (var i = characters.length - 1; i >= 0; i--)
		{
			characters[i].update();
		}
		if (Laya.timer.currFrame % 60 === 0)
		{
			text.text = Stat.FPS.toString();
		}
	}
})();