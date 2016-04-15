/// <reference path="../../libs/LayaAir.d.ts" />
module mouses {
    import Sprite = laya.display.Sprite;
    import Stage = laya.display.Stage;
    import Text = laya.display.Text;
    import Event = laya.events.Event;

    export class Scale {
        //上次记录的两个触模点之间距离
        private lastDistance:number = 0;
        //一个精灵对象
        private rect:Sprite;

        constructor() {
            //引擎初始化
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            //设置背景色
            Laya.stage.bgColor = "#ffeecc";

            //创建精灵对象，默认mouseEnabled属性为false，在增加鼠标监听后会自动设为true;
            this.rect = new Sprite();
            this.rect.graphics.drawRect(0, 0, 300, 300, "#00eeff");

            this.rect.pivot(150, 150);
            this.rect.pos(275, 200);
            this.rect.size(300, 300);

            this.rect.on(Event.MOUSE_DOWN, this, this.onMouseDown);
            this.rect.on(Event.MOUSE_MOVE, this, this.onMouseMove);

            Laya.stage.addChild(this.rect);
        }

        /**按下处理*/
        private onMouseDown(e:Event):void {
            //计算两触发点距离
            this.lastDistance = this.getDistance(e);
        }

        /**移到处理*/
        private onMouseMove(e:Event):void {
            ////计算两触发点距离
            var distance:number = this.getDistance(e);
            //判断当前距离与上次距离变化，确定是放大还是缩小
            if (distance - this.lastDistance > 1) {
                //圆形放大
                this.rect.scale(this.rect.scaleX + 0.01, this.rect.scaleX + 0.01);
            }
            else if (distance - this.lastDistance < -1) {
                //圆形缩小
                this.rect.scale(this.rect.scaleX - 0.01, this.rect.scaleX - 0.01);
            }
            //记录距离
            this.lastDistance = distance;
        }

        /**计算两个触摸点之间的距离 主要是使用event的touches*/
        private getDistance(e:Event):number {
            //定义变量
            var distance:number = 0;
            //获取触发点信息数组
            var touches:Array<any> = e.touches;
            //判断数组长度
            if (touches && touches.length > 1) {
                //x轴距离
                var x:number = touches[0].stageX - touches[1].stageX;
                //y轴距离
                var y:number = touches[0].stageY - touches[1].stageY;
                //计算两点距离
                distance = Math.sqrt(x * x + y * y);
            }
            //返回距离
            return distance;
        }
    }
}
new mouses.Scale()