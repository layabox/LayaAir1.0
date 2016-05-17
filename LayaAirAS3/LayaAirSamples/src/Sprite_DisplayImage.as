package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.maths.Matrix;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class Sprite_DisplayImage
	{
		public function Sprite_DisplayImage()
		{
			Laya.init(550, 400, WebGL);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			// 方法1：使用loadImage
			var ape:Sprite = new Sprite();
			Laya.stage.addChild(ape);
			ape.loadImage("res/apes/monkey3.png");
			
			// 方法2：使用drawTexture
			Laya.loader.load("res/apes/monkey2.png", Handler.create(this, function()
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