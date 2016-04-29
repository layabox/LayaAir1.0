Laya.init(550, 400);
Laya.stage.bgColor = "#ffeecc";
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;
 
var mc = new Laya.MovieClip();
mc.load("res/swf/H5.swf");
 
mc.scale(0.5, 0.5);
mc.pos(100, -10);
 
Laya.stage.addChild(mc);