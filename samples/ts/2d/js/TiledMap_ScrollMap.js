var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var TiledMap = Laya.TiledMap;
    var Rectangle = Laya.Rectangle;
    var Browser = Laya.Browser;
    var Handler = Laya.Handler;
    var Stat = Laya.Stat;
    var WebGL = Laya.WebGL;
    var TiledMap_SimpleDemo = (function () {
        function TiledMap_SimpleDemo() {
            this.mLastMouseX = 0;
            this.mLastMouseY = 0;
            this.mX = 0;
            this.mY = 0;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Stat.show();
            this.createMap();
            Laya.stage.on(Laya.Event.MOUSE_DOWN, this, this.mouseDown); //注册鼠标事件
            Laya.stage.on(Laya.Event.MOUSE_UP, this, this.mouseUp);
        }
        //创建地图
        TiledMap_SimpleDemo.prototype.createMap = function () {
            //创建地图对象
            this.tiledMap = new TiledMap();
            this.mX = this.mY = 0;
            //创建地图，适当的时候调用destory销毁地图
            this.tiledMap.createMap("../../res/tiledMap/desert.json", new Rectangle(0, 0, Browser.width, Browser.height), new Handler(this, this.completeHandler));
        };
        /**
         * 地图加载完成的回调
         */
        TiledMap_SimpleDemo.prototype.completeHandler = function () {
            console.log("地图创建完成");
            console.log("ClientW:" + Browser.clientWidth + " ClientH:" + Browser.clientHeight);
            Laya.stage.on(Laya.Event.RESIZE, this, this.resize);
            this.resize();
        };
        //鼠标按下拖动地图
        TiledMap_SimpleDemo.prototype.mouseDown = function () {
            this.mLastMouseX = Laya.stage.mouseX;
            this.mLastMouseY = Laya.stage.mouseY;
            Laya.stage.on(Laya.Event.MOUSE_MOVE, this, this.mouseMove);
        };
        TiledMap_SimpleDemo.prototype.mouseMove = function () {
            //移动地图视口
            this.tiledMap.moveViewPort(this.mX - (Laya.stage.mouseX - this.mLastMouseX), this.mY - (Laya.stage.mouseY - this.mLastMouseY));
        };
        TiledMap_SimpleDemo.prototype.mouseUp = function () {
            this.mX = this.mX - (Laya.stage.mouseX - this.mLastMouseX);
            this.mY = this.mY - (Laya.stage.mouseY - this.mLastMouseY);
            Laya.stage.off(Laya.Event.MOUSE_MOVE, this, this.mouseMove);
        };
        // 窗口大小改变，把地图的视口区域重设下
        TiledMap_SimpleDemo.prototype.resize = function () {
            //改变地图视口大小
            this.tiledMap.changeViewPort(this.mX, this.mY, Browser.width, Browser.height);
        };
        return TiledMap_SimpleDemo;
    }());
    laya.TiledMap_SimpleDemo = TiledMap_SimpleDemo;
})(laya || (laya = {}));
new laya.TiledMap_SimpleDemo();
