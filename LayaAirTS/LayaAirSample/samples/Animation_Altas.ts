/// <reference path="../../libs/LayaAir.d.ts" />
module animations {
    import Animation = laya.display.Animation;
    import Loader = laya.net.Loader;
    import Handler = laya.utils.Handler;
    import Stage = laya.display.Stage;
    export class AnimationAltas {
        constructor() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            //预加载图集
            Laya.loader.load("res/fighter/fighter.json", Handler.create(this, this.onLoaded), null, Loader.ATLAS);
        }

        private onLoaded(data: any): void {
            //创建一个动画对象
            var ani: laya.display.Animation = laya.display.Animation.fromUrl("res/fighter/fighter/rollSequence{0000}.png", 30);
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
    }
}
new animations.AnimationAltas();