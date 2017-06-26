var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Text = Laya.Text;
    var Event = Laya.Event;
    var Browser = Laya.Browser;
    var WebGL = Laya.WebGL;
    var Interaction_FixInteractiveRegion = (function () {
        function Interaction_FixInteractiveRegion() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        Interaction_FixInteractiveRegion.prototype.setup = function () {
            this.buildWorld();
            this.createLogger();
        };
        Interaction_FixInteractiveRegion.prototype.buildWorld = function () {
            this.createCoralRect();
            this.createDeepSkyblueRect();
            this.createDarkOrchidRect();
            // 设置舞台
            Laya.stage.name = "暗灰色舞台";
            Laya.stage.on(Event.MOUSE_DOWN, this, this.onDown);
        };
        Interaction_FixInteractiveRegion.prototype.createCoralRect = function () {
            var coralRect = new Sprite();
            coralRect.graphics.drawRect(0, 0, Laya.stage.width, Laya.stage.height / 2, "#FF7F50");
            //设置名称
            coralRect.name = "珊瑚色容器";
            coralRect.size(Laya.stage.width, Laya.stage.height / 2);
            Laya.stage.addChild(coralRect);
            coralRect.on(Event.MOUSE_DOWN, this, this.onDown);
        };
        Interaction_FixInteractiveRegion.prototype.createDeepSkyblueRect = function () {
            var deepSkyblueRect = new Sprite();
            deepSkyblueRect.graphics.drawRect(0, 0, 100, 100, "#00BFFF");
            //设置名称
            deepSkyblueRect.name = "天蓝色矩形";
            //设置宽高（要接收鼠标事件必须设置宽高，否则不会被命中）  
            deepSkyblueRect.size(100, 100);
            deepSkyblueRect.pos(10, 10);
            Laya.stage.addChild(deepSkyblueRect);
            deepSkyblueRect.on(Event.MOUSE_DOWN, this, this.onDown);
        };
        Interaction_FixInteractiveRegion.prototype.createDarkOrchidRect = function () {
            var darkOrchidRect = new Sprite();
            darkOrchidRect.name = "暗紫色矩形容器";
            darkOrchidRect.graphics.drawRect(-100, -100, 200, 200, "#9932CC");
            darkOrchidRect.pos(Laya.stage.width / 2, Laya.stage.height / 2);
            Laya.stage.addChild(darkOrchidRect);
            // 为true时，碰撞区域会被修正为实际显示边界
            // mouseThrough命名真是具有强烈的误导性
            darkOrchidRect.mouseThrough = true;
            darkOrchidRect.on(Event.MOUSE_DOWN, this, this.onDown);
        };
        Interaction_FixInteractiveRegion.prototype.createLogger = function () {
            this.logger = new Text();
            this.logger.size(Laya.stage.width, Laya.stage.height);
            this.logger.align = 'right';
            this.logger.fontSize = 20;
            this.logger.color = "#FFFFFF";
            Laya.stage.addChild(this.logger);
        };
        /**侦听处理方法*/
        Interaction_FixInteractiveRegion.prototype.onDown = function (e) {
            this.logger.text += "点击 - " + e.target.name + "\n";
        };
        return Interaction_FixInteractiveRegion;
    }());
    laya.Interaction_FixInteractiveRegion = Interaction_FixInteractiveRegion;
})(laya || (laya = {}));
new laya.Interaction_FixInteractiveRegion();
