/// <reference path="../../libs/LayaAir.d.ts" />
var mouses;
(function (mouses) {
    var Sprite = laya.display.Sprite;
    var Tween = laya.utils.Tween;
    var Event = laya.events.Event;
    var Interaction_Swipe = (function () {
        function Interaction_Swipe() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            //设置背景色
            Laya.stage.bgColor = "#ffeecc";
            //创建一个精灵对象，默认mouseEnabled属性为false，在增加鼠标监听后会自动设为true;
            var circle = new Sprite();
            circle.graphics.drawCircle(50, 50, 50, "#00eeff");
            circle.pos(120, 150);
            //设置宽高（要接收鼠标事件必须设置宽高，否则不会被命中）
            circle.size(100, 100);
            circle.on(Event.MOUSE_DOWN, this, this.onMouseDown, [circle]);
            Laya.stage.on(Event.MOUSE_UP, this, this.onMouseUp, [circle]);
            Laya.stage.on(Event.MOUSE_OUT, this, this.onMouseUp, [circle]);
            Laya.stage.addChild(circle);
            //左侧临界点设为圆形初始位置
            this.leftPoint = circle.x;
            //右侧临界点设置
            this.rightPoint = this.leftPoint + mouses.Interaction_Swipe.RULE;
        }
        /**按下事件处理*/
        Interaction_Swipe.prototype.onMouseDown = function (circle, e) {
            //添加鼠标移到侦听
            circle.on(Event.MOUSE_MOVE, this, this.onMouseMove, [circle]);
            //记录按下时坐标点
            this.downPoint = Laya.stage.mouseX;
        };
        /**抬起事件处理*/
        Interaction_Swipe.prototype.onMouseUp = function (circle, e) {
            //添加鼠标移到侦听
            circle.off(Event.MOUSE_MOVE, this, this.onMouseMove);
        };
        /**移到事件处理*/
        Interaction_Swipe.prototype.onMouseMove = function (circle, e) {
            //移到到的点与按下点x轴距离
            var value = Laya.stage.mouseX - this.downPoint;
            //判断是否满足触发距离
            if (Math.abs(value) >= mouses.Interaction_Swipe.SWIPE_DIS) {
                //向右拖
                if (value > 0) {
                    //当前位置小于右侧临界点
                    if (circle.x < this.rightPoint) {
                        //实现圆形缓动
                        Tween.to(circle, { x: this.rightPoint }, 100);
                    }
                }
                else {
                    //当前位置大于左侧临界点
                    if (circle.x > this.leftPoint) {
                        //实现圆形缓动
                        Tween.to(circle, { x: this.leftPoint }, 100);
                    }
                }
            }
        };
        //swipe滚动范围
        Interaction_Swipe.RULE = 200;
        //触发swipe的拖动距离
        Interaction_Swipe.SWIPE_DIS = 10;
        return Interaction_Swipe;
    }());
    mouses.Interaction_Swipe = Interaction_Swipe;
})(mouses || (mouses = {}));
new mouses.Interaction_Swipe();
