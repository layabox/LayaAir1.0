Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
//预加载图集
Laya.loader.load("res/fighter/fighter.json",laya.utils.Handler.create(this, onLoaded), null, laya.net.Loader.ATLAS);

function onLoaded(data)
{
    var ani = new laya.display.Animation();
    ani.loadAtlas("res/fighter/fighter.json");
    //设置位置
    ani.pos(180, 90);
    //设置播放间隔（单位：毫秒）
    ani.interval = 30;
    //当前播放索引
    ani.index = 1;
    //播放图集动画
    ani.play();

    Laya.stage.addChild(ani);
}