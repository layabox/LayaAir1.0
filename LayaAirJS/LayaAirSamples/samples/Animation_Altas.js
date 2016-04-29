Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

var ani = new Laya.Animation();
ani.loadAtlas("res/fighter/fighter.json");
//设置位置
ani.pos(180, 90);
//设置播放间隔（单位：毫秒）
ani.interval = 30;
//播放图集动画
ani.play();

Laya.stage.addChild(ani);
