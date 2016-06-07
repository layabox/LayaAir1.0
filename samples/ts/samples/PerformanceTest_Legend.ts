/// <reference path="../../libs/LayaAir.d.ts" />
module performanceTest {
    import Animation = laya.display.Animation;
    import Input = laya.display.Input;
    import Sprite = laya.display.Sprite;
    import Event = laya.events.Event;
    import Loader = laya.net.Loader;
    import ComboBox = laya.ui.ComboBox;
    import Browser = laya.utils.Browser;
    import Handler = laya.utils.Handler;
    import Stat = laya.utils.Stat;
    import WebGL = laya.webgl.WebGL;

    export class PerformanceTest_Legend {

        private players: Array<Animation> = [];
        private width: number = Browser.width;
        private height: number = Browser.height;

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(this.width, this.height, WebGL);
            Stat.show()
            this.initHandler();
        }

        private initHandler(): void {
            // 资源加载
            for (var i: number = 1; i <= 6; i++) {
                Laya.loader.load("res/legend/bitmap2/" + i + ".png");
            }
            for (var j: number = 1; j <= 6; j++) {
                Laya.loader.load("res/legend/bitmap3/" + j + ".png");
            }
            for (var k: number = 1; k <= 6; k++) {
                Laya.loader.load("res/legend/bitmap4/" + k + ".png");
            }

            Laya.loader.once(Event.COMPLETE, this, this.loadPlayerRes);

            // 显示背景
            var background: Sprite = new Sprite();
            background.loadImage("res/legend/map.jpg", 0, 0);
            background.scale(this.width / 600, this.height / 600);
            Laya.stage.addChild(background);
        }

        private loadPlayerRes(): void {
            this.createPlayers();
            Laya.timer.frameLoop(1, this, this.animateHandler);
        }

        private animateHandler(): void {
            var ani: Animation;
            for (var i: number = 0; i < this.players.length; i++) {
                ani = this.players[i];
                ani.x += ani["speed"];
                if (ani.x > this.width) {
                    ani.x = -100;
                }
            }
        }

        private createPlayers(): void {
            var playerList: Array<any> = [];
            var player1: Array<string> = [];
            for (var i: number = 1; i <= 6; i++) {
                player1.push("res/legend/bitmap2" + "/" + i + ".png");
            }
            playerList.push(player1);
            var player2: Array<string> = [];
            for (var i: number = 1; i <= 6; i++) {
                player2.push("res/legend/bitmap3" + "/" + i + ".png");
            }
            playerList.push(player2);
            var player3: Array<string> = [];
            for (var i: number = 1; i <= 6; i++) {
                player3.push("res/legend/bitmap4" + "/" + i + ".png");
            }
            playerList.push(player3);
            for (var j: number = 0; j < 500; j++) {
                var ani: Animation = new Animation();
                //加载图片地址集合，组成动画
                ani.loadImages(playerList[parseInt((Math.random() * 3).toString())]);
                //设置位置
                ani.pos(Math.random() * this.width, Math.random() * this.height);
                ani.zOrder = ani.y;
                ani["speed"] = Math.random() + 0.2;
                //设置播放间隔（单位：毫秒）
                ani.interval = 100;
                //当前播放索引
                ani.index = 1;
                //播放图集动画
                ani.play();
                Laya.stage.addChild(ani);
                this.players.push(ani);
            }
        }
    }
}
new performanceTest.PerformanceTest_Legend();