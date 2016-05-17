/// <reference path="../../libs/LayaAir.d.ts" />
Laya.init(550, 400, laya.webgl.WebGL);
// Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
//加载资源
Laya.loader.load("res/apes/monkey2.png", laya.utils.Handler.create(this, onAssetLoaded));
function onAssetLoaded() {
    //创建一个发光滤镜
    var glowFilter = new laya.filters.GlowFilter("#ffff00", 10, 0, 0);
    var ape = new laya.display.Sprite();
    ape.pos(220, 120);
    ape.loadImage("res/apes/monkey2.png");
    //设置滤镜集合为发光滤镜
    ape.filters = [glowFilter];
    Laya.stage.addChild(ape);
}
