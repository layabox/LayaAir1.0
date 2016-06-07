package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class Sprite_DisplayImage
	{
		public function Sprite_DisplayImage()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			showApe();
		}

		private function showApe():void
		{
			// 方法1：使用loadImage
			var ape:Sprite = new Sprite();
			Laya.stage.addChild(ape);
			ape.loadImage("res/apes/monkey3.png");
			
			// 方法2：使用drawTexture
			Laya.loader.load("res/apes/monkey2.png", Handler.create(this, function():void
			{
				var t:Texture = Laya.loader.getRes("res/apes/monkey2.png");
				var ape:Sprite = new Sprite();
				ape.graphics.drawTexture(t,0,0);
				Laya.stage.addChild(ape);
				ape.pos(200, 0);
			}));
		}
	}
}