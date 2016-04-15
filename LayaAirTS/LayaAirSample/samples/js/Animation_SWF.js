/// <reference path="../../libs/LayaAir.d.ts" />
Laya.init(550, 400);
Laya.stage.bgColor = "#ffeecc";
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
var mc = new laya.ani.swf.MovieClip();
mc.load("res/swf/H5.swf");
mc.scale(0.5, 0.5);
mc.pos(100, -10);
Laya.stage.addChild(mc);
