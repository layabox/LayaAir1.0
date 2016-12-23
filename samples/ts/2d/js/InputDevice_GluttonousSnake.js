var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Accelerator = Laya.Accelerator;
    var Point = Laya.Point;
    var Browser = Laya.Browser;
    var WebGL = Laya.WebGL;
    var Event = Laya.Event;
    var InputDevice_GluttonousSnake = (function () {
        function InputDevice_GluttonousSnake() {
            this.segments = [];
            this.foods = [];
            this.initialSegmentsAmount = 5;
            this.vx = 0;
            this.vy = 0;
            Laya.init(Browser.width, Browser.height, WebGL);
            // 初始化蛇
            this.initSnake();
            // 监视加速器状态
            Accelerator.instance.on(Event.CHANGE, this, this.monitorAccelerator);
            // 游戏循环
            Laya.timer.frameLoop(1, this, this.animate);
            // 食物生产
            Laya.timer.loop(3000, this, this.produceFood);
            // 游戏开始时有一个食物
            this.produceFood();
        }
        InputDevice_GluttonousSnake.prototype.initSnake = function () {
            for (var i = 0; i < this.initialSegmentsAmount; i++) {
                this.addSegment();
                // 蛇头部设置
                if (i == 0) {
                    var header = this.segments[0];
                    // 初始化位置
                    header.rotation = 180;
                    this.targetPosition = new Point();
                    this.targetPosition.x = Laya.stage.width / 2;
                    this.targetPosition.y = Laya.stage.height / 2;
                    header.pos(this.targetPosition.x + header.width, this.targetPosition.y);
                    // 蛇眼睛绘制
                    header.graphics.drawCircle(header.width, 5, 3, "#000000");
                    header.graphics.drawCircle(header.width, -5, 3, "#000000");
                }
            }
        };
        InputDevice_GluttonousSnake.prototype.monitorAccelerator = function (acceleration, accelerationIncludingGravity, rotationRate, interval) {
            this.vx = accelerationIncludingGravity.x;
            this.vy = accelerationIncludingGravity.y;
        };
        InputDevice_GluttonousSnake.prototype.addSegment = function () {
            var seg = new Segment(40, 30);
            Laya.stage.addChildAt(seg, 0);
            // 蛇尾与上一节身体对齐
            if (this.segments.length > 0) {
                var prevSeg = this.segments[this.segments.length - 1];
                seg.rotation = prevSeg.rotation;
                var point = seg.getPinPosition();
                seg.x = prevSeg.x - point.x;
                seg.y = prevSeg.y - point.y;
            }
            this.segments.push(seg);
        };
        InputDevice_GluttonousSnake.prototype.animate = function () {
            var seg = this.segments[0];
            // 更新蛇的位置
            this.targetPosition.x += this.vx;
            this.targetPosition.y += this.vy;
            // 限制蛇的移动范围
            this.limitMoveRange();
            // 检测觅食
            this.checkEatFood();
            // 更新所有关节位置
            var targetX = this.targetPosition.x;
            var targetY = this.targetPosition.y;
            for (var i = 0, len = this.segments.length; i < len; i++) {
                seg = this.segments[i];
                var dx = targetX - seg.x;
                var dy = targetY - seg.y;
                var radian = Math.atan2(dy, dx);
                seg.rotation = radian * 180 / Math.PI;
                var pinPosition = seg.getPinPosition();
                var w = pinPosition.x - seg.x;
                var h = pinPosition.y - seg.y;
                seg.x = targetX - w;
                seg.y = targetY - h;
                targetX = seg.x;
                targetY = seg.y;
            }
        };
        InputDevice_GluttonousSnake.prototype.limitMoveRange = function () {
            if (this.targetPosition.x < 0)
                this.targetPosition.x = 0;
            else if (this.targetPosition.x > Laya.stage.width)
                this.targetPosition.x = Laya.stage.width;
            if (this.targetPosition.y < 0)
                this.targetPosition.y = 0;
            else if (this.targetPosition.y > Laya.stage.height)
                this.targetPosition.y = Laya.stage.height;
        };
        InputDevice_GluttonousSnake.prototype.checkEatFood = function () {
            var food;
            for (var i = this.foods.length - 1; i >= 0; i--) {
                food = this.foods[i];
                if (food.hitTestPoint(this.targetPosition.x, this.targetPosition.y)) {
                    this.addSegment();
                    Laya.stage.removeChild(food);
                    this.foods.splice(i, 1);
                }
            }
        };
        InputDevice_GluttonousSnake.prototype.produceFood = function () {
            // 最多五个食物同屏
            if (this.foods.length == 5)
                return;
            var food = new Sprite();
            Laya.stage.addChild(food);
            this.foods.push(food);
            var foodSize = 40;
            food.size(foodSize, foodSize);
            food.graphics.drawRect(0, 0, foodSize, foodSize, "#00BFFF");
            food.x = Math.random() * Laya.stage.width;
            food.y = Math.random() * Laya.stage.height;
        };
        return InputDevice_GluttonousSnake;
    }());
    laya.InputDevice_GluttonousSnake = InputDevice_GluttonousSnake;
    var Segment = (function (_super) {
        __extends(Segment, _super);
        function Segment(width, height) {
            _super.call(this);
            this.size(width, height);
            this.init();
        }
        Segment.prototype.init = function () {
            this.graphics.drawRect(-this.height / 2, -this.height / 2, this.width + this.height, this.height, "#FF7F50");
        };
        // 获取关节另一头位置
        Segment.prototype.getPinPosition = function () {
            var radian = this.rotation * Math.PI / 180;
            var tx = this.x + Math.cos(radian) * this.width;
            var ty = this.y + Math.sin(radian) * this.width;
            return new Point(tx, ty);
        };
        return Segment;
    }(Sprite));
})(laya || (laya = {}));
new laya.InputDevice_GluttonousSnake();
