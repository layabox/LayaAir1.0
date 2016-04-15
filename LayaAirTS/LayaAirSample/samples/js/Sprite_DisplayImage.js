/// <reference path="../../libs/LayaAir.d.ts" />
Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
var ape = new laya.display.Sprite();
//加载猩猩图片
ape.loadImage("res/apes/monkey2.png", 220, 128);
Laya.stage.addChild(ape);
