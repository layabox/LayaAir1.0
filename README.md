##LayaAir是HTML5开源引擎，支持2D，3D、时间轴动画、UI、粒子、骨骼、物理等，提供可视化编辑器，能够用来开发跨平台应用，开源免费。

##LayaAir特点

###多语言支持
同时支持AS3、TypeScript、JavaScript三种语言开发HTML5
###极致性能
LayaAir设计之初便以性能为最高优先级，引擎优先使用webgl渲染，如果webgl不可用，转为canvas渲染，LayaAir唯一拥有大型游戏线上产品（裸跑）案例的HTML5引擎
###功能强大
同时支持2D，3D，VR、时间轴动画、UI、粒子、骨骼、物理等
###轻量易用
引擎本身很注意引擎本身的大小，是目前最小的HTML5引擎，api设计上追求简单易用，易学上手快




##开始使用
####JS版本
    Laya.init(550, 400);
    Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
    
    var ape = new laya.display.Sprite();
    //加载猩猩图片
    ape.loadImage("res/apes/monkey2.png", 220, 128);
    
    Laya.stage.addChild(ape);
    
####AS版本
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
####TS版本
    /// <reference path="../../libs/LayaAir.d.ts" />
    Laya.init(550, 400);
    Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
    
    var ape:laya.display.Sprite = new laya.display.Sprite();
    //加载猩猩图片
    ape.loadImage("res/apes/monkey2.png", 220, 128);
    
    Laya.stage.addChild(ape);


##文件结构
LayaAirAS3 Actionscript3版本引擎库及示例教程

LayaAirJS Javascript版本引擎库及示例教程

LayaAirTS Typesprite版本引擎库及示例教程

LayaAirIDE LayaAir编辑器Win版本

LayaAirIDEMac LayaAir编辑器Mac版本

##辅助帮助
API帮助网址：http://layaair.ldc.layabox.com/api/

Demo演示网址：http://layaair.ldc.layabox.com/demo/
