package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class Sprite_MagnifyingGlass
	{
		private var maskSp:Sprite;
		private var bg2:Sprite;

		public function Sprite_MagnifyingGlass()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(1136, 640, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			Laya.loader.load("res/bg2.png", Handler.create(this, setup));
		}

		private function setup(_e:*=null):void
		{
			var bg:Sprite = new Sprite();
			bg.loadImage("res/bg2.png");
			Laya.stage.addChild(bg);

			bg2 = new Sprite();
			bg2.loadImage("res/bg2.png");
			Laya.stage.addChild(bg2);
			bg2.scale(3, 3);
			
			//创建mask
			maskSp = new Sprite();
			maskSp.loadImage("res/mask.png");
			maskSp.pivot(50, 50);

			//设置mask
			bg2.mask = maskSp;

			Laya.stage.on("mousemove", this, onMouseMove);
		}

		private function onMouseMove(_e:*=null):void
		{
			bg2.x = -Laya.stage.mouseX * 2;
			bg2.y = -Laya.stage.mouseY * 2;

			maskSp.x = Laya.stage.mouseX;
			maskSp.y = Laya.stage.mouseY;
		}
	}
}	