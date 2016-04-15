package
{
    import laya.display.Sprite;
	import laya.display.Stage;
    import laya.events.Event;
    import laya.webgl.WebGL;
     
    public class Sprite_Container
    {
        // 该容器用于装载4张猩猩图片
        private var apesCtn:Sprite;
         
        public function Sprite_Container()
        {
            Laya.init(500, 500,WebGL);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
             
            // 每只猩猩距离中心点150像素
            var layoutRadius:int = 150;
            var radianUnit:Number = Math.PI / 2;
             
            apesCtn = new Sprite();
            Laya.stage.addChild(apesCtn);
             
            // 添加4张猩猩图片
            for (var i:int = 0; i < 4; i++ )
            {
                var ape:Sprite = new Sprite();
                ape.loadImage("res/apes/monkey" + i + ".png");
                 
                ape.pivot(55, 72);
                 
                // 以圆周排列猩猩
                ape.pos(
                    Math.cos(radianUnit * i) * layoutRadius,
                    Math.sin(radianUnit * i) * layoutRadius);
                 
                apesCtn.addChild(ape);
            }
             
            apesCtn.pos(250, 250);
             
            Laya.timer.frameLoop(1, this, animate);
        }
         
        private function animate(e:Event):void
        {
            apesCtn.rotation += 1;
        }
    }
}