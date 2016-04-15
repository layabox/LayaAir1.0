package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	
    public class Sprite_DisplayImage
    {
        public function Sprite_DisplayImage()
        {
            Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
             
            var ape:Sprite = new Sprite();
            //加载猩猩图片
            ape.loadImage("res/apes/monkey2.png", 220, 128);
             
            Laya.stage.addChild(ape);
        }
    }
}