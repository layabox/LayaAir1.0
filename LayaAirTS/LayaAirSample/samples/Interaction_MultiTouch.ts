/// <reference path="../../libs/LayaAir.d.ts" />
module mouses {
    import Sprite = laya.display.Sprite;
    import Point = laya.maths.Point;
    import Event = laya.events.Event;

    export class MuitlPointTouch {
        private rectIsDown:boolean;
        private circleIsDown:boolean;
        private lastRectPoint:Point = new Point();
        private lastCirclePoint:Point = new Point();

        constructor() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#ffeecc";

            //创建一个精灵对象，默认mouseEnabled属性为false，在增加鼠标监听后会自动设为true;
            var rect:Sprite = new Sprite();
            //绘制矩形
            rect.graphics.drawRect(0, 0, 100, 100, "#00eeff");
            //设置坐标点
            rect.pos(100, 150);
            //设置宽高（要接收鼠标事件必须设置宽高，否则不会被命中）
            rect.size(100, 100);
            //添加按下侦听
            rect.on(Event.MOUSE_DOWN, this, this.onRectHandler);
            //添加移到侦听
            rect.on(Event.MOUSE_MOVE, this, this.onRectHandler);
            //添加抬起侦听
            rect.on(Event.MOUSE_UP, this, this.onRectHandler);
            //将矩形对象添加到舞台
            Laya.stage.addChild(rect);

            //创建一个精灵对象，默认mouseEnabled属性为false，在增加鼠标监听后会自动设为true;
            var circle:Sprite = new Sprite();
            //绘制矩形
            circle.graphics.drawCircle(50, 50, 50, "#00eeff");
            //设置坐标点
            circle.pos(350, 150);
            //设置宽高（要接收鼠标事件必须设置宽高，否则不会被命中）
            circle.size(100, 100);
            //添加按下侦听
            circle.on(Event.MOUSE_DOWN, this, this.onCircleHandler);
            //添加移到侦听
            circle.on(Event.MOUSE_MOVE, this, this.onCircleHandler);
            //添加抬起侦听
            circle.on(Event.MOUSE_UP, this, this.onCircleHandler);
            //将矩形对象添加到舞台
            Laya.stage.addChild(circle);
        }

        /**矩形鼠标处理*/
        private onRectHandler(e:Event):void {
            switch (e.type) {
                case Event.MOUSE_DOWN:
                    //记录矩形按下
                    this.rectIsDown = true;
                    //记录按下时坐标点
                    this.lastRectPoint.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
                    break;
                case Event.MOUSE_UP:
                    //矩形按下重置
                    this.rectIsDown = false;
                    break;
                case Event.MOUSE_MOVE:
                    if (this.rectIsDown) {
                        //x轴上鼠标移动位置
                        e.currentTarget.x = e.currentTarget.x + (Laya.stage.mouseX - this.lastRectPoint.x);
                        //y轴上鼠标移动位置
                        e.currentTarget.y = e.currentTarget.y + (Laya.stage.mouseY - this.lastRectPoint.y);
                        //记录本次事件的鼠标坐标
                        this.lastRectPoint.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
                    }
                    break;
            }
        }

        /**圆形鼠标处理*/
        private onCircleHandler(e:Event):void {
            switch (e.type) {
                case Event.MOUSE_DOWN:
                    //记录圆形按下
                    this.circleIsDown = true;
                    //记录按下时坐标点
                    this.lastCirclePoint.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
                    break;
                case Event.MOUSE_UP:
                    //圆形按下重置
                    this.circleIsDown = false;
                    break;
                case Event.MOUSE_MOVE:
                    if (this.circleIsDown) {
                        //x轴上鼠标移动位置
                        e.currentTarget.x = e.currentTarget.x + (Laya.stage.mouseX - this.lastCirclePoint.x);
                        //y轴上鼠标移动位置
                        e.currentTarget.y = e.currentTarget.y + (Laya.stage.mouseY - this.lastCirclePoint.y);
                        //记录本次事件的鼠标坐标
                        this.lastCirclePoint.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
                    }
                    break;
            }
        }
    }
}
new mouses.MuitlPointTouch()