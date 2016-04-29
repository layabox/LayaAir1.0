/// <reference path="../../libs/LayaAir.d.ts" />
var animations;
(function (animations) {
    var Animation = laya.display.Animation;
    var Stage = laya.display.Stage;
    var AnimationAltas = (function () {
        function AnimationAltas() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            //创建一个动画对象
            var ani = new Animation();
            ani.loadAtlas("res/fighter/fighter.json");
            //设置位置
            ani.pos(180, 90);
            //设置播放间隔（单位：毫秒）
            ani.interval = 30;
            //播放图集动画
            ani.play();
            Laya.stage.addChild(ani);
        }
        return AnimationAltas;
    }());
    animations.AnimationAltas = AnimationAltas;
})(animations || (animations = {}));
new animations.AnimationAltas();
