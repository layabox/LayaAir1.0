/// <reference path="../../libs/LayaAir.d.ts" />
module core {
    import Skeleton=laya.ani.bone.Skeleton;
    import Templet=laya.ani.bone.Templet;
    import Loader=laya.net.Loader;
    import Handler=laya.utils.Handler;
    import Stat=laya.utils.Stat;
    import WebGL=laya.webgl.WebGL;
    import Browser=laya.utils.Browser;
    export class TestAnim {
        private  robotAmount:number = 90;
        private  colAmount:number = 15;
        private  robotScale:number = 0.3;
        private  rowAmount:number = Math.ceil(this.robotAmount / this.colAmount);
        private  textureWidth:number;
        private  textureHeight:number;

        constructor() {
            WebGL.enable();
            Laya.init(Browser.width, Browser.height, WebGL);

            Stat.show();

            var assets = [];
            assets.push({url: "res/robot/data.bin", type: Loader.BUFFER});
            assets.push({url: "res/robot/texture.png", type: Loader.IMAGE});
            Laya.loader.load(assets, Handler.create(this, this.onAssetsLoaded));
        }

        private  onAssetsLoaded():void {
            var data:any = Loader.getRes("res/robot/data.bin");
            var img:any = Loader.getRes("res/robot/texture.png");
            var temp:Templet = new Templet(data, img);

            this.textureWidth = temp.textureWidth;
            this.textureHeight = temp.textureHeight;

            var horizontalGap:number = (Laya.stage.width - this.textureWidth * this.robotScale) / this.colAmount;
            var verticalGap:number = (Laya.stage.height - this.textureHeight * this.robotScale) / this.rowAmount;

            for (var i:number = 0; i < this.robotAmount; i++) {
                var col:number = i % this.colAmount;
                var row:number = i / this.colAmount | 0;

                var robot:Skeleton = this.createRobot(temp);

                robot.pos(horizontalGap * col, verticalGap * row);

                robot.stAnimName("Walk");
                robot.play();
            }
        }

        private  createRobot(templet:Templet):Skeleton {
            var sk:Skeleton = new Skeleton(templet);
            sk.pivot(-this.textureWidth, -this.textureHeight);
            sk.scaleX = sk.scaleY = this.robotScale;

            Laya.stage.addChild(sk);

            return sk;
        }
    }
}
new core.TestAnim();
