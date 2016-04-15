/// <reference path="../../libs/LayaAir.d.ts" />
module mouses {
    import Sprite = laya.display.Sprite;
    import Text = laya.display.Text;
    import Point = laya.maths.Point;
    import Event = laya.events.Event;

    export class Rotate {
        //声明一个显示对象
        private sp:Sprite;
        //开始时坐标点
        private lastPoint:Point = new Point();
        //当前坐标点
        private curPoint:Point = new Point();
        //mousedown触发时，记录显示对象的旋转角度
        private preDegree:number = 0;

        constructor() {
            //引擎初始化
            Laya.init(550, 400);
            //设置背景色
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#ffeecc";

            //创建一个sprite
            this.sp = new Sprite();
            this.sp.graphics.drawRect(0, 0, 200, 300, "#00eeff");

            this.sp.pivot(100, 150);
            this.sp.pos(275, 200);
            this.sp.size(200, 300);

            Laya.stage.addChild(this.sp);

            this.sp.on(Event.MOUSE_DOWN, this, this.onMouseDown);
            Laya.stage.on(Event.MOUSE_UP, this, this.onMouseUp);
            Laya.stage.on(Event.MOUSE_OUT, this, this.onMouseUp);
        }

        /**鼠标在显示对象上移到时处理*/
        private onMouseMove(e:Event):void {
            //设置当前触发坐标点
            this.curPoint.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
            //以sp轴心点为原点，计算开始点与原点的角度
            var startDeg:number = -Math.atan2(this.lastPoint.y - this.sp.y, this.lastPoint.x - this.sp.x) * 180 / Math.PI;
            //转化为 0-360度样式
            if (startDeg < 0) startDeg = startDeg + 360;
            //以sp轴心点为原点，计算当前点与原点的角度
            var curDeg:number = -Math.atan2(this.curPoint.y - this.sp.y, this.curPoint.x - this.sp.x) * 180 / Math.PI;
            //转化为 0-360度样式
            if (curDeg < 0) curDeg = curDeg + 360;
            //设置旋转角度
            this.sp.rotation = this.preDegree + (startDeg - curDeg);
        }

        /**按下事件处理*/
        private onMouseDown(e:Event):void {
            //记录坐标
            this.lastPoint.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
            //记录开始滑动前，显示对象的旋转角度
            this.preDegree = this.sp.rotation;
            //添加移动事件侦听
            this.sp.on(Event.MOUSE_MOVE, this, this.onMouseMove);
        }

        /**鼠标收起处理*/
        private onMouseUp(e:Event):void {
            //添加移动事件侦听
            this.sp.off(Event.MOUSE_MOVE, this, this.onMouseMove);
        }
    }
}
new mouses.Rotate()