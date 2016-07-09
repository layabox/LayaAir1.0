package 
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	public class PerformanceTest_T1 
	{
		private var amount:int = 500;
		
		private var character1:Array = [
			"res/images/yd-6_01.png",
			"res/images/yd-6_02.png",
			"res/images/yd-6_03.png",
			"res/images/yd-6_04.png",
			"res/images/yd-6_05.png",
			"res/images/yd-6_06.png",
			"res/images/yd-6_07.png",
			"res/images/yd-6_08.png",
		];
		private var character2:Array = [
			"res/images/yd-3_01.png",
			"res/images/yd-3_02.png",
			"res/images/yd-3_03.png",
			"res/images/yd-3_04.png",
			"res/images/yd-3_05.png",
			"res/images/yd-3_06.png",
			"res/images/yd-3_07.png",
			"res/images/yd-3_08.png",
		];
		private var character3:Array = [
			"res/images/yd-2_01.png",
			"res/images/yd-2_02.png",
			"res/images/yd-2_03.png",
			"res/images/yd-2_04.png",
			"res/images/yd-2_05.png",
			"res/images/yd-2_06.png",
			"res/images/yd-2_07.png",
			"res/images/yd-2_08.png",
		];
		private var character4:Array = [
			"res/images/wyd-1_01.png",
			"res/images/wyd-1_02.png",
			"res/images/wyd-1_03.png",
			"res/images/wyd-1_04.png",
			"res/images/wyd-1_05.png",
			"res/images/wyd-1_06.png",
			"res/images/wyd-1_07.png",
			"res/images/wyd-1_08.png",
		];
		
		private var characterSkins:Array = [character1, character2, character3, character4];
		
		private var characters:Array = [];
		private var text:Text;
		
		public function PerformanceTest_T1() 
		{
			Laya.init(1280, 720, WebGL);
			Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
			Stat.enable();			
			Laya.stage.loadImage("res/background.jpg", 0, 0, 1280, 900);
			
			createCharacters();
			
			text = new Text();
			text.zOrder = 10000;
			text.fontSize = 60;
			text.color = "#ff0000"
			Laya.stage.addChild(text);
			
			Laya.timer.frameLoop(1, this, gameLoop);
		}
		
		private function createCharacters():void 
		{
			var char:Character;
			var charSkin:Array;
			for (var i:int = 0; i < amount; i++)
			{
				charSkin = characterSkins[Math.floor(Math.random() * characterSkins.length)];
				char = new Character(charSkin);
				
				char.x = Math.random() * (Laya.stage.width + Character.WIDTH * 2);
				char.y = Math.random() * (Laya.stage.height - Character.HEIGHT);
				char.zOrder = char.y;
				
				char.setSpeed(Math.floor(Math.random() * 2 + 3));
				char.setName(i);
				
				Laya.stage.addChild(char);
				characters.push(char);
			}
		}
		
		private function gameLoop():void
		{
			for (var i:int = characters.length - 1; i >= 0; i--)
			{
				characters[i].update();
			}
			if (Laya.timer.currFrame % 60 === 0) {
				text.text = Stat.FPS;
			}			
		}
		
	}

}
import laya.display.Animation;
import laya.display.Sprite;
import laya.display.Text;
import laya.utils.Browser;

class Character extends Sprite
{
	public static const WIDTH:int = 110;
	public static const HEIGHT:int = 110;
	
	private var speed:int = 5;
	
	private var bloodBar:Sprite;
	private var animation:Animation;
	private var nameLabel:Text;
	
	public function Character(images:Array)
	{
		debugger;
		createAnimation(images);
		createBloodBar();
		createNameLabel();
	}
	
	private function createAnimation(images:Array):void 
	{
		animation = new Animation();
		animation.loadImages(images);
		animation.interval = 70;
		animation.play(0);
		this.addChild(animation);
	}
	
	private function createBloodBar():void 
	{
		bloodBar = new Sprite();
		bloodBar.loadImage("res/ui/blood_1_r.png");
		bloodBar.x = 20;
		this.addChild(bloodBar);
	}
	
	private function createNameLabel():void
	{
		nameLabel = new Text();
		nameLabel.color = "#FFFFFF";
		nameLabel.text = "Default";
		nameLabel.fontSize = 13;
		nameLabel.width = WIDTH;
		nameLabel.align = "center";
		this.addChild(nameLabel);
	}
	
	public function setSpeed(value:int):void
	{
		speed = value;
	}
	
	public function setName(value:String):void
	{
		nameLabel.text = value;
	}
	
	public function update():void
	{
		this.x += speed;
		if (this.x >= Laya.stage.width + WIDTH)
			this.x = -WIDTH;
	}
}