/// <reference path="../../libs/LayaAir.d.ts" />
var performanceTest;
(function (performanceTest) {
    var Animation = laya.display.Animation;
    var Sprite = laya.display.Sprite;
    var Event = laya.events.Event;
    var Browser = laya.utils.Browser;
    var Stat = laya.utils.Stat;
    var WebGL = laya.webgl.WebGL;
    var AtlasManager = laya.webgl.atlas.AtlasManager;
    var PerformanceTest_Legend = (function () {
        function PerformanceTest_Legend() {
            this.players = [];
            this._width = Browser.width;
            this._height = Browser.height;
            Laya.init(Browser.width, Browser.height, WebGL);
            AtlasManager.enable();
            Stat.show();
            Laya.stage.bgColor = "#000000";
            this.initHandler();
        }
        PerformanceTest_Legend.prototype.initHandler = function () {
            // 资源加载
            for (var i = 1; i <= 6; i++) {
                Laya.loader.load("res/legend/bitmap2/" + i + ".png");
            }
            for (var j = 1; j <= 6; j++) {
                Laya.loader.load("res/legend/bitmap3/" + j + ".png");
            }
            for (var k = 1; k <= 6; k++) {
                Laya.loader.load("res/legend/bitmap4/" + k + ".png");
            }
            Laya.loader.once(Event.COMPLETE, this, this.loadPlayerRes);
            // 显示背景
            var background = new Sprite();
            background.loadImage("res/legend/map.jpg", 0, 0);
            background.scale(this._width / 600, this._height / 600);
            Laya.stage.addChild(background);
        };
        PerformanceTest_Legend.prototype.loadPlayerRes = function () {
            this.createPlayers();
            Laya.timer.frameLoop(1, this, this.animateHandler);
        };
        PerformanceTest_Legend.prototype.animateHandler = function () {
            var ani;
            for (var i = 0; i < this.players.length; i++) {
                ani = this.players[i];
                ani.x += ani["speed"];
                if (ani.x > this._width) {
                    ani.x = -100;
                }
            }
        };
        PerformanceTest_Legend.prototype.createPlayers = function () {
            var playerList = [];
            var player1 = [];
            for (var i = 1; i <= 6; i++) {
                player1.push("res/legend/bitmap2" + "/" + i + ".png");
            }
            playerList.push(player1);
            var player2 = [];
            for (var i = 1; i <= 6; i++) {
                player2.push("res/legend/bitmap3" + "/" + i + ".png");
            }
            playerList.push(player2);
            var player3 = [];
            for (var i = 1; i <= 6; i++) {
                player3.push("res/legend/bitmap4" + "/" + i + ".png");
            }
            playerList.push(player3);
            for (var j = 0; j < 500; j++) {
                var ani = new Animation();
                //加载图片地址集合，组成动画
                ani.loadImages(playerList[parseInt((Math.random() * 3).toString())]);
                //设置位置
                ani.pos(Math.random() * Browser.clientWidth, Math.random() * Browser.clientHeight);
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
        };
        return PerformanceTest_Legend;
    }());
    performanceTest.PerformanceTest_Legend = PerformanceTest_Legend;
})(performanceTest || (performanceTest = {}));
new performanceTest.PerformanceTest_Legend();
